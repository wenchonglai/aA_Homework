require "rails_helper"

feature "the sign up process" do
  scenario "has a sign up page" do
    visit new_user_url
    expect(page).to have_content("sign up".to_russian)
  end

  feature "sign up a user" do
    before (:each) do 
      visit new_user_url
      fill_in "user[email]", with: "test1@testing.com"
      fill_in "user[password]", with: "testingtesting"
      click_on "submit".to_russian
    end

    scenario "redirects to root after signup" do
      expect(page).to have_content("all bands".to_russian)
      expect(current_path).to eq "/"
    end
  end

  feature "does not sign up if user email is invalid" do
    before (:each) do 
      visit new_user_url
      fill_in "user[email]", with: "test"
      fill_in "user[password]", with: "testingtesting"
      click_on "submit".to_russian
    end

    scenario "rerenders the log in page with erros" do
      expect(page).to have_content("log in".to_russian)
      expect(current_path).to eq "/users"
      expect(page).to have_content("email must comply with the correct format".to_russian)
    end
  end

  feature "does not sign up if user email is taken" do
    before (:each) do 
      visit new_user_url
      fill_in "user[email]", with: "1@2.com"
      fill_in "user[password]", with: "testingtesting"
      click_on "submit".to_russian
    end

    scenario "rerenders the log in page with erros" do
      expect(page).to have_content("log in".to_russian)
      expect(current_path).to eq "/users"
      expect(page).to have_content("Email has already been taken".to_russian)
    end
  end

  feature "does not sign up if user password is too short" do
    before (:each) do 
      visit new_user_url
      fill_in "user[email]", with: "1@2345.com"
      fill_in "user[password]", with: "1234"
      click_on "submit".to_russian
    end

    scenario "rerenders the log in page with erros" do
      expect(page).to have_content("log in".to_russian)
      expect(current_path).to eq "/users"
      expect(page).to have_content("Password is too short (minimum is 6 characters)".to_russian)
    end
  end
end