# Namespace for helpers of the ApplicationController.
module ApplicationHelper
  # Sets the title for a page.
  #
  # @param [String] page_title the title of the page.
  # @return [String] the title of the page.
  def title(page_title)
    content_for(:title) { page_title }
    page_title
  end
end
