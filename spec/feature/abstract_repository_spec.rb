require 'spec_helper'

describe Feature::Repository::AbstractRepository do
  it "should raise error on creating a new instance" do
    lambda do
      Feature::Repository::AbstractRepository.new
    end.should raise_error("abstract class Feature::Repository::AbstractRepository!")
  end
end
