require 'rails_helper'

RSpec.describe Progress, type: :model do
  describe "#create" do
      context "作成可能" do
          it "すべての値が入っているときに作成成功" do
              progress = build(:progress)
              expect(progress).to be_valid
          end
      end

      context "空による失敗" do
          it "start_dateが空" do
              progress = build(:progress, start_date: nil)
              progress.valid?
              expect(progress.errors[:start_date]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "start_timeが空" do
              progress = build(:progress, start_time: nil)
              progress.valid?
              expect(progress.errors[:start_time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "timeが空" do
              progress = build(:progress, time: nil)
              progress.valid?
              expect(progress.errors[:time]).to include(I18n.t('errors.messages.blank'))
          end
          
          it "quantityが空" do
              progress = build(:progress, quantity: nil)
              progress.valid?
              expect(progress.errors[:quantity]).to include(I18n.t('errors.messages.blank'))
          end
      end

      context "その他バリデーション" do
        context "時間関係" do
          let(:task) {create(:task)}
          let(:task_hour) {100000}#とりあえず100000時間加算するようにしてる(11年くらいだから大丈夫って考え)。必要あれば直す。
          it "start_dateがtaskの開始より前" do
              progress = build(:progress, task: task, start_date: task.start_date - 1.days)
              progress.valid?
              expect(progress.errors[:start_date]).to include("must be within parent's")
          end

          it "start_timeがtaskの開始より前" do
              progress = build(:progress, task: task, start_date: task.start_date, start_time: task.start_time - 1.hours)
              progress.valid?
              expect(progress.errors[:start_time]).to include("must be within parent's")
          end
          
          it "end_dateがtaskの終了より後" do
            progress = build(:progress, task: task, time: task_hour)
            progress.valid?
            expect(progress.errors[:end_date]).to include("must be within parent's")
          end

          it "end_timeがtaskの終了より前" do
              progress = build(:progress, task: task, time: task_hour)
              progress.valid?
              expect(progress.errors[:end_time]).to include("must be within parent's")
          end
        end
      end

      context "メソッド" do
          it "start_timeのゲッターがstart_dateカラムの日付になっている" do
              progress = build(:progress, start_time: Time.now)
              expect(progress.start_time.to_date).to eq(progress.start_date)
          end

          it "end_timeのゲッターがend_dateカラムの日付になっている" do
              progress = build(:progress)
              expect(progress.end_time.to_date).to eq(progress.end_date)
          end
      end
  end
end
