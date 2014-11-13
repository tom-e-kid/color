require 'spec_helper'

describe "user pages" do
	
	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_title(page_title("Sign up")) }
		it { should have_content('Sign up') }
	end
end
