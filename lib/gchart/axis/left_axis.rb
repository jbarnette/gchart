module GChart
  class LeftAxis < VerticalAxis
    # Returns 'y'.
    def axis_type_label
      'y'
    end

    class << self ; public :new ; end
  end
end
