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

params = %{first_name: "Charles",
           last_name: "Mingus",
           email: "foo@example.com",
           password: "qwerty",
           password_confirmation: "qwerty"}
changeset = Feedya.User.changeset(%Feedya.User{}, params)

Feedya.Repo.insert!(changeset)
Feedya.HNStory.fetch_top!
