defmodule Feedya.HNSubscriptionController do
  use Feedya.Web, :controller

  alias Feedya.{HNSubscription, User}

  def new(conn, _params) do
    changeset = HNSubscription.changeset(%HNSubscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hn_subscription" => params}) do
    params = prepare_params(params, Guardian.Plug.current_resource(conn).id)
    changeset = HNSubscription.changeset(%HNSubscription{}, params)

    case Repo.insert(changeset) do
      {:ok, hn_subscription} ->
        Feedya.Indexer.Supervisor.start!(hn_subscription)
        conn
        |> put_flash(:info, "Hn subscription created successfully.")
        |> redirect(to: page_path(conn, :profile))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    hn_subscription = Repo.get!(HNSubscription, id)
    changeset = HNSubscription.changeset(hn_subscription)
    render(conn, "edit.html", hn_subscription: hn_subscription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hn_subscription" => params}) do
    hn_subscription = Repo.get!(HNSubscription, id)
    params = prepare_params(params, Guardian.Plug.current_resource(conn).id)
    changeset = HNSubscription.changeset(hn_subscription, params)

    case Repo.update(changeset) do
      {:ok, hn_subscription} ->
        conn
        |> put_flash(:info, "Hn subscription updated successfully.")
        |> redirect(to: page_path(conn, :profile))
      {:error, changeset} ->
        render(conn, "edit.html", hn_subscription: hn_subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hn_subscription = Repo.get!(HNSubscription, id)
    Repo.delete!(hn_subscription)

    conn
    |> put_flash(:info, "Hn subscription deleted successfully.")
    |> redirect(to: page_path(conn, :profile))
  end

  defp prepare_params(params, user_id) do
    terms = String.split(params["terms"], ",")

    params
    |> Map.put("terms", terms)
    |> Map.put("user_id", user_id)
  end
end
