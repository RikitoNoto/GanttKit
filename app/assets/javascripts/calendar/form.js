const CALENDAR_FORM = "calendar_form_for_js";
const CLASS_WORK_SELECTOR = "work_selector_for_js";
const CLASS_TASK_SELECTOR = "task_selector_for_js";
const TASK_START_DATE = "calendar_form_start_date_for_js";

window.addEventListener("turbolinks:load", addEventCalendarFormSelector);

function addEventCalendarFormSelector()//リスナの設定
{
    const calendarForm = document.getElementById(CALENDAR_FORM);
    if(calendarForm)
    {
        const work_selector = $(`.${CLASS_WORK_SELECTOR}`)[0];//workselectorを取得
        const task_selector = $(`.${CLASS_TASK_SELECTOR}`)[0];//taskselectorを取得
        work_selector.addEventListener("change", changedWorkSelector);
        task_selector.addEventListener("change", changedTaskSelector);
        replaceTaskStartTime($(`#${TASK_START_DATE}`).data("date"));
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

function changedTaskSelector(e)
{
    let selected = e.target.selectedOptions[0];
    replaceTaskStartTime($(selected).data("date"));
}

function taskSelectorReplace(response)
{
    const task_selector = $($(`.${CLASS_TASK_SELECTOR}`)[0]);
    task_selector.empty();
    $.each(response, function(i, task){
        task_selector.append(createOption(task));
    });

    if(response[0])
    {
        replaceTaskStartTime(response[0].date);
    }
}

function createOption(object)
{
    let option = `<option value="${object.id}" data-date=${object.date}>${object.name}</option>`
    return option;
}

function replaceTaskStartTime(date)
{
    let replace_date = new Date(date);
    let task_date = document.getElementById(TASK_START_DATE);
    if(date)
    {
        task_date.textContent = `${replace_date.getFullYear()}-${numberFormatInteger(2, replace_date.getMonth() + 1)}-${numberFormatInteger(2, replace_date.getDate())} ${numberFormatInteger(2, replace_date.getHours())}:${numberFormatInteger(2, replace_date.getMinutes())}:${numberFormatInteger(2, replace_date.getSeconds())}~`;
    }
    else
    {
        task_date.textContent = null;
    }
}

function numberFormatInteger(digit, number)
{
    return Intl.NumberFormat("ja",{minimumIntegerDigits: digit}).format(number);
}