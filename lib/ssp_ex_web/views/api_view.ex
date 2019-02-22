defmodule SspExWeb.ApiView do
  use SspExWeb, :view

  def render("api.json", %{url: url}) do
    %{
      url: url
    }
  end
end
