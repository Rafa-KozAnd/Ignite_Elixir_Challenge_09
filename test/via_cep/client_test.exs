defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias Rockelivery.ViaCep.Client

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there is a valid cep, returns the cep info", %{bypass: bypass} do
      cep = "69905080"

      url = endpoint_url(bypass.port)
      body = ~s(
        {
          "cep": "69905-080",
          "logradouro": "Avenida Epaminondas Jácome",
          "complemento": "de 1700/1701 a 1999/2000",
          "bairro": "Habitasa",
          "localidade": "Rio Branco",
          "uf": "AC",
          "ibge": "1200401",
          "gia": "",
          "ddd": "68",
          "siafi": "0139"
        }
      )

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:ok, "Avenida Epaminondas Jácome, Habitasa, Rio Branco/AC"}

      assert expected_response == response
    end

    test "when there is a invalid cep, returns an error", %{bypass: bypass} do
      cep = "699"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Plug.Conn.resp(400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: "invalid CEP", status: :bad_request}}

      assert expected_response == response
    end

    test "when the cep was not found, returns an error", %{bypass: bypass} do
      cep = "00000000"

      body = ~s({"erro": true})

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: "CEP not found!", status: :not_found}}

      assert expected_response == response
    end

    test "when there is as generic error , returns an error", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error, %Rockelivery.Error{result: :econnrefused, status: :bad_request}}

      assert expected_response == response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
