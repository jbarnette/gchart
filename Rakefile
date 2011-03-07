require "rubygems"
require "hoe"

Hoe.plugin :doofus, :git
Hoe.plugin :gemspec

Hoe.spec "gchart" do
  developer "John Barnette", "jbarnette@rubyforge.org"
  developer "Jim Ludwig",    "supplanter@rubyforge.org"

  self.extra_rdoc_files = FileList["*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.testlib          = :rspec
end
