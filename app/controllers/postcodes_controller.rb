class PostcodesController < ApplicationController
  def index; end

  def show
    @postcode = PostcodeHelper.unhyphenate(params[:postcode])

    begin
      response = PostcodeHelper.lookup(@postcode)

      @constituency = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
    rescue PostcodeHelper::PostcodeError => error
      flash[:error] = error.message

      redirect_to(PostcodeHelper.previous_path)
    end
  end

  def lookup
    raw_postcode = params[:postcode]
    hyphenated_postcode = PostcodeHelper.hyphenate(raw_postcode)
    PostcodeHelper.previous_path = params[:previous_path]

    redirect_to postcode_path(hyphenated_postcode)
  end
end
