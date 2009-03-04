require 'rubygems'
require 'active_record'
require 'active_record/fixtures'

RAILS_ENV ||= "test"

module RecrodExtention
  module TestUtil
    MEMORY_DB_OPTIONS = {
      :adapter => "sqlite3",
      :database => ":memory:",
    }.with_indifferent_access.freeze

    def setup
      memory_db!
      log_or_silent!
      ActiveRecord::Base.extend(ClassMethods)
    end

    def memory_db!(options = {})
      ActiveRecord::Base.configurations = {"test" => MEMORY_DB_OPTIONS.merge(options) }
      ActiveRecord::Base.establish_connection(:test)
    end

    def log_or_silent!(dir = "log")
      ActiveRecord::Base.logger = Logger.new(dir && File.directory?(dir) ? "#{dir}/#{RAILS_ENV}.log" : "/dev/null")
    end

    def next_schema_version
      begin
        ActiveRecord::Base.connection.select_one("SELECT version FROM schema_migrations")["version"].succ
      rescue ActiveRecord::StatementInvalid
        "1"
      end
    end
    module_function :setup, :memory_db!, :log_or_silent!, :next_schema_version

    module ClassMethods
      def define_table(table_name = self.name.tableize, &migration)
        ActiveRecord::Schema.define(:version => TestUtil.next_schema_version) do
          create_table(table_name, &migration)
        end
      end
    end
  end
end

