require 'spec_helper'

describe "facade pages" do
	
  subject { page }

  describe "home" do
	before { visit root_path }

	it { should have_title(page_title("")) }
	it { should_not have_title('| Home') }
	it { should have_content('Color') }
	it { should have_link('Sign up') }
	it { should have_link('Sign in') }
  end
end