//@は数値に置き換える
//workフォームのチェックボックス
const WORK_FORM_CHECKBOX = "work_tasks_@";
//ワークフォームのゴミ箱アイコン
const WORK_FORM_TRASH_ICON = "work_form_icon_for_js_@";
//ワークフォームのゴミ箱チェックボックスに共通でついているクラス
const CLASS_TRASH_CHECKBOX = "work_form_checkbox_for_js";
//チェックボックスがオンの時にアイコンについているクラス
const CLASS_TRASH_CHECKED = "form__field__label--post_it__icon--trash"

window.addEventListener("turbolinks:load", addEventTrashCheckbox);

function addEventTrashCheckbox()//リスナの設定
{
    const trash_checkbox = document.getElementsByClassName(CLASS_TRASH_CHECKBOX);
    if(trash_checkbox.length > 0)
    {
        for(let i = 0; i < trash_checkbox.length; i++)
        {
            trash_checkbox[i].addEventListener("change", changedTrashCheckbox);
        }
    }
}

function changedTrashCheckbox(e)
{
    const target = e.target;
    const checkbox_id = get_number_from_id(target.getAttribute("id"), WORK_FORM_CHECKBOX);
    const icon_id = get_id_from_number(checkbox_id, WORK_FORM_TRASH_ICON)
    const trash_icon = document.getElementById(icon_id);
    if(target.checked)
    {
        trash_icon.classList.add(CLASS_TRASH_CHECKED);
    }
    else
    {
        trash_icon.classList.remove(CLASS_TRASH_CHECKED);        
    }
}

function get_number_from_id(query_id, format)
{
    query_id.match(new RegExp(format.replace("@", "(\\d+)")));
    return Number(RegExp.$1);
}

function get_id_from_number(id, format)
{
    return format.replace("@", id);
}