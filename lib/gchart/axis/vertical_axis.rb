module GChart
  class VerticalAxis < Axis
    # Returns 'r' to indicate a horizontal +range_marker+ (stemming
    # from a vertical axis).
    def range_marker_type_label
      'r'
    end

    class << self ; private :new ; end
  end
end
