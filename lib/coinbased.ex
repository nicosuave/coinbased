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
    headers = response.headers
    body = response.body
    response = unless body == "", do: body |> JSX.decode!,
    else: nil

    if (status_code == 200), do: response,
    else: {status_code, response}
  end

  def delete(path, client, body \\ "") do
    _request(:delete, url(client, path), client.auth, body)
  end

  def post(path, client, body \\ "") do
    _request(:post, url(client, path), client.auth, body)
  end

  def patch(path, client, body \\ "") do
    _request(:patch, url(client, path), client.auth, body)
  end

  def put(path, client, body \\ "") do
    _request(:put, url(client, path), client.auth, body)
  end

  def get(path, client, params \\ []) do
    url = url(client, path)
    url = <<url :: binary, build_qs(params) :: binary>>
    _request(:get, url, client.auth)
  end

  def _request(method, url, auth, body \\ "") do
    json_request(method, url, body, authorization_header(auth, @user_agent))
  end

  def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    request!(method, url, JSX.encode!(body), headers, options) |> process_response
  end

  @spec url(client :: Client.t, path :: binary) :: binary
  defp url(client = %Client{endpoint: endpoint}, path) do
    endpoint <> path
  end

  @spec build_qs([{atom, binary}]) :: binary
  defp build_qs([]), do: ""
  defp build_qs(kvs), do: to_string('?' ++ URI.encode_query(kvs))

  @doc """
    Authentication is soon to be supported via your Coinbase API key & secret

  ## More info
  https:\\developers.coinbase.com/api/v2#authentication
  """

  def authorization_header(_, headers) do
    headers ++ [{"CB-VERSION", timestamp}]
  end

  @doc """
  Same as `authorization_header/2` but defaults initial headers to include `@user_agent`.
  """
  def authorization_header(options) do
    authorization_header(options, @user_agent)
  end

  defp timestamp do
    Timex.Date.now |> Timex.DateFormat.format("%Y-%m-%d", :strftime) |> elem 1
  end
end
