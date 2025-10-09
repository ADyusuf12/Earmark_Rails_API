class ListingsQuery
  attr_reader :relation, :params

  def initialize(relation = Listing.all, params = {})
    @relation = relation
    @params   = params
  end

  def call
    scoped = relation
    scoped = filter_by_location(scoped)
    scoped = filter_by_price(scoped)
    scoped = filter_by_keyword(scoped)
    scoped = apply_sort(scoped)
    scoped = paginate(scoped)
    scoped
  end

  private

  def filter_by_location(scope)
    return scope unless params[:location].present?
    scope.where("location ILIKE ?", "%#{params[:location]}%")
  end

  def filter_by_price(scope)
    min = params[:min_price].presence && params[:min_price].to_f
    max = params[:max_price].presence && params[:max_price].to_f

    scope = scope.where("price >= ?", min) if min
    scope = scope.where("price <= ?", max) if max
    scope
  end

  def filter_by_keyword(scope)
    return scope unless params[:q].present?
    q = "%#{params[:q]}%"
    scope.where("title ILIKE :q OR description ILIKE :q OR location ILIKE :q", q: q)
  end

  def apply_sort(scope)
    case params[:sort]
    when "price_asc"
      scope.order(price: :asc)
    when "price_desc"
      scope.order(price: :desc)
    when "newest"
      scope.order(created_at: :desc)
    else
      scope.order(created_at: :desc)
    end
  end

  def paginate(scope)
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    scope.page(page).per(per_page)
  end
end
