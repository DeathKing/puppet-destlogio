
# Log destination to a log.io server
# Hard coding for a TCP socket connection, we may refactoring it to a connection pool later to
# reuse the connection.

Puppet::Util::Log.newdesttype :logio do

  require 'socket'

  attr_accessor :stream, :node

  ENDLINE = "\r\n".freeze
  NEWLINE = "\n".freeze

  DEFAULT_SERVER = "logio".freeze
  DEFAULT_PORT   = 28777
  DEFAULT_STREAM = "agent".freeze

  @time_format = "%Y-%m-%d %H:%M:%S %z".freeze

  class << self
    attr_reader :time_format

    def time_format=(str)
      @time_format = str.dup.freeze
    end
  end

  def initialize
    Puppet.settings.use :agent
    setup_log(Puppet[:logio_stream], Puppet[:logio_node])
    setup_connection
  end

  def setup_connection
    server  = Puppet[:logio_server] || DEFAULT_SERVER
    port    = Puppet[:logio_port]   || DEFAULT_PORT
    @connection = TCPSocket.new(server, port)
  end

  def setup_log(stream, node)
    @stream = stream || DEFAULT_STREAM
    @node = node || Puppet[:certname]
  end

  def send_message(msgstr)
    @connection.write "#{msgstr}#{ENDLINE}"
  end

  def send_log(msg)
    send_message build_log(msg)
  end

  def build_log(msg)
    time = get_log_time(msg)
    message = filter_message(msg)
    "+log|#@stream|#@node|#{msg.level}|[#{time}] #{msg.source} #{msg.level}: #{message}"
  end

  def handle(msg)
    send_log msg
  end

  def get_log_time(msg)
    msg.time.strftime(self.class.time_format)
  end

  # Maybe you wanto filter some message such as password stuff?
  # This method should have type Puppet::Util::Log -> String
  def filter_message(msg)
    msgstr = msg.to_s
    # all another filter methd should have type String -> String
    msgstr = escape_message(msgstr)
    msgstr
  end

  def escape_message(msgstr)
    msgstr.gsub(ENDLINE, NEWLINE)
  end

  def send_close
    send_message(build_close_message)
  end

  def build_close_message
    "-node|#@node"
  end

  def close
    send_close
    close_connection
  end

  def close_connection
    if @connection
      @connection.close
      @connection = nil
    end
  end
end