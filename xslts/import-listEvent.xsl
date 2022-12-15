<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:param name="einzuarbeitendeListe"
        select="document('../individual-lists/schnitzler-bahr_tage.xml')"/>
    <xsl:key name="nachschlagen" match="tei:event" use="@when-iso"/>
    <xsl:param name="threshold" select="xs:date('1931-10-21')"/>
    <!-- kein Datum nach Schnitzlers Tod -->
    <xsl:template match="tei:listEvent[not(child::*)]"/>
    <xsl:template match="tei:body/tei:list/tei:item">
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:variable name="iso-datum" select="@sortKey" as="xs:date"/>
            <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>
            <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:for-each
                    select="collection(concat($folderURI, '?select=*_tage.xml;recurse=yes'))/descendant::tei:text[1]/tei:body[1]/descendant::tei:listEvent[1]/tei:event[@when-iso = $iso-datum]">
                    <xsl:variable name="einzuarbeitenderTyp" select="child::tei:idno[1]/@type"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
