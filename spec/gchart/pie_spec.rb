require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Pie do
  it "renders the correct chart type" do
    GChart::Pie.new.render_chart_type.should == "p"
  end
end

describe GChart::Pie, "#query_params" do
  before(:each) { @chart = GChart::Pie.new }
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should == "p"
  end
end

describe GChart::Pie, "#data" do
  it "complains if you provide more than one set of data" do
    lambda { GChart::Pie.new(:data => [1, 2, 3]) }.should_not raise_error(ArgumentError)
    lambda { GChart::Pie.new(:data => [[1, 2, 3]]) }.should_not raise_error(ArgumentError)
    lambda { GChart::Pie.new(:data => [[1, 2, 3], [3, 2, 1]]) }.should raise_error(ArgumentError)
  end
end
