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
            <xsl:sort select="@when-iso"/>
            <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="sortKey">
                    <xsl:value-of select="@when-iso"/>
                </xsl:attribute>
                <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="fn:current-group()"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
