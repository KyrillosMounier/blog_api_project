class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  def index
    render json: Post.includes(:tags, :comments).all
  end

  def create
    post = @current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @post
  end

  def update
    authorize_owner!(@post)
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_owner!(@post)
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, tag_ids: [])
  end

  def authorize_owner!(record)
    render json: { error: 'Forbidden' }, status: :forbidden unless record.author == @current_user
  end
end
