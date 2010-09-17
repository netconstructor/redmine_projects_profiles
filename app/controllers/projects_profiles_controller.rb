class ProjectsProfilesController < ApplicationController
  before_filter :require_admin, :only => [ :configure ]

  helper :custom_fields

  unloadable

  def index
    @projects = {}    
    @profiles = ProjectsProfile.all
    projects = Project.all
    @main_sort = @profiles.select{|e| e.value == "group_field_main"}[0].meaning
    @sub_sort = @profiles.select{|e| e.value == "group_field_sub_main"}[0].meaning
    @alt_name = @profiles.select{|e| e.value == "alt_name"}[0].meaning
    if ( (@main_sort.nil?) || (@sub_sort.nil?) || (@alt_name.nil?) )
      flash[:notice] = l(:projects_profiles_error_configure)
      return
    end    
    custom_values = CustomValue.all(:conditions => "custom_field_id='#{@main_sort}'",:order => "value")
    prev_value = "some_secret_key"
    temp_array = []
    selected_projects = ""
    custom_values.each do |custom_value|
      if (custom_value.value != prev_value)
        @projects[prev_value] = temp_array if temp_array.size > 0
        prev_value  = custom_value.value
        temp_array = []
      end
      temp_project = projects.select{|e| e.id==custom_value.customized_id}[0]
      temp_array.push(temp_project)
      selected_projects = selected_projects + "#{temp_project.id},"
    end
    @projects[prev_value] = temp_array if temp_array.size > 0
    if (selected_projects.size>0)
      selected_projects[selected_projects.size-1] = ""
      projects_without_category = Project.find_by_sql("Select * from projects where id not in (#{selected_projects}) ")
      @projects[l(:projects_profiles_rest_sort)] = projects_without_category if (projects_without_category.size>0)
    end  
  end

  def configure
    show_text = l(:projects_profiles_show)
    @fields = {"description"=>[l(:projects_profiles_description),show_text], "homepage"=>[l(:projects_profiles_homepage), show_text], "created_on"=>[l(:projects_profiles_created_on), show_text], "updated_on"=>[l(:projects_profiles_updated_on), show_text]}
    if request.post?
      ProjectsProfile.delete_all      
      params["projects_profile"].each do |key, value|
        if (!key["position_"].nil?)
          profile = ProjectsProfile.new
          profile.meaning = key.match(/_(.+)/)[1]
          profile.value = value
          profile.save
        end
        if !( (key["group_field_"].nil?) && (key["alt_name"].nil?) )
          profile = ProjectsProfile.new
          profile.meaning = value
          profile.value = key
          profile.save
        end
      end
    flash[:notice] = l(:projects_profiles_settings_saved)
    redirect_to :action => "configure"
    else
    end
    profiles = ProjectsProfile.all
    @custom_fields = CustomField.all(:conditions => "type='ProjectCustomField' ")
    @custom_fields.each do |custom_field|
      @fields[custom_field.id] = [custom_field.name, show_text]
    end
    if (profiles.size>0)
      @fields.each do |key, value|
        profile = profiles.select{|e| e.meaning.to_s == key.to_s}
        if (profile.size>0)
          value[1] = profile[0].value.to_s      
        end
      end
      @default_main = ""
      @default_main = profiles.select{|e| e.value == "group_field_main"}[0].meaning
      @default_sub_main = ""
      @default_sub_main = profiles.select{|e| e.value == "group_field_sub_main"}[0].meaning
      @default_alt_name = ""
      @default_alt_name = profiles.select{|e| e.value == "alt_name"}[0].meaning
    end
  end
end
