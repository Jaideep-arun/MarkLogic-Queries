xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

let $config := admin:get-configuration()
let $dbid := xdmp:database("documents")

(: Read the JSON file :)
let $index-definitions := collection("path")


(: Extract range path indexes :)
let $path-indexes := 
  for $index in $index-definitions/range-path-index
  return admin:database-range-path-index(
    $dbid,
    $index/scalar-type,
    $index/path-expression,
    $index/collation,
    fn:true(),
    $index/invalid-values
  )

(: Extract range element indexes :)
let $element-indexes := 
  for $index in $index-definitions/range-element-index
  return admin:database-range-element-index(
    $index/scalar-type,
    $index/namespace-uri,
    $index/localname,
    $index/collation,
    fn:true(),
    $index/invalid-values
  )

(: Add range path indexes to the database configuration :)
let $config := admin:database-add-range-path-index($config, $dbid, $path-indexes)

(: Add range element indexes to the database configuration :)
let $config := admin:database-add-range-element-index($config, $dbid, $element-indexes)

(: Save the configuration :)
return admin:save-configuration($config)