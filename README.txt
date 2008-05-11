= GChart

== DESCRIPTION
  
GChart exposes the Google Chart API (http://code.google.com/apis/chart) via
a friendly Ruby interface. It can generate the URL for a given chart
(for webpage use), or download the generated PNG (for offline use).

== PROBLEMS/TODO

* Add grid lines, linear stripes, shape markers, gradient fills
* Make venn data specification friendlier
* Make documentation more digestible

There are lots of missing features. Until they're implemented, you can directly specify
query parameters using the :extras key, e.g.,

  # provides a legend for each data set
  g = GChart.line(:data => [[1, 2], [3, 4]], :extras => { "chdl" => "First|Second"})

== SYNOPSIS

  # line chart
  g = GChart.line(:data => [0, 10, 100])
  
  # bar chart
  g = GChart.bar(:data => [100, 1000, 10000])
  
  # pie chart (pie3d for a fancier look)
  g = GChart.pie(:data => [33, 33, 34])
  
  # venn diagram (asize, bsize, csize, ab%, bc%, ca%, abc%)
  g = GChart.venn(:data => [100, 80, 60, 30, 30, 30, 10])
  
  # scatter plot (x coords, y coords [, sizes])
  g = GChart.scatter(:data => [[1, 2, 3, 4, 5], [5, 4, 3, 2, 1], [1, 2, 3, 4, 5]])

  # map chart
  g = GChart.map(:area => 'usa', :data => {'NY'=>1,'VA'=>3,'CA'=>2})
  
  # meter
  g = GChart.meter(:data => 70, :label => "70%")
  
  # chart title
  g = GChart.line(:title => "Awesomeness over Time", :data => [0, 10, 100])

  # data set legend
  g = GChart.line(:data => [[1, 2], [3, 4]], :legend => ["Monkeys", "Ferrets"])

  # data set colors
  g = GChart.line(:data => [[0, 10, 100], [100, 10, 0]], :colors => ["ff0000", "0000ff"])
  
  g.to_url            # generate the chart's URL, or
  g.fetch             # get the bytes, or
  g.write("foo.png")  # write to a file (defaults to "chart.png")
  g.write(stream)     # write to anything that quacks like IO

== AXIS LABELING

Charts which support an axis concept can be labeled. Supported types
are line charts, bar charts, radar charts and scatter plots. See
+GChart::Axis+ for more information.

== EXAMPLES

=== Simple Line Chart with 2 data sets

  require 'gchart'
  chart = GChart.line do |g|
    g.data   = [[0, 1, 2, 3, 4, 5, 6], [3, 2, 4, 1, 5, 0, 6]]
    g.colors = [:red,                  :yellow]
    g.legend = ["Line",                "Wonkiness"]

    g.width  = 600
    g.height = 150

    g.entire_background = "f4f4f4"

    g.axis(:left) { |a| a.range = 0..6 }

    g.axis(:bottom) do |a|
      a.labels          = ["Mon", "Tue", "Thu", "Sun"]
      a.label_positions = [0,     16.67, 50,    100]
      a.text_color = :black
    end

    g.axis(:bottom) do |a|
      a.labels = ["Week 42"]
      a.label_positions = [50]
    end
  end

=== Complex Line Chart with multiple axes

  require 'gchart'
  chart = GChart.line do |g|
    g.data   = [data_array1, data_array2, data_array3]
    g.colors = [:red,        :green,      :blue]
    g.legend = ["Set 1",     "Set 2",     "Set 3"]

    g.width  = 950
    g.height = 315

    g.entire_background = "434"
    g.chart_background  = "aba"

    g.axis(:left) do |a|
      a.range = 0..100
      a.text_color = :red
      a.font_size  = 9
    end

    g.axis(:right) do |a|
      a.range = 0..1000
      a.labels = %w(250 500 750)
      a.label_positions = [250, 500, 750]

      a.text_color = :green
      a.font_size  = 8
      a.text_alignment = :right
    end

    g.axis(:top) do |a|
      a.labels = %w(2008)
      a.positions = [50]
    end

    bottom1 = g.axis(:bottom)
    bottom1.labels = dates_array
    bottom1.range_markers = [
      [0..33.33, 'ff000044'], [33.33..66.67, '00ff0044'], [66.67..100, '0000ff44']
    ]

    # We "manually" create our 2nd bottom axis...
    bottom2 = GChart::Axis.create(:bottom)
    bottom2.labels = %w(Dates)
    bottom2.label_positions = [50]

    # ...and therefore need to also add it to our axes "manually".
    g.axes << bottom2
  end

  url = chart.to_url

== LICENSE

(The MIT License)

Copyright 2007-2008 John Barnette (jbarnette@rubyforge.org),
  Jim Ludwig (supplanter@rubyforge.org)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
