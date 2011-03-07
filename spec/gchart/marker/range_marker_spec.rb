require "spec_helper"

describe GChart::RangeMarker do
	describe "#to_param" do

		it "return a line marker param" do
			m = GChart::RangeMarker.new  
			m.direction = "r"
			m.color = "E5ECF9"
			m.start_point = 0.75
			m.end_point = 0.25

			m.to_param.should == "r,E5ECF9,0,0.75,0.25"
		end

	end
end
