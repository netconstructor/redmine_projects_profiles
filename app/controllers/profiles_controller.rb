class ProfilesController < ApplicationController
  before_filter :require_admin, :only => [ :configure ]
  
  helper :custom_fields

  unloadable

  def index    
    @users = {} 
    profiles = Profile.all
    users = User.all
    @profile = profiles.select{|e| e.value == 'anchor' }[0]        
    @alt_name_key = profiles.select{|e| e.value == 'alt_name'}[0]
    @profiles_not_shown = profiles.select{|e| e.value == 'void'}
    if ( (@profile.nil?) || (@alt_name_key.nil?))
      flash[:notice] = l(:profile_error_configure)
      return
    end
    custom_values = CustomValue.all(:conditions => "custom_field_id='#{@profile.meaning}'",:order => "value")
    prev_value = "some_secret_key"
    temp_array = []
    selected_users = ""
    custom_values.each do |custom_value|
      if (custom_value.value != prev_value)
        @users[prev_value] = temp_array if temp_array.size > 0
        prev_value  = custom_value.value
        temp_array = []                                 
      end
      temp_user = users.select{|e| e.id==custom_value.customized_id}[0]      
      temp_array.push(temp_user)
      selected_users = selected_users + "#{temp_user.id},"
    end
    @users[prev_value] = temp_array if temp_array.size > 0
    if (selected_users.size>0)
      selected_users[selected_users.size-1] = ""
      users_without_category = User.find_by_sql("Select * from users where id not in (#{selected_users}) and type!='AnonymousUser' ")
      @users[l(:profile_rest_sort)] = users_without_category if (users_without_category.size>0)
    end
    @left_column = {}
    profiles.select{|e| e.value=="left"}.each do |profile|
      @left_column[profile.meaning] = "left"
    end
  end

  def configure  
   @fields = []
   if request.post?
     Profile.delete_all     
     params["profile"].each do |key, value|
       if (!key["position"].nil?)
         profile = Profile.new
         profile.meaning = key[/\d+/]
         profile.value = value
         profile.save
       end
       if (!key["custom_field_anchor"].nil?)
         profile = Profile.new
         profile.meaning = value
         profile.value = "anchor"
         profile.save
       end
       if (!key["custom_field_alt_name"].nil?)
         profile = Profile.new
         profile.meaning = value
         profile.value = "alt_name"
         profile.save
       end
     end
   flash[:notice] = l(:profile_settings_saved)
   redirect_to :action => "configure"  
   else
   end
   @profiles = Profile.all    
   @anchor_default = ""
   @alt_name_default = ""
   custom_fields = CustomField.all(:conditions => "type='UserCustomField' ")
   custom_fields.each do |field|
     default_value = "right"
     @profiles.each do |profile|
       if ( (profile.meaning == field.id) && (profile.value != "anchor") ) 
         default_value = profile.value
       end
       if (profile.value == "anchor")
         @anchor_default = profile.meaning
       end
       if (profile.value == "alt_name")
         @alt_name_default = profile.meaning
       end
     end
     @fields.push([field.id, field.name, default_value])
   end
  end
end
