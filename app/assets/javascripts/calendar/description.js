const CALENDAR_DESCRIPTION = "calendar__description_for_js";

function DisplayDescription()
{
    let description = document.getElementById(CALENDAR_DESCRIPTION);
    description.classList.remove("display_none");
}

function CloseDescription()
{
    let description = document.getElementById(CALENDAR_DESCRIPTION);
    description.classList.add("display_none");
}