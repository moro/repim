# add hook to activate in rails app.
#
# example.
# ActiveRecrod::Base.send(:include, Repim)

require 'repim/application'
config.gem 'moro-open_id_authentication', :lib => 'open_id_authentication', :source => 'http://gems.github.com/'

