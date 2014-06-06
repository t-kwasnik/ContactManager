require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"

require_relative 'models/contact'

PAGE_LIMIT = 2

get '/' do

  if !params[:where].nil?
    @contacts = Contact.where('first_name ILIKE ? or last_name ILIKE ?', params[:where],params[:where])
    @where = URI.encode(params[:where])
  else
    @contacts = Contact.all
    @where = ""
  end

  params[:page].nil? ? ( @page = 0 ) : ( @page = params[:page].to_i )
  offset = PAGE_LIMIT * @page

  @contacts = @contacts.limit(2).offset(offset)

  erb :index
end

get "/contacts/:id" do

  @contact = Contact.where('id = ?',params[:id]).take
  erb :show

end

post "/submit" do


  Contact.create({ "first_name" => params[:first], "last_name" => params[:last], "phone_number" => params[:number]})

  redirect "/"

end
