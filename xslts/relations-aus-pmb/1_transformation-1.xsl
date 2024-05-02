<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:number="http://dummy/" xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all"
    xmlns:functx="http://www.functx.com" version="3.0" xmlns:mam="whatever"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="false"/>
    <!-- Dieses XSLT wird auf den automatischen Export listevent.xml aus
        der PMB angewandt: 
        https://pmb.acdh.oeaw.ac.at/media/listevent.xml
        und erstellt das fertige pmb-event-tage.xml (anpassung eventName -> head, alles in desc)
    -->
   
  <xsl:template match="root">
      <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:apply-templates/>
      </xsl:element>
  </xsl:template>
    
    <xsl:function name="mam:date-check-iso" as="xs:boolean">
        <xsl:param name="datum" as="xs:string"/>
        <xsl:sequence select="matches($datum, '\d{4}-\d{2}-\d{2}')"/>
    </xsl:function>
    
    <xsl:function name="mam:date-check-german" as="xs:boolean">
        <xsl:param name="datum" as="xs:string"/>
        <xsl:sequence select="matches($datum, '\d{1,2}\.\d{1,2}\.\d{4}')"/>
    </xsl:function>
    
    
    <xsl:template match="*:row[(target_id = 2121 or source_id=2121 or target_id = 2173 or source_id=2173) and not(relation_start_date = 'nodate')]">
        <xsl:if test="mam:date-check-iso(relation_start_date_written[1]) or mam:date-check-german(relation_start_date_written[1])">
        <xsl:choose>
            <xsl:when test="(relation_start_date = relation_end_date) or (relation_end_date = 'nodate')">
                <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="when-iso">
                        <xsl:choose>
                            <xsl:when test="contains(relation_start_date, 'T00')">
                                <xsl:value-of select="substring-before(relation_start_date, 'T00')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="relation_start_date"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:value-of select="relation_name"/>
                    </xsl:element>
                    <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type">
                            <xsl:text>pmb</xsl:text>
                        </xsl:attribute>
                        <xsl:variable name="andere-id" >
                            <xsl:choose>
                                <xsl:when test="target_id = 2121">
                                    <xsl:value-of select="source_id"/>
                                </xsl:when>
                                <xsl:when test="source_id = 2121">
                                    <xsl:value-of select="target_id"/>
                                </xsl:when>
                                <xsl:when test="target_id = 2173">
                                    <xsl:value-of select="source_id"/>
                                </xsl:when>
                                <xsl:when test="source_id = 2173">
                                    <xsl:value-of select="target_id"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="concat('https://pmb.acdh.oeaw.ac.at/entity/', $andere-id, '/')"/>
                                          
                    </xsl:element>
                </xsl:element>
                
            </xsl:when>
        </xsl:choose></xsl:if>
        
    </xsl:template>
   
    
    
</xsl:stylesheet>
