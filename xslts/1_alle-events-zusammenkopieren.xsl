<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:param name="csv-url"
        select="'https://docs.google.com/spreadsheets/d/1D7DOS22f-j5o6BfCANtqTdRebi8Q4_cAsqqMcrNbRxw/gviz/tq?tqx=out:csv&amp;sheet=schnitzler-chronik-manual'"/>
    <xsl:param name="csv-content" select="unparsed-text($csv-url)"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title level="s">Arthur Schnitzler – Chronik</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Kristina Fink</name>
                            <name>Martin Anton Müller</name>
                            <name>Laura Untner</name>
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
                        <date when="2023">2023</date>
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
                        <p>Für jeden Tag zwischen 1879 und 1931–10-21 in Arthur Schnitzlers Leben,
                            für den es mindestens ein Ereignis gibt, einen Eintrag </p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                       <xsl:call-template name="events-einfuegen"/>
                     <!-- Hier der Import von Google Sheets -->
                        <xsl:for-each select="tokenize($csv-content, '&#10;')[not(position()=1)]">
                            <xsl:if test="matches(replace(tokenize(., '&#34;,&#34;')[1], '&#34;', ''), '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0" inherit-namespaces="true">
                                <xsl:attribute name="when-iso">
                                    <xsl:value-of select="replace(tokenize(., '&#34;,&#34;')[1], '&#34;', '')"/>
                                </xsl:attribute>
                                <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="tokenize(., '&#34;,&#34;')[2]"/>
                                </xsl:element>
                                <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="tokenize(., '&#34;,&#34;')[3]"/>
                                </xsl:element>
                                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type">
                                        <xsl:text>schnitzler-chronik-manuell</xsl:text>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(tokenize(., '&#34;,&#34;')[4])=''">
                                            <xsl:value-of select="concat('schnitzler-manuell_', position())"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace(normalize-space(tokenize(., '&#34;,&#34;')[4]), '&#34;', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template name="events-einfuegen" >
        <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>
        <xsl:for-each
            select="collection(concat($folderURI, '../../import-lists/?select=*_tage.xml'))/descendant::tei:listEvent">
            <xsl:sort select="@when-iso"/>
            <xsl:copy-of select="child::tei:event" copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
