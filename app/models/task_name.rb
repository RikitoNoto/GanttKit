class TaskName < ApplicationRecord
    has_many :tasks
    has_many :task_params
    belongs_to :user

    validates :name, presence: true
    COUNT_TASK_PARAMS = 3#タスクのパラメータの個数

    #初期のparamsは
    #f(x) = θ0 + θ1x + θ2x^2 の式で
    #(0,0)と一つ目の(量, 時間)の両方を通る式。
    # 時間 = θ0 + θ1(量) + θ2x^2
    # 0 = θ0 + 0 + θ2x^2
    #の連立方程式になる。
    #最初は一次関数でいいのでθ2は0とすると
    #0 = θ0 + 0 + 0
    #よりθ0=0
    #よってθ1=時間/量になる
    #なので初期値として
    #θ0=0
    #θ1=時間/量
    #θ2=0
    #の3つを保存する
    def create_params(task)
        if self.task_params.length == 0#パラメータが一つもなかったら
            (COUNT_TASK_PARAMS).times do |i|
                if i == 1
                    self.task_params.create(order: i, param: task.time / task.quantity)
                else
                    self.task_params.create(order: i, param: 0)
                end
            end
        end
    end

    def self.get_id(_name: _name, user: nil)
        record = self.find_by(name: _name, user: user)
        unless record
            record = self.create(name: _name, user: user)
        end
        return record.id
    end
end
