class RelyingPartyGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options={})
    super
    user_name, user_cols = @args

    if user_name
      @user_klass_name = user_name.singularize.under_score
      @user_cols = user_cols
    else
      @user_klass_name = "user"
    end
  end

  def manifest
    controller_file_name  = plural_name + "_controller"
    controller_class_name = controller_file_name.camelize

    record do |m|
      m.file "sessions_controller.rb", "app/controllers/#{controller_file_name}.rb"
      m.route_resources plural_name
      m.dependency("open_id_authentication_tables", ["open_id_authentication_tables" ])

      model_generator = using_rspec? ? "rspec_model" : "model"
      m.dependency(model_generator, [@user_klass_name, "identity_url:string", user_cols].flatten.compact)

      if $0 =~ %r!script/destroy!
        m.gsub_file('app/controllers/application.rb', /(^\s*include Repim::Application\s*$)/mi){|m| "" }
      else
        m.gsub_file 'app/controllers/application.rb', /(^\s*helper\s.*?$)/mi do |match|
          "#{match}\n  include Repim::Application"
        end
      end
    end
  end

  private
  def user_model_exists?
    File.exists?( File.expand_path(@user_klass_name + ".rb", RAILS_ROOT + "/app/models") )
  end

  def using_rspec?
    File.directory?( File.expand_path("spec"), RAILS_ROOT )
  end
end
