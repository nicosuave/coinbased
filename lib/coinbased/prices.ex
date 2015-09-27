defmodule Coinbased.Prices do
  import Coinbased
  alias Coinbased.Client

  @doc """
  Get the total price to buy one bitcoin.

  ## Example

      Coinbased.Prices.buy
      Coinbased.Prices.buy, client

  More info at: https://developers.coinbase.com/api/v2#get-buy-price
  """
  def buy(client \\ %Client{}) do
    get "prices/sell", client
  end

  @doc """
  Get the total price to sell one bitcoin.

  ## Example

      Coinbased.Prices.sell
      Coinbased.Prices.sell, client

  More info at: https://developers.coinbase.com/api/v2#get-sell-price
  """
  def sell(client \\ %Client{}) do
    get "prices/buy", client
  end

  @doc """
  Get the current market price for bitcoin. This is usually somewhere in between the buy and sell price.

  ## Example

      Coinbased.Prices.spot
      Coinbased.Prices.spot, client

  More info at: https://developers.coinbase.com/api/v2#get-spot-price
  """
  def spot(client \\ %Client{}) do
    get "prices/spot", client
  end
end
