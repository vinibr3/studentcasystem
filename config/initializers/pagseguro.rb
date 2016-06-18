PagSeguro.configure do |config|
  config.token = ENV['PAGSEGURO_TOKEN']
  config.email = ENV['PAGSEGURO_EMAIL']
  config.environment = ENV['PAGSEGURO_ENVIRONMENT'] 
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end