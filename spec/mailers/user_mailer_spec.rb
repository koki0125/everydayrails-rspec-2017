require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, email: "rspec@example.com") }
  let(:mail) { UserMailer.welcome_email(user) }
    
  describe "welcome_email" do
    
    # ウェルカムメールをユーザーのメールアドレスに送信すること
    it "sends a welcome email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    # サポート用のメールアドレスから送信すること
    it "sends from the support email address" do
      expect(mail.from).to eq ["support@example.com"]
    end

    # 正しい件名で送信すること
    it "sends with the correct subject" do
      expect(mail.subject).to eq "Welcome to Projects!"
    end
    # ユーザーにはファーストネームであいさつすること
    it "greets the user by first name" do
      expect(mail.body).to match(/Hello #{user.first_name},/)
    end

    # 登録したユーザーのメールアドレスを残しておくこと
    it "reminds the user of the registered email address" do
      expect(mail.body).to match user.email
    end
  end

  describe "パスワードリセット" do
    before do
      user
    end

    context "メアドのフォーマットがあっていないとき" do
      it "メールフォーマットのバリデーションエラー" do
        post 
      end
    end
      
    context "メアドのフォーマットがあっているとき" do
      it "入力されたメアドが登録されていないときバリデーションエラー" do
        
      end

      it "入力されたメアドが登録されているとき正常にメール送られる" do
        
      end
    end
  end
  
end
