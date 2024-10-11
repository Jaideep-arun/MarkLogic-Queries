1. Retrieve the uri of all the endpoints and from these uris get the endpoint name
Collection-name : endpoint
xquery version "1.0-ml";
for $i in cts:search(fn:doc(),cts:collection-query('endpoint'))
return <result>
<endpoint>
<url>{xdmp:node-uri($i)}</url>
{$i/endpoint/endPointName}
</endpoint>
</result>


2. For each role, retrieve moduleName and the services having 'Design' permission under that module. 
Collection-name : role
xquery version "1.0-ml";

let $data := cts:search(collection('role'), cts:element-word-query(xs:QName('permissions'), 'Design'))
return
<result>{
for $i in $data
where $i/role/module/access/permissions = 'Design'
return<role>
<roleName>{$i/role/roleName/text()}</roleName>{
for $module in $i/role/module
return <Module>{
$module/moduleName,
for $service in $module/access/service
where $module/access/permissions = 'Design'
return $service
}
</Module>
}
</role>
}
</result>

3. For these 5 collections user, endpoint, role, apidefinition, schema
Find count of documents in each collection. Also get sum, average, minimum, maximum of these values.

xquery version "1.0-ml"; (:user, endpoint, role, apidefinition, schema:)
let $ep := cts:count(cts:collections('endpoint'))
let $u := cts:count(cts:collections('user'))
let $r := cts:count(cts:collections('role'))
let $ap := cts:count(cts:collections('apidefinition'))
let $s := cts:count(cts:collections('schema'))

return <res>
<count>
<user>{$u}</user>
<endpoint>{$ep}</endpoint>
<role>{$r}</role>
<apidefinition>{$ap}</apidefinition>
<schema>{$s}</schema>
</count>
<Average>{fn:avg(($u,$ep,$r,$ap,$s))}</Average>
<Sum>{fn:sum(($u,$ep,$r,$ap,$s))}</Sum>
<minimum>{fn:min(($u,$ep,$r,$ap,$s))}</minimum>
<maximum>{fn:max(($u,$ep,$r,$ap,$s))}</maximum>
</res>

4. Create 2 list containing username and createdSource from ‘user’ collection. Return the values which are available in both lists.

xquery version "1.0-ml";

let $userNames := 
for $user in collection('user')
return $user/user/userName/text()

let $createdSources := 
for $user in collection('user')
return $user/user/createdSource/text()

let $common := 
for $user in distinct-values($userNames)
where $user = $createdSources
return $user

return <result>
<commonValues>
{ for $value in distinct-values($common) return <value>{$value}</value> }
</commonValues>
</result>
 