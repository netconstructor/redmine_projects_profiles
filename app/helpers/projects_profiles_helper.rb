module ProjectsProfilesHelper
def alt_name(project)
  s = ''
  result_arr = project.custom_values.select{|element| element.custom_field_id.to_s==@alt_name.to_s}
  result_string = result_arr.join(" ").strip
  if ( (result_arr.size>0) && (!result_string.blank?) )
    s << '(' + result_string + ')'
  end
  s
end

def users_with_roles(project)
  s = ''
  users_by_role = project.users_by_role
  if (users_by_role.any?)          
    users_by_role.keys.sort.each do |role|
      s << '<tr><td>'  + h(role) + ':' + users_by_role[role].sort.collect{|u| link_to_user u}.join(", ") + '</td></tr>'
    end
  end
   s
end
end
