module GChart
	class CandlestickMarker
		def self.applied? chart
			[Bar, Line].include chart.class
		end

		attr_accessor :declining_color
		attr_accessor :data_series_index
		attr_accessor :which_points
		attr_accessor :width
		attr_accessor :z_order

		def to_param
			[ "F", declining_color, data_series_index, which_points, width, z_order ].join(',')
		end

	end
end
