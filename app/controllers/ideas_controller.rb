class IdeasController < ApplicationController
  before_filter :require_user, :except => [ :preview, :show, :tags, :index]
  before_filter :check_references, :only => [ :new ]

  def index
    @ideas = Idea.recent
  end

  def new
    @tags = Idea.all_tags
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.tags = idea_params['tags'].split(',').collect(&:strip)
    @idea.user = current_user

    if @idea.save
      redirect_to idea_path(@idea), :notice => "Idea created"
    else
      render :action => "new"
    end
  end

  def preview
    filter = HTML::Pipeline::MarkdownFilter.new(params[:idea])
    render :text => filter.call
  end

  def tags
    render :json => Idea.all_tags.to_json
  end

  def show
    @idea = Idea.find_by_sha(params[:id])
  end

  private

  def check_references
    if params[:references_id]
      redirect_to ideas_path, :warning => "Could not find referenced idea" unless @references = Idea.find_by_sha(params[:references_id])
    end
  end

  def idea_params
    params.require(:idea).permit(:title, :body, :subject, :tags, :parent_id)
  end
end
