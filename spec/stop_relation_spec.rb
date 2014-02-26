require_relative '../config/boot'

describe StopRelation do
  subject do
    routes = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7).map { |str| Route.new(*str.each_char.to_a) }
    stop_map = StopMap.new(*routes)
  end

  describe '#initialize' do
    it 'returns a instance of StopRelation if the inputs stops exist' do
      expect(StopRelation.new(subject.stops, 'A', 'C')).to be_a(StopRelation)
    end

    it 'raises error if input stop dont exist' do
      -> { StopRelation.new(subject.stops, 'M', 'C') }.should raise_error
      -> { StopRelation.new(subject.stops, 'C', 'K') }.should raise_error
    end
  end

  describe '#direct_route' do
    it 'returns the direct route of the begin stop and end stop if the route exist' do
      expect(StopRelation.new(subject.stops, 'E', 'B').direct_route).to be_a(Route)
    end

    it 'returns nil if the direct route dont exist' do
      expect(StopRelation.new(subject.stops, 'E', 'A').direct_route).to be_nil
    end
  end

  describe '#direct?' do
    it 'returns true if the direct route exist' do
      expect(StopRelation.new(subject.stops, 'E', 'B').direct?).to be_true
    end

    it 'returns false if the direct route dont exist' do
      expect(StopRelation.new(subject.stops, 'E', 'A').direct?).to be_false
    end
  end

  describe '#where' do
    it 'sets the instance variables from options' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C')
      stop_relation.where(routes_count: 3,
                          max_routes_count: 4,
                          max_distance: 5,
                          shortest: true)

      expect(stop_relation.routes_count).to eq(3)
      expect(stop_relation.max_routes_count).to eq(4)
      expect(stop_relation.max_distance).to eq(5)
      expect(stop_relation.shortest).to be_true
    end

    it 'returns self' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C')
      expect(stop_relation.where(routes_count: 3)).to be(stop_relation)
    end
  end

  describe '#to_s' do
    it 'returns the string of result paths' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_routes_count: 3)
      puts stop_relation.to_s
      expect(stop_relation.to_s).to eq(['CDC', 'CEBC'].to_s)
    end
  end

  describe '#load!' do
    it 'returns false if relation already loaded' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_routes_count: 3)
      stop_relation.load!
      expect(stop_relation.load!).to be_false
    end

    it 'returns false if no valid limiting options' do
      expect(StopRelation.new(subject.stops, 'C', 'C').where({abc: 123}).load!).to be_false
    end

    it 'gets the valid paths and returns true for the option max_routes_count' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_routes_count: 3)
      expect(stop_relation.load!).to be_true
      expect(stop_relation.paths.map(&:to_s)).to eq(['CDC', 'CEBC'])
    end

    it 'gets the valid paths and returns true for the option routes_count' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(routes_count: 4)
      expect(stop_relation.load!).to be_true
      expect(stop_relation.paths.map(&:to_s)).to eq(["CDEBC", "CDCDC"])
    end

    it 'gets the valid paths and returns true for the option shortest' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(shortest: true)
      expect(stop_relation.load!).to be_true
      expect(stop_relation.paths.map(&:to_s)).to eq(["CEBC"])
    end

    it 'gets the valid paths and returns true for the option routes_count' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_distance: 30)
      expect(stop_relation.load!).to be_true
      expect(stop_relation.paths.map(&:to_s)).to eq(["CDC", "CEBC", "CDEBC", "CEBCDC", "CDCEBC", "CEBCEBC", "CEBCDEBC", "CDEBCEBC", "CEBCEBCEBC"])
    end

    it 'gets the valid paths and returns true for the multiple options' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_distance: 30, routes_count: 5)
      expect(stop_relation.load!).to be_true
      expect(stop_relation.paths.map(&:to_s)).to eq(["CEBCDC", "CDCEBC"])
    end
  end

  describe '#load?' do
    it 'returns true if loaded' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_routes_count: 3)
      stop_relation.load!
      expect(stop_relation.loaded?).to be_true
    end

    it 'returns false if relation didnt load' do
      stop_relation = StopRelation.new(subject.stops, 'C', 'C').where(max_routes_count: 3)
      expect(stop_relation.loaded?).to be_false
    end
  end

end
