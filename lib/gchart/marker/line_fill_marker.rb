module GChart

	#
	#  marker = GChart::Marker.create :line_fill do |m|
	#    m.b_or_B = "B"
	#    m.color = "76A4FB"
	#    m.start_line_index = 0
	#    m.end_line_index = 0
	#  end
	#
	#  marker.to_param #=> "B,76A4FB,0,0,0"
	#
	#
	class LineFillMarker

		# return true if LineMarke works with chart.
		#
		# @param [Object] chart <#Bar>, <#Line>, ..
		# @return [Boolean]
		def self.applied? chart
			[Line, Radar].include chart.class
		end

		# Whether to fill to the bottom of the chart, or just to the next lower line.
		#
		# @param [String] :b_or_B "b" "B"
		attr_accessor :b_or_B

		def b_or_B= value
			if not %w(b B).include? value
				raise ArgumentError, "b_or_B attribute values must 'b' or 'B' -- #{value.inspect}"
			end
			@b_or_B = value
		end

		# fill color.
		#
		# @param [String] color
		attr_accessor :color
		def color= color
			GChart.valid_color?(color)
			@color = GChart.expand_color(color)
		end

		# The index of the line at which the fill starts. 
		attr_accessor :start_line_index

		# The index of the line at which the fill ends. 
		# @see start_line_index
		attr_accessor :end_line_index


		# return [String] "B,76A4FB,0,0,0"
		def to_param
			[b_or_B, color, start_line_index, end_line_index, 0].join(',')
		end
	end
end
