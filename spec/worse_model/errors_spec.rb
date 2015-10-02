require 'spec_helper'

module WorseModel
  describe WorseModelError do
    it 'behaves like StandardError' do
      expect(subject).to be_a(StandardError)
    end
  end

  describe UnknownRecord do
    it 'behaves like WorseModelError' do
      expect(subject).to be_a(WorseModelError)
    end
  end

  describe InvalidRecord do
    it 'behaves like WorseModelError' do
      expect(subject).to be_a(WorseModelError)
    end
  end

  describe UnknownAttribute do
    it 'behaves like WorseModelError' do
      expect(subject).to be_a(WorseModelError)
    end
  end
end
