require "spec_helper"

describe GChart::LineFillMarker do
	describe "#to_param" do

		it "return a line marker param" do
			m = GChart::LineFillMarker.new  
			m.b_or_B = "B"
			m.color = "76A4FB"
			m.start_line_index = 0
			m.end_line_index = 0

			m.to_param.should == "B,76A4FB,0,0,0"
		end
	end
end
