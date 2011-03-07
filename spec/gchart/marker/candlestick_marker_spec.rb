require "spec_helper"

describe GChart::CandlestickMarker do
	describe "#to_param" do
		it "returns a candelstick Marker param" do
			m = GChart::CandlestickMarker.new  
			m.declining_color = "0000FF"
			m.data_series_index = 0
			m.width = 20

			m.to_param.should == "F,0000FF,0,,20,"
		end
	end
end
