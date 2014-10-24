class User < ActiveRecord::Base
  has_many :favs
  has_many :histories
  has_secure_password
  validates_presence_of :name
  validates_uniqueness_of :name

  def unique?
    !User.find_by_name(self.name)
  end

  def fav_list
    Fav.list(self.id)
  end

  def history_list
    History.list(self.id)
  end

end
