const TASK_NAME_FORM = "task_name_for_js";//タスクネームのフォーム
const TASK_QUANTITY_FORM = "task_quantity_form_for_js";//タスク量のフォーム
const TASK_TIME_FORM = "task_time_form_for_js";//タスクのタイムフォーム
const DEBUG = false;//デバッグの画面を表示するかどうか
const CALCULATE_MAX_COUNT = 1000;//計算の最大回数
const CALCULATE_MIN_DIFF = 0;//ループを終了させるための誤差率の最小の差
const H = 0.00000000001//学習率η
var params = [];//パラメータの配列
var tasks = [];//サーバーから受け取るタスクの配列
var name_id;

//======フロー======
//1.ボタン押下でajaxでサーバーからタスクのデータ取得
//2.取得したデータをもとにパラメータの算出
//3.パラメータの計算後入力されているquantityを式にあてはめ時間の出力
//4.計算後のパラメータをサーバーに出力
//==================


//=============1==============
function GuessTime()
{
    let task_name = document.getElementById(TASK_NAME_FORM).value;
    let task_quantity = document.getElementById(TASK_QUANTITY_FORM).value;
    if(task_name && task_quantity)//タスクに名前が入力されているときだけ実行
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
    name_id = datas.name_id;
    params = createParamsArray(datas.params);//パラメータの配列を作成
    tasks = datas.tasks;
    const promise = new Promise(CalculateTaskParams);//フロー番号2
    promise.then(CalculateTimeFromInputQuantity);//フロー番号3
}

function createParamsArray(paramsObj)//paramsの配列を引数にする
{
    let params_arr = [];
    for(let i = 0; i < paramsObj.length; i++)
    {
        params_arr.push(paramsObj.filter(function(param, index){
            if(param.order == i) return true;
        })[0].param);
    }
    return params_arr;
}

//==================================

//================2=================
function CalculateTaskParams(resolve)
{

    for(let i = 0; i < CALCULATE_MAX_COUNT; i++)//定数CALCULATE_MAX_COUNTの回数だけループ
    {
        let E = CalculateErrorSum();//全体の誤差率の計算
        if(E <= CALCULATE_MIN_DIFF)//誤差率が最小誤差率より小さければループを抜ける
        {
            break;
        }

        let update_params = [];
        for( let j = 0; j < params.length; j++ )//パラメータの個数偏微分するので個数分ループする
        {
            let sum_func = CalculateSumFunc(j);//合成関数を計算
            let param = params[j] - (H * sum_func);
            update_params.push(param)
        }
        params = update_params;
        if(DEBUG)
        {
            console.log(params);
        }
    }
    resolve();//ここに入れた引数がthenで呼ばれるメソッドの引数になる
}

function CalculateTaskTime(quantity)//パラメータをもとに時間を計算する関数
{
    let time = 0;
    for(let i = 0; i < params.length; i++)
    {
        time += CreateTaskNum(i, quantity);
    }
    return time;
}

function CreateTaskNum(i, x)//パラメータの配列と項の順番、xの値を引数にして項を返す
{
    return params[i] * Math.pow(x, i);
}

function CalculateErrorSum()
{
    let Error_sum = 0;//誤差率
    for(let i = 0; i < tasks.length; i++)//タスクの数だけループ
    {
        Error_sum += Math.pow(tasks[i].time - CalculateTaskTime(tasks[i].quantity), 2);//(y - f(x))^2
    }
    Error_sum /= 2// E * 1/2
    return Error_sum;
}

//パラメータ更新式
//θi := θi - η(∂E/∂θi)
//合成関数で微分の箇所を抜き出すと
//∂E/∂θi
//∂E/∂f(x) * ∂f(x)/∂θi
//一つ目の項はiにかかわらず固定なのでまずここを求める
//一つ目の項は
//∂1/2(Σ(yi - f(xi)^2) / ∂f(xi)
//1/2Σ(∂((yi- f(xi))^2/∂f(xi)))
//( yi - f(xi) )^2 →　yi^2 - 2yif(xi) + f(xi)^2
//微分して -2yi + 2f(xi)
//よって一つ目の項は
//1/2Σ(2f(xi) - 2yi)
//=Σ(f(xi) - yi)
//
//二つ目の項は
//f(x) = Σ(θi * x^i)
//なのでこれをθiで微分すると
//=x^i
//よって二つの項をあてはめた更新式は
//θi := θi - η（Σ(f(xi) - yi) * x^i)
function CalculateSumFunc(roop_count)
{
    let result = 0;//一つ目の項
    for(let i=0 ; i < tasks.length; i++)//タスクの回数ループ
    {
        result += (CalculateTaskTime(tasks[i].quantity) - tasks[i].time) * Math.pow(tasks[i].quantity, roop_count);
    }


    return result;
}
//==================================

//================3==================
function CalculateTimeFromInputQuantity()
{
    let task_quantity = document.getElementById(TASK_QUANTITY_FORM).value;
    let time = CalculateTaskTime(task_quantity);
    document.getElementById(TASK_TIME_FORM).value = Math.floor(time * 100) / 100;
    SendParamsToServer();
}

//===================================

//================4==================
function SendParamsToServer()
{   
    $.ajax({
        url: `/task_names/${name_id}/task_params`,
        type: "put",
        dataType: "json",
        data: {params: params}
        })
        .done()
        .fail();
}

//===================================