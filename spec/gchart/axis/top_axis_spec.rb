require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe GChart::TopAxis do
  before(:each) { @axis = GChart::Axis.create(:top) }

  it "describes its axis_type_label as 't'" do
    @axis.axis_type_label.should == 't'
  end

  it "describes its range_marker_type_label as being vertical ('R')" do
    @axis.range_marker_type_label.should == 'R'
  end
end
