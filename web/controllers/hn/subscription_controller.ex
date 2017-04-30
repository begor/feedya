defmodule Feedya.HN.SubscriptionController do
  use Feedya.Web, :controller

  alias Feedya.{HN.Subscription, User, Indexer}

  def new(conn, _params) do
    changeset = Subscription.changeset(%Subscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"subscription" => params}) do
    params = prepare_params(params, Guardian.Plug.current_resource(conn).id)
    changeset = Subscription.changeset(%Subscription{}, params)

    case Repo.insert(changeset) do
      {:ok, hn_subscription} ->
        Indexer.Supervisor.start!(hn_subscription.id)
        conn
        |> put_flash(:info, "Subscription created successfully.")
        |> redirect(to: page_path(conn, :profile))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    hn_subscription = Repo.get!(Subscription, id)
    changeset = Subscription.changeset(hn_subscription)
    render(conn, "edit.html", hn_subscription: hn_subscription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "subscription" => params}) do
    hn_subscription = Repo.get!(Subscription, id)
    params = prepare_params(params, Guardian.Plug.current_resource(conn).id)
    changeset = Subscription.changeset(hn_subscription, params)

    case Repo.update(changeset) do
      {:ok, hn_subscription} ->
        conn
        |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: page_path(conn, :profile))
      {:error, changeset} ->
        render(conn, "edit.html", hn_subscription: hn_subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hn_subscription = Repo.get!(Subscription, id)
    Repo.delete!(hn_subscription)

    conn
    |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: page_path(conn, :profile))
  end

  defp prepare_params(params, user_id) do
    terms = String.split(params["terms"], ",")

    params
    |> Map.put("terms", terms)
    |> Map.put("user_id", user_id)
  end
end
