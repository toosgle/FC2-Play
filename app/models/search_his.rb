class SearchHis < ActiveRecord::Base
  class << self
    # ユーザ登録した時に、tmp_idでの履歴情報を新しいUserIdの番号に書き換える
    def rename_user_history(tmp_user_id, id)
      SearchHis.where(user_id: tmp_user_id).update_all(user_id: id)
    end
  end
end
