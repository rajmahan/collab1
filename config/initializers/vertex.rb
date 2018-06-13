if RUBY_PLATFORM =~ /java/
  # When running on Vertx we are on multi threaded mode
  # No need to lock the request. Vertx will take of such things
  require 'java'
  Rails.configuration.middleware.delete Rack::Lock
  begin
    java_import org.jruby.jubilee.vertx.JubileeVertx
    java_import java.lang.System

    puts "Initialize eventbus_consumer_handlers*********************************************"
    event_bus = JubileeVertx.vertx.eventBus

    # For update the variable data
    event_bus.consumer("return-mvn-variables").handler do |msg|
      msg_body = msg.body
      puts "update-variables Consuer handler************************** #{msg_body.present?}"
      if msg_body.present?
        res = JSON.parse(msg_body.to_s)
        post = Post.find_by_id(res["variables"]["post"])
        if post.present? && res.present?
          pfd = post.jbpm_flow_data
          (pfd ||= {}).merge!(res)
          p post.update(jbpm_flow_data: pfd)
          event_bus.publish("stateChanged_#{(post.id rescue 1)}", "")
        end
      end
    end

  rescue Exception => ex
    Rails.logger.debug "#{ex.message}"
  end
end