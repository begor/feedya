# Wrapper for HN API
defmodule Feedya.API.HN do
  use HTTPoison.Base

  @base_url "https://hacker-news.firebaseio.com/v0/"

  ### Callbacks ###

  def process_url(url) do
    @base_url <> url
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end


  ## Interface ##


  def story(id), do: fetch_from_url("item/#{Integer.to_string(id)}.json")

  def top_ids, do: fetch_from_url("topstories.json")

  def new_ids, do: fetch_from_url("newstories.json")

  def best_ids, do: fetch_from_url("beststories.json")


  ## Implementation ##


  defp fetch_from_url(url) do
    {:ok, resp} = get(url)
    {:ok, resp.body}
  end

end
