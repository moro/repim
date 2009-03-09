class RelyingPartyGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options={})
    super
    user_name, user_cols = @args

    if user_name
      @user_klass_name = user_name.singularize.underscore
      @user_cols = user_cols
    else
      @user_klass_name = "user"
    end
  end

  def add_options!(opt)
    opt.on("--skip-user-scaffold",
           "Create user model with (rspec_)model generator. In default we user (rspec_)scaffold."){|v| options[:skip_user_scaffold] = true }

    opt.on("--skip-plugins-spec",
           "Do'nt copy application_controller_spec.rb and #{plural_name}_controller_spec.rb, default is #{!using_rspec?}"){|v| options[:skip_sessions_spec] = true }

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
      m.route_resources plural_name

      unless options[:skip_sessions_spec]
        m.directory "spec/controllers"
        m.file "spec/application_controller_spec.rb", "spec/controllers/application_controller_spec.rb"
        m.file "spec/sessions_controller_spec.rb", "spec/controllers/#{controller_file_name}_spec.rb"
      end

      m.dependency(care_rspec(options[:skip_user_scaffold] ? "model" : "scaffold"),
                   [@user_klass_name, "identity_url:string", @user_cols].flatten.compact)

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

  def user_model_exists?
    File.exists?( File.expand_path(@user_klass_name + ".rb", RAILS_ROOT + "/app/models") )
  end

  def care_rspec(base)
     using_rspec? ? "rspec_#{base}" : base
  end

  def using_rspec?
    File.directory?( File.expand_path("spec", RAILS_ROOT) )
  end
end
