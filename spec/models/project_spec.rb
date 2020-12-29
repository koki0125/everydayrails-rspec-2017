require 'rails_helper'

RSpec.describe Project, type: :model do

  # validaition spec
  describe "validation" do
    before do
      @user = User.create(
        first_name: "Joe",
        last_name: "Tester",
        email: "a@example.com",
        password: "asdasd"
      )
    end

    context "when a name is present" do
      it "project is valid" do
        project = @user.projects.build(name: "my first spec")
        expect(project).to be_valid
      end
    end

    context "when a name is nil" do
      it "project is invalid" do
        project2 = @user.projects.new(name: nil)
        project2.valid?
        expect(project2.errors[:name]).to include("can't be blank")
      end
    end
    
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "a@example.com",
      password: "asdasd"
    )

    user.projects.create(
      name: "Test Project"
    )

    new_project = user.projects.build(
      name: "Test Project"
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "a@example.com",
      password: "asdasd"
    )
    user.projects.create( name: "Test Project", )

    other_user = User.create(
      first_name: "Jane",
      last_name: "Tester",
      email: "b@example.com",
      password: "asdasd",
    )
    other_project = other_user.projects.build( name: "Test Project",)
    expect(other_project).to be_valid
  end
end
