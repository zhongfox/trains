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

    if stops.last == route.from_stop
      @stops << route.to_stop.to_s
      @routes << route
      @distance += route.distance
    else
      raise 'Invalid path'
    end

    self
  end

  def +(route)
    self.class.new(*routes + [route])
  end

  def begin_from(begin_stop)
    if stops.empty?
      @stops << begin_stop.to_s
    else
      raise 'The path already has begin stop'
    end

    self
  end

  def to_s
    stops.join
  end

  def length
    routes.length
  end

  alias :routes_count :length

end
