class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  def new
    @survey = Survey.new
    @user = User.new unless current_user
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      toast :success, '貴重なご意見ありがとうございました。　引き続きFC*FC Playでお楽しみください。'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:result)
  end
end
