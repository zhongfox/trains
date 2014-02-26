require_relative '../config/boot'

describe Path do
  describe '#add_route' do
    it 'adds route to path' do
      route_a_b = Route.new(:a, :b, 5)
      route_b_d = Route.new(:b, :d, 7)
      path = Path.new.add_route(route_a_b).add_route(route_b_d)
      expect(path.stops).to eq(['a', 'b', 'd'])
      expect(path.routes).to eq([route_a_b, route_b_d])
    end

    it 'raises a error if routes are not end to end' do
      route_a_b = Route.new(:a, :b, 5)
      route_e_d = Route.new(:c, :d, 7)
      path = Path.new.add_route(route_a_b)
      -> { path.add_route(route_e_d) }.should raise_error
    end
  end

  describe '#+' do
    it 'creates a new path object with the routes of both' do
      route_a_b = Route.new(:a, :b, 5)
      route_b_d = Route.new(:b, :d, 7)
      path = Path.new(route_a_b, route_b_d)
      route_b_d = Route.new(:d, :f, 2)

      new_path = path + route_b_d

      expect(path).not_to be(new_path)
      expect(path.routes).to have(2).items
      expect(new_path.routes).to have(3).items
    end
  end

  describe '#begin_from' do
    it 'adds the begin stop for empty path' do
      empty_path = Path.new
      empty_path.begin_from(:a)

      expect(empty_path.stops).to eq(['a'])
    end

    it 'raises error for not empty path' do
      not_empty_path = Path.new(Route.new(:a, :b, 5))

      -> { not_empty_path.begin_from(:a) }.should raise_error
    end
  end

  describe '#to_s' do
    it 'returns the sting of routes' do
      route_a_b = Route.new(:a, :b, 5)
      route_b_d = Route.new(:b, :d, 7)
      path = Path.new(route_a_b, route_b_d)

      expect(path.to_s).to eq('abd')
    end
  end

  describe '#length' do
    it 'returns the length of routes' do

      route_a_b = Route.new(:a, :b, 5)
      route_b_d = Route.new(:b, :d, 7)
      path = Path.new(route_a_b, route_b_d)

      expect(path.length).to eq(2)
      expect(path.routes_count).to eq(2)
    end
  end

end
