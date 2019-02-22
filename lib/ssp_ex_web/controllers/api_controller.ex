defmodule SspExWeb.ApiController do
  use SspExWeb, :controller

  def execute(conn, %{"app_id" => app_id}) do
    # payload 作成
    ssp_name = "y_sako"
    request_time = Timex.now("Asia/Tokyo")
                   |> Timex.format!("%Y%m%d-%H%M%S.%f", :strftime)
                   |> String.slice(0, 20)
    request_id = ssp_name <> "-" <> UUID.uuid4()


    # DSPに並列でリクエスト送信
    HTTPoison.start()

    payload = %{
      ssp_name: ssp_name,
      request_time: request_time,
      request_id: request_id,
      app_id: app_id
    }

    urls = [
      %{
        host: "10.100.100.20",
        port: "80"
      },
      %{
        host: "10.100.100.22",
        port: "80"
      }
    ]

    ad_list = urls
              |> Flow.from_enumerable
              |> Flow.map(fn url -> process(url, payload) end)
              |> Enum.to_list
              |> Enum.sort(fn(x, y) -> x.price > y.price end)


    # WinNotice
    IO.inspect(ad_list)
    winner = Enum.at(ad_list, 0)
    win_url = winner.req_url <> "/win"
    win_price = Enum.at(ad_list, 1).price
    win_payload = %{request_id: request_id, price: win_price}
    IO.inspect(win_payload)

    HTTPoison.post!(win_url, Poison.encode!(win_payload), [{"Content-Type", "application/json"}])
    render(conn, "api.json", url: winner.ad_url)
  end

  defp process(%{host: host, port: port}, payload) do
    req_url = "http://#{host}:#{port}"
    res = HTTPoison.post!(req_url <> "/req", Poison.encode!(payload), [{"Content-Type", "application/json"}])
    body = Poison.decode!(res.body)
    %{
      price: body["price"],
      ad_url: body["url"],
      req_url: req_url
    }
  end
end
