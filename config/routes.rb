Rails.application.routes.draw do

  root 'solutions#index'

  scope "api" do
    get '/solve' => 'solutions#solve'
  end

  # if user tries to hit any other route retroute to root
  get '*path' => redirect('/')
end
