module GChart
  class RightAxis < VerticalAxis
    # Returns 'r'.
    def axis_type_label
      'r'
    end

    class << self ; public :new ; end
  end
end
