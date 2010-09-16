require 'redmine'
Redmine::Plugin.register :redmine_profiles do
  name 'Projects profiles plugin'  
  description 'Plugin for viewing projects profiles'
  version '0.0.1'
  menu :top_menu, :projects_profiles, { :controller => 'projects_profiles', :action => 'index' }, :caption => :projects_profiles_plugin_name
  menu :admin_menu, :projects_profiles, { :controller => 'projects_profiles', :action => 'configure' }, :caption => :projects_profiles_plugin_name
end

