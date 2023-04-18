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
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='Arthur-Schnitzler-digital']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='schnitzler-tagebuch']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='schnitzler-briefe']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='schnitzler-orte']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='pollaczek']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='schnitzler-bahr']"/>
        <xsl:copy-of select="tei:event[tei:idno[1]/@type='schnitzler-cmif']"/>
        <xsl:copy-of select="tei:event[not(tei:idno/@type='schnitzler-bahr') and not(tei:idno/@type='schnitzler-cmif') and
            not(tei:idno/@type='schnitzler-orte') and not(tei:idno/@type='pollaczek') and not(tei:idno/@type='schnitzler-briefe') and not(tei:idno/@type='schnitzler-tagebuch') and
            not(tei:idno/@type='Arthur-Schnitzler-digital')]"/>
    </xsl:template>
</xsl:stylesheet>
