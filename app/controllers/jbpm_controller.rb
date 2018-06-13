class JbpmController < ApplicationController
  include JbpmHelper
  def index
  		
  end

  def start

  end
  
  def new_post
  	  @branch = params[:branch]
	  @categories = Category.where(branch: @branch)
	  @post = Post.new
	  #render "cg_publisher/sidebar/view_agreement_content", locals: {agreement: agreement}, layout: 'cg_author/overlay'
	  render template: "jbpm/posts/post/new"
  end

  def save_post
    @post = Post.new(post_params)
    @post.jbpm_flow = true
	  if @post.save!
	    redirect_to post_path(@post) 
	  else
	    redirect_to root_path
	  end
  end

  def start_jbpm
    @post = Post.find_by(id: params[:post_id])
    data = { post: @post.id}
    start_the_workflow_task(data)
  end

  private

  def post_params
    params.require(:post).permit(:content, :title, :category_id).merge(user_id: current_user.id)
  end

end
