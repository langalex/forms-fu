module FormsFuHelper
    def label_fu(model, field_name)
      "<label for=\"#{model.class.to_s.dasherize}_#{field_name}\">#{field_name.to_s.humanize} #{'*' if model.class.required_field?(field_name)}</label>"
    end
end

ActionView::Helpers::FormBuilder.class_eval do
  include FormsFuHelper
  
  def label_fu_with_form_builder(field_name)
    label_fu_without_form_builder object, field_name
  end
  
  alias_method_chain :label_fu, :form_builder
end

