require_relative 'lib/rbimg/version'

Gem::Specification.new do |spec|
  spec.name          = "rbimg"
  spec.version       = Rbimg::VERSION
  spec.authors       = ["micahshute"]
  spec.email         = ["micah.shute@gmail.com"]

  spec.summary       = %q{Create, read, and manipulate images via arrays of pixel data}
  spec.description   = %q{This gem allows you to read and/or create a valid picture by working with an array of pixel data. This can be used to easily visualize the MSNT dataset, ecrypt/decrypt images, create graphs and charts, etc.}
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "http://rubygems.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/micahshute/rbimg"
  spec.metadata["changelog_uri"] = "https://github.com/micahshute/rbimg"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'byteman', "~> 0.1.0"
  spec.add_dependency 'require_all', "~> 3.0"
end
