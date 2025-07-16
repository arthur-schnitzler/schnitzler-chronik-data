<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <!-- das hier nimmt wienerschnitzler.xml  schreibt es um listEvent -->
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    
    <xsl:param name="wiener-schnitzler" select="document('https://raw.githubusercontent.com/wiener-moderne-verein/wienerschnitzler-data/refs/heads/main/data/editions/xml/wienerschnitzler_complete_nested.xml')"></xsl:param>
    
    
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
                <xsl:attribute name="corresp">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
                <xsl:value-of select="child::tei:placeName[1]"/>
            </xsl:element>
            <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="tei:listPlace"/>
            </xsl:element>
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:text>wienerschnitzler</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="concat('https://wienerschnitzler.org/tag.html&#35;', ancestor::tei:event[1]/@when)"/>
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    
        
        
    
    <xsl:template match="tei:TEI">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Wiener Schnitzler – Schnitzlers Wien</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Arthur Schnitzler</name>
                            <name>Martin Anton Müller</name>
                            <name>Laura Untner</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <orgName>Austrian Centre for Digital Humanities, Austrian Academy of Sciences </orgName>
                            <address>
                                <addrLine>Bäckerstraße 13</addrLine>
                                <addrLine>1010 Vienna</addrLine>
                            </address>
                        </publisher>
                        <pubPlace ref="http://d-nb.info/gnd/4066009-6">Vienna</pubPlace>
                        <date when="2025">2025</date>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by/4.0/">
                                <p>The Creative Commons Attribution 4.0 International (CC BY 4.0) License applies
                                    to this text.</p>
                                <p>The CC BY 4.0 License also applies to this TEI XML file.</p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>This is data taken from https://wienerschnitzler.org/</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div>
                        <xsl:apply-templates select="$wiener-schnitzler/descendant::tei:text/tei:body/tei:div/tei:listEvent"/>
                    </div>
                </body>
            </text>
        </TEI>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>
