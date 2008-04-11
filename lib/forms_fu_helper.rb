module FormsFuHelper
    def label_fu(model, field_name)
      "<label for=\"#{model.class.to_s.dasherize}_#{field_name}\">#{field_name.to_s.humanize} #{'*' if model.class.required_field?(field_name)}</label>"
    end
  
end