class AdminController < ApplicationController
  # You can login admin page !!!
  http_basic_authenticate_with name:  'admin', password: 'fc2play'

  def index
    @reports = Record.create_reports
    @weeks = @reports[:weeks]

    @playweek = History.weekly_report
    @survey_result = Survey.report
    @bugreports = BugReport.all
  end
end
