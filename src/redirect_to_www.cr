
require "uri"
require "da"
require "http/server"
require "da_server"

module Redirect_To_WWW

  extend self

  def port
    DA.is_development? ? 4567 : 320
  end

  def service_run
    DA_Server.new(
      host: "0.0.0.0",
      port: port,
      user: "www-redirector",
      handlers: [Redirect_To_WWW::Handler.new]
    ).listen
  end # === def service_run

  # =============================================================================
  # Handler:
  # =============================================================================

  class Handler

    include HTTP::Handler

    def call(ctx)
      old_host = ctx.request.host_with_port
      path = ctx.request.path

      if !old_host
        raise Exception.new("Invalid host received: #{old_host.inspect}")
      end

      new_host = "www.#{old_host.sub(/^www\./, "")}"
      if old_host == new_host
        raise Exception.new("Received a www. domain: #{path}")
      end
      new_uri = File.join("http://", new_host, path)

      ctx.response.headers.add "Location", new_uri
      ctx.response.status_code = 301
      ctx
    end # === def call

  end # === class Handler

end # === module Redirect_To_WWW
