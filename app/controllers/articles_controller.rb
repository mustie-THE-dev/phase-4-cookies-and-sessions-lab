class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def increment_counter
    if session[:page_views].nil?
      session[:page_views] = 0
    end
    session[:page_views] += 1
  end
  
    def index
      articles = Article.all.includes(:user).order(created_at: :desc)
      render json: articles, each_serializer: ArticleListSerializer
    end
  
    def show
      @count =  increment_counter
      if @count<=3
      article = Article.find(params[:id])
      render json: article
      else
        render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
      end
    end
  
    private
  
    def record_not_found
      render json: { error: "Article not found" }, status: :not_found
    end
  

end
