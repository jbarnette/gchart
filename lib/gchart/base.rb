require "open-uri"
require "uri"

module GChart
  class Base
    # Array of chart data. See subclasses for specific usage.
    attr_accessor :data

    # Hash of additional HTTP query params.
    attr_accessor :extras

    # Chart title.
    attr_accessor :title

    # Array of rrggbb colors, one per data set.
    attr_accessor :colors

    # Array of legend text, one per data set.
    attr_accessor :legend

    # Max data value for quantization.
    attr_accessor :max

    # Chart width, in pixels.
    attr_reader :width

    # Chart height, in pixels.
    attr_reader :height

    # Background rrggbb color of entire chart image.
    attr_accessor :entire_background

    # Background rrggbb color of just chart area of chart image.
    attr_accessor :chart_background

    # Array of +GChart::Axis+ objects.
    attr_accessor :axes

    def initialize(options={}, &block)
      @data   = []
      @colors = []
      @legend = []
      @axes   = []
      @extras = {}

      @width = 300
      @height = 200
  
      options.each { |k, v| send("#{k}=", v) }
      yield(self) if block_given?
    end

    # Sets the chart's width, in pixels. Raises +ArgumentError+
    # if +width+ is less than 1 or greater than 1,000.
    def width=(width)
      if width.nil? || width < 1 || width > 1_000
        raise ArgumentError, "Invalid width: #{width.inspect}"
      end

      @width = width
    end

    # Sets the chart's height, in pixels. Raises +ArgumentError+
    # if +height+ is less than 1 or greater than 1,000.
    def height=(height)
      if height.nil? || height < 1 || height > 1_000
        raise ArgumentError, "Invalid height: #{height.inspect}"
      end

      @height = height
    end

    # Returns the chart's size as "WIDTHxHEIGHT".
    def size
      "#{width}x#{height}"
    end

    # Sets the chart's size as "WIDTHxHEIGHT". Raises +ArgumentError+
    # if +width+ * +height+ is greater than 300,000 pixels.
    def size=(size)
      self.width, self.height = size.split("x").collect { |n| Integer(n) }

      if (width * height) > 300_000
        raise ArgumentError, "Invalid size: #{size.inspect} yields a graph with more than 300,000 pixels"
      end
    end

    # Returns the chart's URL.
    def to_url
      pluck_out_data_points! if url_to_try.length > GChart::URL_MAXIMUM_LENGTH
      url_to_try
    end

    # Returns the chart's generated PNG as a blob.
    def fetch
      open(to_url) { |io| io.read }
    end

    # Writes the chart's generated PNG to a file. If +io_or_file+ quacks like an IO,
    # calls +write+ on it instead.
    def write(io_or_file="chart.png")
      return io_or_file.write(fetch) if io_or_file.respond_to?(:write)
      open(io_or_file, "w+") { |io| io.write(fetch) }
    end

    # Adds an +axis_type+ +GChart::Axis+ to the chart's set of
    # +axes+. See +GChart::Axis::AXIS_TYPES+.
    def axis(axis_type, &block)
      axis = GChart::Axis.create(axis_type, &block)
      @axes.push(axis)
      axis
    end

    protected
    
    def url_to_try
      query = query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
      "#{GChart::URL}?#{query}"
    end

    def query_params(raw_params={}) #:nodoc:
      params = raw_params.merge("cht" => render_chart_type, "chs" => size)
      
      render_data(params)
      render_title(params)
      render_colors(params)
      render_legend(params)
      render_backgrounds(params)

      unless @axes.empty?
        if is_a?(GChart::Line) or is_a?(GChart::Bar) or is_a?(GChart::Scatter) # or is_a?(GChart::Radar)
          render_axes(params)
        end
      end

      params.merge(extras)
    end

    def render_chart_type #:nodoc:
      raise NotImplementedError, "override in subclasses"
    end
    
    def render_data(params) #:nodoc:
      raw = data && data.first.is_a?(Array) ? data : [data]
      max = self.max || raw.collect { |s| s.max }.max

      sets = raw.collect do |set|
        set.collect { |n| GChart.encode(:extended, n, max) }.join
      end
      params["chd"] = "e:#{sets.join(",")}"
    end
    
    def render_title(params) #:nodoc:
      params["chtt"] = title.tr("\n ", "|+") if title
    end

    def render_colors(params) #:nodoc:
      unless colors.empty?
        params["chco"] = colors.collect{ |color| GChart.expand_color(color) }.join(",")
      end
    end

    def render_legend(params) #:nodoc:
      params["chdl"] = legend.join("|") unless legend.empty?
    end

    def render_backgrounds(params) #:nodoc:
      if entire_background || chart_background
        if entire_background and not GChart.valid_color?(entire_background)
          raise ArgumentError.new("The entire_background attribute has an invalid color")
        end
        if chart_background and not GChart.valid_color?(chart_background)
          raise ArgumentError.new("The chart_background attribute has an invalid color")
        end

        separator = entire_background && chart_background ? "|" : ""
        params["chf"]  = entire_background ? "bg,s,#{GChart.expand_color(entire_background)}" : ""
        params["chf"] += "#{separator}c,s,#{GChart.expand_color(chart_background)}" if chart_background
      end
    end

    def render_axes(params) #:nodoc:
      @axes.each do |axis|
        axis.validate!
      end

      render_axis_type_labels(params)
      render_axis_labels(params)
      render_axis_label_positions(params)
      render_axis_ranges(params)
      render_axis_styles(params)
      render_axis_range_markers(params)
    end

    def render_axis_type_labels(params) #:nodoc:
      params["chxt"] = @axes.collect{ |axis| axis.axis_type_label }.join(',')
    end

    def render_axis_labels(params) #:nodoc:
      if @axes.any?{ |axis| axis.labels.size > 0 }
        chxl = []

        @axes.each_with_index do |axis, index|
          if axis.labels.size > 0
            chxl.push("#{index}:")
            chxl += axis.labels
          end
        end

        params["chxl"] = chxl.join('|')
      end
    end

    def render_axis_label_positions(params) #:nodoc:
      if @axes.any?{ |axis| axis.label_positions.size > 0 }
        chxp = []

        @axes.each_with_index do |axis, index|
          chxp.push("#{index}," + axis.label_positions.join(',')) if axis.label_positions.size > 0
        end

        params["chxp"] = chxp.join('|')
      end
    end

    def render_axis_ranges(params) #:nodoc:
      if @axes.any?{ |axis| axis.range }
        chxr = []

        @axes.each_with_index do |axis, index|
          chxr.push("#{index},#{axis.range.join(',')}") if axis.range
        end

        params["chxr"] = chxr.join('|')
      end
    end

    def render_axis_styles(params) #:nodoc:
      if @axes.any?{ |axis| axis.text_color }
        chxs = []

        @axes.each_with_index do |axis, index|
          if axis.text_color
            chxs.push(
              "#{index}," +
              [GChart.expand_color(axis.text_color), axis.font_size, axis.text_alignment].compact.join(',')
            )
          end
        end

        params["chxs"] = chxs.join('|')
      end
    end

    def render_axis_range_markers(params) #:nodoc:
      if @axes.any?{ |axis| axis.range_markers.size > 0 }
        chmr = []

        @axes.each do |axis|
          axis.range_markers.each do |range, color|
            chmr.push("#{axis.range_marker_type_label},#{color},0,#{range.first},#{range.last}")
          end
        end

        params["chm"] = chmr.join('|')
      end
    end

    # If the length of an initially-generated URL exceeds the maximum
    # length which Google allows for chart URLs, then we need to trim
    # off some data.  Here we make the (rather sane) assumption that
    # each data set is the same size as every other data set (or a
    # size of 1, which we ignore here).  Then we remove the same
    # number of points from each data set, in an as evenly-distributed
    # approach as we can muster, until the length of our generated URL
    # is less than the maximum length.
    def pluck_out_data_points!
      original_data_sets = data_clone(data)

      divisor_upper = data.collect{ |set| set.length }.max
      divisor_lower = 0
      divisor       = 0

      while divisor_upper - divisor_lower > 1 || url_to_try.length > GChart::URL_MAXIMUM_LENGTH
        self.data = data_clone(original_data_sets)

        if divisor_upper - divisor_lower > 1
          divisor = (divisor_lower + divisor_upper) / 2
        else
          divisor += 1
        end

        data.each do |set|
          next if set.size == 1
          indexes_for_plucking(set.size, divisor).each do |deletion_index|
            set.delete_at(deletion_index)
          end
        end

        if divisor_upper - divisor_lower > 1
          if url_to_try.length > GChart::URL_MAXIMUM_LENGTH
            divisor_lower = divisor
          else
            divisor_upper = divisor
          end
        end
      end
    end

    def indexes_for_plucking(array_length, divisor) #:nodoc:
      indexes = []

      last_index               = array_length - 1
      num_points_to_remove     = divisor - 1
      num_points_after_removal = array_length - num_points_to_remove
      num_points_in_chunk      = num_points_after_removal / divisor.to_f

      subtraction_point = array_length.to_f

      1.upto(num_points_to_remove) do |point_number|
        subtraction_point -= num_points_in_chunk
        indexes.push( (subtraction_point - point_number).round )
      end

      indexes
    end

    def data_clone(original_array_of_arrays) #:nodoc:
      cloned_array_of_arrays = Array.new

      original_array_of_arrays.each do |original_array|
        cloned_array = Array.new

        original_array.each do |datum|
          cloned_array << datum
        end

        cloned_array_of_arrays << cloned_array
      end

      cloned_array_of_arrays
    end
  end
end
