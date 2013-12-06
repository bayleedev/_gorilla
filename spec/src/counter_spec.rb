require 'spec_helper'

describe Gorilla::Counter do

  describe '.new' do

    it 'sets counter to 0' do
      expect(subject.counter).to eq(0)
    end

  end

  describe '#plusplus' do

    before do
      expect(subject.counter).to eq(0)
      subject.plusplus
    end

    it 'increments counter by 1' do
      expect(subject.counter).to eq(1)
    end

  end

  describe '#to_s' do

    it 'converts the current number to a string' do
      expect(subject.to_s).to eq('0')
    end

  end

end
