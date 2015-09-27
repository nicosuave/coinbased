defmodule Coinbased.Time do
  import Coinbased
  alias Coinbased.Client

  @doc """
  Get the API server time.

  ## Example

      Coinbased.Time.get

  More info at: https://developers.coinbase.com/api/v2#get-current-time
  """
  def fetch(client \\ %Client{}) do
    get "time", client
  end
end
