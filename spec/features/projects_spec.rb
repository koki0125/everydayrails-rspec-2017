require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      click_link "New Project"
      fill_in "Name", with: "the project"
      fill_in "Description", with: "trying out capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "the project"  
      expect(page).to have_content "Owner: #{user.name}"  
    }.to change(user.projects, :count).by(1)
  end

end
