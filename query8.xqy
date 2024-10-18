xquery version "1.0-ml";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
declare function local:convert($parsed-json,$parsed-json1){

let $convert := 
  for $key in map:keys($parsed-json1)
  let $value1 :=  map:get($parsed-json1, $key) 
  let $value := map:get($parsed-json,$key )
  return 
    if (fn:exists($value)) then
      typeswitch ($value1)
        case xs:integer return map:put($parsed-json, $key, fn:number($value))
        case xs:boolean return map:put($parsed-json, $key, xs:boolean($value))
        case xs:string  return map:put($parsed-json, $key, xs:string($value))
        case json:array return local:convert(json:array-values($value),json:array-values($value1))

         default return $parsed-json
    else $parsed-json
    return $convert[1]
};
declare variable $JSON :='{
"OrganizationName": "Alwazzan FSIG Snack", 
"SourceCode": "7000", 
"SourceHeaderId": "7000", 
"TransactionTypeId": "42", 
"SourceLineId": "7000", 
"TransactionUnitOfMeasure": "UNITS", 
"SubinventoryCode": "Main Store", 
"UseCurrentCostFlag": "true", 
"ItemNumber": "RM2001", 
"TransactionQuantity": "101", 
"TransactionMode": "3", 
"TransactionHeaderId": "7000", 
"TransactionDate": "2024-04-01", 
"lots": [
{
"TransactionQuantity": "101", 
"LotExpirationDate": "2026-04-01", 
"LotNumber": "SDS2043"
}
]
}';
declare variable $JSON1 := '{
    "OrganizationName": "Alwazzan FSIG Snack",
    "SourceCode": 7000,
    "SourceHeaderId": 7000,
    "TransactionTypeId": 42,
    "SourceLineId": "7000",
    "TransactionUnitOfMeasure": "UNITS",
    "SubinventoryCode": "Main Store",
    "lots": [
        {
            "TransactionQuantity": 101,
            "LotExpirationDate": "2024-03-31",
            "LotNumber": "20240101"
        }
    ],
    "UseCurrentCostFlag": true,
    "ItemNumber": "RM1001",
    "TransactionQuantity": 10,
    "TransactionMode": "3",
    "TransactionHeaderId": 7000,
    "TransactionDate": "2024-04-01"
}';



xdmp:to-json(local:convert(map:new(xdmp:from-json-string($JSON)),map:new(xdmp:from-json-string($JSON1))
))