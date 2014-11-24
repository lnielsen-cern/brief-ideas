require 'rails_helper'

describe IdeasController, :type => :controller do
  describe "GET #new" do
    it "NOT LOGGED IN responds with a redirect" do
      get :new, :format => :html
      expect(response).to be_redirect
    end
  end

  describe "GET #new" do
    it "LOGGED IN responds with a redirect" do
      user = create(:user)
      allow(controller).to receive_message_chain(:current_user).and_return(user)

      get :new, :format => :html
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "NOT LOGGED IN responds with success" do
      idea = create(:idea)
      get :show, :id => idea.to_param, :format => :html
      expect(response).to be_success
    end
  end

  describe "GET #preview" do
    it "should return content that's been through the HTML pipeline" do
      idea_params = "# Aloha!"
      get :preview, :idea => idea_params
      expect(response.body).to eq("<h1>Aloha!</h1>")
    end
  end

  describe "POST #create" do
    it "NOT LOGGED IN responds with redirect" do
      idea_params = {:title => "Yeah whateva", :body => "something", :subject => "The > Good > Stuff", :tags => "Hello, my, name, is"}
      post :create, :idea => idea_params
      expect(response).to be_redirect
    end
  end

  describe "POST #create" do
    it "LOGGED IN responds with success" do
      user = create(:user)
      allow(controller).to receive_message_chain(:current_user).and_return(user)
      idea_count = Idea.count

      idea_params = {:title => "Yeah whateva", :body => "something", :subject => "The > Good > Stuff", :tags => "Hello, my, name, is"}
      post :create, :idea => idea_params
      expect(response).to be_redirect # as it's created the thing
      expect(Idea.count).to eq(idea_count + 1)
    end
  end
end
