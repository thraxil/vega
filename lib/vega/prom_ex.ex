defmodule Vega.PromEx do
  @moduledoc """
  Be sure to add the following to finish setting up PromEx:

  1. Update your configuration (config.exs, dev.exs, prod.exs, releases.exs, etc) to
     configure the necessary bit of PromEx. Be sure to check out `PromEx.Config` for
     more details regarding configuring PromEx:
     ```
     config :vega, Vega.PromEx,
       disabled: false,
       manual_metrics_start_delay: :no_delay,
       drop_metrics_groups: [],
       grafana: :disabled,
       metrics_server: :disabled
     ```

  2. Add this module to your application supervision tree. It should be one of the first
     things that is started so that no Telemetry events are missed. For example, if PromEx
     is started after your Repo module, you will miss Ecto's init events and the dashboards
     will be missing some data points:
     ```
     def start(_type, _args) do
       children = [
         Vega.PromEx,

         ...
       ]

       ...
     end
     ```

  3. Update your `endpoint.ex` file to expose your metrics (or configure a standalone
     server using the `:metrics_server` config options). Be sure to put this plug before
     your `Plug.Telemetry` entry so that you can avoid having calls to your `/metrics`
     endpoint create their own metrics and logs which can pollute your logs/metrics given
     that Prometheus will scrape at a regular interval and that can get noisy:
     ```
     defmodule VegaWeb.Endpoint do
       use Phoenix.Endpoint, otp_app: :vega

       ...

       plug PromEx.Plug, prom_ex_module: Vega.PromEx

       ...
     end
     ```

  4. Update the list of plugins in the `plugins/0` function return list to reflect your
     application's dependencies. Also update the list of dashboards that are to be uploaded
     to Grafana in the `dashboards/0` function.
  """

  use PromEx, otp_app: :vega

  alias PromEx.Plugins

  @impl true
  def plugins do
    [
      # PromEx built in plugins
      Plugins.Application,
      Plugins.Beam,
      {Plugins.Phoenix, router: VegaWeb.Router, endpoint: VegaWeb.Endpoint},
      Plugins.Ecto,
      # Plugins.Oban,
      Plugins.PhoenixLiveView,
      # Plugins.Absinthe,
      # Plugins.Broadway,

      # Add your own PromEx metrics plugins
      Vega.PromExPlugin
    ]
  end

  @impl true
  def dashboard_assigns do
    [
      datasource_id: "vega",
      default_selected_interval: "30s"
    ]
  end

  @impl true
  def dashboards do
    [
      # PromEx built in Grafana dashboards
      {:prom_ex, "application.json"},
      {:prom_ex, "beam.json"}
      # {:prom_ex, "phoenix.json"},
      # {:prom_ex, "ecto.json"},
      # {:prom_ex, "oban.json"},
      # {:prom_ex, "phoenix_live_view.json"},
      # {:prom_ex, "absinthe.json"},
      # {:prom_ex, "broadway.json"},

      # Add your dashboard definitions here with the format: {:otp_app, "path_in_priv"}
      # {:vega, "/grafana_dashboards/user_metrics.json"}
    ]
  end
end

defmodule Vega.PromExPlugin do
  use PromEx.Plugin
  alias Vega.Site

  @impl true
  def polling_metrics(opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    poll_rate = Keyword.get(opts, :poll_rate, 61_000)
    metric_prefix = Keyword.get(opts, :metric_prefix, PromEx.metric_prefix(otp_app, :site))

    [
      Polling.build(
        :site_posts_count,
        poll_rate,
        {__MODULE__, :posts_count, []},
        [
          last_value(
            metric_prefix ++ [:posts, :total],
            event_name: [:prom_ex, :plugin, :site, :posts, :count],
            description: "Total number of posts",
            measurement: :count,
            unit: :count
          )
        ]
      ),
      Polling.build(
        :site_metrics,
        poll_rate,
        {__MODULE__, :users_count, []},
        [
          last_value(
            metric_prefix ++ [:users, :total],
            event_name: [:prom_ex, :plugin, :site, :users, :count],
            description: "Total number of users",
            measurement: :count,
            unit: :count
          )
        ]
      )
    ]
  end

  @doc false
  def posts_count do
    cnt = Site.count_posts()
    :telemetry.execute([:prom_ex, :plugin, :site, :posts, :count], %{count: cnt})
  end

  @doc false
  def users_count do
    cnt = Site.count_users()
    :telemetry.execute([:prom_ex, :plugin, :site, :users, :count], %{count: cnt})
  end
end
