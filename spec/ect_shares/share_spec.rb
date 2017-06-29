require 'spec_helper'

describe EctShares::Share do
  # TODO: I cannot get these to work, seems it fails to load the correct validation matcher function.
  # it {expect(subject).to validate_presence_of(:holder_number)}
  # it {expect(subject).to validate_presence_of(:postcode)}

  describe "validation" do
    it "requires holder_number to be present" do
      subject.holder_number = nil
      subject.valid?
      expect(subject.errors[:holder_number]).to eq (["can't be blank"])
    end

    it "requires postcode to be present" do
      subject.postcode = nil
      subject.valid?
      expect(subject.errors[:postcode]).to eq (["can't be blank"])
    end
  end

  describe "share types" do
    ['ESIOA', 'ESIOB'].each do |st|
      it "sets #{st}" do
        expect(eval("subject.class::#{st}")).to eq(st)
      end
    end
  end

  describe ".kind" do
    context "with A shares" do
      it "returns the first kind of available shares" do
        subject.esioa = rand(100)
        subject.esiob = rand(100)
        expect(subject.kind).to eq(subject.class::ESIOA)
      end
    end

    context "with B shares" do
      it "returns the first kind of available shares" do
        subject.esioa = 0
        subject.esiob = rand(100)
        expect(subject.kind).to eq(subject.class::ESIOB)
      end
    end

    context "with no shares" do
      it "returns nil" do
        subject.esioa = 0
        subject.esiob = 0
        expect(subject.kind).to eq(nil)
      end
    end
  end

  describe ".available_units" do
    it "converts values to integer" do
      subject.esioa = rand(1..10).to_s
      subject.esiob = rand(1..10).to_s
      expect(subject.available_units).to eq(subject.esioa.to_i)

      subject.esioa = nil
      subject.esiob = rand(1..10).to_s
      expect(subject.available_units).to eq(subject.esiob.to_i)
    end

    context "witn no shares" do
      it "returns 0" do
        subject.esioa = nil
        subject.esiob = nil
        expect(subject.available_units).to eq(0)
      end
    end

    context "with A shares" do
      it "returns the number of shares" do
        subject.esioa = rand(100)
        expect(subject.available_units).to eq(subject.esioa)
      end
    end

    context "with B shares" do
      it "returns the number of shares" do
        subject.esiob = rand(100)
        expect(subject.available_units).to eq(subject.esiob)
      end
    end

    context "with A and B shares" do
      it "preferentially returns the number of ESIOA shares" do
        subject.esioa = rand(100)
        subject.esiob = rand(100)
        expect(subject.available_units).to eq(subject.esioa)
      end
    end
  end

end
