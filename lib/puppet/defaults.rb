module Puppet

  define_settings(:agent,
      :logio => {
          :default => false,
          :type    => :boolean,
          :desc    => 'Whether to use Log.io to record live log for each resource.'
      }
  )

  define_settings(:agent,
      :logio_server => {
          :default => "logio",
          :type    => :string,
          :desc    => 'The domain or hostname or the ip address of Log.io server.'
      }
  )

  define_settings(:agent,
      :logio_port => {
          :default => 28777,
          :desc    => 'The port of Log.io server.'
      }
  )

  define_settings(:agent,
      :logio_node => {
          :default => "$certname",
          :type    => :string,
          :desc    => "The node name which used to identify the host on Log.io"
      }
  )

  define_settings(:agent,
      :logio_stream => {
          :default => "agent",
          :type    => :array,
          :desc    => "On which stream this host push to, may be a single stream or a group of streams
         split by ',' symbol."
      }
  )

end
