const SCROLL_AREA = "scroll_area_for_js";
const TODAY_COLUMN = "today_for_js";
const FIRST_DATE_COLUMN = "first_date_for_js"
//日付表示のth要素に今日の日付の場合はid="today~~"が付与される
//一番最初の日付はid="first~~"が付与される
//それらの差分をとり、スクロールする。

window.addEventListener("turbolinks:load", calendarScrollEvent);

function calendarScrollEvent()//ロード時に実行される関数
{
    const scroll_area = document.getElementById(SCROLL_AREA);
    if(scroll_area)
    {
        calendarScroll();
    }
}

function calendarScroll()
{
    const scroll_area = document.getElementById(SCROLL_AREA);
    const today_column = document.getElementById(TODAY_COLUMN);
    const first_column = document.getElementById(FIRST_DATE_COLUMN);

    let today_point = today_column.getBoundingClientRect().left;
    let first_point = first_column.getBoundingClientRect().left;
    

    let scroll_amount = today_point - first_point - (scroll_area.getBoundingClientRect().width / 2);
    //中心にtodayをスクロールさせるためにscroll_areaの半分の長さを加算している
    let time = 300;
    let count = 100;
    const scroll_per_count = scroll_amount / count;
    let timer =setInterval(function(){
                                        if(count < 0)
                                        {
                                            clearInterval(timer);
                                        }
                                        scroll_area.scrollBy(scroll_per_count, 0);
                                        count--;
                                    }, time/count);
}
