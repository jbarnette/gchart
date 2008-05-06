require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart, ".expand_color" do
  { "693" => "669933", "fff" => "ffffff", "000" => "000000" }.each do |_3_char_color, _6_char_color|
    it "expands #{_3_char_color} into #{_6_char_color}" do
      GChart.expand_color(_3_char_color).should == _6_char_color
    end
  end

  { :red => "ff0000", :alice_blue => "f0f8ff", :yellow => "ffff00" }.each do |color_symbol, expanded|
    it "expands #{color_symbol} into #{expanded}" do
      GChart.expand_color(color_symbol).should == expanded
    end
  end

  [ :canary_burnt_sienna, 3, 7.4, ['fff'], {'693' => 'cool'}, nil ].each do |non_color|
    it "does not expand #{non_color}" do
      GChart.expand_color(non_color).should == non_color
    end
  end

  %w(669933 ffffff 000000).each do |_6_character_color|
    it "does not expand #{_6_character_color}" do
      GChart.expand_color(_6_character_color).should == _6_character_color
    end
  end

end

describe GChart, ".valid_color?" do
  it "verifies a 3-hex-character rgb color definition as being valid" do
    GChart.valid_color?('ffF').should == true
    GChart.valid_color?('123').should == true
  end

  it "verifies a 6-hex-character rrggbb color definition as being valid" do
    GChart.valid_color?('123fFf').should == true
    GChart.valid_color?('a1B2c3').should == true
  end

  it "verifies an 8-hex-character rrggbbtt (transparency) color definition as being valid" do
    GChart.valid_color?('123fffAa').should == true
    GChart.valid_color?('a1b2c300').should == true
  end

  it "verifies a COLORS symbol color definition as being valid" do
    GChart.valid_color?(:red).should == true
    GChart.valid_color?(:slate_blue4).should == true
  end

  it "states as being invalid any non-String/non-Symbol" do
    GChart.valid_color?([:purple]).should == false
    GChart.valid_color?({:red => true}).should == false
    GChart.valid_color?(true).should == false
    GChart.valid_color?(7).should == false
    GChart.valid_color?(99.99).should == false
    GChart.valid_color?(Object.new).should == false
    GChart.valid_color?(GChart.class).should == false
  end

  it "states as being invalid any String of length not equal to 3, 6 or 8" do
    GChart.valid_color?('ab').should == false
    GChart.valid_color?('abcd').should == false
    GChart.valid_color?('abcde').should == false
    GChart.valid_color?('abcdef1').should == false
    GChart.valid_color?('abcdef123').should == false
  end

  it "states as being invalid any String of length equal to 3, 6 or 8 with non-hex characters" do
    GChart.valid_color?('efg').should == false
    GChart.valid_color?('bcdefg').should == false
    GChart.valid_color?('abcdefZZ').should == false
  end

  it "states as being invalid any symbol which is not in the COLORS table" do
    GChart.valid_color?(:awesome_blue).should == false
    GChart.valid_color?(:burnt_cyborg).should == false
  end
end
