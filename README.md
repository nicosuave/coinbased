Coinbased
=========

A simple Elixir wrapper for [Coinbase's v2 Wallet API](https://developers.coinbase.com/api/v2).

Inspiration came from from the wonderful [Tentacat](https://github.com/edgurgel/tentacat) by [Eduardo Gurgel](https://github.com/edgurgel).

##Features

* Prices
  * Get buy price
  * Get sell price
  * Get spot price

## Quickstart

Fetching dependencies and running on elixir console:

```console
mix deps.get
iex -S mix
```

Now you can run the examples!

## Examples

Authenticated calls to Coinbase requires passing in a `Client` as an argument.

Fetch the most recent buy price

```
iex> Coinbased.Prices.buy
%{"data" => %{"amount" => "232.50", "currency" => "USD"},
  "warnings" => [%{"id" => "missing_version",
     "message" => "Please supply API version (YYYY-MM-DD) as CB-VERSION header",
     "url" => "https://developers.coinbase.com/api#versioning"}]}
```

Fetch the most recent sell price

```
iex> Coinbased.Prices.sell
%{"data" => %{"amount" => "237.40", "currency" => "USD"},
  "warnings" => [%{"id" => "missing_version",
     "message" => "Please supply API version (YYYY-MM-DD) as CB-VERSION header",
     "url" => "https://developers.coinbase.com/api#versioning"}]}
```

Fetch the most recent spot price

```
iex> Coinbased.Prices.spot
%{"data" => %{"amount" => "234.67", "currency" => "USD"},
  "warnings" => [%{"id" => "missing_version",
     "message" => "Please supply API version (YYYY-MM-DD) as CB-VERSION header",
     "url" => "https://developers.coinbase.com/api#versioning"}]}
```

## Contributing

Start by forking this repo

Then run this command to fetch dependencies and run tests:

```console
MIX_ENV=test mix do deps.get, test
```

Pull requests are greatly appreciated
