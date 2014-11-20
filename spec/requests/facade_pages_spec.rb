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

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:issue, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:issue, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end
end