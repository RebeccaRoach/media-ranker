module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :success 
      "alert-success"
    when :error
      "alert-warning"
    end
  end
end
