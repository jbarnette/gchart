require "spec_helper"

describe GChart::Marker do
	describe "#create" do

		it "creates a LineMarker instance" do
			GChart::Marker.create :line do |m|
				m.should be_an_instance_of(GChart::LineMarker)
			end
		end

	end
end
