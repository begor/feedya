defmodule Feedya.User do
  use Feedya.Web, :model

  alias Comeonin.Bcrypt
  alias Feedya.{User, Repo}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_digest, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  Changesets define a pipeline of transformations our data needs
  to undergo before it will be ready for our application to use.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:first_name, :email, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password, message: "Passwords doesn't match!") # Compares password against password_confirmation
    |> hash_password
  end

  def find_and_confirm_password(user_params) do
    User
    |> Repo.get_by(email: user_params["email"])
    |> confirm_password(user_params["password"], user_params)
  end

  defp confirm_password(nil, _, user_params), do: {:error, user_params}
  defp confirm_password(user, password, user_params) do
    if Bcrypt.checkpw(password, user.password_digest) do
      {:ok, user}
    else
      {:error, user_params}
    end
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_digest, Bcrypt.hashpwsalt(password))
    end
  end
end
