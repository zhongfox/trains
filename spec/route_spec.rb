require_relative '../config/boot'

describe Route do
  subject { Route.new('A', 'B', 5) }

  describe '#to_path' do
    it 'returns a instance of Path' do
      expect(subject.to_path).to be_a(Path)
    end
  end

  describe '#to_path' do
    it 'combines the stops and distance to a string' do
      expect(subject.to_s).to eq('AB5')
    end
  end
end
