module DataHelper
  def create_base_data
    create(:user)
    10.times do |i|
      create(:video, id: i)
      create(:new_arrival, video_id: i)
    end
    50.times do |i|
      create(:video, id: i + 100)
      create(:weekly_rank, video_id: i + 100)
      create(:video, id: i + 150)
      create(:monthly_rank, video_id: i + 150)
    end
  end
end
