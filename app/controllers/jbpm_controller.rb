class JbpmController < ApplicationController
   
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
	  if @post.save 
	    redirect_to post_path(@post) 
	  else
	    redirect_to root_path
	  end
  end 

end
