defmodule AuroraCGPWeb.PersonSessionControllerTest do
  use AuroraCGPWeb.ConnCase, async: true

  import AuroraCGP.PersonsFixtures

  setup do
    %{person: person_fixture()}
  end

  describe "POST /persons/log_in" do
    test "logs the person in", %{conn: conn, person: person} do
      conn =
        post(conn, ~p"/persons/log_in", %{
          "person" => %{"email" => person.email, "password" => valid_person_password()}
        })

      assert get_session(conn, :person_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ person.email
      assert response =~ ~p"/persons/settings"
      assert response =~ ~p"/persons/log_out"
    end

    test "logs the person in with remember me", %{conn: conn, person: person} do
      conn =
        post(conn, ~p"/persons/log_in", %{
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_aurora_cgp_web_person_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the person in with return to", %{conn: conn, person: person} do
      conn =
        conn
        |> init_test_session(person_return_to: "/foo/bar")
        |> post(~p"/persons/log_in", %{
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "login following registration", %{conn: conn, person: person} do
      conn =
        conn
        |> post(~p"/persons/log_in", %{
          "_action" => "registered",
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password()
          }
        })

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
    end

    test "login following password update", %{conn: conn, person: person} do
      conn =
        conn
        |> post(~p"/persons/log_in", %{
          "_action" => "password_updated",
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password()
          }
        })

      assert redirected_to(conn) == ~p"/persons/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/persons/log_in", %{
          "person" => %{"email" => "invalid@email.com", "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/persons/log_in"
    end
  end

  describe "DELETE /persons/log_out" do
    test "logs the person out", %{conn: conn, person: person} do
      conn = conn |> log_in_person(person) |> delete(~p"/persons/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :person_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the person is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/persons/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :person_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
