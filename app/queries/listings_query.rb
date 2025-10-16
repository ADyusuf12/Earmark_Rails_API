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
    scope.where("LOWER(location) LIKE ?", "%#{params[:location].downcase}%")
  end

  def filter_by_price(scope)
    min = safe_float(params[:min_price])
    max = safe_float(params[:max_price])

    scope = scope.where("price >= ?", min) if min
    scope = scope.where("price <= ?", max) if max
    scope
  end

  def filter_by_keyword(scope)
    return scope unless params[:q].present?
    q = "%#{params[:q].downcase}%"
    scope.where(
      "LOWER(title) LIKE :q OR LOWER(description) LIKE :q OR LOWER(location) LIKE :q",
      q: q
    )
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
    page     = safe_int(params[:page])     || 1
    per_page = safe_int(params[:per_page]) || 10
    scope.page(page).per(per_page)
  end

  # Helpers
  def safe_float(value)
    return nil unless value.present?
    Float(value) rescue nil
  end

  def safe_int(value)
    return nil unless value.present?
    Integer(value) rescue nil
  end
end
