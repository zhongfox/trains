class Route
  attr_reader :from_stop, :to_stop, :distance

  def initialize(from_stop, to_stop, distance)
    raise 'The distance must bigger than 0' if distance.to_i <= 0

    @from_stop = from_stop.to_s
    @to_stop   = to_stop.to_s
    @distance  = distance.to_i
  end

  def to_path
    Path.new(self)
  end

  def to_s
    "#{from_stop}#{to_stop}#{distance}"
  end
end
