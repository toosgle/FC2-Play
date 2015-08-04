ENV['RAILS_ENV'] || 'production'

app_path = '/var/www/fc2play'
app_shared_path = "#{app_path}/shared"

# 実態は symlink。
# SIGUSR2 を送った時にこの symlink に対して
# Unicorn のインスタンスが立ち上がる
working_directory "#{app_path}/current/"

worker_processes 4
preload_app true
timeout 300
listen '/tmp/unicorn.sock', backlog: 64
pid "#{app_shared_path}/tmp/pids/unicorn.pid"

stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

before_fork do |_server, _worker|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', ENV['RAILS_ROOT'])
end

before_fork do |server, _worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  old_pid = "#{server.config[:pid]}.oldbin"
  unless old_pid == server.pid
    begin
      # Process.kill :QUIT, File.read(old_pid).to_i
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      ignore_exception
    end
  end
end

def ignore_exception
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
