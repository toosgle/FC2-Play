class SearchHis < ActiveRecord::Base
  def self.create_record(keyword, favs, duration, user_id)
    history = SearchHis.new(keyword: keyword,
                            favs: favs,
                            duration: duration,
                            user_id: user_id)
    history.save
  end

  # ユーザ登録した時に、tmp_idでの履歴情報を新しいUserIdの番号に書き換える
  def self.rename_user_history(tmp_user_id, id)
    SearchHis.where(user_id: tmp_user_id).update_all(user_id: id)
  end
end
