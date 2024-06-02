defmodule AuroraCGPWeb.PersonSettingsLiveTest do
  use AuroraCGPWeb.ConnCase, async: true

  alias AuroraCGP.Persons
  import Phoenix.LiveViewTest
  import AuroraCGP.PersonsFixtures

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_person(person_fixture())
        |> live(~p"/persons/settings")

      assert html =~ "Change Email"
      assert html =~ "Change Password"
    end

    test "redirects if person is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/persons/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/persons/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      password = valid_person_password()
      person = person_fixture(%{password: password})
      %{conn: log_in_person(conn, person), person: person, password: password}
    end

    test "updates the person email", %{conn: conn, password: password, person: person} do
      new_email = unique_person_email()

      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => password,
          "person" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~ "A link to confirm your email"
      assert Persons.get_person_by_email(person.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "current_password" => "invalid",
          "person" => %{"email" => "with spaces"}
        })

      assert result =~ "Change Email"
      assert result =~ "must have the @ sign and no spaces"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, person: person} do
      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => "invalid",
          "person" => %{"email" => person.email}
        })
        |> render_submit()

      assert result =~ "Change Email"
      assert result =~ "did not change"
      assert result =~ "is not valid"
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      password = valid_person_password()
      person = person_fixture(%{password: password})
      %{conn: log_in_person(conn, person), person: person, password: password}
    end

    test "updates the person password", %{conn: conn, person: person, password: password} do
      new_password = valid_person_password()

      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      form =
        form(lv, "#password_form", %{
          "current_password" => password,
          "person" => %{
            "email" => person.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/persons/settings"

      assert get_session(new_password_conn, :person_token) != get_session(conn, :person_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert Persons.get_person_by_email_and_password(person.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "current_password" => "invalid",
          "person" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/persons/settings")

      result =
        lv
        |> form("#password_form", %{
          "current_password" => "invalid",
          "person" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
      assert result =~ "is not valid"
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      person = person_fixture()
      email = unique_person_email()

      token =
        extract_person_token(fn url ->
          Persons.deliver_person_update_email_instructions(%{person | email: email}, person.email, url)
        end)

      %{conn: log_in_person(conn, person), token: token, email: email, person: person}
    end

    test "updates the person email once", %{conn: conn, person: person, token: token, email: email} do
      {:error, redirect} = live(conn, ~p"/persons/settings/confirm_email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/persons/settings"
      assert %{"info" => message} = flash
      assert message == "Email changed successfully."
      refute Persons.get_person_by_email(person.email)
      assert Persons.get_person_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"/persons/settings/confirm_email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/persons/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
    end

    test "does not update email with invalid token", %{conn: conn, person: person} do
      {:error, redirect} = live(conn, ~p"/persons/settings/confirm_email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/persons/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
      assert Persons.get_person_by_email(person.email)
    end

    test "redirects if person is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"/persons/settings/confirm_email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/persons/log_in"
      assert %{"error" => message} = flash
      assert message == "You must log in to access this page."
    end
  end
end
