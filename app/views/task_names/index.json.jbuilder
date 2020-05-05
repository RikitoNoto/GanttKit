json.array! @tasks do |task|
    json.id task.id
    json.quantity task.quantity
    json.time task.time
end

json.array! @params do |param|
    json.id param.id
    json.order param.order
    json.param param.param
end