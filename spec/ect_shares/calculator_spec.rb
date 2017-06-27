require 'spec_helper'

describe EctShares::Calculator do
  let(:subject) {EctShares::Calculator.new(OpenStruct.new())}

  it {expect(subject).to respond_to(:count)}
  it {expect(subject).to respond_to(:share)}
  it {expect(subject).to respond_to(:deposit)}
  it {expect(subject).to respond_to(:payment_method)}

  describe "PAYMENT_METHODS" do
    payment_methods = ['6 months arrears', '6 months advance', '12 months advance', 'default']

    it "contains all valid PAYMENT_METHODS" do
      payment_methods.each do |pmt|
        expect(EctShares::Calculator::PAYMENT_METHODS).to include(pmt)
      end
    end
  end

  describe ".initialize" do
    it "sets @share" do
      tmp = EctShares::Calculator.new(OpenStruct.new)
      expect(tmp.share.present?).to eq(true)
    end

    it "sets @deposit" do
      tmp = EctShares::Calculator.new(OpenStruct.new)
      expect(tmp.deposit).to eq(0)
    end

    it "sets @count" do
      tmp = EctShares::Calculator.new(OpenStruct.new)
      expect(tmp.count).to eq(0)
    end

    it "does not set @payment_method" do
      tmp = EctShares::Calculator.new(OpenStruct.new)
      expect(tmp.payment_method).to eq(nil)
    end
  end

  describe ".strike_price" do
    before(:each) do
      subject.share.unit_price = rand(100)
      subject.share.available_units = 9999
      subject.count = 999
    end

    it "multiplies the unit price and the count" do
      expect(subject.strike_price).to eq(999*subject.share.unit_price)
    end

    it "caps the units to the availble units" do
      subject.share.available_units = 10
      expect(subject.strike_price).to eq(10*subject.share.unit_price)
    end
  end

  describe ".purchase_price" do
    before(:each) do
      subject.share.unit_price = rand(100)
      subject.share.available_units = 9999
      subject.count = 999
    end

    it "subtracts the deposit from the strike price" do
      subject.deposit = rand(999)
      expect(subject.purchase_price).to eq(subject.strike_price - subject.deposit)
    end

    it "ensures values are always at least 0" do
      allow(subject).to receive(:strike_price).and_return(0)
      subject.deposit = rand(999)
      expect(subject.purchase_price).to eq(0)
    end
  end

  describe ".lsr" do
    it "returns the ratio of purchase_price to strike_price" do
      allow(subject).to receive(:strike_price).and_return(rand(1000).to_f + 1)
      allow(subject).to receive(:purchase_price).and_return(rand(subject.strike_price).to_f)
      expect(subject.lsr()).to eq(subject.purchase_price / subject.strike_price)
    end

    it "returns a decimal value" do
      allow(subject).to receive(:strike_price).and_return(rand(1000).to_f + 1)
      allow(subject).to receive(:purchase_price).and_return(rand(subject.strike_price).to_f)
      expect(subject.lsr()).to be_between(0, 1).inclusive
    end

    it "returns 100% lst no strike price if strike_price is zero" do
      allow(subject).to receive(:strike_price).and_return(0)
      allow(subject).to receive(:purchase_price).and_return(rand(1000).to_f + 1)
      expect(subject.lsr()).to eq(1.0)
    end
  end

  describe ".rate" do
    before(:each) do
      subject.share.unit_price = rand(100)
      subject.count = 999
      subject.share.available_units = rand(1000) + subject.count
      subject.payment_method = EctShares::Calculator::PAYMENT_METHODS.sample
      # allow_any_instance_of(subject.class).to receive(:lsr).and_return(99)
    end

    it "requires a valid payment method to be set" do
      expect(subject.rate()).not_to eq(nil)
      subject.payment_method = nil
      expect(subject.rate()).to eq(nil)
    end

    it "returns the rate for the lsr provided" do
      prep = [
        [45/100.0, '12 months advance', 3.13],
        [60/100.0, '6 months advance', 6.63],
        [85/100.0, '6 months arrears', 8.63],
      ]
      prep.each do |vals|
        allow(subject).to receive(:lsr).and_return(vals[0].to_f)
        subject.payment_method = vals[1]
        expect(subject.rate()).to eq(vals[2])
      end
    end
  end

  describe ".advance?" do
    it "returns true if 'advance' occurs in the payment method" do
      EctShares::Calculator::PAYMENT_METHODS.each do |pmt|
        subject.payment_method = pmt
        expect(subject.advance?).to eq(subject.payment_method.include?('advance'))
      end
    end
  end

  describe ".arrears?" do
    it "returns true if 'arrears' occurs in the payment method" do
      EctShares::Calculator::PAYMENT_METHODS.each do |pmt|
        subject.payment_method = pmt
        expect(subject.arrears?).to eq(subject.payment_method.include?('arrears'))
      end
    end
  end
end
