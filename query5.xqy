(:Cross Link Data between two databases:)
xquery version "1.0-ml";
for $uri in cts:uris((), (), cts:directory-query("/schema/root/VASN/VendorASN/","infinity"))
  let $asn := fn:doc($uri)
  return <res>
   <From>{$uri}</From>{
     for $d in cts:search(
       fn:doc(),
       cts:and-query((
         cts:path-range-query('ASN/ASNid','=',$asn//Vendor_ASN/ASNid),
         cts:path-range-query('/ASN/PO','=',$asn//Vendor_ASN/PO),
         cts:path-range-query('/ASN/company','=',$asn//Vendor_ASN/company),
         cts:path-range-query('/ASN/BusinessUnit','=',$asn//Vendor_ASN/BusinessUnit))
        ))
         return
           <To>{xdmp:node-uri($d)}</To>
    }</res>