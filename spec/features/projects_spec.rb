require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  
  scenario "user creates a new project" do
    sign_in user

    visit root_path

    expect {
      create_project
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "user updates a project" do
    sign_in user
    visit root_path
    create_project
    go_to_project "Edit"
    update_name_project

    aggregate_failures do
      expect(page).to have_content "Project was successfully updated"
      expect(page).to have_content "Test Project2"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  def create_project
    click_link "New Project"
    fill_in "Name", with: "Test Project"
    fill_in "Description", with: "Trying out Capybara"
    click_button "Create Project"
  end

  def go_to_project(name)
    # visit root_path
    click_link name
  end

  def update_name_project
    fill_in "Name", with: "Test Project2"
    click_button "Update Project"
  end
end
