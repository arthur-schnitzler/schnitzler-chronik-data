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
                        <title level="s">Hedy Kempny, Arthur Schnitzler: Das Mädchen mit den dreizehn Seelen</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Heinz Adamek</name>
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
                        <p>Hedy Kempny und
                            Arthur Schnitzler: Das Mädchen mit den dreizehn Seelen. Eine Korrespondenz
                            ergänzt durch Blätter aus Hedy Kempnys Tagebuch sowie durch eine Auswahl ihrer
                            Erzählungen. Hg. v. Heinz P. Adamek. Reinbek bei Hamburg: Rowohlt
                            1984. (Neue Frau)</p>
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
        <xsl:variable name="jahr" select="Jahr"/>
        <xsl:for-each select="child::*[not(name() = 'Jahr')]">
            <xsl:variable name="monat" as="xs:string">
                <xsl:choose>
                    <xsl:when test="position() &lt; 10">
                        <xsl:value-of select="concat('0', position())"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="fn:position()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="tokenize(text(), ',')">
                <xsl:variable name="tag" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="number(normalize-space(.)) &lt; 10">
                            <xsl:value-of select="concat('0', normalize-space(.))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="datum" as="xs:date">
                    <xsl:value-of select="concat($jahr, '-', $monat, '-', $tag)"/>
                </xsl:variable>
                <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="when-iso">
                        <xsl:value-of select="$datum"/>
                    </xsl:attribute>
                    <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>Hedy Kempny, Tagebucheintrag vom </xsl:text>
                        <xsl:value-of select="
                                format-date($datum, '[D01]. [MNn] [Y0001]',
                                'de',
                                'AD',
                                'DE')"/>
                    </xsl:element>
                    <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="bibl">
                            <xsl:text>Hedy Kempny und
                    Arthur Schnitzler: Das Mädchen mit den dreizehn Seelen. Eine Korrespondenz
                    ergänzt durch Blätter aus Hedy Kempnys Tagebuch sowie durch eine Auswahl ihrer
                    Erzählungen. Hg. v. Heinz P. Adamek. Reinbek bei Hamburg: Rowohlt
                    1984. (Neue Frau)</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="idno">
                        <xsl:attribute name="type">
                            <xsl:text>schnitzler-kempny-buch</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="subtype">
                            <xsl:text>#ISBN3-499-154-57-9</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
