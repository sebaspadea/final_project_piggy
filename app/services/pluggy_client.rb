require 'rest-client'

class PluggyClient
  attr_reader :api_key, :items, :accounts, :transactions

  def initialize
    @url = "https://api.pluggy.ai"
    @api_key = auth(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
    @headers = { "X-API-KEY": @api_key }
  end

  def connectors
    response = get("/connectors")
    response["results"]
  end

  def connector(id)
  end

  def fetch_items(connector_id, params = {})
    body = {
      "connectorId": connector_id,
      "parameters": params,
      "webhookUrl": "https://www.myapi.com/notifications"
    }
    @items = post("/items", body)
  end

  def fetch_accounts(item_id)
    response = get("/accounts", { "itemId": item_id })
    @accounts = response["results"]
  end

  def fetch_account(id)
  end

  def fetch_transactions(account_id)
    @transactions = get("/transactions", { "accountId": account_id })
  end

  def fetch_transaction(id)
  end

  private

  def auth(client_id, client_secret)
    payload = {
      clientId: client_id,
      clientSecret: client_secret
    }
    response = RestClient.post("#{@url}/auth", payload)
    json = JSON.parse(response)
    json["apiKey"]
  end

  def get(path, params = {})
    headers = @headers
    headers[:params] = params
    response = RestClient.get("#{@url}#{path}", headers)
    JSON.parse(response)
  end

  def post(path, payload = {})
    headers = @headers
    headers[:content_type] = :json
    headers[:accept] = :json
    response = RestClient.post("#{@url}#{path}", payload.to_json, headers)
    JSON.parse(response)
  end
end
