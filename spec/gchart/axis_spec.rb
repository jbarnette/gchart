require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Axis do
  before(:each) { @axis = GChart::Axis.create(:bottom) }

  it "blows up when you try to create it with new" do
    lambda { GChart::Axis.new }.should raise_error(NoMethodError)
  end

  describe ".create" do
    {
      :top    => GChart::TopAxis,    :right => GChart::RightAxis,
      :bottom => GChart::BottomAxis, :left  => GChart::LeftAxis
    }.each do |axis_type, axis_class|
      it "can create a #{axis_class}" do
        axis = GChart::Axis.create(axis_type)
        axis.should be_instance_of(axis_class)
      end
    end

    it "explodes with an invalid axis_type" do
      lambda { GChart::Axis.create(:middle) }.should raise_error(ArgumentError)
    end
  end

  describe ".validate!" do
    it "will validate all axis attributes as working with each other by not blowing up" do
      @axis.validate!
    end
  end

  describe ".labels" do
    it "will contain an array of labels" do
      @axis.labels = %w(Mon Tue Wed Thu Fri)
    end
  end

  describe ".label_positions" do
    it "will contain an array of label_positions" do
      @axis.label_positions = [0, 25, 50, 75, 100]
    end
  end

  describe ".validate!" do
    it "will blow up if there are labels and label_positions, but their sizes don't match" do
      @axis.labels = %w(Mon Tue Wed Thu Fri)
      @axis.label_positions = [0, 25, 50]
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end

    it "will be happy when there is 1 label_position for every label" do
      @axis.labels = %w(Mon Tue Wed Thu Fri)
      @axis.label_positions = [0, 25, 50, 75, 100]
      @axis.validate!
    end

    it "will be happy if there are labels but no label_positions" do
      @axis.labels = %w(Mon Tue Wed Thu Fri)
      @axis.validate!
    end

    it "will be happy if there are label_positions but no labels" do
      @axis.label_positions = [0, 25, 50, 75, 100]
      @axis.validate!
    end

    it "will blow up if label_positions contains non-numeric values" do
      @axis.label_positions = %w(a e h l)
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end
  end

  describe ".range" do
    it "will contain a range from which to derive labels" do
      @axis.range = [0, 1300]
    end
  end

  describe ".validate!" do

    it "will be content if a range is used in combination with labels" do
      @axis.range = [0, 100]
      @axis.labels = [25, 50, 75]
      @axis.validate!
    end

    it "will be content if a range is used in combination with labels and label_positions both" do
      @axis.range = [0, 100]
      @axis.labels = %w(25 50 75)
      @axis.label_positions = [25, 50, 75]
      @axis.validate!
    end
  end

  describe ".text_color" do
    it "will contain the color in which to draw axis labelings" do
      @axis.text_color = :green
    end
  end

  describe ".font_size" do
    it "will contain the font_size for the labels on the axis" do
      @axis.font_size = 12
    end
  end

  describe ".text_alignment" do
    it "will contain the information on how to align labels on the axis" do
      @axis.text_alignment = :right
    end
  end

  describe ".validate!" do
    it "will be happy if the text_color is a valid color" do
      @axis.text_color = 'ff0199aa'
      @axis.validate!
    end

    it "will blow up if the text_color is not a valid color" do
      @axis.text_color = :rgb_freakout
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end

    it "will be happy if font_size is specified along with text_color" do
      @axis.text_color = 'bbb'
      @axis.font_size = 12
      @axis.validate!
    end

    it "will blow up if the text_color is valid but the font_size is not numeric" do
      @axis.text_color = :black
      @axis.font_size = "13.5"
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end

    it "will be happy if text_alignment is specified with both font_size and text_color" do
      @axis.text_alignment = :center
      @axis.font_size = 11.5
      @axis.text_color = :cyan
      @axis.validate!
    end

    it "will blow up if font_size and text_color are valid, but text_alignment isn't in TEXT_ALIGNMENT table" do
      @axis.text_color = :magenta
      @axis.font_size = 12
      @axis.text_alignment = :upper
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end
  end

  describe ".range_markers" do
    it "will contain an array of ranges of markers and their colors" do
      @axis.range_markers = [[45..70, :magenta], [75..90, :pink]]
    end
  end

  describe ".validate!" do
    it "be happy when range_markers contains an array of 2-element subarrays of ranges and colors" do
      @axis.range_markers = [[45..70, :magenta], [75..90, :pink]]
      @axis.validate!
    end

    it "will bomb if any element in range_markers is not an array of 2 elements" do
      @axis.range_markers = ["string", :thistle]
      lambda { @axis.validate! }.should raise_error(ArgumentError)

      @axis.range_markers = [[:one, :two, :three], [:un, :deux, :trois]]
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end

    it "will bomb if the 1st element in any of the 2-element arrays in range_markers is not a numeric range" do
      @axis.range_markers = [[75, :blue], [75..100, :green]]
      lambda { @axis.validate! }.should raise_error(ArgumentError)

      @axis.range_markers = [['a'..'z', :blue], [75..10, :green]]
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end

    it "will bomb if the 2nd element in any of the 2-element arrays in range_markers is not a valid color" do
      @axis.range_markers = [[75..90, :blue], [75..100, :cyantiago]]
      lambda { @axis.validate! }.should raise_error(ArgumentError)
    end
  end



end
