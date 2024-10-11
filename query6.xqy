(:Convert XML into JSON:)

xquery version "1.0-ml";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
let $data := cts:search(fn:doc(), cts:collection-query('JSON'))
let $config := json:config("custom") ,
          $cx := map:put( $config, "attribute-names" , ("subKey" , "boolKey" , "empty" ) )

let $xml := <root> {json:transform-from-json($data,$config)}</root>

return xdmp:document-insert('/obj/json',$xml)