module GChart
  class BottomAxis < HorizontalAxis
    # Returns 'x'.
    def axis_type_label
      'x'
    end

    class << self ; public :new ; end
  end
end
