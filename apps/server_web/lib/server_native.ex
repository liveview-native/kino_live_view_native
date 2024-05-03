defmodule ServerNative do
  import ServerWeb, only: [verified_routes: 0]

  def live_view() do
    quote do
      use LiveViewNative.LiveView,
        formats: [
          :html,
          :jetpack,
          :swiftui
        ],
        layouts: [
          html: {ServerWeb.Layouts.HTML, :app},
          jetpack: {ServerWeb.Layouts.Jetpack, :app},
          swiftui: {ServerWeb.Layouts.SwiftUI, :app}
        ]

      unquote(verified_routes())
    end
  end

  def render_component(opts) do
    opts =
      opts
      |> Keyword.take([:format])
      |> Keyword.put(:as, :render)

    quote do
      use LiveViewNative.Component, unquote(opts)

      unquote(helpers(opts[:format]))
    end
  end

  def component(opts) do
    opts = Keyword.take(opts, [:format, :root, :as])

    quote do
      use LiveViewNative.Component, unquote(opts)

      unquote(helpers(opts[:format]))
    end
  end

  def layout(opts) do
    opts = Keyword.take(opts, [:format, :root])

    quote do
      use LiveViewNative.Component, unquote(opts)

      import LiveViewNative.Component, only: [csrf_token: 1]

      unquote(helpers(opts[:format]))
    end
  end

  defp helpers(format) do
    gettext_quoted = quote do
      import ServerWeb.Gettext
    end

    plugin = LiveViewNative.fetch_plugin!(format)
    plugin_component_quoted = try do
      Code.ensure_compiled!(plugin.component)

      quote do
        import unquote(plugin.component)
      end
    rescue
      _ -> nil
    end

    core_component_module = Module.concat([ServerWeb, CoreComponents, plugin.module_suffix])

    core_component_quoted = try do
      Code.ensure_compiled!(core_component_module)

      quote do
        import unquote(core_component_module)
      end
    rescue
      _ -> nil
    end

    [gettext_quoted, plugin_component_quoted, core_component_quoted, verified_routes()]
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__([which | opts]) when is_atom(which) do
    apply(__MODULE__, which, [opts])
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
