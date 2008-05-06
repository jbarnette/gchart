require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe GChart::LeftAxis do
  before(:each) { @axis = GChart::Axis.create(:left) }

  it "describes its axis_type_label as 'y'" do
    @axis.axis_type_label.should == 'y'
  end

  it "describes its range_marker_type_label as being horizontal ('r')" do
    @axis.range_marker_type_label.should == 'r'
  end
end
