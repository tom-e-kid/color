require 'spec_helper'

describe Task do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@task = user.tasks.build(content: "Lorem ipsum")
	end

  subject{ @task }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { expect(@task.user).to eq user }

  it { should be_valid }

  describe "when user_id is nil" do
    before { @task.user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is blank" do
    before { @task.content = " " }
    it { should_not be_valid }
  end
end