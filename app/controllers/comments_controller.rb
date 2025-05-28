class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[update destroy]

  def create
    comment = @post.comments.build(body: params[:body], author: @current_user)
    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize_owner!(@comment)
    if @comment.update(body: params[:body])
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_owner!(@comment)
    @comment.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_owner!(record)
    render json: { error: 'Forbidden' }, status: :forbidden unless record.author == @current_user
  end
end
