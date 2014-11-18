require 'spec_helper'

describe User do
	
  before do
    @user = User.new(name: "testname", email: "test@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }

  it { should be_valid }

  it { should respond_to(:authenticate) }  
  it { should_not be_admin }

  context "admin" do
    before do
      @user.save!
      @user.toggle(:admin)
    end
  it { should be_admin }
  end

  context "name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  context "name is too long (max:16)" do
  	before { @user.name = "a" * 17 }
  	it { should_not be_valid }
  end

  context "name is too short (min:3)" do
  	before { @user.name = "aa" }
  	it { should_not be_valid }
  end

  context "name format is invalid" do
  	it "should not be valid" do
  		names = %w[tom-e-kid  @tom_e_kid $tomekid]
  		names.each do |invalid|
  			@user.name = invalid
  			expect(@user).not_to be_valid
  		end
  	end
  end

  context "name format is valid" do
  	it "should not be valid" do
  		names = %w[ttom_e_kid tom.e.kid tom_e_kid123]
  		names.each do |valid|
  			@user.name = valid
  			expect(@user).to be_valid
  		end
  	end
  end

  context "email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  context "email format is invalid" do
  	it "should not be valid" do
  		addresses = %w[aaa@bbb,com aaa_bbb_at_ccc.org aaa@bbb. aaa@bbb_ccc.com aaa@bbb+ccc.com]
  		addresses.each do |invalid|
  			@user.email = invalid
  			expect(@user).not_to be_valid
  		end
  	end
  end

  context "email format is valid" do
  	it "should be valid" do
  		addresses = %w[aaa@bbb.COM A_BBB@c.d.org aaa.bbb@ccc.jp a+b@ccc.cn]
  		addresses.each do |valid|
  			@user.email = valid
  			expect(@user).to be_valid
  		end
  	end
  end

  context "email is already taken" do
  	before do
  		dup_user = @user.dup
  		dup_user.email = @user.email.upcase
  		dup_user.save
  	end
  	it { should_not be_valid }
  end

  context "email with mixed case" do
    let(:mixed_email) { "Test@ExAMpL.CoM" }
    it "saved with lower-case" do
      @user.email = mixed_email
      @user.save
      expect(@user.reload.email).to eq mixed_email.downcase
    end
  end

  context "password is not present" do
    before do
      @user = User.new(name: "testname", email: "test@example.com", password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }    
  end

  context "password is mismatch" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context "authenticate" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "invalid password" do
      let(:invalid_user) { found_user.authenticate('invalid') }
      it { should_not eq invalid_user }
      specify { expect(invalid_user).to be_falsey }
    end
  end

  context "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end
end