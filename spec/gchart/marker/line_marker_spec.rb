require "spec_helper"

describe GChart::LineMarker do
	describe "#to_param" do

		it "return a line marker param" do
			m = GChart::LineMarker.new  
			m.color = "0033FF"
			m.series_index = 0
			m.which_points = 0
			m.size = 5
			m.z_order = 1

			m.to_param.should == "D,0033FF,0,0,5,1"
		end

	end
end
