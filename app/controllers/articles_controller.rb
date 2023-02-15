class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :update, :destroy]

  def index
    page = params[:page] || 1
    per = params[:per] || 20
    sort_by = params[:sort_by]
    ids = params[:ids]
    keyword = params[:keyword]

    sort_options = { "id_asc" => { id: :asc }, "id_desc" => { id: :desc }, "title_asc" => { title: :asc }, "title_desc" => { title: :desc } }
    default_sort_option = sort_options["id_asc"]

    @articles = Article.all
                       .then { |articles| ids ? articles.where(id: ids) : articles }
                       .then { |articles| keyword ? articles.where("title LIKE ?", "%#{keyword}%") : articles }
                       .order(sort_options[sort_by] || default_sort_option)
                       .page(page)
                       .per(per)

    render json: {
      articles: @articles.as_json(except: :body),
      pagination: {
        per: @articles.limit_value,
        total_counts: @articles.total_count,
        total_pages: @articles.total_pages,
        is_last_page: @articles.last_page?
      }
    }
  end

  def create
    @article = Article.create!(create_params)
    render json: @article
  end

  def show
    render json: @article
  end

  def update
    @article.update!(update_params)
    render json: @article
  end

  def destroy
    render json: @article.destroy
  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def create_params
    params.permit(:title, :body)
  end

  def update_params
    params.permit(:title, :body)
  end
end
