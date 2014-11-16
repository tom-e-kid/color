require 'spec_helper'

describe "user pages" do
	
  subject { page }

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

	it { should have_title(page_title(user.name)) }
	it { should have_content(user.name) }
  end

  describe "signup page" do
	before { visit signup_path }

	it { should have_title(page_title("Sign up")) }
	it { should have_content('Sign up') }

	let(:submit) { "Create my account" }

	context "with invalid info" do
	  it "should not create user" do
	  	expect do
	  		click_button submit
	  	end.not_to change(User, :count)
	  end

	  describe "after submission" do
	  	before { click_button submit }
	  	it { should have_title('Sign up') }
	  	it { should have_content('error') }
	  end
	end

	context "with valid info" do
	  before do
	  	fill_in "Username", 	with: "example_user"
	  	fill_in "Email",		with: "example_user@example.com"
	  	fill_in "Password",		with: "foobar"
	  	fill_in "Confirmation",	with: "foobar"
	  end
	  it "should create user" do
	  	expect do
	  		click_button submit
	  	end.to change(User, :count).by(1)
	  end

	  describe "after saving user" do
	  	before { click_button submit }
	  	let(:user) { User.find_by(email: "example_user@example.com") }
	  	it { should have_title(user.name) }
	  	it { should have_selector('div.alert.alert-success', text: 'Welcome') }
  	 	it { should have_link('Sign out', href: signout_path) }
	  end
	end
  end
end
