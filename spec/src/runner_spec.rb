require 'spec_helper'

describe Gorilla::Runner do

  before do
    Gorilla::Runner.any_instance.stub(:run!).and_return(false)
  end

  describe '.run!' do

    it 'returns instance of self' do
      expect(Gorilla::Runner.run!).to be_a(Gorilla::Runner)
    end

    it 'returns same instance twice' do
      expect(Gorilla::Runner.run!).to eq(Gorilla::Runner.run!)
    end

  end

end
