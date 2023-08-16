class ODPI::Driver < DB::Driver
  def build_connection(context : DB::ConnectionContext) : ODPI::Connection
    ODPI::Connection.new(context)
  end

  def connection_builder(uri : URI) : DB::ConnectionBuilder
    # Error fix
    # Error: abstract `def DB::Driver#connection_builder(uri : URI)` must be implemented by ODPI::Driver
  end
end

DB.register_driver "odpi", ODPI::Driver
