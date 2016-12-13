class Path
  attr_reader :routes, :stops, :distance

  def initialize(*routes)
    @routes   = []
    @stops    = []
    @distance = 0

    routes.each { |route| add_route route }
  end

  def add_route(route)
    @stops << route.from_stop.to_s if stops.empty?

    raise 'Invalid path' unless stops.last == route.from_stop

    @stops << route.to_stop.to_s
    @routes << route
    @distance += route.distance

    self
  end

  def time_cost
    (length - 1) * StopMap::TIME_COST_PER_STOP + distance * StopMap::TIME_COST_PER_DISTANCE
  end

  def +(other)
    self.class.new(*routes + [other])
  end

  def begin_from(begin_stop)
    raise 'The path already has begin stop' unless stops.empty?

    @stops << begin_stop.to_s
    self
  end

  def to_s
    stops.join
  end

  def length
    routes.length
  end

  alias routes_count length
end
