require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  
  describe "Create POST user_password_path" do
    let(:user) { FactoryBot.create(:user, email: "rspec@example.com") }


    before do
      sign_in user
      # @raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
      # self.reset_password_token = enc
      # self.reset_password_sent_at = Time.now.utc
      # save(validate: false)
    end

    context "paramsが足りないとき" do

      it "バリデーションエラーを出す" do
        params = { user: {  
          password_confirmation: "password", 
          password: "password",
          reset_password_token: @raw
        } 
        }
        patch user_password_path, params: params
        expect(response.body).to include("Current password can't be blank")
      end
      
    end
    
    context "正しいパラメーターがあるとき" do
      
    end

  end
end
