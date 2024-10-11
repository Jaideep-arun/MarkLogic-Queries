xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()

(: Fetch the database ID for "Cars" :)
let $dbid := admin:database-get-id($config, "Cars")

(: Fetch the forest IDs attached to the "Cars" database :)
let $forest-ids := admin:database-get-attached-forests($config, $dbid)

(: Fetch the app server ID for "Cars-Server" :)
(:let $appserver-id := admin:appserver-get-id($config, admin:get-group-ids($config), "Cars-Server"):)
let $app-server-id := for $id in admin:get-appserver-ids($config)
  let $appdb :=  admin:appserver-get-database($config, $id) 
  where $appdb = $dbid
  return $id
(:return <app><id1>{$app-server-id}</id1><id2>{$appserver-id}</id2></app>:)

(: Fetch the modules database ID for "Car-Modules-9000" :)
let $module-db-id := admin:appserver-get-modules-database($config, $app-server-id)


(: Fetch the forest ID for "Car-forest-Modules-9000" :)
let $module-forest-id := admin:database-get-attached-forests($config, $module-db-id)


(: Delete the app server :)
let $config := admin:appserver-delete($config, $app-server-id)
let $config := admin:save-configuration-without-restart($config)
let $config := admin:get-configuration()

(: Detach and delete the forests from the main database :)
let $config := for $forest-id in $forest-ids
               return admin:database-detach-forest($config, $dbid, $forest-id)
let $config := admin:save-configuration-without-restart($config)
let $config := admin:get-configuration()

let $config := for $forest-id in $forest-ids
               return admin:forest-delete($config, $forest-id, fn:true())
let $config := admin:save-configuration-without-restart($config)
let $config := admin:get-configuration()

(: Detach and delete the forest from the modules database :)
let $config := admin:database-detach-forest($config, $module-db-id, $module-forest-id)
let $config := admin:save-configuration($config)
let $config := admin:get-configuration()
let $config := admin:forest-delete($config, $module-forest-id, fn:true())
let $config := admin:save-configuration-without-restart($config)
let $config := admin:get-configuration()

(: Delete the databases :)
let $config := admin:database-delete($config, $dbid)
let $config := admin:database-delete($config, $module-db-id)
let $config := admin:save-configuration-without-restart($config)
let $config := admin:get-configuration()

(: Final save configuration :)
return admin:save-configuration($config)
 