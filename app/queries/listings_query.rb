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

  def paginate(scope)
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    scope.page(page).per(per_page)
  end
end
