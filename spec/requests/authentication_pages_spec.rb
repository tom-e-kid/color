require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
  	let(:submit) { "Sign in" }
  	before { visit signin_path }
  	
  	it { should have_content('Sign in') }
  	it { should have_title('Sign in') }

  	context "with invalid info" do
  	  before { click_button submit }
  	  it { should have_title('Sign in') }
  	  it { should have_selector('div.alert.alert-danger', text: 'Invalid') }
  	end

  	context "with valid info" do
  	  let(:user) { FactoryGirl.create(:user) }
  	  before do
  	  	fill_in "Email", 	with: user.email.upcase
  	  	fill_in "Password", with: user.password
  	  	click_button submit
  	  end

  	  it { should have_title(user.name) }
  	  it { should have_link('Sign out', href: signout_path) }
  	  it { should_not have_link('Sign in', href: signin_path) }

  	  describe "sign out" do
  	  	before { click_link "Sign out" }
  	  	it { should have_link('Sign in', href: signin_path) }
  	  end
  	end
  end
end