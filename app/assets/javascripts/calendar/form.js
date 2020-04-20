const CALENDAR_FORM = "calendar_form_for_js";
const CLASS_WORK_SELECTOR = "work_selector_for_js";
const CLASS_TASK_SELECTOR = "task_selector_for_js";

window.addEventListener("turbolinks:load", addEventCalendarFormSelector);

function addEventCalendarFormSelector()//リスナの設定
{
    const calendarForm = document.getElementById(CALENDAR_FORM);
    if(calendarForm)
    {
        const work_selector = $(`.${CLASS_WORK_SELECTOR}`)[0];//workselectorを取得
        const task_selector = $(`.${CLASS_TASK_SELECTOR}`)[0];//taskselectorを取得
        work_selector.addEventListener("change", changedWorkSelector);
        // task_selector.addEventListener("change", );
    }
}


function changedWorkSelector(e)
{
    const work_id = parseInt($(`.${CLASS_WORK_SELECTOR}`)[0].value);//workselectorの値を取得
    $.ajax({
        url: `/works/${work_id}/tasks`,
        type: "get",
        dataType: "json",
        data: {}
        })
        .done(taskSelectorReplace)
        .fail(function(){
            alert("通信エラーです。");
            location.reload();
        });
}

function taskSelectorReplace(response)
{
    const task_selector = $($(`.${CLASS_TASK_SELECTOR}`)[0]);
    task_selector.empty();
    $.each(response, function(i, task){
        task_selector.append(createOption(task));
    });
}

function createOption(object)
{
    let option = `<option value="${object.id}">${object.name}</option>`
    return option;
}