class StopRelation
  include Enumerable

  attr_reader :stops, :begin_stop, :end_stop, :paths, :loaded
  attr_accessor :routes_count, :max_routes_count, :max_distance, :shortest, :max_cost_time

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
    [:routes_count, :max_routes_count, :max_distance, :max_cost_time].each do |option|
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

    unless valid_options?
      puts 'You must give stop relation at least one limiting condition'
      return false
    end

    path = Path.new.begin_from(begin_stop)
    find_path(path => stops[begin_stop])
    @loaded = true
  end

  def valid_options?
    routes_count || max_routes_count || max_distance || shortest || max_cost_time
  end

  def loaded?
    loaded
  end

  private

  def find_path(path_routes_map)
    next_path_routes_map = {}
    #current_path_length = path_routes_map.keys.first.routes_count #The keys should all have the same routes_count

    path_routes_map.each do |path, routes|
      routes.each do |route|
        next_path = path + route

        break if path_fail_options? next_path

        if route.to_stop == end_stop && path_pass_options?(next_path)
          @paths << next_path
          if shortest
            @paths = [paths.min_by { |route| route.distance }]
            break
          end
        end

        next_path_routes_map[next_path] ||= []
        next_path_routes_map[next_path] += stops[route.to_stop]
      end

    end

    find_path(next_path_routes_map) unless next_path_routes_map.empty?
  end

  def path_fail_options?(path)
    return true if routes_count && path.routes_count > routes_count
    return true if max_routes_count && path.routes_count > max_routes_count
    return true if max_distance && path.distance > max_distance
    return true if shortest && paths.first && paths.first.distance <= path.distance
    return true if max_cost_time && path.time_cost > max_cost_time
  end

  def path_pass_options?(path)
    # pass = true
    # pass = false if routes_count && routes_count != path.routes_count
    # pass = false if max_routes_count && max_routes_count < path.routes_count
    # pass = false if max_distance && max_distance < path.distance
    # pass = false if max_cost_time && max_cost_time < path.time_cost
    # pass
    [routes_count && (routes_count != path.routes_count),
     max_routes_count && (max_routes_count < path.routes_count),
     max_distance && (max_distance < path.distance),
     max_cost_time && (max_cost_time < path.time_cost)].all? { |result| !result }
  end

end
