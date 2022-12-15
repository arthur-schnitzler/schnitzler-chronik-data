# schnitzler-tage
A TEI-listEvent with entries for every day of Arthur Schnitzler’s adult life

This repository collects links to different biographical sources on Arthur Schnitzler:
* schnitzler-tagebuch https://schnitzler-tagebuch.acdh.oeaw.ac.at
* pollaczek https://pollaczek.acdh.oeaw.ac.at Clara Katharina Pollaczek: Arthur Schnitzler und ich
* schnitzler-orte https://schnitzler-orte.acdh.oeaw.ac.at
* https://schnitzler-bahr.acdh.oeaw.ac.at

The next release should include:

* https://schnitzler-briefe.acdh.oeaw.ac.at
* https://schnitzler-cmif.acdh.oeaw.ac.at printed correspondences of Schnitzlers
*  Contributions from https://www.schnitzler-edition.net 

The general idea is to be able to look up any given day in Arthur Schnitzler’s life and get a listing of his diary entry, letters and manuscripts from that very day.

The basic information includes

* projectname
* iso-date
* written-date*
* from*
* to*
* head
* desc
* URL

items with asterix are not mandatory. if @from and @to are given "iso-date" can be omitted.

the basic TEI-outline of the file is an item with the iso-date as sortKey and a listEvent with as much events as available, giving the source project in the idno-type:

```xml
<list>
<item sortKey="1930-04-21">
               <listEvent>
                  <event when-iso="1930-04-21">
                     <head>Tagebuch, 21. April 1930</head>
                     <desc/>
                     <idno type="schnitzler-tagebuch">https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__1930-04-21.html</idno>
                  </event>
                  <event when-iso="1930-04-21">
                     <head>Tagebuch von Clara Katharina Pollaczek, 18.–26. April 1930</head>
                     <desc/>
                     <idno type="pollaczek">https://pollaczek.acdh.oeaw.ac.at/ckp771.html</idno>
                  </event>
                  <event when-iso="1930-04-21">
                     <head>Wien</head>
                     <desc/>
                     <idno type="schnitzler-orte">https://pmb.acdh.oeaw.ac.at/entity/50/</idno>
                  </event>
                  <event when-iso="1930-04-21">
                     <head>Purkersdorf</head>
                     <desc/>
                     <idno type="schnitzler-orte">https://pmb.acdh.oeaw.ac.at/entity/91552/</idno>
                  </event>
                  <event when-iso="1930-04-21">
                     <head>Riederberg</head>
                     <desc/>
                     <idno type="schnitzler-orte">https://pmb.acdh.oeaw.ac.at/entity/91592/</idno>
                  </event>
               </listEvent>
            </item>
        </list>    
```

While URLs wrapped in the idno-element are preferred, sometimes the desc-element may be used instead to refer to a printed source
        
