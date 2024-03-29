module ODPI
  class ODPI::Connection < DB::Connection
    @raw_conn : LibODPI::DpiConn*
    @raw_context : LibODPI::DpiContext*
    @details : String?
    getter raw_conn, raw_context

    record Options, 
      host : String,
      port : Int32?,
      path : String?,
      user : String,
      password : String do
      def self.from_uri(uri : URI) : Options
        host = uri.hostname || raise "no host was provided"
        port = uri.port
        path = uri.path
        user = uri.user || raise "username is missing"
        password = uri.password || raise "password is missing"

        Options.new(host: host, port: port, path: path, user: user, password: password)
      end
    end

    def initialize(options : ::DB::Connection::Options, odpi_options : Options)
      super(options)

      @raw_conn = Pointer(LibODPI::DpiConn).null
      @raw_context = Pointer(LibODPI::DpiContext).null

      error = LibODPI::DpiErrorInfo.new

      res = LibODPI.dpi_context_create_with_params(LibODPI::DPI_MAJOR_VERSION,LibODPI::DPI_MINOR_VERSION,nil, pointerof(@raw_context), pointerof(error))

      if res != LibODPI::DPI_SUCCESS
        puts String.new(error.message)
      end

      user = odpi_options.user.not_nil!.to_slice()
      user_len = user.size
      user = user.to_unsafe.as(Pointer(LibODPI::UserName))

      password = odpi_options.password.not_nil!.to_slice
      conn_string =
        if odpi_options.port != nil
          "#{odpi_options.host}:#{odpi_options.port}#{odpi_options.path}".to_slice
        else
          "#{odpi_options.host}#{odpi_options.path}".to_slice
        end

      common_params = Pointer(LibODPI::DpiCommonCreateParams).null
      create_params = Pointer(LibODPI::DpiConnCreateParams).null

      # connect to the database
      res = LibODPI.dpi_context_init_conn_create_params(@raw_context, create_params)

      if res != LibODPI::DPI_FAILURE
        LibODPI.dpi_context_get_error(@raw_context,pointerof(error))
        puts String.new(error.message)
      end

      res = LibODPI.dpi_conn_create(@raw_context, user, user_len, password,
                                 password.size, conn_string, conn_string.size,
                                 common_params, create_params, pointerof(@raw_conn))

      if res != LibODPI::DPI_SUCCESS
        LibODPI.dpi_context_get_error(@raw_context, pointerof(error))
        error_msg = String.new(error.message)
        raise "Error establishing connection: #{error_msg}"
      end
    end

    def build_prepared_statement(query) : Statement
      Statement.new(self, query)
    end

    def build_unprepared_statement(query) : Statement
      Statement.new(self, query)
    end

    def do_close
      super
      res = LibODPI.dpi_conn_release(@raw_conn)
      res = LibODPI.dpi_context_destroy(@raw_context)
    end
  end
end
