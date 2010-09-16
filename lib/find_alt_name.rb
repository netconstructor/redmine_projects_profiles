module AltArray
  def find_alt(key)
    return_value = ""
    self.each do |element|
       return_value = element.value if (element.custom_field_id==key)
    end
  end 
end

