require 'spec_helper'

describe Gorilla::Signature do

  describe '#klass' do

    context 'the existing class String' do

      subject { Gorilla::Signature.new('String#size') }

      it { expect(subject.klass).to eq(String) }

    end

    context 'a non existing class Person' do

      subject { Gorilla::Signature.new('Person#name') }

      it { expect(subject.klass).to be_false }

    end

    context 'namespaced class' do

      subject { Gorilla::Signature.new('Gorilla::Signature.new') }

      it { expect(subject.klass).to eq(Gorilla::Signature) }

    end

  end

  describe '#method' do

    context 'existing static method' do

      subject { Gorilla::Signature.new('String.name') }

      it { expect(subject.method).to eq(:name) }

    end

    context 'non-existing instance method' do

      subject { Gorilla::Signature.new('Person#name') }

      it { expect(subject.method).to eq(:name) }

    end

  end

  describe '#to_s' do

    it 'should return given signature' do
      expect(Gorilla::Signature.new('Foo#baz').to_s).to eq('Foo#baz')
    end

  end

  describe '#instance_method?' do

    context 'an instance signature' do

      subject { Gorilla::Signature.new('String#size') }

      it { expect(subject.instance_method?).to be_true }

    end

    context 'a static signature' do

      subject { Gorilla::Signature.new('String.name') }

      it { expect(subject.instance_method?).to be_false }

    end

  end

  describe '#static_method?' do

    context 'an instance signature' do

      subject { Gorilla::Signature.new('String#size') }

      it { expect(subject.static_method?).to be_false }

    end

    context 'a static signature' do

      subject { Gorilla::Signature.new('String.name') }

      it { expect(subject.static_method?).to be_true }

    end

  end

  describe '#current_method' do

    context 'existing instance method' do

      let(:method) { String.instance_method(:size) }

      subject { Gorilla::Signature.new('String#size') }

      it 'returns instance method' do

        expect(subject.current_method).to eq(method)

      end

    end

    context 'existing static method' do

      let(:method) { String.method(:name) }

      subject { Gorilla::Signature.new('String.name') }

      it 'returns static method' do

        expect(subject.current_method).to eq(method)

      end

    end

    context 'non-existing static method' do

      subject { Gorilla::Signature.new('Dog.name') }

      it { expect(subject.current_method).to be_false }

    end

  end

  describe '#matches?' do

    it 'should match the same signature' do
      expect(Gorilla::Signature.new('Foo#baz').matches?('Foo#baz')).to be_true
    end

    it 'should not match a different signature' do
      expect(Gorilla::Signature.new('Foo#baz').matches?('Foo#bar')).to be_false
    end

  end

  describe '#klass_exists?' do

    context 'existing class' do

      subject { Gorilla::Signature.new('String#size') }

      it { expect(subject.klass_exists?).to be_true }

    end

    context 'non-existing class' do

      subject { Gorilla::Signature.new('Person#name') }

      it { expect(subject.klass_exists?).to be_false }

    end

  end

  describe '#method_exists?' do

    context 'existing class and method' do

      subject { Gorilla::Signature.new('String#size') }

      it { expect(subject.method_exists?).to be_true }

    end

    context 'non-existing class and method' do

      subject { Gorilla::Signature.new('Person#name') }

      it { expect(subject.method_exists?).to be_false }

    end

    context 'existing class and non-existing method' do

      subject { Gorilla::Signature.new('String.foo') }

      it { expect(subject.method_exists?).to be_false }

    end

  end

end
