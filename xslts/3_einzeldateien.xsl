<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:df="http://example.com/df"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:import href="germandate.xsl"/>
    <xsl:param name="relevant-uris" select="document('../editions/indices/list-of-relevant-uris.xml')"/>
    <xsl:key name="only-relevant-uris" match="item" use="abbr"/>
    
    
    <xsl:template match="tei:TEI">
        
        <empty>
            <xsl:apply-templates select="tei:text/tei:body/tei:list/tei:item"/>
        </empty>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:variable name="dateiname" as="xs:string"
            select="concat(normalize-space(@sortKey), '.xml')"/>
        <xsl:result-document href="{$dateiname}">
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title level="s">Arthur Schnitzler – Tag für Tag</title>
                            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="level">
                                    <xsl:text>a</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="when-iso">
                                    <xsl:value-of select="@sortKey"/>
                                </xsl:attribute>
                                <xsl:variable name="wochentag"
                                    select="df:germanNames(fn:format-date(@sortKey, '[FNn]'))"/>
                                <xsl:variable name="monat"
                                    select="df:germanNames(fn:format-date(@sortKey, '[MNn]'))"/>
                                <xsl:value-of
                                    select="concat($wochentag, ', ', fn:format-date(@sortKey, '[D]'), '. ', $monat, ' ', fn:format-date(@sortKey, '[Y]'))"
                                />
                            </xsl:element>
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
                            <xsl:variable name="heute" select="fn:current-date()"/>
                            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="when-iso">
                                    <xsl:value-of
                                        select="format-date($heute, '[Y0001]-[M01]-[D01].')"/>
                                </xsl:attribute>
                                <xsl:value-of select="format-date($heute, '[D01].[M01].[Y0001]')"/>
                            </xsl:element>
                            <availability>
                                <licence
                                    target="https://creativecommons.org/licenses/by/4.0/deed.de">
                                    <p>Sie dürfen: Teilen — das Material in jedwedem Format oder
                                        Medium vervielfältigen und weiterverbreiten Bearbeiten — das
                                        Material remixen, verändern und darauf aufbauen und zwar für
                                        beliebige Zwecke, sogar kommerziell.</p>
                                    <p>Der Lizenzgeber kann diese Freiheiten nicht widerrufen
                                        solange Sie sich an die Lizenzbedingungen halten. Unter
                                        folgenden Bedingungen:</p>
                                    <p>Namensnennung — Sie müssen angemessene Urheber- und
                                        Rechteangaben machen, einen Link zur Lizenz beifügen und
                                        angeben, ob Änderungen vorgenommen wurden. Diese Angaben
                                        dürfen in jeder angemessenen Art und Weise gemacht werden,
                                        allerdings nicht so, dass der Eindruck entsteht, der
                                        Lizenzgeber unterstütze gerade Sie oder Ihre Nutzung
                                        besonders. Keine weiteren Einschränkungen — Sie dürfen keine
                                        zusätzlichen Klauseln oder technische Verfahren einsetzen,
                                        die anderen rechtlich irgendetwas untersagen, was die Lizenz
                                        erlaubt.</p>
                                    <p>Hinweise:</p>
                                    <p>Sie müssen sich nicht an diese Lizenz halten hinsichtlich
                                        solcher Teile des Materials, die gemeinfrei sind, oder
                                        soweit Ihre Nutzungshandlungen durch Ausnahmen und Schranken
                                        des Urheberrechts gedeckt sind. Es werden keine Garantien
                                        gegeben und auch keine Gewähr geleistet. Die Lizenz
                                        verschafft Ihnen möglicherweise nicht alle Erlaubnisse, die
                                        Sie für die jeweilige Nutzung brauchen. Es können
                                        beispielsweise andere Rechte wie Persönlichkeits- und
                                        Datenschutzrechte zu beachten sein, die Ihre Nutzung des
                                        Materials entsprechend beschränken.</p>
                                </licence>
                            </availability>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Für jeden Tag zwischen 1879 und 1931–10-21 in Arthur Schnitzlers
                                Leben, für den es mindestens ein Ereignis gibt, einen Eintrag </p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <xsl:copy-of select="child::*"/>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        <xsl:variable name="dateiname-json" as="xs:string"
            select="concat(normalize-space(@sortKey), '.json')"/>
        <xsl:result-document href="{$dateiname-json}" encoding="utf8" omit-xml-declaration="true">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="descendant::tei:listEvent/tei:event" mode="jsonlist"/>
            <xsl:text>] </xsl:text>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template mode="jsonlist" match="tei:event">
        <xsl:text>{&#10; "type":&#10; "</xsl:text>
        <xsl:value-of select="tei:idno/@type"/>
        <xsl:if test="tei:idno/@subtype">
            <xsl:text>",&#10; "subtype":&#10; "</xsl:text>
            <xsl:value-of select="tei:idno/@subtype"/>
        </xsl:if>
        <xsl:text>",&#10; "color":&#10; "</xsl:text>
        <xsl:value-of select="key('only-relevant-uris', @type, $relevant-uris)/color"/>
        <xsl:if test="tei:idno[not(normalize-space(.) = '')]">
            <xsl:text>",&#10; "idno":&#10; "</xsl:text>
            <xsl:value-of select="tei:idno"/>
        </xsl:if>
        <xsl:text>",&#10; "head":&#10; "</xsl:text>
        <xsl:value-of select="tei:head"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="tei:desc[not(fn:normalize-space(.) = '')]">
            <xsl:text>,&#10; "desc":&#10;{</xsl:text>
            <xsl:for-each select="tei:desc/child::*">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>":&#10; </xsl:text>
                <xsl:apply-templates mode="jsonlist" select="."/>
                <xsl:if test="not(position() = last())">
                    <xsl:text>,&#10; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="text()[not(fn:normalize-space(.) = '')]">
                <xsl:if test="child::*">
                    <xsl:text>,&#10; </xsl:text>
                </xsl:if>
                <xsl:text> "text":&#10; "</xsl:text>
                <xsl:value-of select="text()[not(fn:normalize-space(.) = '')]"/>
                <xsl:text>" </xsl:text>
            </xsl:if>
            <xsl:text>}&#10;</xsl:text>
        </xsl:if>
        <xsl:text>&#10;}</xsl:text>
        <xsl:if test="not(fn:position() = last())">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listPerson">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:person">
            <xsl:text>{&#10; "persName":&#10; "</xsl:text>
            <xsl:value-of select="normalize-space(tei:persName)"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:persName/@ref"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>,&#10; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listBibl">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:bibl">
            <xsl:text> {&#10; "title":&#10; "</xsl:text>
            <xsl:value-of select="normalize-space(tei:title)"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:title/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listPlace">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:place">
            <xsl:text> {&#10; "placeName":&#10; "</xsl:text>
            <xsl:value-of select="normalize-space(tei:placeName)"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:placeName/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listOrg">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:org">
            <xsl:text> {&#10; "orgName":&#10; "</xsl:text>
            <xsl:value-of select="normalize-space(tei:orgName)"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:orgName/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:event/tei:desc/tei:bibl">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
</xsl:stylesheet>
