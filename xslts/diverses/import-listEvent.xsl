<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    
    <xsl:key name="nachschlagen" match="tei:event" use="@when-iso"/>
    
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    
    
    <xsl:template match="tei:listEvent[not(child::*)]"/>
    
    <xsl:template match="tei:list">
        <xsl:element name="list" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates>
                <xsl:with-param name="einzuarbeitenderListenName" select="'../individual-lists/schnitzler-bahr_tage.xml'"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="einzuarbeitenderListenName" select="'../individual-lists/pollaczek_tage.xml'"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="einzuarbeitenderListenName" select="'../individual-lists/schnitzler-tagebuch_tage.xml'"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="einzuarbeitenderListenName" select="'../individual-lists/wienerschnitzler_tage.xml'"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="einzuarbeitenderListenName" select="'../individual-lists/manuelle-ergaenzungen_tage.xml'"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    
    
    <xsl:template match="tei:body/tei:list/tei:item" >
        <xsl:param name="einzuarbeitenderListenName" as="xs:string"/>
        <xsl:variable name="einzuarbeitendeListe" select="document($einzuarbeitenderListenName)"/>
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            
            <xsl:variable name="einzuarbeitenderTyp" select="$einzuarbeitendeListe/descendant::tei:body/descendant::tei:idno[1]/@type"/>
            <xsl:choose>
                <xsl:when test="tei:listEvent[not(child::*)] and not(key('nachschlagen', @sortKey, $einzuarbeitendeListe))"/>
                <xsl:otherwise>
                    <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:copy-of select="tei:listEvent/tei:event[not(tei:idno[@type=$einzuarbeitenderTyp])]"/>
                        <xsl:copy-of select="key('nachschlagen', @sortKey, $einzuarbeitendeListe)"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>