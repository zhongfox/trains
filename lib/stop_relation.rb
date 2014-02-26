class StopRelation
  include Enumerable

  attr_reader :stops, :begin_stop, :end_stop, :paths, :loaded
  attr_accessor :routes_count, :max_routes_count, :max_distance, :shortest

  def initialize(stops, begin_stop, end_stop)
    raise 'The stops must contain the begin stop' if stops[begin_stop].nil?
    raise 'The stops must contain the end stop' if stops[end_stop].nil?

    @paths      = []
    @stops      = stops
    @begin_stop = begin_stop.to_s
    @end_stop   = end_stop.to_s
    @loaded     = false
  end

  def direct_route
    stops[begin_stop].find { |route| route.to_stop == end_stop }
  end

  def direct?
    stops[begin_stop].any? { |route| route.to_stop == end_stop }
  end

  def each(&block)
    load!
    paths.each(&block)
  end

  def where(options)
    [:routes_count, :max_routes_count, :max_distance].each do |option|
      if options.include? option
        raise "#{option} must bigger than 0" if options[option].to_i <= 0
        send("#{option}=", options[option])
      end
    end

    self.shortest = !!options[:shortest] if options.include? :shortest

    self
  end

  def to_s
    load!
    paths.map(&:to_s).to_s
  end

  def load!
    return false if loaded

    unless routes_count || max_routes_count || max_distance || shortest
      puts 'You must give stop relation at least one limiting condition'
      return false
    end

    path = Path.new.begin_from(begin_stop)
    load_routes(path => stops[begin_stop])
    @loaded = true
  end

  def loaded?
    loaded
  end

  private

  def load_routes(path_routes_map)
    next_path_routes_map = {}
    current_path_length = path_routes_map.keys.first.routes_count #The keys should all have the same routes_count

    path_routes_map.each do |path, routes|
      routes.each do |route|
        next_path = path + route

        break if routes_count && current_path_length + 1 > routes_count
        break if max_routes_count && current_path_length + 1 > max_routes_count
        next if max_distance && next_path.distance > max_distance
        break if shortest && paths.first && paths.first.distance <= next_path.distance

        if route.to_stop == end_stop
          unless (routes_count && routes_count != current_path_length + 1) ||
            (max_routes_count && max_routes_count < current_path_length + 1) ||
            (max_distance && max_distance < next_path.distance)

            @paths << next_path
            if shortest
              @paths = [paths.min_by { |route| route.distance }]
              next
            end
          end
        end

        next_path_routes_map[next_path] ||= []
        next_path_routes_map[next_path] += stops[route.to_stop]
      end

    end

    load_routes(next_path_routes_map) unless next_path_routes_map.empty?
  end

end
