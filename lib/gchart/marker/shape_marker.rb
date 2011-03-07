module GChart
	class ShapeMarker < AbstractShapeMarker
		attr_accessor :offset

		def to_param
			[ marker_type, color, series_index, which_points, size, z_order, offset ].join(',')
		end
	end



end
