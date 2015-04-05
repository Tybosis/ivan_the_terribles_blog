# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

begin
  IvanTheTerriblesBlog::Application.configure do
    config.secret_token = File.read(Rails.root.join('secret_token.rb'))
  end
rescue LoadError, Errno::ENOENT => e
  raise "Secret token couldn't be loaded! Error: #{e}"
end
