defmodule AuroraCGPWeb.PersonConfirmationInstructionsLiveTest do
  use AuroraCGPWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import AuroraCGP.PersonsFixtures

  alias AuroraCGP.Persons
  alias AuroraCGP.Repo

  setup do
    %{person: person_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/persons/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, person: person} do
      {:ok, lv, _html} = live(conn, ~p"/persons/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", person: %{email: person.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Persons.PersonToken, person_id: person.id).context == "confirm"
    end

    test "does not send confirmation token if person is confirmed", %{conn: conn, person: person} do
      Repo.update!(Persons.Person.confirm_changeset(person))

      {:ok, lv, _html} = live(conn, ~p"/persons/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", person: %{email: person.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Persons.PersonToken, person_id: person.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", person: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Persons.PersonToken) == []
    end
  end
end
