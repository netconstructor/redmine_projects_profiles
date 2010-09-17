module ProjectsProfilesHelper
def alt_name(select_project)
  s = ''
  result_arr = select_project.custom_values.select{|element| element.custom_field_id==@alt_name}
  if (result_arr.size>0)
    s << '(' + result_arr.join(" ") + ')'
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
