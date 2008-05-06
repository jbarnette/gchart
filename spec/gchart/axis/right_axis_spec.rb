require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe GChart::RightAxis do
  before(:each) { @axis = GChart::Axis.create(:right) }

  it "describes its axis_type_label as 'r'" do
    @axis.axis_type_label.should == 'r'
  end

  it "describes its range_marker_type_label as being horizontal ('r')" do
    @axis.range_marker_type_label.should == 'r'
  end
end
