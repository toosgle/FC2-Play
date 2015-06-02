class BugReportsController < ApplicationController
  after_filter :flash_clear

  def create
    report = BugReport.new(content: params[:content])
    if report.save
      toast :success, 'ご報告ありがとうございます　あなたのおかげでFC*FC Playがまた一歩前進しました'
    else
      toast :error, '報告に失敗しました。もう一度試してみてください。'
    end
  end
end
