# Log destination to a log.io server
# Hard coding for a TCP socket connection, we may refactoring it to a connection pool later to
# reuse the connection.

require 'socket'

Puppet::Util::Log.newdesttype :logio do

  attr_accessor :stream, :node

  DEFAULT_SERVER = "logio".freeze
  DEFAULT_PORT   = 28777
  DEFAULT_STREAM = "agent".freeze

  @time_format = "%Y-%m-%d %H:%M:%S %z".freeze

  class << self
    def time_format=(str)
      @time_format = str.dup.freeze
    end
  end

  def initialize
    Puppet.settings.use :agent
    setup_log Puppet[:logio_stream], Puppet[:logio_node]
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

  def send_message(msg)
    @connection.write msg + "\r\n"
  end

  def send_log(msg)
    send_message build_log(msg)
  end

  def build_log(msg)
    escaped_message = escape_message(msg.to_s)
    timed_message = timestamp_message(escaped_message)
    "+log|#@stream|#@node|#{msg.level}|#{timed_message}"
  end

  def handle(msg)
    send_log msg
  end

  def timestamp_message(msg)
    "[#{Time.now.strftime(@@time_format)}] " + msg
  end

  def escape_message(msg)
    msg.gsub "\r\n", "\n"
  end

  def send_close
    send_message build_close_message
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