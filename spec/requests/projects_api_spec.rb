require 'rails_helper'

RSpec.describe "ProjectsApis", type: :request do

  # 1件のプロジェクトを読み出すこと 
  it "loads a project" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project,
      name: "Sample Project"
    )
    FactoryBot.create(:project,
      name: "Second Sample Project",
      owner: user
    )
    
    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    project_id = json[0]["id"]


    get api_project_path(project_id), params: { 
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "Second Sample Project"
  end

  # プロジェクトを作成できること 
  it 'creates a project' do
    user = FactoryBot.create(:user)
    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end

  # プロジェクトを編集することができること
  it "uopdates a project" do
    user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: user)
    project_params = FactoryBot.attributes_for(:project, name: "sainara")
    expect(@project.id).to eq @project.id
    expect {
      put api_project_path(@project.id), params: {
        user_email: user.email,
        user_token: user.authentication_token,
        id: @project.id,
        project: project_params
      }
    }.to_not change(user.projects, :count)
    expect(@project.id).to eq @project.id
    expect(Project.find(@project.id).name).to eq "sainara"
  end
end
