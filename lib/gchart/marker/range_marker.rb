module GChart

	#
	#
	#   marker = GChart::Marker.create :range do |m|
	#     m.direction = "r"
	#     m.color = "E5ECF9"
	#     m.start_point = 0.75
	#     m.end_point = 0.25
	#   end
	#
	#   maker.to_param #=> "r,E5ECF9,0,0.75,0.25"
	#
	#
	class RangeMarker

		def self.applied? chart
			[Bar, Candlestick, Line, Radar, Scatter].include? chart.class
		end

		attr_accessor :direction
		attr_accessor :color
		def color= color
			GChart.check_valid_color color
			@color = GChart.expand_color color
		end

		attr_accessor :start_point
		attr_accessor :end_point

		def to_param
			[ direction, color, 0, start_point, end_point].join(',')
		end

	end
end
