require 'rails_helper'

describe User do
  let(:user){ User.create!(email: "abc@def.com", password: "123456") }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_length_of(:password).is_at_least(6) }

  describe "#is_password?" do
    context "password entered correctly" do
      it "should return true" do
        expect(user.is_password?("123456")).to be true
      end
    end

    context "password entered incorrectly" do
      it "should return false" do
        expect(user.is_password?("")).not_to be true
        expect(user.is_password?("654321")).not_to be true
        expect(user.is_password?("1234567")).not_to be true
      end
    end
  end

  describe "#reset_session_token!" do
    it "should ensure a user instance has a session token before action" do
      expect(user.session_token).not_to be_nil
    end

    it "should update the user's instance after the reset_session_token! method is called" do
      expect(user.session_token).not_to eq user.reset_session_token!
      expect(user.reset_session_token!).to be_a(String)
    end
  end

  describe "::find_with_password" do
    before {user.save!}
    context "correct email and password given" do
      it "should return the correct user instance" do
        expect(User.find_with_password({email: "abc@def.com", password: "123456"})).to eq(user)
      end
    end

    context "correct email and incorrect password given" do
      it "should return the correct user instance" do
        expect(User.find_with_password({email: "abc@def.com", password: "1234456"})).to be_falsey
      end
    end

    context "correct email and incorrect password given" do
      it "should return the correct user instance" do
        expect(User.find_with_password({email: "abcd@def.com", password: "123456"})).to be_falsey
      end
    end

    context "incorrect email and incorrect password given" do
      it "should return the correct user instance" do
        expect(User.find_with_password({email: "abc@defg.com", password: "12344567"})).to be_falsey
      end
    end
  end
end
