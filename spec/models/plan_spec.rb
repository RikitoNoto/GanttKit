require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe "#create" do
      context "作成可能" do
          it "すべての値が入っているときに作成成功" do
              plan = build(:plan)
              expect(plan).to be_valid
          end
      end

      context "空による失敗" do
          it "start_dateが空" do
              plan = build(:plan, start_date: nil)
              plan.valid?
              expect(plan.errors[:start_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "start_timeが空" do
              plan = build(:plan, start_time: nil)
              plan.valid?
              expect(plan.errors[:start_time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "timeが空" do
              plan = build(:plan, time: nil)
              plan.valid?
              expect(plan.errors[:time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "quantityが空" do
              plan = build(:plan, quantity: nil)
              plan.valid?
              expect(plan.errors[:quantity]).to include(I18n.t('errors.messages.blank'))
          end
      end

      context "その他バリデーション" do
        context "時間関係" do
          let(:task) {create(:task)}
          let(:task_hour) {100000}#とりあえず100000時間加算するようにしてる(11年くらいだから大丈夫って考え)。必要あれば直す。
          it "start_dateがtaskの開始より前" do
              plan = build(:plan, task: task, start_date: task.start_date - 1.days)
              plan.valid?
              expect(plan.errors[:start_date]).to include("must be within parent's")
          end

          it "start_timeがtaskの開始より前" do
              plan = build(:plan, task: task, start_date: task.start_date, start_time: task.start_time - 1.hours)
              plan.valid?
              expect(plan.errors[:start_time]).to include("must be within parent's")
          end
          
          it "end_dateがtaskの終了より後" do
            plan = build(:plan, task: task, time: task_hour)
            plan.valid?
            expect(plan.errors[:end_date]).to include("must be within parent's")
          end

          it "end_timeがtaskの終了より前" do
              plan = build(:plan, task: task, time: task_hour)
              plan.valid?
              expect(plan.errors[:end_time]).to include("must be within parent's")
          end
        end
      end

      context "メソッド" do
          it "start_timeのゲッターがstart_dateカラムの日付になっている" do
              plan = build(:plan, start_time: Time.now)
              expect(plan.start_time.to_date).to eq(plan.start_date)
          end

          it "end_timeのゲッターがend_dateカラムの日付になっている" do
              plan = build(:plan)
              expect(plan.end_time.to_date).to eq(plan.end_date)
          end
      end
  end
end
