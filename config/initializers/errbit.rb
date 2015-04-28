Airbrake.configure do |config|
  config.api_key = '3d7a9f745df5220f22c8b98c572e578f'
  config.host    = 'showwin-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
