xquery version "1.0-ml";
(:1] Insert above xml document into documents database.:)
xdmp:document-insert('/test/lib/data.xml',<library>
  <book>
    <title>Book_1</title>
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

(:2] Retrieve all books from an XML document:)

xquery version "1.0-ml";
fn:doc()
(:3.Retrieve all Books:)
xquery version "1.0-ml";
fn:doc()//library/book
(:3] Retrieve all unique authors from an XML document:)

xquery version "1.0-ml";
for $auth in distinct-values(fn:doc()//library/book/author)
  return <author>{$auth}</author>

(:4] Retrieve the count of books written by each author:)

xquery version "1.0-ml";

for $author in distinct-values(doc()//book/author)
let $count := count(doc()//book[author = $author])
return <author>
         <name>{$author}</name>
         <book-count>{$count}</book-count>
       </author>
       
       
(:5] Retrieve books published after a specific year 2020:)


xquery version "1.0-ml";
cts:search(fn:doc()//library/book, cts:path-range-query('/library/book/year', '>', xs:gYear('2021')))