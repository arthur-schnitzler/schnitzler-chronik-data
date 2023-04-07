<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
   
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    
    
    <xsl:template match="tei:list">
        <xsl:element name="list" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="start-date" select="xs:date('1879-01-01')"/>
            <xsl:variable name="numberDays" select="xs:integer(($threshold - $start-date) div xs:dayTimeDuration('P1D'))"/>        
            <xsl:for-each select="0 to $numberDays">
                <xsl:element name="item">
                    <xsl:attribute name="sortKey">
                        <xsl:value-of select="xs:date($start-date) + (xs:dayTimeDuration('P1D')*(position()-1))"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
