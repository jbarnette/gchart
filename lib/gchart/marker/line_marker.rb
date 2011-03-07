module GChart 

	#
	#  marker = GChart::Marker.create :line do |m|
	#    m.color = "0033FF"
	#    m.series_index = 0
	#    m.which_points = 0
	#    m.size = 5
	#    m.z_order = 1
	#  end
	#  
	#  marker.to_param #=> "D,0033FF,0,0,5,1"
	#
	#
	class LineMarker
		def self.applied? chart
			[Bar, Line, Radar, Scatter].include? chart.class
		end

		attr_accessor :color
		def color= color
			GChart.check_valid_color color
			@color = GChart.expand_color color
		end

		attr_accessor :series_index
		attr_accessor :which_points
		attr_accessor :size
		attr_accessor :z_order

		def to_param
			["D", color, series_index, which_points, size, z_order].join(',')
		end

	end
end
