defmodule Feedya.Email do
  use Bamboo.Phoenix, view: Feedya.EmailView

  def feedya do
    Application.get_env(:feedya, :email)
  end

  # TODO: HTML-emails

  def welcome(email) do
    new_email
    |> to(email)
    |> from(feedya)
    |> subject("Welcome!")
    |> text_body("Welcome to Feedya!")
  end

  def new_stories(email, stories) do
    titles = stories
             |> Enum.map(fn(s) -> s.title end)
             |> Enum.join("\n")

    new_email
    |> to(email)
    |> from(feedya)
    |> subject("New stories for subscription!")
    |> text_body(titles)
  end
end
