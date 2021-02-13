# viaf-to-tei

This is an XSLT script for populating a minimal TEI `person` record with the following information from VIAF (http://viaf.org/)

- variant forms of personal names
- dates of birth and death
- identifiers from various sources (GND, BNF, LC, Wikidata)

It is designed to be used as a transformation scenario from within Oxygen. There are instructions on setting up a transformation scenario in the Oxygen documentation (https://www.oxygenxml.com/doc/versions/23.0/ug-editor/topics/defining-new-transformation-scenario.html) 

The transformation should be applied to a TEI file containing a `listPerson` element containing one or more minimal `person` elements (as in `sample-input.xml`):

```
<person xml:id="person_409437">
  <persName type="display" source="DNB">Nicolaus Tempelfeld de Brega -1471</persName>
</person>
```

The `xml:id` of the `person` element must be in the format `person_XXXXX` where `XXXXXX` is the VIAF identifier.

The output will be a record populated with information from VIAF (cf. `sample-output.xml`):

```
           <person xml:id="person_409437">
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">Tempelfeld de Brega</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Brega, Nicolaus &#x98;de&#x9c;</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolas</name>
                  <name type="marc-c">Tempelfeld de Brieg</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolas</name>
                  <name type="marc-c">Tempelfeld</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">Tempelfeld Bregensis</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">Tempelfeld von Brieg</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">Tempelfeld</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">Tympelfelt</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">Nicolaus</name>
                  <name type="marc-c">de Brega</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Tempelfeld Bregensis, Nicolaus</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Tempelfeld de Brega, Nicolaus</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Tempelfeld, Nicolas</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Tempelfeld, Nicolaus</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="surenameFirst" source="DNB">
                  <name type="marc-a">Tympelfelt, Nicolaus</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <persName type="variant" subtype="forenameFirst" source="DNB">
                  <name type="marc-a">ʿMikołaja</name>
                  <name type="marc-c">z Brzegu</name>
                  <name type="marc-d">-1471</name>
               </persName>
               <death source="VIAF" when="1471">1471</death>
               <note type="links">
                  <list type="links">
                     <item>
                        <ref target="http://d-nb.info/gnd/102836450">
                           <title>GND</title>
                        </ref>
                     </item>
                     <item>
                        <ref target="http://www.wikidata.org/entity/Q94859990">
                           <title>Wikidata</title>
                        </ref>
                     </item>
                     <item>
                        <ref target="https://viaf.org/viaf/409437">
                           <title>VIAF</title>
                        </ref>
                     </item>
                  </list>
               </note>
               <persName type="display" source="DNB">Nicolaus Tempelfeld de Brega -1471</persName>
            </person>
```

Note that the original content of the record is preserved as the final lines of the new record. This ensures that any local forms of the name are not overwritten and allows for comments or other information to be included.
