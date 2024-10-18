(:Write and upload query as document:)

xdmp:document-insert("/task/todelete.xqy", 
text {
            "xquery version '1.0-ml';
            for $uri in cts:uris()
            let $creation-time := xdmp:document-timestamp($uri)
            where fn:day-from-dateTime(xdmp:timestamp-to-wallclock($creation-time)) >= 15
            return xdmp:document-delete($uri)"
       }
)

(:Schedule Task:)

xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
let $config := admin:get-configuration()
let $task := admin:group-hourly-scheduled-task('/todelete.xqy', '/task', 24 , 1 , xdmp:database('ucbos'),xdmp:database('ucbos'), xdmp:user('admin'), 0,'normal')
let $config := admin:group-add-scheduled-task($config,admin:get-group-ids($config), $task)
return admin:save-configuration($config)

(:Write and upload query as document:)
xdmp:document-insert("/task/todelete.xqy", text {
  "xquery version '1.0-ml';
for $uri in cts:uris()
               let $doc := fn:doc($uri)
               let $creation-time := xs:dateTime($doc/ASN/createdDateTime)
                where fn:days-from-duration((fn:current-dateTime() - $creation-time )) >= 15
               return xdmp:document-delete($uri)"
});

(:Schedule Task:)


xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
let $config := admin:get-configuration()
let $task := admin:group-hourly-scheduled-task('/todelete.xqy', '/task', 24 , 1 , xdmp:database('ucbos'),xdmp:database('ucbos'), xdmp:user('admin'), 0,'normal')
let $config := admin:group-add-scheduled-task($config,admin:get-group-ids($config), $task)
return admin:save-configuration($config)