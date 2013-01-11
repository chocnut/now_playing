require 'rubygems'
require 'sinatra'
require 'sinatra/config_file'
require 'koala'
require 'lib/track'

class ItunesToFb < Sinatra::Application
  register Sinatra::ConfigFile

  config_file '../config.yml'
  
  enable :sessions
  set :session_secret, settings.session_key  

  get '/' do
    if session['access_token']
      session['oauth'] = Koala::Facebook::API.new(session["access_token"])
      'You are logged in! <a href="/share">Share Current Track </a> &nbsp;|&nbsp; <a href="/logout">Logout</a>'
    else
      '<a href="/login">Login</a>'
    end
  end

  get '/login' do
    session['oauth'] = Koala::Facebook::OAuth.new(settings.app_id, settings.secret, settings.url + 'callback')
    redirect session['oauth'].url_for_oauth_code(:permissions => "publish_stream")
  end

  get '/logout' do
    session['oauth'] = nil
    session['access_token'] = nil
    redirect '/'
  end

  get '/callback' do
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    redirect '/'
  end

  get '/share' do
    session['oauth'].put_wall_post(Track.current_track)
    redirect '/'
  end
end