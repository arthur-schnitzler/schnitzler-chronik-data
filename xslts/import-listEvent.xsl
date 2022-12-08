<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:param name="einzuarbeitendeListe" select="document('../individual-lists/bahr-tage.xml')"/>
    <xsl:key name="nachschlagen" match="tei:event" use="@when-iso"/>
    
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    
    
    <xsl:template match="tei:listEvent[not(child::*)]"/>
   
    
    <xsl:template match="tei:body/tei:list/tei:item">
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:variable name="einzuarbeitenderTyp" select="$einzuarbeitendeListe/descendant::tei:body/descendant::tei:idno[1]/@type"/>
            <xsl:choose>
                <xsl:when test="tei:listEvent[not(child::*)] and not(key('nachschlagen', @sortKey, $einzuarbeitendeListe))"/>
                <xsl:otherwise>
                    <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:copy-of select="tei:listEvent/tei:event[not(tei:idno/@type=$einzuarbeitenderTyp)]"/>
                        <xsl:copy-of select="key('nachschlagen', @sortKey, $einzuarbeitendeListe)"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            
            
            
        </xsl:element>
    </xsl:template>
    
    
    
    
    
   <!-- <xsl:template match="date">
        <xsl:variable name="desc"
            select="concat('Tagebuch, ', fn:format-date(., '[D1o] [MNn] [Y]', 'de', (), ()))"/>
        <xsl:variable name="url"
            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', ., '.html')"/>
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="when-iso">
                <xsl:value-of select="."/>
            </xsl:attribute>
            <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="$desc"/>
            </xsl:element>
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:text>schnitzler-tagebuch</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="$url"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>-->
    
    
    <!--  
        Damit habe ich die Liste der Tage erzeugt
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
     -->
</xsl:stylesheet>
