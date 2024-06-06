<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <!-- das hier nimmt schnitzler-orte.xml  schreibt es um listEvent -->
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    
    <xsl:template match="tei:listEvent">
        <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="tei:event/tei:listPlace/tei:place"/>
        </xsl:element>
        
    </xsl:template>
    
    
    <xsl:template match="tei:event/tei:listPlace/tei:place">
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="when-iso">
                <xsl:value-of select="ancestor::tei:event/@when"/>
            </xsl:attribute>
            <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="child::tei:placeName[1]"/>
            </xsl:element>
            <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0"/>
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:text>schnitzler-orte</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="tei:idno[@type='pmb' or @subtype='pmb'][1]"/>
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
