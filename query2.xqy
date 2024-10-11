(:ADD data:)

xquery version "1.0-ml";
xdmp:document-insert('/XML/Library/Book',<library>
  <book>
    <title>Book 1</title>
    <author>Author 1</author>
    <year>2022</year>
  </book>
  <book>
    <title>Book 2</title>
    <author>Author 2</author>
    <year>2023</year>
  </book>
  <book>
    <title>Book 3</title>
    <author>Author 1</author>
    <year>2020</year>
  </book>
  <book>
    <title>Book 4</title>
    <author>Author 1</author>
    <year>2022</year>
  </book>
  <book>
    <title>Book 5</title>
    <author>Author 2</author>
    <year>2023</year>
  </book>
  <book>
    <title>Book 3</title>
    <author>Author 1</author>
    <year>2020</year>
  </book>
</library>)

(:Change URI:)

xquery version "1.0-ml";

let $old-uri := '/XML/Library/Book' (: change to original URI :)
let $new-uri := '/UCBOS/Library/Book' (: change to desired URI :)
let $lock := ($old-uri, $new-uri) ! xdmp:lock-for-update(.)
let $prop-ns := fn:namespace-uri-from-QName(xs:QName("prop:properties"))
let $properties :=
  xdmp:document-properties($old-uri)/node()/node()
    [ fn:namespace-uri(.) ne $prop-ns ]
return (
  xdmp:document-insert(
    $new-uri,
    fn:doc($old-uri),
    xdmp:document-get-permissions($old-uri),
    xdmp:document-get-collections($old-uri)
  ),
  xdmp:document-delete($old-uri),
  xdmp:document-set-properties($new-uri, $properties)
)

(:Add Data to collection:)

xquery version "1.0-ml";
xdmp:document-add-collections('/UCBOS/Library/Book', ("Book" , "UCBOS"))
xquery version "1.0-ml";


(:remove <2022 data:)
let $books := fn:doc('/UCBOS/Library/Book')//library/book
let $newbook := for $b in $books
  where $b/year >  2022
    return $b

(:add price:)
let $newbook := for $b in $newbook
  return <book>{$b/*}<price>350</price></book>
(:add new book:)
let $addbook := <book>
        <title>Book 10</title>
        <author>Author 5</author>
        <year>2024</year>
        <price>350</price>
        </book>
let $lib := <library>{$newbook, $addbook}</library>
(:Make author lower case:)
let $libn := <library>{ 
  for $b in $lib/book
    return <book>
    {$b/title,<author>{fn:lower-case($b/author)}</author>,$b/year,$b/price}</book>
    }</library>
(:return $libn:)
return xdmp:document-insert('/UCBOS/Library/Book',$libn)



   xquery version "1.0-ml";
(:remove <2022 data:)
let $books := fn:doc('/UCBOS/Library/Book')//library/book
let $newbook := for $b in $books
  where $b/year >  2022
    return $b

(:add price:)
let $newbook := for $b in $newbook
  return <book>{$b/*}<price>350</price></book>
(:add new book:)
let $addbook := <book>
        <title>Book 6</title>
        <author>Author101</author>
        <year>2023</year>
        <price>350</price>
        </book>
let $lib := <library>{$newbook, $addbook}</library>
(:Make author lower case:)
let $libn := <library>{ 
  for $b in $lib/book
    return <book>
    {$b/title,<author>{fn:lower-case($b/author)}</author>,$b/year,$b/price}</book>
    }</library>
(:return $libn:)
return xdmp:document-insert('/UCBOS/Library/Book',$libn)



(:Fetch data in another table:)
xquery version "1.0-ml";

let $uri := "/UCBOS/Library/Book"
let $database := xdmp:database('documents')

return xdmp:eval(
  "collection('UCBOS')",
  (),
  <options xmlns="xdmp:eval">
    <database>{$database}</database>
  </options>
)