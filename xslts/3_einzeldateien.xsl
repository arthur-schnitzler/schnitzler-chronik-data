<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:template match="tei:TEI">
        <empty>
        <xsl:apply-templates select="tei:text/tei:body/tei:list/tei:item"/>
        </empty>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:result-document href="{normalize-space(@sortKey),'.xml'}">
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
                                <xsl:value-of
                                    select="format-date(@sortKey, '[Fn], [D]. [MNn] [Y0001]', 'de', (), ())"
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
    </xsl:template>
</xsl:stylesheet>
