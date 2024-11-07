<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:number="http://dummy/" xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all"
    xmlns:functx="http://www.functx.com" version="3.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="false"/>
    <!-- Dieses XSLT gleicht die in event-tage angeführten aufenthaltsorte
        mit schnitzler-orte_tage ab und gibt jene orte aus, die zwar im event sind,
        aber nicht im aufenthaltsort
    -->
    
    
    
    <xsl:param name="listOrte" select="document('../../import-lists/schnitzler-orte_tage.xml')"/>
    <xsl:key name="ortsabgleich" match="tei:event" use="concat(@when-iso, tei:idno[1])"/>
    
    <xsl:template match="/">
        <xsl:element name="list" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="descendant::tei:event"></xsl:apply-templates>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:event[descendant::tei:placeName]">
        <xsl:variable name="when" select="@when"/>
        
        <xsl:for-each select="descendant::tei:placeName/@key">
            <xsl:variable name="key" select="replace(replace(., '#', ''), 'pmb', '')"/>
            <xsl:variable name="key-idnoForm" select="concat('https://pmb.acdh.oeaw.ac.at/entity/', $key, '/')"/>
            <xsl:choose>
                <xsl:when test="key('ortsabgleich', concat($when, $key-idnoForm), $listOrte)">
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="when-iso">
                            <xsl:value-of select="$when"/>
                        </xsl:attribute>
                        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="key">
                                <xsl:value-of select="concat('pmb', $key)"/>
                            </xsl:attribute>
                            
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            
            
            
            
            
            
        </xsl:for-each>
        
        
    </xsl:template>
    
  
   
    
</xsl:stylesheet>
