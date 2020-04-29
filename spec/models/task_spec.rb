require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "#create" do
      context "作成可能" do
          it "すべての値が入っているときに作成成功" do
              task = build(:task)
              expect(task).to be_valid
          end

          it "unit以外の値が入っているときに作成成功" do
              task = build(:task, unit: nil)
              expect(task).to be_valid
          end
      end

      context "空による失敗" do
          it "nameが空" do
              task = build(:task, name: nil)
              task.valid?
              expect(task.errors[:name]).to include(I18n.t('errors.messages.blank'))
          end

          it "start_dateが空" do
              task = build(:task, start_date: nil)
              task.valid?
              expect(task.errors[:start_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "start_timeが空" do
              task = build(:task, start_time: nil)
              task.valid?
              expect(task.errors[:start_time]).to include(I18n.t('errors.messages.blank'))
          end

          it "end_dateが空" do
              task = build(:task, end_date: nil)
              task.valid?
              expect(task.errors[:end_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "end_timeが空" do
              task = build(:task, end_time: nil)
              task.valid?
              expect(task.errors[:end_time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "timeが空" do
              task = build(:task, time: nil)
              task.valid?
              expect(task.errors[:time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "quantityが空" do
              task = build(:task, quantity: nil)
              task.valid?
              expect(task.errors[:quantity]).to include(I18n.t('errors.messages.blank'))
          end
      end

      context "その他バリデーション" do
        context "時間関係" do
          let(:work) {create(:work)}
          it "start_dateがworkの開始より前" do
              task = build(:task, work: work, start_date: work.start_date - 1.days)
              task.valid?
              expect(task.errors[:start_date]).to include("must be within parent's")
          end

          it "start_timeがworkの開始より前" do
              task = build(:task, work: work, start_date: work.start_date, start_time: work.start_time - 1.hours)
              task.valid?
              expect(task.errors[:start_time]).to include("must be within parent's")
          end
          
          it "end_dateがworkの終了より後" do
            task = build(:task, work: work, end_date: work.end_date + 1.days)
            task.valid?
            expect(task.errors[:end_date]).to include("must be within parent's")
          end

          it "end_timeがworkの終了より前" do
              task = build(:task, work: work, end_date: work.end_date, end_time: work.end_time + 1.hours)
              task.valid?
              expect(task.errors[:end_time]).to include("must be within parent's")
          end
        end
      end

      context "メソッド" do
          it "start_timeのゲッターがstart_dateカラムの日付になっている" do
              task = build(:task, start_time: Time.now)
              expect(task.start_time.to_date).to eq(task.start_date)
          end

          it "end_timeのゲッターがend_dateカラムの日付になっている" do
              task = build(:task, end_time: Time.now)
              expect(task.end_time.to_date).to eq(task.end_date)
          end
      end
  end
end
