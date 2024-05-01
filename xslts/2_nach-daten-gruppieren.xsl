<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="tei:body">
        <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="list" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:listEvent">
        <xsl:for-each-group select="tei:event" group-by="@when-iso">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="sortKey">
                    <xsl:value-of select="@when-iso"/>
                </xsl:attribute>
                <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'Arthur-Schnitzler-digital' or tei:idno[1]/@subtype = 'Arthur-Schnitzler-digital']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-tagebuch' or tei:idno[1]/@subtype = 'schnitzler-tagebuch']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-briefe' or tei:idno[1]/@subtype = 'schnitzler-briefe']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-orte' or tei:idno[1]/@subtype = 'schnitzler-orte']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-interviews' or tei:idno[1]/@subtype = 'schnitzler-interviews']"/>
                    <xsl:apply-templates select="current-group()[tei:idno[1]/@type = 'pollaczek' or tei:idno[1]/@subtype = 'pollaczek']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-bahr' or tei:idno[1]/@subtype = 'schnitzler-bahr']"/>
                    <xsl:apply-templates select="current-group()[tei:idno[1]/@type = 'pmb' or tei:idno[1]/@subtype = 'pmb']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-chronik-manuell' or tei:idno[1]/@subtype = 'schnitzler-chronik-manuell']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-cmif' or tei:idno[1]/@subtype = 'schnitzler-cmif']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-traeume']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-kino-buch']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'schnitzler-kempny-buch']"/>
                    <xsl:apply-templates
                        select="current-group()[tei:idno[1]/@type = 'kalliope-verbund' or tei:idno[1]/@subtype = 'kalliope-verbund']"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
