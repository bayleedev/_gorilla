require 'spec_helper'

describe Gorilla::Patcher do

  subject { Gorilla::Patcher.new(signature: signature) }

  describe '.new' do

    context 'given an instance signature' do

      let(:signature) { Gorilla::Signature.new('String#length') }

      it 'extends InstancePatcher' do
        expect(subject).to be_a(Gorilla::InstancePatcher)
      end

    end

    context 'given a static signature' do

      let(:signature) { Gorilla::Signature.new('String.name') }

      it 'extends StaticPatcher' do
        expect(subject).to be_a(Gorilla::StaticPatcher)
      end

    end

  end

  describe '#needs_patch?' do

    context 'valid signature' do

      let(:signature) { Gorilla::Signature.new('String.name') }

      context 'new patcher' do

        it { expect(subject.needs_patch?).to be_true }

      end

      context 'patched patcher' do

        before do
          subject.stub(:overwrite_method).and_return(true)
          subject.patch_method
        end

        it { expect(subject.needs_patch?).to be_false }

      end

    end

    context 'invalid signature' do

      let(:signature) { Gorilla::Signature.new('Foo#Baz') }

      it { expect(subject.needs_patch?).to be_false }

    end

  end

  describe '#patch_method' do

    context 'instance signature' do

      let(:signature) { Gorilla::Signature.new('String#length') }

      before do
        @cached_method = signature.current_method
        subject.patch_method
      end

      it 'replaces old method' do
        expect(signature.current_method).to_not eq(@cached_method)
      end

    end

    context 'static signature' do

      let(:signature) { Gorilla::Signature.new('String.name') }

      before do
        @cached_method = signature.current_method
        subject.patch_method
      end

      it 'replaces old method' do
        expect(signature.current_method).to_not eq(@cached_method)
      end

    end

  end

end
