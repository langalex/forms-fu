class TabularFormBuilder < ActionView::Helpers::FormBuilder 
  
  def select(field, select_options = nil, options = {})
    select_options ||= []
    super field, select_options, options
  end
  
  ['text_field', 'text_area', 'password_field', 'date_select', 'check_box', 'file_field'].each do |selector| 
    src = <<-END_SRC 
      def #{selector}_with_label(field, options = {}) 
        options.reverse_merge!(:class => 'string') if '#{selector}' == 'text_field'
        
        @template.content_tag("tr", 
        @template.content_tag("th", label_fu(field)) + 
        @template.content_tag("td", #{selector}_without_label(field, options)))
      end 
      
      alias_method_chain :#{selector}, :label
      
    END_SRC
    class_eval src, __FILE__, __LINE__ 
  end 
  
  alias_method :super_select, :select
  
  def select_with_label(field, select_options = nil, options = {})
    @template.content_tag("tr", 
    @template.content_tag("th", label_fu(field)) + 
    @template.content_tag("td", select_without_label(field, select_options, options)))
  end
  
  def select_without_label(field, select_options = nil, options = {})
    select_options ||= select_options_from_enum(field) || []
    super_select field, select_options, options
  end
  
  def select(field, select_options = nil, options = {})
    select_with_label field, select_options, options
  end
  
  def text_fields(*fields)
    fields.inject('') do |res, field|
      res << text_field(field)
    end
  end
  
  private
  
  def select_options_from_enum(field)
    if object.class.respond_to?(:field_type) && object.class.field_type(field).respond_to?(:values)
      object.class.field_type(field).values
    end
  end
end