(: Find the count of widgets created each day in past one week.  :)
xquery version "1.0-ml";
declare function local:get-past-week-dates() as xs:string* {
  let $today := current-date()
  for $i in 0 to 6
  let $past-date := $today - xs:dayTimeDuration(concat("P", $i, "D"))
  return fn:format-date($past-date, "[Y0001]-[M01]-[D01]")
};

let $count := 
  for $date in  local:get-past-week-dates()
  let $docs := 
    for $doc in fn:collection('dashboard')
    where xs:date(fn:format-dateTime($doc/dashboarddetail/createdDttm ,"[Y0001]-[M01]-[D01]" ))= xs:date($date)
    return $doc
  return <object num="{$date}"> 
      <count>{fn:count($docs)}</count> 
    </object>

return <res>{$count}</res>

(: Write a Function which return Interval For given input start datetime, end datetime and interval duration. :)

xquery version "1.0-ml";  

declare function local:intervals($start,$end,$duration)  {
  let $days := if(fn:days-from-duration($end - $start) >0 )then (fn:days-from-duration($end - $start) ) else (1 )
  let $intervals := 
    for $i in 0 to fn:floor($days *24 div fn:hours-from-duration($duration)) +1
    let $interval-start := $start + ($i * $duration)
    let $interval-end := $interval-start + $duration -  xs:dayTimeDuration("PT1S")
    return(
     if ($interval-start ge $end) then
       ()
     else
      <interval attr="{ $i + 1 }">
        <startdatetime>{ $interval-start }</startdatetime>
        <enddatetime>{ if ($interval-end le $end) then $interval-end else $end }</enddatetime>
      </interval>
     )
  return
    <IntervalDetails>
      { $intervals }
    </IntervalDetails>
};

let $start := xs:dateTime("2024-10-01T10:00:00")
let $end := xs:dateTime("2024-10-01T17:00:00")
let $duration := xs:dayTimeDuration("PT6H")

return local:intervals($start, $end, $duration)