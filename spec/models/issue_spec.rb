require 'spec_helper'

describe Issue do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@issue = user.issues.build(content: "Lorem ipsum")
	end

  subject{ @issue }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { expect(@issue.user).to eq user }

  it { should be_valid }

  describe "when user_id is nil" do
    before { @issue.user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is blank" do
    before { @issue.content = " " }
    it { should_not be_valid }
  end
end