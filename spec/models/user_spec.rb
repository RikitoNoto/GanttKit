require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#create" do
      context "作成可能" do
          it "すべての値が入っているときに作成成功" do
              user = build(:user)
              expect(user).to be_valid
          end
      end

      context "空による失敗" do
          it "nameが空" do
              user = build(:user, name: nil)
              user.valid?
              expect(user.errors[:name]).to include(I18n.t('errors.messages.blank'))
          end

          it "emailが空" do
              user = build(:user, email: nil)
              user.valid?
              expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
          end

          it "passwordが空" do
              user = build(:user, password: nil)
              user.valid?
              expect(user.errors[:password]).to include(I18n.t('errors.messages.blank'))
          end
      end

      context "その他バリデーション" do
          it "@のないemail" do
              user = build(:user, email: "email")
              user.valid?
              expect(user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
          end

          it "重複したemail" do
              create(:user, email: "a@a")
              user = build(:user, email: "a@a")
              user.valid?
              expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
          end

          it "文字数の少ないパスワード" do
              user = build(:user, password: "aaa", password_confirmation: "aaa")
              user.valid?
              expect(user.errors[:password]).to include(I18n.t('errors.messages.too_short', count: 6))
          end

          it "確認と異なるパスワード" do
              user = build(:user, password: "aaaaaaa", password_confirmation: "bbbbbbb")
              user.valid?
              expect(user.errors[:password_confirmation]).to include(I18n.t('errors.messages.confirmation', attribute: "Password"))
          end
      end
  end
end
