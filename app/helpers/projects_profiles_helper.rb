module ProjectsProfilesHelper
def alt_name(select_project)
  s = ''
  result_arr = select_project.custom_values.select{|element| element.custom_field_id==@alt_name}
  if (result_arr.size>0)
    s << '(' + result_arr.join(" ") + ')'
  end
  s
  end
end
