class SearchHis < ActiveRecord::Base
  def self.create_record(keyword, favs, duration, user_id)
    history = SearchHis.new(keyword: keyword,
                            favs: favs,
                            duration: duration,
                            user_id: user_id)
    history.save
  end
end
