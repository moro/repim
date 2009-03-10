class RelyingPartyGenerator < Rails::Generator::NamedBase
  def add_options!(opt)
    opt.on("--skip-plugins-spec",
           "Do'nt copy application_controller_spec.rb and #{plural_name}_controller_spec.rb, default is #{!using_rspec?}"){|v| options[:skip_sessions_spec] = true }
    opt.on("--user-class=klass",
           "Specify User class name defailt is [User]"){|v| opt[:user_klass] = "User" }
    opt.on("--user-management=generation_type",
           "'model' for generate (rspec_)model, 'singnup' for controller using Repim::Signup. default is 'signup'"){|v| options[:user_model_only] = (v == "model") }
    opt.on("--openid-migration=migration_name",
           "Specify openid migration name, default is 'open_id_authentication_tables'. If value is 'none' generate nothing.") do |v|
      options[:openid_migration] = v
    end
  end

  def manifest
    controller_file_name  = plural_name + "_controller"
    controller_class_name = controller_file_name.camelize

    record do |m|
      m.file "sessions_controller.rb", "app/controllers/#{controller_file_name}.rb"
      assign_session_routing(singular_name, m)

      m.directory "app/views/layouts"
      m.file "views/layouts/sessions.html.erb", "app/views/layouts/#{plural_name}.html.erb"

      m.directory "app/views/#{plural_name}"
      m.file "views/sessions/new.html.erb", "app/views/#{plural_name}/new.html.erb"

      %w[public/images/openid-login.gif public/stylesheets/repim.css].each do |asset|
        m.directory File.dirname(asset)
        m.file asset, asset
      end

      unless options[:skip_sessions_spec]
        m.directory "spec/controllers"
        m.file "spec/application_controller_spec.rb", "spec/controllers/application_controller_spec.rb"

        m.file "spec/sessions_controller_spec.rb", "spec/controllers/#{controller_file_name}_spec.rb"
        m.file "spec/sessions_routing_spec.rb", "spec/controllers/#{plural_name}_routing_spec.rb"
      end

      generate_user_management(m, !options[:skip_sessions_spec]) unless options[:user_model_only]
      m.dependency(care_rspec("model"), [user_klass_name, "identity_url:string", @user_cols].flatten.compact)

      # FIXME very veriy dirty
      # "sleep 3" is for changing timestamp of 'create_user' or 'open_id_authentication_tables'
      if options[:command] == :create
        m.gsub_file(app_controller, /(^\s*helper\s.*?$)/mi) do |ms|
          sleep 3
          "#{ms}\n  include Repim::Application"
        end
      else
        m.gsub_file(app_controller, /(^\s*include Repim::Application\s*$)/mi){|m| "" }
      end

      unless options[:openid_migration] == "none"
        name = options[:openid_migration] || "open_id_authentication_tables"
        m.dependency("open_id_authentication_tables", [name])
      end
    end
  end

  private
  def app_controller
    %w[application_controller application].
      map{|f| "app/controllers/#{f}.rb" }.
      detect{|c| File.exists?(File.expand_path(c, RAILS_ROOT)) }
  end

  def care_rspec(base); using_rspec? ? "rspec_#{base}" : base end

  def using_rspec?; File.directory?( File.expand_path("spec", RAILS_ROOT) ) end

  def assign_session_routing(name, manifest)
    sentinel = 'ActionController::Routing::Routes.draw do |map|'

    logger.route "map.resource #{name}"
    route = <<EOS

  map.signin  '/signin',  :controller => 'sessions', :action => 'new'
  map.signout '/signout', :controller => 'sessions', :action => 'destroy'
  map.resource :session
EOS

    unless options[:pretend]
      if options[:command] == :create
        manifest.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}#{route}"
        end
      else
        manifest.gsub_file 'config/routes.rb', route, ''
      end
    end
  end

  def user_klass_name
    options[:user_klass] || "User"
  end
  def generate_user_management(m, with_spec = true)
    users = user_klass_name.pluralize.underscore
    user_controller_name =  users + "_controller"

    m.route_resources users.to_sym
    m.file("users_controller.rb", "app/controllers/#{user_controller_name}.rb")

    m.directory "app/views/#{users}"
    m.template "views/users/new.html.erb", "app/views/#{users}/new.html.erb", :assigns => {:user => user_klass_name.underscore, :users => users}

    if with_spec
      m.file "spec/users_controller_spec.rb", "spec/controllers/#{user_controller_name}_spec.rb"
      m.file "spec/users_routing_spec.rb", "spec/controllers/#{users}_routing_spec.rb"
    end
  end
end
