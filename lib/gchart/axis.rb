module GChart
  class Axis

    # Array of axis labels. Can be exactly placed along the axis with
    # +label_positions+, otherwise are evenly spaced.
    attr_accessor :labels

    # Array of float positions for +labels+. Without +labels+, the
    # +label_positions+ are self-labeling.
    attr_accessor :label_positions

    # Takes a +Range+ of float values. With +labels+, defines +labels+
    # context, meaning the +labels+ will be spaced at their proper
    # location within the +range+. Without +labels+, smart-labeling
    # occurs for +range+.
    attr_accessor :range

    # An rrggbb color for axis text.
    attr_accessor :text_color

    # Size of font in pixels. To set +font_size+, +text_color+ is also
    # required.
    attr_accessor :font_size

    # +TEXT_ALIGNMENT+ property for axis labeling. To set
    # +text_alignment+, both +text_color+ and +font_size+ must also be
    # set.
    attr_accessor :text_alignment

    # Array of 2-element sub-arrays such that the 1st element in each
    # sub-array is a +Range+ of float values which describe the start
    # and end points of the range marker, and the 2nd element in each
    # sub-array is an rrggbb color for the range marker.  For +:top+
    # and +:bottom+ +AXIS_TYPES+, markers are vertical. For +:right+
    # and +:left+ +AXIS_TYPES+, markers are horizontal.
    attr_accessor :range_markers

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
        unless range.is_a?(Range)
          raise ArgumentError.new("The range attribute has been specified with a non-Range class")
        end

        unless range.first.is_a?(Numeric)
          raise ArgumentError.new("The range attribute has been specified with non-numeric range values")
        end
      end

      if font_size and not text_color
        raise ArgumentError.new("To specify a font_size, a text_color must also be specified")
      end

      if text_alignment and not (text_color and font_size)
        raise ArgumentError.new(
          "To specify a text_alignment, both text_color and font_size must also be specified"
        )
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
    end

  end
end
