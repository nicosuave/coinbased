defmodule Coinbased.Accounts do
  import Coinbased
  alias Coinbased.Client

  @doc """
  Lists current user’s accounts to which the authentication method has access to.

  ## Example

      Coinbased.Accounts.list, client

  More info at: https://developers.coinbase.com/api/v2#list-accounts
  """
  def list(client \\ %Client{}) do
    get "accounts", client
  end

  @doc """
  Show current user’s account. To access user’s primary account, primary keyword can be used instead of the account id in the URL.

  ## Example

      Coinbased.Accounts.show, client

  More info at: https://developers.coinbase.com/api/v2#show-an-account
  """
  def show(account_id, client \\ %Client{}) do
    get "accounts/#{account_id}", client
  end
end
