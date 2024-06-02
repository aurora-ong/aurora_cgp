defmodule AuroraCGPWeb.PersonForgotPasswordLiveTest do
  use AuroraCGPWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import AuroraCGP.PersonsFixtures

  alias AuroraCGP.Persons
  alias AuroraCGP.Repo

  describe "Forgot password page" do
    test "renders email page", %{conn: conn} do
      {:ok, lv, html} = live(conn, ~p"/persons/reset_password")

      assert html =~ "Forgot your password?"
      assert has_element?(lv, ~s|a[href="#{~p"/persons/register"}"]|, "Register")
      assert has_element?(lv, ~s|a[href="#{~p"/persons/log_in"}"]|, "Log in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_person(person_fixture())
        |> live(~p"/persons/reset_password")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end
  end

  describe "Reset link" do
    setup do
      %{person: person_fixture()}
    end

    test "sends a new reset password token", %{conn: conn, person: person} do
      {:ok, lv, _html} = live(conn, ~p"/persons/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", person: %{"email" => person.email})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"

      assert Repo.get_by!(Persons.PersonToken, person_id: person.id).context ==
               "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", person: %{"email" => "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"
      assert Repo.all(Persons.PersonToken) == []
    end
  end
end
