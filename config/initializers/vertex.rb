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
    event_bus.consumer("update-variables").handler do |msg|
      msg_body = msg.body
      puts "update-variables Consuer handler************************** #{msg_body.present?}"
      if msg_body.present?
        res = JSON.parse(msg_body.to_s)
        cp = CgProject::CreatorProject.find_by_id(res["variables"]["creator_project"])
        if cp.present? && res.present?
          pfd = cp.publisher_flow_data
          (pfd ||= {}).merge!(res)
          p cp.update(publisher_flow_data: pfd)
          event_bus.publish("stateChanged_#{(cp.work.id rescue 1)}", "")
        end
      end
    end

    # For update current_task_data
    event_bus.consumer("serve-notification").handler do |msg|
      begin
        msg_body = msg.body
        puts "serve-notification Consuer handler************************** #{msg_body}"
        if msg_body.present?
          res = JSON.parse(msg_body.to_s)
          p CgNotificationClient::NotificationNotifier.new.serve_notification(res["n_type"], res["work_id"], res["opts"])
        end
      rescue => e
        puts "Serve notification failed............................... #{e.inspect}"
        puts e.backtrace.join("\n")
      end
    end

  rescue Exception => ex
    Rails.logger.debug "#{ex.message}"
  end
end