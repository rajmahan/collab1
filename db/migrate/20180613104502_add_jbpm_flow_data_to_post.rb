class AddJbpmFlowDataToPost < ActiveRecord::Migration
  def change
    add_column "posts", :jbpm_flow,  :boolean, default: false
    add_column "posts", :jbpm_flow_data, :jsonb, default: {}
  end
end
