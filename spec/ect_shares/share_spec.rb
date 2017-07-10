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
    share_types = ['ESIOA', 'ESIOB'].sort
    it "defines a list of share types" do
      expect(subject.class::SHARE_TYPES).to eq(share_types)
    end
  end

  describe ".esioa?" do
    it "returns false if there are any ESIOA shares available" do
      subject.esioa = 0
      expect(subject.esioa?).to eq(false)
    end

    it "returns true if there are any ESIOA shares available" do
      subject.esioa = rand(1..10).to_s
      expect(subject.esioa?).to eq(true)
    end
  end

  describe ".esiob?" do
    it "returns false if there are any ESIOB shares available" do
      subject.esiob = 0
      expect(subject.esiob?).to eq(false)
    end

    it "returns true if there are any ESIOB shares available" do
      subject.esiob = rand(1..10).to_s
      expect(subject.esiob?).to eq(true)
    end
  end

  describe ".available_units" do
    it "converts values to integer" do
      subject.esioa = rand(1..10).to_s
      subject.esiob = rand(1..10).to_s
      expect(subject.available_units('ESIOA')).to eq(subject.esioa.to_i)

      subject.esioa = nil
      subject.esiob = rand(1..10).to_s
      expect(subject.available_units('ESIOB')).to eq(subject.esiob.to_i)
    end

    context "witn no shares" do
      it "returns 0" do
        subject.esioa = nil
        subject.esiob = nil
        expect(subject.available_units(EctShares::Share::SHARE_TYPES.sample)).to eq(0)
      end
    end

    context "with A shares" do
      it "returns the number of shares" do
        subject.esioa = rand(100)
        expect(subject.available_units('ESIOA')).to eq(subject.esioa)
      end
    end

    context "with B shares" do
      it "returns the number of shares" do
        subject.esiob = rand(100)
        expect(subject.available_units('ESIOB')).to eq(subject.esiob)
      end
    end

    context "with A and B shares" do
      before(:each) do
        subject.esioa = rand(1..100)
        subject.esiob = rand(1..100)
      end

      EctShares::Share::SHARE_TYPES.each do |type|
        it "returns the number of shares of the requested type: #{type}" do
          expect(subject.available_units(type)).to eq(subject.send("#{type.downcase}"))
        end
      end

      it "returns 0 if the requested type is unknown" do
        expect(subject.available_units('bogus')).to eq(0)
      end
    end
  end

end
