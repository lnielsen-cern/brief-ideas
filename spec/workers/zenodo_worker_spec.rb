require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

# TODO write some more assertions here.
describe ZenodoWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
    Idea.destroy_all
  end

  it "should assign a DOI to the idea once processed." do
    idea = build(:idea)
    idea.save

    ZenodoWorker.new.perform(idea.sha)
    assert !idea.doi.blank?
  end

  it "should create the correct number of jobs" do
    idea = build(:idea)
    idea.save

    expect {
      ZenodoWorker.perform_async(idea.sha)
    }.to change(ZenodoWorker.jobs, :size).by(1)
  end

  it "should call RestClient three times and Swiftype::Client once" do
    idea = build(:idea)
    idea.save

    RestClient.expects(:post).times(3)
    Swiftype::Client.expects(:create_document).once
  end
end
