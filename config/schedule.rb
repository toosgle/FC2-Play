#coding: utf-8
require 'open-uri'

#ログの出力
#log_path = Whenever.path + '/log/cron.log'
#error_log_path = Whenever.path + '/log/error.log'
#set :output, {:standard => log_path, :error => error_log_path}
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
set :environment, :production

#人気の更新
every 1.hours do
  runner "History.rank_update"
end

#admin用の集計
every 1.day, :at => '0:01 am' do
  runner "Record.create_yesterday_his"
end

#検索の更新
every 2.day, :at => '8:30 am' do
  runner "Video.daily_update"
end

#開発中のみ
#every 2.minutes do
#  runner "History.rank_update"
#end
