<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0" exclude-result-prefixes="tei">
    <xsl:output method="xml" indent="true" omit-xml-declaration="yes"/>
    <xsl:template match="root">
        <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="TEI"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="TEI">
        <xsl:variable name="eintrag" select="." as="node()"/>
        <xsl:for-each
            select="descendant::listBibl/biblStruct[descendant::imprint/date/@when[string-length(.) = 10]]">
            <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="when-iso">
                    <xsl:value-of select="descendant::imprint/date/@when"/>
                </xsl:attribute>
                <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="$eintrag/descendant::titleStmt/title[@level = 'a'][1]"/>
                </xsl:element>
                <xsl:element name="idno">
                    <xsl:attribute name="type">
                        <xsl:text>schnitzler-interviews</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of
                        select="concat('https://schnitzler-interviews.acdh.oeaw.ac.at/', $eintrag/@xml:id, '.html')"
                    />
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
