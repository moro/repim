# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{repim}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["MOROHASHI Kyosuke"]
  s.date = %q{2009-03-11}
  s.description = %q{Relying Party in minutes.}
  s.email = %q{moronatural@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "ChangeLog"]
  s.files = ["README.rdoc", "ChangeLog", "Rakefile", "lib/repim", "lib/repim/application.rb", "lib/repim/ax_attributes_adapter.rb", "lib/repim/relying_party.rb", "lib/repim/signup.rb", "lib/repim.rb", "generators/relying_party", "generators/relying_party/relying_party_generator.rb", "generators/relying_party/templates", "generators/relying_party/templates/public", "generators/relying_party/templates/public/images", "generators/relying_party/templates/public/images/openid-login.gif", "generators/relying_party/templates/public/stylesheets", "generators/relying_party/templates/public/stylesheets/repim.css", "generators/relying_party/templates/sessions_controller.rb", "generators/relying_party/templates/spec", "generators/relying_party/templates/spec/application_controller_spec.rb", "generators/relying_party/templates/spec/sessions_controller_spec.rb", "generators/relying_party/templates/spec/sessions_routing_spec.rb", "generators/relying_party/templates/spec/users_controller_spec.rb", "generators/relying_party/templates/spec/users_routing_spec.rb", "generators/relying_party/templates/users_controller.rb", "generators/relying_party/templates/views", "generators/relying_party/templates/views/layouts", "generators/relying_party/templates/views/layouts/sessions.html.erb", "generators/relying_party/templates/views/sessions", "generators/relying_party/templates/views/sessions/new.html.erb", "generators/relying_party/templates/views/users", "generators/relying_party/templates/views/users/new.html.erb", "rails/init.rb"]
  s.homepage = %q{http://github.com/moro/repim/}
  s.rdoc_options = ["--title", "repim documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Relying Party in minutes.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
