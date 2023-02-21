defmodule ComponentPreviewer.CodeLive do
  @moduledoc false
  use ComponentPreviewer, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>&lt;.code&gt;</.header>

    <.code source={File.read!(__MODULE__.__info__(:compile)[:source])} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "<.code>")}
  end
end
