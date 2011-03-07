module GChart
	#
	#
	#   bar = GChart.bar do |b|
	#     b.axis(:left) { |a|
	#       a.tick_length = 12
	#     }
	#
	#     b.axis(:bottom) { |a|
	#       a.tick_lengths = [12,13]
	#     }
	#   end
	#
	#
  class Axis

    # Array of axis labels. Can be exactly placed along the axis with
    # +label_positions+, otherwise are evenly spaced.
    attr_accessor :labels

    # Array of float positions for +labels+. Without +labels+, the
    # +label_positions+ are self-labeling.
    attr_accessor :label_positions

    # With +labels+, defines +labels+
    # context, meaning the +labels+ will be spaced at their proper
    # location within the +range+. Without +labels+, smart-labeling
    # occurs for +range+.
		#
		# @since 1.1 change range from Range to Array
		# @param [Array] range \[start_val, end_val, opt_step]
    attr_accessor :range

		def range= range
			# for compablity.
			if Range === range
				@range = [range.first, range.last]
			else
				@range = range
			end
		end


    # An RRGGBB color for axis text. 
		#
		# @param [String] text_color (gray)
    attr_accessor :text_color
		alias label_color text_color
		alias label_color= text_color=
		def text_color; @text_color || "676767" end

		# The color of this axis line.
		#
		# @param [String] axis_color (gray)
		attr_accessor :axis_color

		# the tick mark color.
		#
		# @param [String] tick_color (gray)
		attr_accessor :tick_color

		# Whether to show tick marks and/or axis lines for this axis. 
		# Tick marks and axis lines are only available for innermost axes 
		# (for example, they are not supported for the outer of two x-axes). 
		#
		# Use one of the following values:
		# * l (lowercase 'L') - Draw axis line only.
		# * t - Draw tick marks only. Tick marks are the little lines next to axis labels.
		# * lt - [Default] Draw both an axis line and tick marks for all labels.
		# * _ - (Underscore) Draw neither axis line nor tick marks. If you want to hide an axis line, use this value.
		#
		# @param [String] axis_or_tick ("lt")
		attr_accessor :axis_or_tick
		def axis_or_tick; @axis_or_tick || "lt" end


    # Size of font in pixels. 
		#
		# @param [Numeric] font_size (11.5)
    attr_accessor :font_size
		def font_size; @font_size || 11.5 end

		# Label alignment. For top or bottom axes, this describes how the label 
		# aligns to the tick mark above or below it; for left or right axes, 
		# this describes how the aligns inside its bounding box, which touches the axis. 
		#
		# @param [Symbol] text_alignment (:center) :left, :right, :center
    attr_accessor :text_alignment
		alias alignment text_alignment
		alias alignment= text_alignment=
		def text_alignment; @text_alignment || :center end

    # Array of 2-element sub-arrays such that the 1st element in each
    # sub-array is a +Range+ of float values which describe the start
    # and end points of the range marker, and the 2nd element in each
    # sub-array is an rrggbb color for the range marker.  For +:top+
    # and +:bottom+ +AXIS_TYPES+, markers are vertical. For +:right+
    # and +:left+ +AXIS_TYPES+, markers are horizontal.
    attr_accessor :range_markers

		# Axis Tick Mark Styles (chxtc)
		# @note Use the chxs parameter to change the tick mark color.
		#
		# Length of the tick marks on that axis, in pixels. 
		# If a single value is given, it will apply to all values; 
		# if more than one value is given, the axis tick marks will cycle through the list of values for that axis.
		# Psitive values are drawn outside the chart area and cropped by the chart borders. 
		# The maximum positive value is 25. 
		# Negative values are drawn inside the chart area and cropped by the chart area borders.
		#
		# @param [Numeric, Array<Numeric>] tick_length
		attr_accessor :tick_length
		def tick_length= length
			@tick_length = Array === length ? length : [length]
		end
		alias tick_lengths tick_length
		alias tick_lengths= tick_length=

    AXIS_TYPES = [ :top, :right, :bottom, :left ]

    # Defaults: +:left+ for +RightAxis+, +:center+ for +TopAxis+ and
    # for +BottomAxis+, and +:right+ for +LeftAxis+.
    TEXT_ALIGNMENT = { :left => -1, :center => 0, :right => 1 }

    class << self
      # Instantiates the proper +GChart::Axis+ subclass based on the
      # +axis_type+.
      def create(axis_type, &block)
        raise ArgumentError.new("Invalid axis type '#{axis_type}'") unless AXIS_TYPES.include?(axis_type)

        axis = Object.module_eval("GChart::#{axis_type.to_s.capitalize}Axis").new

        yield(axis) if block_given?
        axis
      end

      private :new
    end

    def initialize
      @labels          = []
      @label_positions = []
      @range_markers   = []
    end

    # Returns a one-character label of the axis according to its type.
    def axis_type_label
      raise NotImplementedError.new("Method must be overridden in a subclass of this abstract base class.")
    end

    # Returns a one-character label to indicate whether
    # +ranger_markers+ are vertical or horizontal.
    def range_marker_type_label
      raise NotImplementedError.new("Method must be overridden in a subclass of this abstract base class.")
    end

    # Ensures that all combinations of attributes which have been set
    # will work with each other. Raises +ArgumentError+ otherwise.
    def validate!
      if labels.size > 0 and label_positions.size > 0 and labels.size != label_positions.size
        raise ArgumentError.new(
          "Both labels and label_positions have been specified, but their " +
          "respective counts do not match (labels.size = '#{labels.size}' " +
          "and label_positions.size = '#{label_positions.size}')"
        )
      end

      unless label_positions.all? { |pos| pos.is_a?(Numeric) }
        raise ArgumentError.new(
          "The label_positions attribute requires numeric values for each position specified"
        )
      end

      if range
        unless range.is_a?(Array)
          raise ArgumentError.new("The range attribute has been specified with a non-Array class")
        end

        unless range.first.is_a?(Numeric)
          raise ArgumentError.new("The range attribute has been specified with non-numeric range values")
        end
      end

      if text_color and not GChart.valid_color?(text_color)
        raise ArgumentError.new("The text_color attribute has been specified with an invalid color")
      end

      if font_size and not font_size.is_a?(Numeric)
        raise ArgumentError.new("The font_size must have a numeric value")
      end

      if text_alignment and not TEXT_ALIGNMENT[text_alignment]
        raise ArgumentError.new(
          "The text_alignment attribute has been specified with a non-TEXT_ALIGNMENT"
        )
      end

      if not range_markers.all? { |array| array.is_a?(Array) and array.size == 2 and
                                          array[0].is_a?(Range) and array[0].first.is_a?(Numeric) and
                                          GChart.valid_color?(array[1]) }
        raise ArgumentError.new(
          "The range_markers attribute must be an array of 2-element sub-arrays such that " +
          "the first element in each sub-array is a Range of numeric values and the second " +
          "element in each sub-array is a valid color"
        )
      end

			if tick_color and not GChart.valid_color?(tick_color)
        raise ArgumentError.new("The tick_color attribute has been specified with an invalid color")
			end

			if axis_color and not GChart.valid_color?(axis_color)
        raise ArgumentError.new("The axis_color attribute has been specified with an invalid color")
			end

			if axis_or_tick and not axis_or_tick.is_a?(String)
        raise ArgumentError.new("The axis_or_tick must be a String")
			end
    end

  end
end
