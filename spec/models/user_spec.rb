require 'spec_helper'

describe User do

  	before do
  		 @user = User.new(name: "Example User", email: "user@example.com",
         				password: "foobar", password_confirmation: "foobar") 
	
    end
    
  	subject { @user }

  	it { should respond_to(:name) }
  	it { should respond_to(:email) }
  	it { should respond_to(:password_digest) }

	it { should respond_to(:password) }
  	it { should respond_to(:password_confirmation) }
    
    it { should respond_to(:remember_token) }
  	it { should respond_to(:authenticate) }
    
    it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
    
    it { should respond_to(:feed) }
    
  	it { should respond_to(:relationships) }
    
    it { should respond_to(:followed_users) }
    it { should respond_to(:following?) }
  	it { should respond_to(:follow!) }

  	it { should be_valid }
    
    
    describe "when password is not present" do
        before do
          @user = User.new(name: "Example User", email: "user@example.com",
                           password: " ", password_confirmation: " ")
        end
        it { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
        before { @user.password_confirmation = "mismatch" }
        it { should_not be_valid }
    end
    
    
    describe "remember token" do
        before { @user.save }
        its(:remember_token) { should_not be_blank }
    end
    
    
    describe "micropost associations" do

        before { @user.save }
        let!(:older_micropost) do
          FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
        end
        let!(:newer_micropost) do
          FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
        end

        it "should have the right microposts in the right order" do
          expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
        end
        
        it "should destroy associated microposts" do
          microposts = @user.microposts.to_a
          @user.destroy
          expect(microposts).not_to be_empty
          microposts.each do |micropost|
            expect(Micropost.where(id: micropost.id)).to be_empty
          end
        end
        
    end
    
    describe "following" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          @user.save
          @user.follow!(other_user)
        end

        it { should be_following(other_user) }
        its(:followed_users) { should include(other_user) }
        
        describe "and unfollowing" do
          before { @user.unfollow!(other_user) }

          it { should_not be_following(other_user) }
          its(:followed_users) { should_not include(other_user) }
        end
        
      end

end
