module GChart

	class AbstractShapeMarker 

		# return true if LineMarke works with chart.
		#
		# @param [Object] chart <#Bar>, <#Line>, ..
		# @return [Boolean]
		def self.applied? chart
			[Bar, Line, Radar, Scatter].include? chart.class
		end


		# marker_type
		#
		# @param [String] type "a", "@a", ..
		attr_accessor :marker_type
		alias type marker_type
		alias type= marker_type=

		# the color of the markers for this series,
		#
		# @param [color] color see GChart color
		attr_accessor :color
		def color= color
			GChart.check_valid_color color
			@color = GChart.expand_color(color)
		end

		# The zero-based index of the data series on which to draw the markers
		attr_accessor :series_index

		# Which point(s) to draw markers on
		#
		# optional
		# @param [String] which_points ("-1")
		attr_accessor :which_points 
		def which_points
			@which_points || "-1"
		end

		# The size of the marker, in pixels.
		attr_accessor :size

		# The layer on which to draw the marker, 
		#
		# optional
		attr_accessor :z_order

		# return [String] param 
		def to_param; raise NotImplementError end
	end
end
