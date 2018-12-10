class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    redirect_back(fallback_location: home_path ) if params[:query].blank?
    @query = params[:query]
    @investigations_result = Investigation.title_search(@query)

    @criminals_result = Criminal.search(@query)

    @officers_result = Officer.search(@query)

    @total_hits = @investigations_result.size + @criminals_result.size + @officers_result.size
  end
end
