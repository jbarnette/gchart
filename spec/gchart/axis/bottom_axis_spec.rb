require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe GChart::BottomAxis do
  before(:each) { @axis = GChart::Axis.create(:bottom) }

  it "describes its axis_type_label as 'x'" do
    @axis.axis_type_label.should == 'x'
  end

  it "describes its range_marker_type_label as being vertical ('R')" do
    @axis.range_marker_type_label.should == 'R'
  end
end
