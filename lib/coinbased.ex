defmodule Coinbased do
  use HTTPoison.Base

  defmodule Client do
    defstruct auth: nil, endpoint: "https://api.coinbase.com/v2/"

    @type auth :: %{api_key: binary, secret_key: binary}
    @type t :: %__MODULE__{auth: auth, endpoint: binary}

    @spec new() :: t
    def new(), do: %__MODULE__{}

    @spec new(auth) :: t
    def new(auth),  do: %__MODULE__{auth: auth}

    @spec new(auth, binary) :: t
    def new(auth, endpoint) do
      endpoint = if String.ends_with?(endpoint, "/") do
        endpoint
      else
        endpoint <> "/"
      end
      %__MODULE__{auth: auth, endpoint: endpoint}
    end
  end

  @user_agent [{"User-agent", "coinbased"}]

  @type response :: {integer, any}  | :jsx.json_term

  @spec process_response(HTTPoison.Response.t) :: response
  def process_response(response) do
    status_code = response.status_code
    _headers = response.headers
    body = response.body
    response = unless body == "", do: body |> JSX.decode!,
    else: nil

    if (status_code == 200), do: response,
    else: {status_code, response}
  end

  def delete(path, client, body \\ "") do
    _request(:delete, path, client, body)
  end

  def post(path, client, body \\ "") do
    _request(:post, path, client, body)
  end

  def patch(path, client, body \\ "") do
    _request(:patch, path, client, body)
  end

  def put(path, client, body \\ "") do
    _request(:put, path, client, body)
  end

  # TODO: Fix encoding of query params
  def get(path, client, params \\ []) do
    path_with_query_params = << path :: binary, build_qs(params) :: binary>>
    _request(:get, path_with_query_params, client)
  end

  def _request(method, path, client, body \\ "") do
    json_request(method, url(client, path), body, authorization_header(client.auth, %{method: method, request_path: path, body: body}, @user_agent))
  end

  def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    request!(method, url, JSX.encode!(body), headers, options) |> process_response
  end

  @spec url(client :: Client.t, path :: binary) :: binary
  defp url(_client = %Client{endpoint: endpoint}, path) do
    endpoint <> path
  end

  @spec build_qs([{atom, binary}]) :: binary
  defp build_qs([]), do: ""
  defp build_qs(kvs), do: to_string('?' ++ URI.encode_query(kvs))

  @doc """
    Authentication is supported via your Coinbase API key & secret

  ## More info
  https:\\developers.coinbase.com/api/v2#authentication
  """

  def authorization_header(%{api_key: api_key, secret_key: secret_key}, %{method: method, request_path: request_path, body: body}, headers) do
    timestamp = seconds_since_epoch
    signature = sign(%{timestamp: timestamp, method: method, request_path: request_path, body: body, secret_key: secret_key})
    headers_to_be_added = [
      {"CB-ACCESS-KEY", api_key},
      {"CB-ACCESS-TIMESTAMP", timestamp},
      {"CB-ACCESS-SIGN", signature},
      {"CB-VERSION", formatted_date}
    ]
    headers ++ headers_to_be_added
  end

  def authorization_header(_, _request_metadata, headers) do
    headers ++ [{"CB-VERSION", formatted_date}]
  end

  @doc """
  Same as `authorization_header/2` but defaults initial headers to include `@user_agent`.
  """
  def authorization_header(options) do
    authorization_header(options, nil, @user_agent)
  end

  defp sign(%{timestamp: timestamp, method: method, request_path: request_path, body: body, secret_key: secret_key}) do
    method = "#{method}" |> String.upcase
    # TODO: Figure out why this isn't working
    prehash_string = "#{timestamp}#{method}/v2/#{request_path}#{body}"
    IO.puts "PREHASH STRING: #{prehash_string}"
    signature = :crypto.hmac(:sha256, secret_key, prehash_string) |> Base.encode16 |> String.downcase
    IO.puts "SIGNATURE: #{signature}"
    signature
  end

  defp seconds_since_epoch do
    Timex.Date.now |> Timex.Date.to_secs
  end

  defp formatted_date do
    Timex.Date.now |> Timex.DateFormat.format("%Y-%m-%d", :strftime) |> elem 1
  end
end
