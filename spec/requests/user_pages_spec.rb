require 'spec_helper'

describe "user pages" do
	
  subject { page }

  describe "index page" do
    let(:user) { FactoryGirl.create(:user) }
  	before(:each) do
  		sign_in user
      visit users_path
  	end

    it { should have_title("All users") }
    it { should have_content("All users") }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "destroy action" do
      it { should_not have_link('delete') }

      describe "as admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
    let!(:task1) { FactoryGirl.create(:task, user: user, content: "Foo") }
    let!(:task2) { FactoryGirl.create(:task, user: user, content: "Bar") }

  	before { visit user_path(user) }

    it { should have_title(page_title(user.name)) }
    it { should have_content(user.name) }

    describe "tasks" do
      it { should have_content(task1.content) }
      it { should have_content(task2.content) }
      it { should have_content(user.tasks.count) }
    end
  end

  describe "signup page" do
    let(:submit) { "Create my account" }
    before { visit signup_path }
    
    it { should have_title(page_title("Sign up")) }
    it { should have_content('Sign up') }

    context "with invalid info" do
      it "should not create user" do
        expect do
          click_button submit
        end.not_to change(User, :count)
      end
    end

    describe "after submission" do
      before { click_button submit }
      it { should have_title('Sign up') }
      it { should have_content('error') }
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Save changes" }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    context "page" do
      it { should have_title("Edit user") }
      it { should have_content("Update your profile") }
    end

  	context "with invalid info" do
  	  before { click_button submit }
  	  it { should have_content('error') }
  	end

  	context "with valid info" do
  		let(:new_name) { "new_name" }
  		let(:new_email) { "new_name@example.com" }
  		before do
  			fill_in "Username", 	with: new_name
  			fill_in "Email",		with: new_email
  			fill_in "Password",		with: user.password
  			fill_in "Confirmation",	with: user.password
  			click_button submit
  		end

  		it { should have_title(new_name) }
  		it { should have_selector('div.alert.alert-success') }
  	 	it { should have_link('Sign out', href: signout_path) }

  	 	specify { expect(user.reload.name).to eq new_name }
  	 	specify { expect(user.reload.email).to eq new_email }
  	end

    context "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password, password_confirmation: user.password} }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }
    end
  end
end
