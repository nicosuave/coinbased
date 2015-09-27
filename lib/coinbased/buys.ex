defmodule Coinbased.Buys do
  import Coinbased
  alias Coinbased.Client

  @doc """
  Get the total price to buy one bitcoin.

  ## Example

      Coinbased.Buys.list, client

  More info at: https://developers.coinbase.com/api/v2#get-buy-price
  """
  def list(account_id, client \\ %Client{}) do
    get "accounts/#{account_id}/buys", client
  end
end
