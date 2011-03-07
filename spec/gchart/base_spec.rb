require "tmpdir"
require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Base do
  it "can be initialized with a hash" do
    GChart::Base.new(:title => "foo").title.should == "foo"
  end

  it "complains about being initialized with unknown attributes" do
    lambda { GChart::Base.new(:monkey => :chimchim) }.should raise_error(NoMethodError)
  end

  it "can be initialized with a block" do
    chart = GChart::Base.new do |c|
      c.title = "foo"
    end

    chart.title.should == "foo"
  end
end

describe GChart::Base, "#data" do
  it "is an empty array by default" do
    GChart::Base.new.data.should == []
  end
end

describe GChart::Base, "#size" do
  before(:each) { @chart = GChart::Base.new }
  
  it "can be accessed as width and height" do
    @chart.width.should_not be_zero
    @chart.height.should_not be_zero
  end
  
  it "can be accessed as a combined size" do
    @chart.size.should == "#{@chart.width}x#{@chart.height}"
  end
  
  it "can be specified as a combined size" do
    @chart.size = "11x13"
    @chart.width.should == 11
    @chart.height.should == 13
  end
  
  it "has a reasonable default value" do
    @chart.size.should == "300x200"
  end
  
  it "complains about negative numbers" do
    lambda { @chart.size = "-15x13" }.should raise_error(ArgumentError)
    lambda { @chart.width = -1 }.should raise_error(ArgumentError)
    lambda { @chart.height= -1 }.should raise_error(ArgumentError)
  end
  
  it "complains about sizes that are out of bounds (300,000 pixel graph limit, 1000 pixel side limit)" do
    lambda { @chart.size = "491x611" }.should raise_error(ArgumentError)
    lambda { @chart.size = "1001x300" }.should raise_error(ArgumentError)
    lambda { @chart.size = "300x1001" }.should raise_error(ArgumentError)
  end
end

describe GChart::Base, "#render_chart_type" do
  it "raises; subclasses must implement" do
    lambda { GChart::Base.new.render_chart_type }.should raise_error(NotImplementedError)
  end
end

describe GChart::Base, "#query_params" do
  before(:each) do
    @chart = GChart::Base.new
    @chart.stub!(:render_chart_type).and_return("TEST")
  end
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should == "TEST"
  end
  
  it "contains the chart's data" do
    @chart.data = [[1, 2, 3], [3, 2, 1]]
    @chart.query_params["chd"].should == "e:VVqq..,..qqVV"
  end
  
  it "contains the chart's size" do
    @chart.query_params["chs"].should == "300x200"
  end
  
  it "contains the chart's title" do
    @chart.title = "foo"
    @chart.query_params["chtt"].should == "foo"
  end
  
  it "escapes the chart's title" do
    @chart.title = "foo bar"
    @chart.query_params["chtt"].should == "foo+bar"
    
    @chart.title = "foo\nbar"
    @chart.query_params["chtt"].should == "foo|bar"
  end
  
  it "contains the chart's data colors" do
    @chart.colors = ["cccccc", "eeeeee", :salmon3, "49d", :red]
    @chart.query_params["chco"].should == "cccccc,eeeeee,cd7054,4499dd,ff0000"

    @chart.colors = []
    @chart.query_params["chco"].should be_nil
  end

  it "contains the chart's background colors" do
    @chart.query_params["chf"].should be_nil

    @chart.entire_background = :red
    @chart.query_params["chf"].should == "bg,s,ff0000"

    @chart.chart_background = "704"
    @chart.query_params["chf"].should == "bg,s,ff0000|c,s,770044"

    @chart.entire_background = nil
    @chart.query_params["chf"].should == "c,s,770044"
  end

  it "contains the chart's colors" do
    @chart.colors = ["cccccc", "eeeeee"]
    @chart.query_params["chco"].should == "cccccc,eeeeee"
  end
end

describe GChart::Base, "#to_url" do
  before(:each) do
    @chart = GChart::Base.new
    @chart.stub!(:render_chart_type).and_return("TEST")
  end

  it "generates a URL that points at Google" do
    @chart.to_url.should =~ %r(http://chart.apis.google.com/chart)
  end
end

describe GChart::Base, "#fetch" do
  # THIS EXPECTATION HITS THE CLOUD!  Comment it out for a faster cycle. :)
  it "fetches a blob from Google" do
    blob = GChart.line(:data => [1, 2]).fetch
    blob.should_not be_nil
    blob.should =~ /PNG/
  end
end

describe GChart::Base, "#write" do
  before(:each) do
    @chart = GChart::Base.new
    @chart.stub!(:fetch).and_return("PAYLOAD")
  end
  
  it "writes to chart.png by default" do
    Dir.chdir(Dir.tmpdir) do
      @chart.write
      File.file?("chart.png").should == true
    end
  end
  
  it "writes to a specified file" do
    Dir.chdir(Dir.tmpdir) do
      @chart.write("foo.png")
      File.file?("foo.png").should == true
    end
  end
  
  it "writes to anything that quacks like IO" do
    result = ""
    
    StringIO.open(result, "w+") do |io|
      @chart.write(io)
    end
    
    result.should == "PAYLOAD"
  end
end

describe GChart::Base, "#axis" do
  before(:each) do
    @chart = GChart::Line.new
    @axis = @chart.axis(:bottom)
  end

  it "instantiates a new GChart::Axis of the proper axis_type" do
    chart = GChart::Line.new
    axis  = chart.axis(:bottom)
    axis.is_a?(GChart::BottomAxis).should == true
  end

  it "pushes the new axis to the chart's set of axes" do
    chart = GChart::Line.new
    axis  = chart.axis(:bottom)
    chart.axes.first.should == axis
  end

  [GChart::Line, GChart::Bar, GChart::Scatter].each do |chart_type|
    it "renders axis information when chart axes are present and chart is of proper type" do
      chart = chart_type.new
      axis  = chart.axis(:left)
      chart.to_url.should =~ /chxt/
    end
  end

  [GChart::Pie3D, GChart::Pie, GChart::Venn, GChart::XYLine].each do |chart_type|
    it "should not render axis information when chart axes are present but chart is not of proper type" do
      chart = chart_type.new
      axis  = chart.axis(:left)
      chart.to_url.should_not =~ /chxt/
    end
  end
end

describe GChart::Base, "#entire_background" do
  it "sets the background color for the entire chart" do
    chart = GChart.line
    chart.entire_background = :blue
  end
end

describe GChart::Base, "#chart_background" do
  it "sets the background color for just the chart area of the chart image" do
    chart = GChart.bar
    chart.chart_background = "876"
  end
end

describe GChart::Base, "#render_backgrounds" do
  before(:each) do
    @chart = GChart::Line.new
  end

  it "verifies that background colors are valid colors" do
    @chart.chart_background = :cyan
    @chart.to_url

    @chart.entire_background = 'f37'
    @chart.to_url
  end

  it "blows up if either of the background colors are invalid" do
    @chart.chart_background = :redneck_skin
    lambda { @chart.to_url }.should raise_error(ArgumentError)

    @chart.chart_background = nil
    @chart.entire_background = 'f375'
    lambda { @chart.to_url }.should raise_error(ArgumentError)
  end

  it "renders chart background information correctly" do
    @chart.to_url.should_not =~ /chf=/

    @chart.chart_background = 'f3A'
    @chart.to_url.should =~ /chf=c,s,ff33AA/

    @chart.entire_background = :yellow
    @chart.to_url.should =~ /chf=bg,s,ffff00%7Cc,s,ff33AA/

    @chart.chart_background = nil
    @chart.to_url.should_not =~ /chf=bg,s,ffff00%7Cc,s,ff33AA/
    @chart.to_url.should =~ /chf=bg,s,ffff00/
  end
end

describe GChart::Base, "#to_url" do
  it "plucks out data points for large sets of data so as not to exceed Google maximum url length" do
    data = [0, 1, 2, 3, 4, 5, 4, 3, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 5, 3, 1] * 40
    chart = GChart.line(:data => [data] * 4)

    chart.data.collect{ |set| set.length }.should == [840] * 4

    chart.to_url.length.should < GChart::URL_MAXIMUM_LENGTH
    chart.data.collect{ |set| set.length }.should == [251] * 4
  end
end

describe GChart::Base do

	describe "#render_axes" do

		before(:each) { 
			@chart = GChart::Bar.new do |c|
				c.axis(:left) { |a|
					a.tick_length = 12
				}

				c.axis(:bottom) { |a|
					a.tick_length = [1,2]
				}
			end
		}

		it "render tick length correctly" do
			@chart.to_url.should =~ /chxtc=0,12|1,1,2/
		end

	end
end


