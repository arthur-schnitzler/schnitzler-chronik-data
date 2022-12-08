<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="3.0"
    exclude-result-prefixes="tei">
    <xsl:output method="xml" indent="true" omit-xml-declaration="yes"/>
    
    <xsl:template match="start">
        <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="TEI">
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="when-iso">
                <xsl:variable name="datum-ohne-striche" select="descendant::*[name()='date' or name()='origDate'][@n][1]/@*[not(name()='n')][1]"/>
                <xsl:value-of select="concat(substring($datum-ohne-striche, 1, 4), '-', substring($datum-ohne-striche, 5, 2), '-', substring($datum-ohne-striche, 7, 2))"/>
            </xsl:attribute>
            <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="descendant::titleStmt/title[@level='a'][1]"/>
            </xsl:element>
            <xsl:element name="idno">
                <xsl:attribute name="type">
                    <xsl:text>schnitzler-bahr</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="concat('https://schnitzler-bahr.acdh.oeaw.ac.at/', @xml:id, '.html')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
