module ValidationReflection
  def self.included(base)
    base.class_eval do
      @@required_fields ||= {}
      @@required_fields[self.to_s] ||= []
      
      def self.required_fields
        @@required_fields[self.to_s]
      end
      
      base.extend ClassMethods
      
      public
      
      class <<self
        alias_method_chain :validates_presence_of, :reflection
        alias_method_chain :validates_acceptance_of, :reflection
        alias_method_chain :validates_inclusion_of, :reflection
      end
    end
  end
  
  module ClassMethods
    def validates_presence_of_with_reflection(*args)
      add_to_required_fields(*args)
      validates_presence_of_without_reflection(*args)
    end

    def validates_acceptance_of_with_reflection(*args)
      add_to_required_fields(*args)
      validates_acceptance_of_without_reflection(*args)
    end

    def validates_inclusion_of_with_reflection(*args)
      add_to_required_fields(*args)
      validates_inclusion_of_without_reflection(*args)
    end

    def add_to_required_fields(*args)
      options = args.last.is_a?(Hash) ? args.last : {}
      names = args.select{|a| a.is_a?(Symbol)}
      required_fields << names unless  options[:if] || (options[:on] && options[:on] != :create) || (options[:in] && options[:in].include?('')) || options[:allow_nil]
    end
    
    def required_field?(name)
      required_fields.flatten.include?(name.to_sym)
    end
    
    
  end
end

ActiveRecord::Base.class_eval do
  
  def self.inherited_with_validation_reflection(sub_class)
    sub_class.send(:include, ValidationReflection)
    inherited_without_validation_reflection(sub_class)
  end
  
  class <<self
    alias_method_chain :inherited, :validation_reflection
  end
end