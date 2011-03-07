require "spec_helper"

describe GChart::TextMarker do
	describe "#to_param" do

		it "return a line marker param" do
			m = GChart::TextMarker.new  
			m.marker_type = "tMin"
			m.color = "0000FF"
			m.series_index = 0
			m.which_points = 1
			m.size = 10

			m.to_param.should == "tMin,0000FF,0,1,10,,"
		end


	end
end
