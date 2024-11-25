<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title level="s">Arthur Schnitzler – Datierungen in der Mikroverfilmung des
                            Nachlasses</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Julius Handl</name>
                        </respStmt>
                        <respStmt>
                            <resp>converted to XML encoding</resp>
                            <name>Martin Anton Müller</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>Austrian Centre for Digital Humanities and Cultural
                            Heritage</publisher>
                        <pubPlace>Vienna</pubPlace>
                        <date when="2024">2024</date>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by/4.0/deed.de">
                                <p>Sie dürfen: Teilen — das Material in jedwedem Format oder Medium
                                    vervielfältigen und weiterverbreiten Bearbeiten — das Material
                                    remixen, verändern und darauf aufbauen und zwar für beliebige
                                    Zwecke, sogar kommerziell.</p>
                                <p>Der Lizenzgeber kann diese Freiheiten nicht widerrufen solange
                                    Sie sich an die Lizenzbedingungen halten. Unter folgenden
                                    Bedingungen:</p>
                                <p>Namensnennung — Sie müssen angemessene Urheber- und Rechteangaben
                                    machen, einen Link zur Lizenz beifügen und angeben, ob
                                    Änderungen vorgenommen wurden. Diese Angaben dürfen in jeder
                                    angemessenen Art und Weise gemacht werden, allerdings nicht so,
                                    dass der Eindruck entsteht, der Lizenzgeber unterstütze gerade
                                    Sie oder Ihre Nutzung besonders. Keine weiteren Einschränkungen
                                    — Sie dürfen keine zusätzlichen Klauseln oder technische
                                    Verfahren einsetzen, die anderen rechtlich irgendetwas
                                    untersagen, was die Lizenz erlaubt.</p>
                                <p>Hinweise:</p>
                                <p>Sie müssen sich nicht an diese Lizenz halten hinsichtlich solcher
                                    Teile des Materials, die gemeinfrei sind, oder soweit Ihre
                                    Nutzungshandlungen durch Ausnahmen und Schranken des
                                    Urheberrechts gedeckt sind. Es werden keine Garantien gegeben
                                    und auch keine Gewähr geleistet. Die Lizenz verschafft Ihnen
                                    möglicherweise nicht alle Erlaubnisse, die Sie für die jeweilige
                                    Nutzung brauchen. Es können beispielsweise andere Rechte wie
                                    Persönlichkeits- und Datenschutzrechte zu beachten sein, die
                                    Ihre Nutzung des Materials entsprechend beschränken.</p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>The microfilm collection of Arthur Schnitzler's estate
                            (https://schnitzler-mikrofilme.acdh.oeaw.ac.at) was reviewed by Julius
                            Handl, focusing on pages with complete dates. Vague (»1900«, »May
                            1890?«) or illegible entries were omitted.</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="descendant::*:row"/>
                    </xsl:element>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="*:row">
       <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
           <xsl:attribute name="when-iso">
               <xsl:value-of select="Datum"/>
           </xsl:attribute>
           <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
               <xsl:choose>
               <xsl:when test="contains(Titel, ' – ')">
                   <xsl:value-of select="fn:normalize-space(substring-before(Titel, ' – '))"/>
               </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="fn:normalize-space(Titel)"/>
                </xsl:otherwise>
               </xsl:choose>
           </xsl:element>
           
               <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                   <xsl:value-of select="fn:normalize-space(substring-after(Titel, ' – '))"/>
                   
               </xsl:element>
               
           
          <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:attribute name="type">
                  <xsl:text>schnitzler-mikrofilme-daten</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="Identifier"/>
          </xsl:element> 
           
           
          
           
           
           
       </xsl:element>
    </xsl:template>
</xsl:stylesheet>
