require 'sinatra'
require 'sinatra/reloader'
require './models/item.rb'
require './models/category.rb'
require './controllers/item_controller.rb'
require './controllers/category_controller.rb'
require './db/mysql_connector'
require 'dotenv'

Dotenv.load

get '/' do
    items = Item.get_all_items
    erb :index, locals: {
        items: items
    }
end

get '/commit' do
    MySQLDB.commit
end

get '/items' do
    ItemController.items(params)
end

get "/items/new" do
    ItemController.create_form
end

post '/items' do
    redirect('/') if ItemController.create_item(params)
    p "FK U BITCH"
end


get '/items/:id' do
    id = params["id"].to_i
    item = Item.get_item_by_id(id)
    if !item 
        return status 404
    else
        erb :show, locals: {
            item: item
        }
    end
end


get '/items/:id/edit' do
    id = params["id"].to_i
    item = Item.get_item_by_id(id)
    if !item 
        return status 404
    else
        categories = Category.all
        erb :edit, locals: {
            item: item,
            categories: categories
        }
    end
end

post '/items/:id/update' do
    redirect("/items/#{params[:id]}") if ItemController.update(params)
end

#DELETE DAN SHOW

post '/items/:id/delete' do
    id = params["id"].to_i
    Item.new(id, "", "").delete
    redirect('/')
end 

get '/categories' do
    CategoryController.all_categories
end

post '/categories' do
    redirect('/categories') if CategoryController.create_category(params)
end

get '/categories/create' do
    CategoryController.create_form
end

get '/categories/:id/edit' do
    CategoryController.edit_form(params)
end

post '/categories/:id/update' do
    redirect('/categories') if CategoryController.update(params)
    redirect("/categories/#{params["id"].to_i}/edit")
end

post '/categories/:id/delete' do
    redirect('/categories') if CategoryController.delete(params)
end



not_found do
    erb :not_found
end