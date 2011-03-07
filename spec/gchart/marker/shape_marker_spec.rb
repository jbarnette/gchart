require "spec_helper"

describe GChart::ShapeMarker do
	describe "#to_param" do

		it "return a line marker param" do
			m = GChart::ShapeMarker.new  
			m.marker_type = "a"
			m.color = "990066"
			m.series_index = 0
			m.which_points = 0.0
			m.size = 9

			m.to_param.should == "a,990066,0,0.0,9,,"
		end

	end
end
