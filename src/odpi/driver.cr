class ODPI::Driver < DB::Driver
  class ConnectionBuilder < ::DB::ConnectionBuilder
    def initialize(@options : ::DB::Connection::Options, @odpi_options : ODPI::Connection::Options)
    end

    def build : ::DB::Connection
      ODPI::Connection.new(@options, @odpi_options)
    end
  end

  def connection_builder(uri : URI) : ::DB::ConnectionBuilder
    params = HTTP::Params.parse(uri.query || "")
    ConnectionBuilder.new(connection_options(params), ODPI::Connection::Options.from_uri(uri))
  end

  def build_connection(context : DB::ConnectionContext) : ODPI::Connection
    ODPI::Connection.new(context)
  end
end

DB.register_driver "odpi", ODPI::Driver
