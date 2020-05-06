json.tasks do
    json.array! @tasks do |task|
        json.id task.id
        json.quantity task.quantity
        json.time task.time
    end
end

json.params do
    json.array! @params do |param|
        json.id param.id
        json.order param.order
        json.param param.param
    end
end

json.name_id @name.id
# イメージ
# tasks[{:id, :quantity, :time}, {:id, :quantity, :time}]
# params[{:id, :order, :param}, {:id, :order, :param}]