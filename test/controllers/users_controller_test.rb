require "test_helper"

describe UsersController do
  it "can get the login form" do
    get login_path

    must_respond_with :success
  end

  describe "logging in" do
    it "can log in a new user" do
      user = nil
      expect{
        login()
      }.must_differ "User.count", 1

      must_respond_with :redirect

      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.user_name).must_equal "Tina Hastings"

    end

    it "can log in an existing user" do
      user = User.create(user_name: "Cherie Pancake")

      expect{
        login(user.user_name)
      }.wont_change "User.count"

      expect(session[:user_id]).must_equal user.id
    end
  end

  describe "logging out" do
    it "can log out a logged in user" do
      login()
      expect(session[:user_id]).wont_be_nil

      post logout_path

      expect(session[:user_id]).must_be_nil
    end
  end

end
