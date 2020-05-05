const TASK_NAME_FORM = "task_name_for_js";
function GuessTime()
{
    let task_name = document.getElementById(TASK_NAME_FORM).value;
    if(task_name)//タスクに名前が入力されているときだけ実行
    {
        getTaskNameDetail(task_name);
    }
}

function getTaskNameDetail(name)
{
    $.ajax({
        url: `/task_names`,
        type: "get",
        dataType: "json",
        data: {name: name}
        })
        .done(getTasksData)
        .fail();
}

function getTasksData(datas)
{
    console.log(datas);
}