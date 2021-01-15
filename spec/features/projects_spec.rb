require "rails_helper"

RSpec.feature "Projects", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, name: "a project", owner: @user)
    @completed_project = FactoryBot.create(:project, :completed, name: "a completed project", owner: @user)
  end

  scenario "user creates a new project" do
    # using our customer login helper:
    # sign_in_as user
    # or the one provided by Devise:
    sign_in @user

    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      aggregate_failures do
        expect(page).to have_content "Project was successfully created"
        expect(page).to have_content "Test Project"
        expect(page).to have_content "Owner: #{@user.name}"
      end
    }.to change(@user.projects, :count).by(1)
  end

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    # ユーザーはログインしている
    login_as @user, scope: :user
    # ユーザーがプロジェクト画面を開き、
    visit project_path(@project)

    expect(page).to_not have_content "Completed"
    # "complete" ボタンをクリックすると、
    click_button "Complete"
    # プロジェクトは完了済みとしてマークされる
    expect(@project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end

  # 完了したプロジェクトは表示されない
  scenario "doesn't show completed projects" do
    login_as @user, scope: :user
    visit root_path
    aggregate_failures do
      expect(page).to have_content @user.name
      expect(page).to have_content @project.name
      expect(page).to_not have_content @completed_project.name
    end
  end

  # root_pageの完了したのプロジェクトにページ遷移したら完了プロジェクトのみの一覧が表示されている
  # 詳細ページもクリックしたら見れる
  scenario "index and show completed projects" do

    # login
    sign_in @user
    # go to root_path
    visit root_path
    # push the button 'completed projects'
    expect(page).to have_content @user.name
    expect(page).to have_content(@project.name)
    click_link "Completed projects"
    # get to the new page
    # index completed project names
    expect(page).to have_content(@completed_project.name)
    expect(page).to_not have_content(@project.name)

    # click the project.name
    click_link @completed_project.name
    # show project detail
    expect(page).to have_content(@completed_project.name)
    expect(page).to_not have_content(@project.name)
    expect(page).to have_content("Completed")
    expect(page).to have_content("Tasks")
    expect(page).to have_content("Notes")
  end
end
