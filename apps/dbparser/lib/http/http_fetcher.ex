defmodule Dbparser.HttpFetcher do
  import Logger

  @behaviour Dbparser.Http

  @api_key System.get_env("DB_API_KEY")
  @user_agent [ { "User-agent", "Elixir foo@bar.com" }]
  @http_ok 200
  @timeout_millis 2000

  def get(url, params) do
    url =
      url
      |> replace_url_params(Map.put(params, "<AUTH_KEY>", @api_key))

    debug("GET #{url}")

    url
      |> HTTPoison.get(@user_agent, timeout: @timeout_millis)
      |> handle_response
  end

  def replace_url_params(url, params) do
    params
    |> Enum.reduce(url, fn({k, v}, next_url) -> String.replace(next_url, k, v) end)
  end

  def replace_param({k, v}, url) do
    url
    |> String.replace(k, v)
  end

  defp handle_response({:ok, %HTTPoison.Response{ status_code: @http_ok, body: body }}) do
    {:ok, body}
  end

  defp handle_response({status, %HTTPoison.Response{ status_code: @http_ok, body: body }}) do
    warn("Received a non OK status #{status} #{inspect body}")
    {:error, body}
  end

  defp handle_response({:error, error}) do
    error("Received error #{inspect(error.reason)}")
    {:error, error.reason}
  end
end
