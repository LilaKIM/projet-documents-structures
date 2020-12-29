xquery version "3.1";

module namespace app="http://localhost:8080/exist/apps/documents-structures/templates";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/documents-structures/config" at "config.xqm";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute data-template="app:test" 
 : or class="app:test" (deprecated). The function has to take at least 2 default
 : parameters. Additional parameters will be mapped to matching request or session parameters.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};

declare function app:recherchePleinTexte($node as node(), $model as map(*), $type as xs:string?, $date as xs:integer?, $terme as xs:string?) as element (div)*{
    let $date_sup := $date + 99
    let $name_docs := 
        <div><table width="110%" height="10%" border="5">
            <tr><th>Titre</th><th>Date de la {$type}</th><th>Element</th><th>Contenu</th></tr>
            {
                for $fichier in collection($config:app-root || "/data")
                let $date_doc := 
                    if ($type = 'source') then $fichier//tei:creation/tei:date
                    else number(substring-after(substring-after($fichier//tei:fileDesc/tei:publicationStmt/tei:date, '/'), '/'))
                let $name_doc := $fichier//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()
                return 
                    if ($date_doc >= $date and $date_doc <= $date_sup) then 
                    let $my_texts := 
                    for $node in $fichier//tei:text//tei:p
                    return $node
                    
                    for $my_hit in $my_texts[ft:query(., $terme)]
                    return <tr><td align="center">{$name_doc}</td><td align="center">{$date_doc}</td><td align="center">{local-name($my_hit)}</td><td>{$my_hit}</td></tr>
                else ()
            }
        </table></div>
        
    return $name_docs
};

declare function app:affichageTexte($node as node(), $model as map(*), $titre as xs:string?) as element (div)* {
    for $fichier in collection($config:app-root || "/data")
    where $titre = $fichier//tei:title
    let $xsl := doc("/db/apps/documents-structures/resources/afficheTexte.xsl")
    return
    transform:transform($fichier, $xsl, ())
};