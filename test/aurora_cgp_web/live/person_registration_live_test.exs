defmodule AuroraCGPWeb.PersonRegistrationLiveTest do
  use AuroraCGPWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import AuroraCGP.PersonsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/persons/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_person(person_fixture())
        |> live(~p"/persons/register")
        |> follow_redirect(conn, "/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(person: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Register"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register person" do
    test "creates account and logs the person in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/register")

      email = unique_person_email()
      form = form(lv, "#registration_form", person: valid_person_attributes(email: email))
      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings"
      assert response =~ "Log out"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/register")

      person = person_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          person: %{"email" => person.email, "password" => "valid_password"}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/register")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Log in")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/persons/log_in")

      assert login_html =~ "Log in"
    end
  end
end
