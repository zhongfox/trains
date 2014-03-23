class StopMap
  attr_reader :stops

  TIME_COST_PER_STOP = 2
  TIME_COST_PER_DISTANCE = 1

  def initialize(*routes)
    @stops = {}
    routes.each { |route| add_route(route) }
  end

  def add_route(route)
    @stops[route.from_stop] ||= []
    @stops[route.to_stop] ||= []
    @stops[route.from_stop] << route

    @stops[route.from_stop].sort_by! { |route|  route.distance }
  end

  def get_routes_by_path_stops(*path_stops)
    path_stops = path_stops.join.each_char.to_a
    routes = []

    raise 'Path stops length must more than 1' if path_stops.length <= 1

    path_stops.inject do |from_stop, to_stop|
      if direct_route =  relation_of(from_stop, to_stop).direct_route
        routes << direct_route
      else
        return nil
      end
      from_stop = to_stop
    end

    routes
  end

  def relation_of(begin_stop, end_stop)
    StopRelation.new(stops, begin_stop, end_stop)
  end

end
