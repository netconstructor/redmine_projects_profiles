require 'redmine'
Redmine::Plugin.register :redmine_profiles do
  name 'Profiles plugin'  
  description 'Plugin for viewing users profiles'
  version '0.0.1'
  menu :top_menu, :profiles, { :controller => 'profiles', :action => 'index' }, :caption => :profile_plugin_name
  menu :admin_menu, :profiles, { :controller => 'profiles', :action => 'configure' }, :caption => :profile_plugin_name

end

