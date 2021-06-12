module ApplicationHelper
  def format_flash_errors(errors)
    return if errors.blank?

    if errors.is_a?(Array)
      "* #{errors.join("<br/>* ")}"
    else
      "* #{errors}"
    end
  end
end
