module GChart
	class TextMarker < AbstractShapeMarker
		attr_accessor :placement

		def to_param
			[ marker_type, color, series_index, which_points, size, z_order, placement ].join(',')
		end
	end



end
