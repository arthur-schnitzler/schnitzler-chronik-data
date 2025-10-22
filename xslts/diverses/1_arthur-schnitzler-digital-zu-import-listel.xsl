<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mam="whatever" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:function name="mam:url-escape">
        <xsl:param name="input-url" as="xs:string"/>
        <xsl:variable name="eins" select="fn:escape-html-uri($input-url)"/>
        <xsl:variable name="zwei" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains($eins, '*')">
                    <xsl:value-of
                        select="concat(substring-before($eins, '*')[1], '%2A', substring-after($eins, '*')[1])"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$eins"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="drei" as="xs:string">
            <xsl:choose>
                <xsl:when test='contains($zwei, "&apos;")'>
                    <xsl:value-of
                        select='concat(substring-before($eins, "&apos;")[1], "&apos;", substring-after($zwei, "&apos;")[1])'
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$eins"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$drei"/>
    </xsl:function>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title level="s">Arthur Schnitzler digital</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Kristina Fink</name>
                            <name>Judith Beniston</name>
                            <name role="principal">Wolfgang Lukas</name>
                            <name role="principal">Michael Scheffel</name>
                            <name>Andrew Webber</name>
                        </respStmt>
                        <respStmt>
                            <resp>converted to XML encoding</resp>
                            <name>Kristina Fink,</name>
                            
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>Arthur Schnitzler digital</publisher>
                        <pubPlace>Wuppertal</pubPlace>
                        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="when">
                                <xsl:value-of select="format-date(current-date(), '[Y]')"/>
                            </xsl:attribute>
                            <xsl:value-of select="format-date(current-date(), '[D01].[M01].[Y]')"/>
                        </xsl:element>
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
                        <p>Arthur Schnitzler digital. Digitale historisch-kritische Edition (Werke
                            1905–1931). Hg. v. Wolfgang Lukas, Michael Scheffel, Andrew Webber und
                            Judith Beniston in Zusammenarbeit mit Thomas Burch. Wuppertal,
                            Cambridge, Trier 2018 ff.</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="descendant::*:event"/>
                    </xsl:element>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="*:event">
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*:head"/>
            <xsl:choose>
                <xsl:when test="*:desc">
                    <xsl:apply-templates select="*:desc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*:idno"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:head">
        <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:desc">
        <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:listPerson">
        <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:person">
        <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:persName">
        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:listPlace">
        <xsl:element name="listPlace" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:place">
        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:placeName">
        <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:listBibl">
        <xsl:element name="listBibl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:bibl">
        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:title">
        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:principal"/>
    <xsl:template match="*:idno">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:value-of select="replace(@type, ' ', '-')"/>
            </xsl:attribute>
            <xsl:value-of select="mam:url-escape(.)"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
