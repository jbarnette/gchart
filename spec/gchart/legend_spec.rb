require "spec_helper"

describe GChart::Legend do

	describe "#new" do
		it "call new with hash option" do
			chart = GChart::Legend.new labels: [1,2]
			chart.to_params_hash.should == {"chdl" => "1|2"}
		end

		it "call new with block" do
			chart = GChart::Legend.new labels: [1,2] do |l|
				l.labels = [2,3]
			end

			chart.to_params_hash.should == {"chdl" => "2|3"}
		end
	end


	it "store position" do
		chart = GChart::Legend.new do |l|
			l.labels = [1]
			l.position = "b"
		end

		chart.to_params_hash.should == {
			"chdl" => "1",
			"chdlp" => "b"
		}
	end

	it "store label_order" do
		chart = GChart::Legend.new do |l|
			l.labels = [1]
			l.label_order = "r"
		end

		chart.to_params_hash.should == {
			"chdl" => "1",
			"chdlp" => "r|r"
		}
	end

	it "store color" do
		chart = GChart::Legend.new do |l|
			l.labels = [1]
			l.color = "0f0"
		end

		chart.to_params_hash.should == {
			"chdl" => "1",
			"chdls" => "00ff00,11.5"
		}
	end

	it "store size" do
		chart = GChart::Legend.new do |l|
			l.labels = [1]
			l.size = 12
		end

		chart.to_params_hash.should == {
			"chdl" => "1",
			"chdls" => "666666,12"
		}
	end

end
