require_relative '../config/boot'

describe StopMap do
  subject do
    routes = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7).map { |str| Route.new(*str.each_char.to_a) }
    stop_map = StopMap.new(*routes)
  end

  describe '#add_route' do
    it 'builds the StopMap object' do
      expect(subject.stops.keys).to eq(["A", "B", "C", "D", "E"])
    end

    it 'sorts the routes by the distance' do
      expect(subject.stops['A'].map(&:to_s)).to eq(['AB5', 'AD5', 'AE7'])
      expect(subject.stops['B'].map(&:to_s)).to eq(["BC4"])
      expect(subject.stops['C'].map(&:to_s)).to eq(["CE2", "CD8"])
      expect(subject.stops['D'].map(&:to_s)).to eq(["DE6", "DC8"])
      expect(subject.stops['E'].map(&:to_s)).to eq(["EB3"])
    end
  end

  describe '#get_routes_by_path_stops' do
    it 'returns the path if input stops are end to end' do
      expect(subject.get_routes_by_path_stops('ABC').map(&:to_s)).to eq(['AB5', 'BC4'])
    end

    it 'returns nil if input stops are not end to end' do
      expect(subject.get_routes_by_path_stops('AED')).to be(nil)
    end

    it 'raises error if input stops less than 2' do
      -> { subject.get_routes_by_path_stops() }.should raise_error
      -> { subject.get_routes_by_path_stops('A') }.should raise_error
    end
  end

  describe '#relation_of' do
    it 'returns a StopRelation object with correct stops' do
      stop_relation = subject.relation_of('A', 'E')

      expect(stop_relation).to be_a(StopRelation)
      expect(stop_relation.begin_stop).to eq('A')
      expect(stop_relation.end_stop).to eq('E')
    end
  end

end
