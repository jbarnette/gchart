%w(abstract_shape_marker candlestick_marker line_fill_marker 
	line_marker range_marker shape_marker text_marker ).each{|v| require_relative "marker/#{v}"}

module GChart
	class Marker
		TYPES = {
			:line => LineMarker, :shape => ShapeMarker, :text => TextMarker,
			:range => RangeMarker, :text => TextMarker, :line_fill => LineFillMarker
		}


		def self.create type, &block
			begin
				klass = TYPES[type]
			rescue KeyError
				raise ArgumentError, "not support type -- #{type.inspect}"
			end

			marker = klass.new

			block.call marker if block 

			marker
		end

	end
end
