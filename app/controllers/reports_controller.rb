class ReportsController < ApplicationController
  def parse

  end

  def do_parse
    if params[:message].present?
      Report.choose_report_text params[:message][:text]
    end
    redirect_to root_path
  end
end
