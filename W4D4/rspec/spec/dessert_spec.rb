require 'rspec'
require 'dessert'

=begin
Instructions: implement all of the pending specs (the `it` statements without blocks)! Be sure to look over the solutions when you're done.
=end

describe Dessert do
  let(:chef_name){"Not A Chef"}
  let(:chocolate){"chocolate"}
  let(:chef) { double("chef",
    :name => chef_name,
    :titleize =>  "Chef #{chef_name} the Great Baker"
  )}
  subject(:subj){Dessert.new(chocolate, 5, chef)}

  describe "#initialize" do
    it "sets a type" do
      expect(subj.type).to eq(chocolate)
    end

    it "sets a quantity" do
      expect(subj.quantity).to eq(5)
    end

    it "starts ingredients as an empty array" do
      expect(subj.ingredients).to be_empty
    end

    it "raises an argument error when given a non-integer quantity" do
      expect {Dessert.new('chocolate', '5', chef)}.to raise_error(ArgumentError)
    end
  end

  describe "#add_ingredient" do
    let(:sugar){'sugar'}
    let(:cream){'cream'}
    let(:cocoa_powder){'cocoa powder'}

    before(:each) do
      subj.add_ingredient(sugar)
      subj.add_ingredient(cream)
      subj.add_ingredient(cocoa_powder)
    end

    it "adds an ingredient to the ingredients array" do
      expect(subj.ingredients).to include(sugar)
      expect(subj.ingredients).to include(cream)
      expect(subj.ingredients).to include(cocoa_powder)
    end
  end

  describe "#mix!" do
    it "shuffles the ingredient array" do
      expect(subj.ingredients).to receive(:shuffle!)
      subj.mix!
    end
  end

  describe "#eat" do
    let(:amount){3}

    before(:each) do
      subj.eat(3)
    end

    it "subtracts an amount from the quantity" do
      expect(subj.quantity).to eq(2)
    end

    it "raises an error if the amount is greater than the quantity" do
      expect{subj.eat(5)}.to raise_error("not enough left!")
    end
  end

  describe "#serve" do
    before (:each) do
      subj.serve
    end

    it "contains the titleized version of the chef's name" do
      expect(subj.serve).to eq "#{chef.titleize} has made #{subj.quantity} #{subj.type.pluralize}!"
    end
  end

  describe "#make_more" do
    it "calls bake on the dessert's chef with the dessert passed in" do
      expect(chef).to receive(:bake).with(subj)
      subj.make_more
    end
  end
end
