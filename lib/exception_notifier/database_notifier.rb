module ExceptionNotifier
  class DatabaseNotifier
    def initialize(_options)
      # do something with the options...
    end

    def call(exception, options = {})
      begin
        @ip              = (options[:env]['HTTP_X_REAL_IP'] || options[:env]['action_dispatch.remote_ip'].instance_variable_get(:@ip))
        @controller_info = options[:env]['action_dispatch.request.parameters']['controller']
        @action_info     = options[:env]['action_dispatch.request.parameters']['action']
        @params          = options[:env]['action_dispatch.request.parameters']
        @params.delete_if { |key, _value| ['authenticity_token', 'utf8', 'action', 'controller'].include?(key) }
      rescue
        nil
      end
      @title   = exception.message
      messages = []
      messages << exception.inspect
      unless exception.backtrace.blank?
        messages << "\n"
        messages << exception.backtrace[0, 100]
      end
      if  Rails.env.production? 
        ExceptionLog.create(title:      @title,
                            body:       messages.join("\n"),
                            controller: @controller_info,
                            action:     @action_info,
                            params:     @params.to_json,
                            ip:         @ip,
                            local_ip:   @ip  )
      else
        puts "\n======================"
        puts messages.join("\n")
        puts "======================\n"
      end
    end
  end
end