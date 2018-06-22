module JbpmHelper

  def get_task_user
    user = "new-publisher"
    user
  end

  def start_the_workflow_task(data = {}, user = nil)
    user ||= get_task_user
    event_bus = JubileeVertx.vertx.eventBus
    datas = input_to_event_bus("start-process", data, user)
    event_bus.send("inbound-address", datas){|res, err|
      # update_response(res, err, "process_instance")
    }
  rescue => e
    puts "Failed to start workflow !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{e.inspect}"
  end

  def get_all_variables
    event_bus = JubileeVertx.vertx.eventBus
    datas = input_to_event_bus("get-variables")
    event_bus.send("inbound-address", datas) {|res, err|
      # update_response(res, err, "variables")
    }
  rescue => e
    puts "Failed to get_variables !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{e.inspect}"
    puts e.backtrace.join("\n")
  end

  def task_action(data = {}, user = nil)
    user ||= get_task_user
    event_bus = JubileeVertx.vertx.eventBus
    datas = input_to_event_bus("task-action", data, user)
    event_bus.send("inbound-address", datas) {|res, err|
      update_response(res, err)
      post_id = @post.id rescue 1
      event_bus.publish("stateChanged_#{post_id}", "")
    }
  rescue => e
    puts "Failed to perform task_action !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{e.inspect}"
  end

  def update_response(res, err, update_to = "")
    if res.present? && res.result().present?
      @post.reload
      pfd = @post.jbpm_flow_data
      response = JSON.parse(res.result().body().to_s)
      update_to = response["name"] unless update_to.present?
      (pfd ||= {}).merge!(response) if response.present?
      @post.update(jbpm_flow_data: pfd)
      @post.reload
    end
  rescue => e
    puts "Failed to perform update_response !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{e.inspect}"
    puts e.backtrace.join("\n")
  end


  def input_to_event_bus(action, data = {}, user = "new-publisher")
    datas = {}
    if @post.present?
      pfd = @post.jbpm_flow_data
      piid, process_id = if pfd && pfd["process_instance"].present?
                           [pfd["process_instance"]["piid"].to_s, pfd["process_instance"]["process_id"]]
                         else
                           ["0", "publisher-flow.mva1"]
                         end
      datas = {action: action, piid: piid, process_id: process_id, user: user, datas: data,
               url: "http://localhost:8090/jbpm-console", deployment_id: "scholarorg:publisher-flow:LATEST"}
    end
    return datas.to_json
  rescue => e
    puts "Failed to perform input_to_event_bus !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{e.inspect}"
    puts e.backtrace.join("\n")
  end

end
