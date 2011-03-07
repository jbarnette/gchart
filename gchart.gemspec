# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gchart}
  s.version = "1.0.0.20110308073316"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette", "Jim Ludwig"]
  s.date = %q{2011-03-08}
  s.description = %q{GChart exposes the Google Chart API via a friendly Ruby interface. It
can generate the URL for a given chart (for webpage use), or download
the generated PNG (for offline use).}
  s.email = ["jbarnette@rubyforge.org", "supplanter@rubyforge.org"]
  s.extra_rdoc_files = ["Manifest.txt", "README.rdoc", "CHANGELOG.rdoc"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "lib/gchart.rb", "lib/gchart/axis.rb", "lib/gchart/axis/bottom_axis.rb", "lib/gchart/axis/horizontal_axis.rb", "lib/gchart/axis/left_axis.rb", "lib/gchart/axis/right_axis.rb", "lib/gchart/axis/top_axis.rb", "lib/gchart/axis/vertical_axis.rb", "lib/gchart/bar.rb", "lib/gchart/base.rb", "lib/gchart/colors.rb", "lib/gchart/line.rb", "lib/gchart/map.rb", "lib/gchart/meter.rb", "lib/gchart/pie.rb", "lib/gchart/pie_3d.rb", "lib/gchart/scatter.rb", "lib/gchart/sparkline.rb", "lib/gchart/venn.rb", "lib/gchart/xy_line.rb", "spec/gchart/axis/bottom_axis_spec.rb", "spec/gchart/axis/left_axis_spec.rb", "spec/gchart/axis/right_axis_spec.rb", "spec/gchart/axis/top_axis_spec.rb", "spec/gchart/axis_spec.rb", "spec/gchart/bar_spec.rb", "spec/gchart/base_spec.rb", "spec/gchart/colors_spec.rb", "spec/gchart/line_spec.rb", "spec/gchart/map_spec.rb", "spec/gchart/meter_spec.rb", "spec/gchart/pie_3d_spec.rb", "spec/gchart/pie_spec.rb", "spec/gchart/scatter_spec.rb", "spec/gchart/sparkline_spec.rb", "spec/gchart/venn_spec.rb", "spec/gchart/xy_line_spec.rb", "spec/gchart_spec.rb", "spec/helper.rb", "spec/spec.opts", ".gemtest"]
  s.homepage = %q{http://github.com/jbarnette/gchart}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gchart}
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{GChart exposes the Google Chart API via a friendly Ruby interface}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.9.1"])
    else
      s.add_dependency(%q<hoe>, [">= 2.9.1"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.9.1"])
  end
end
