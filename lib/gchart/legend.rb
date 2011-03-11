module GChart
	class Legend

		attr_accessor :labels

		# @param [String] position ("r")
		attr_accessor :position
		def position; @position || "r" end

		attr_accessor :label_order

		# @param [color] color ("666666")
		attr_accessor :color
		def color= color
			GChart.check_valid_color color
			@color = GChart.expand_color(color)
		end

		def color; @color || "666666" end

		# @param [Numeric] size (11.5)
		attr_accessor :size
		def size; @size || 11.5 end

		# @overload new(o={})
		#   @param [Hash] o option
		# @overload new(o={})
		#   @yieldparam [Legend] l
		def initialize o={}, &blk
			o.each {|k,v| send "#{k}=", v }
			blk.call self if blk
		end

		def to_params_hash
			params = {}

			# chdl=<data_series_1_label>|...|<data_series_n_label>
			params["chdl"] = labels.join('|')

			# chdlp=<opt_position>|<opt_label_order>
			if @position or @label_order
			 params["chdlp"] = [position, label_order].compact.join('|')
			end

			# chdls=<color>,<size>
			if @color or @size
			 params["chdls"] = [color, size].join(',')
			end

			params
		end

	end
end
