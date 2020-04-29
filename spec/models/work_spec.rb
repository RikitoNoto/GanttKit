require 'rails_helper'

RSpec.describe Work, type: :model do
  describe "#create" do
      context "作成可能" do
          it "すべての値が入っているときに作成成功" do
              work = build(:work)
              expect(work).to be_valid
          end
      end

      context "空による失敗" do
          it "nameが空" do
              work = build(:work, name: nil)
              work.valid?
              expect(work.errors[:name]).to include(I18n.t('errors.messages.blank'))
          end

          it "start_dateが空" do
              work = build(:work, start_date: nil)
              work.valid?
              expect(work.errors[:start_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "start_timeが空" do
              work = build(:work, start_time: nil)
              work.valid?
              expect(work.errors[:start_time]).to include(I18n.t('errors.messages.blank'))
          end

          it "end_dateが空" do
              work = build(:work, end_date: nil)
              work.valid?
              expect(work.errors[:end_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "end_timeが空" do
              work = build(:work, end_time: nil)
              work.valid?
              expect(work.errors[:end_time]).to include(I18n.t('errors.messages.blank'))
          end
      end

      context "その他バリデーション" do
      end

      context "メソッド" do
          it "start_timeのゲッターがstart_dateカラムの日付になっている" do
              work = build(:work, start_time: Time.now)
              expect(work.start_time.to_date).to eq(work.start_date)
          end

          it "end_timeのゲッターがend_dateカラムの日付になっている" do
              work = build(:work, end_time: Time.now)
              expect(work.end_time.to_date).to eq(work.end_date)
          end
      end
  end
end
