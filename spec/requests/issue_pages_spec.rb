require 'spec_helper'

describe "issue pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "issue creation" do
    before { visit root_path }

    describe "with invalid info" do
      it "should not create issue" do
        expect { click_button "Post" }.not_to change(Issue, :count)
      end

      describe "error message" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid info" do
      before { fill_in 'issue_content', with: "Lorem ipsum" }
      it "should not create issue" do
        expect { click_button "Post" }.to change(Issue, :count).by(1)
      end      
    end
  end

  describe "issue destruction" do
    before { FactoryGirl.create(:issue, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete an issue" do
        expect { click_link "delete" }.to change(Issue, :count).by(-1)
      end
    end
  end
end