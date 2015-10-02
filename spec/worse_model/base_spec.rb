require 'spec_helper'

module WorseModel
  describe 'Base' do
    class Record
      include WorseModel::Base

      field :name
    end

    subject { Record.new }

    describe '#new?' do
      it 'returns true' do
        expect(subject.new?).to eq(true)
      end
    end

    describe '#new_record?' do
      it 'returns true' do
        expect(subject.new_record?).to eq(true)
      end
    end

    describe '#id' do
      before { subject.id = 666 }

      it 'returns the id' do
        expect(subject.id).to eq(666)
      end
    end

    describe '#id=' do
      it 'sets the id' do
        expect { subject.id = 666 }.to change(subject, :id)
          .from(nil).to(666)
      end
    end

    describe '#==' do
      let(:subject_2) { Record.new }

      it 'returns true when records are equal' do
        expect(subject == subject_2).to eq(true)
      end

      it 'returns false when records are equal' do
        subject_2.id = 5
        expect(subject == subject_2).to eq(false)
      end
    end

    describe '#eql?' do
      let(:subject_2) { Record.new }

      it 'returns true when records are equal' do
        expect(subject == subject_2).to eq(true)
      end

      it 'returns false when records are equal' do
        subject_2.id = 5
        expect(subject == subject_2).to eq(false)
      end
    end

    describe '#hash' do
      it 'returns the hash of the record' do
        expect(subject.hash).to be_an(Integer)
      end
    end

    describe '#dup' do
      before { subject.name = 'trololo' }

      it 'returns a copy of the record' do
        expect(subject.dup.attributes).to eq(subject.attributes)
      end
    end

    describe '#save' do
      context 'when it is the first save' do
        it 'creates the record' do
          expect(subject).to receive(:create)

          subject.save
        end
      end

      context 'when it is not the first save' do
        before { subject.save }

        it 'updates the record' do
          expect(subject).to receive(:update)

          subject.save
        end
      end
    end

    describe '#save!' do
      pending 'saves the record' do
        expect(true).to eq(false)
      end

      pending 'raises an error' do
        expect(true).to eq(false)
      end
    end
  end
end
