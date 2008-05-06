module GChart
  class HorizontalAxis < Axis
    # Returns 'R' to indicate a vertical +range_marker+ (stemming
    # from a horizontal axis).
    def range_marker_type_label
      'R'
    end

    class << self ; private :new ; end
  end
end
