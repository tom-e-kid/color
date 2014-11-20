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

  describe "with valid info" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    it { should have_title(user.name) }
    it { should have_link('Users',        href: users_path) }
    it { should have_link('Profile',      href: user_path(user)) }
    it { should have_link('Edit profile', href: edit_user_path(user)) }
    it { should have_link('Sign out',     href: signout_path) }
    it { should_not have_link('Sign in',  href: signin_path) }
  end

  describe "authorization" do

    context "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      context "protected page" do
        before do
          visit edit_user_path(user)

          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after sign in" do
          it "should render the desired protected page" do
            expect(page).to have_title("Edit user")
          end
        end
      end

      context "in users controller" do
        context "method: index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        context "method: edit" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        context "method: update" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      context "in issues controller" do
        describe "method: create" do
          before { post issues_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "method: destroy" do
          before { delete issue_path(FactoryGirl.create(:issue)) }
          specify { expect(response).to redirect_to(signin_path) }          
        end
      end
    end

    context "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      context "edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(page_title("Edit user")) }
        specify { expect(response).to redirect_to(root_path) }
      end

      context "update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    context "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "delete action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end