# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Feedya.Repo.insert!(%Feedya.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seeds do
  def create_user do
    params = %{first_name: "Charles",
               last_name: "Mingus",
               email: "foo@example.com",
               password: "qwerty",
               password_confirmation: "qwerty"}
    changeset = Feedya.User.changeset(%Feedya.User{}, params)
    Feedya.Repo.insert!(changeset)
  end

  def create_subscriptions do
    params1 = %{user_id: 1,
                terms: ["Elixir", "Erlang", "Python", "Ruby", "CIA"],
                name: "Test #1"}
    params2 = %{user_id: 1,
                terms: ["HTML", "CSS", "Rust"],
                name: "Test #2"}

    changeset = Feedya.HNSubscription.changeset(%Feedya.HNSubscription{}, params1)
    Feedya.Repo.insert!(changeset)

    changeset = Feedya.HNSubscription.changeset(%Feedya.HNSubscription{}, params2)
    Feedya.Repo.insert!(changeset)
  end
end

Seeds.create_user
Seeds.create_subscriptions
Feedya.HNStory.save_top!
