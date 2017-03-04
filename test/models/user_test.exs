defmodule Feedya.UserTest do
  use Feedya.ModelCase

  alias Feedya.User

  @valid_attrs %{email: "some@content.com",
                 first_name: "some content",
                 last_name: "some content",
                 password: "suchsecure",
                 password_confirmation: "suchsecure"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
