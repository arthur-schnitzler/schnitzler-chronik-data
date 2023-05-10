<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:ns0="http://www.loc.gov/mods/v3"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    
    <!-- Nun die Umwandlung für schnitzler-tage -->
    
    <xsl:template match="records">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:call-template name="teiheader"/>
        <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:element>
        </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ns0:mods">
        <xsl:variable name="eintrag" select="." as="node()"/>        
        <xsl:for-each select="descendant::ns0:dateCreated/date[format-date(@when-iso, '[Y0001]-[M01]-[D01]') &lt; '1931-12-31' and format-date(@when-iso, '[Y0001]-[M01]-[D01]') &gt; '1862-05-14']">
            <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="when-iso">
                    <xsl:value-of select="@when-iso"/>
                </xsl:attribute>
                <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="normalize-space($eintrag/ns0:titleInfo/ns0:title)"/>
                </xsl:element>
                
                <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:choose>
                        <xsl:when test="@type='timespan-begin'">
                            <xsl:text>Erstes Objekt aus der Mappe. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@type='timespan-end'">
                            <xsl:text>Letztes Objekt aus der Mappe. </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$eintrag/ns0:abstract and $eintrag/ns0:physicalDescription">
                            <xsl:choose>
                                <xsl:when test="ends-with(normalize-space($eintrag/ns0:abstract), '.')">
                                    <xsl:choose>
                                        <xsl:when test="starts-with($eintrag/ns0:abstract, '. ')">
                                            <xsl:value-of select="replace(substring($eintrag/ns0:abstract, 3), '. . ', '. ')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace($eintrag/ns0:abstract, '. . ', '. ')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="normalize-space($eintrag/ns0:abstract)=''"/>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space($eintrag/ns0:abstract)"/><xsl:text>. </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>                            
                            <xsl:value-of select="normalize-space($eintrag/ns0:physicalDescription)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($eintrag/ns0:abstract)"/><xsl:text>. </xsl:text>
                            <xsl:value-of select="normalize-space($eintrag/ns0:physicalDescription)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$eintrag/ns0:name[@authority='GND' and not(contains(@valueURI, 'gnd/118609807'))]">
                        <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each select="$eintrag/ns0:name[@authority='GND' and not(contains(@valueURI, 'gnd/118609807'))]">
                                <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                        
                                    <xsl:attribute name="ref">
                                        <xsl:value-of select="@valueURI"/>
                                    </xsl:attribute>
                                        <xsl:value-of select="normalize-space(ns0:namePart)"/>
                                </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                
                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type">
                        <xsl:text>kalliope-verbund</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($eintrag/ns0:identifier[@type='uri'])"/>
                </xsl:element>
                
            </xsl:element>
            
            
        </xsl:for-each>
      
    </xsl:template>
    
    
    <xsl:template name="teiheader" as="node()">
        <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="level">
                            <xsl:text>s</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Export aus Kalliope-Verbund</xsl:text>
                    </xsl:element>
                    <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="level">
                            <xsl:text>a</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Taggenau datierte Ergebnisse zu Arthur Schnitzler</xsl:text>
                    </xsl:element>
                    <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>providing the content</xsl:text>
                        </xsl:element>
                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Martin Anton Müller</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>converted to XML encoding</xsl:text>
                        </xsl:element>
                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Martin Anton Müller</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>Austrian Centre for Digital Humanities and Cultural Heritage (ACDH-CH)</xsl:text>
                    </xsl:element>
                    <xsl:element name="pubPlace" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>Vienna, Austria</xsl:text>
                    </xsl:element>
                    <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:value-of select="fn:current-date()"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>Alle Ergebnisse für »Arthur Schnitzler« aus Kalliope, die mit
                        einem ISO-Datum datiert sind. Für Zeitspannen, die mit Schrägstrich getrennt
                        sind, wurde das erste und letzte Objekt berücksichtigt</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>