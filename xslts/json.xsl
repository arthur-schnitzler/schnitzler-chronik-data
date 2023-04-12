<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:df="http://example.com/df"
    version="3.0">
    <xsl:output method="text" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:template match="tei:TEI">
        <xsl:variable name="dateiname-json" as="xs:string"
            select="concat(normalize-space(@sortKey), '.json')"/>
        <!--<xsl:result-document href="{$dateiname-json}">-->
        <xsl:text>{&#10; "date":&#10; {&#10; "when-iso":&#10; "</xsl:text>
        <xsl:value-of select="@sortKey"/>
        <xsl:value-of select="descendant::tei:titleStmt/tei:title/@when-iso"/>
        <xsl:text>",&#10; "written":&#10; "</xsl:text>
        <xsl:value-of select="descendant::tei:titleStmt/tei:title[@when-iso]"/>
        <xsl:text>"&#10;},&#10;</xsl:text>
        <xsl:if test="descendant::tei:listEvent">
            <xsl:text>"listEvent":&#10; [</xsl:text>
            <xsl:apply-templates select="descendant::tei:listEvent/tei:event" mode="jsonlist"/>
            <xsl:text>] </xsl:text>
        </xsl:if>
        <xsl:text>&#10;}</xsl:text>
        <!--</xsl:result-document>-->
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:event">
        <xsl:text>{&#10; "type":&#10; "</xsl:text>
        <xsl:value-of select="tei:idno/@type"/>
        <xsl:if test="tei:idno/@subtype">
            <xsl:text>",&#10; "subtype":&#10; "</xsl:text>
            <xsl:value-of select="tei:idno/@subtype"/>
        </xsl:if>
        <xsl:if test="tei:idno[not(normalize-space(.) = '')]">
            <xsl:text>",&#10; "idno":&#10; "</xsl:text>
            <xsl:value-of select="tei:idno"/>
        </xsl:if>
        <xsl:text>",&#10; "head":&#10; "</xsl:text>
        <xsl:value-of select="tei:head"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="tei:desc[not(fn:normalize-space(.) = '')]">
            <xsl:text>,&#10; "desc":&#10;{</xsl:text>
            <xsl:for-each select="tei:desc/child::*">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>":&#10; </xsl:text>
                <xsl:apply-templates mode="jsonlist" select="."/>
                <xsl:if test="not(position() = last())">
                    <xsl:text>,&#10; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="text()[not(fn:normalize-space(.) = '')]">
                <xsl:if test="child::*">
                    <xsl:text>,&#10; </xsl:text>
                </xsl:if>
                <xsl:text> "text":&#10; "</xsl:text>
                <xsl:value-of select="text()[not(fn:normalize-space(.) = '')]"/>
                <xsl:text>" </xsl:text>
            </xsl:if>
            <xsl:text>}&#10;</xsl:text>
        </xsl:if>
        <xsl:text>&#10;}</xsl:text>
        <xsl:if test="not(fn:position() = last())">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listPerson">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:person">
            <xsl:text>{&#10; "persName":&#10; "</xsl:text>
            <xsl:value-of select="tei:persName"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:persName/@ref"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>,&#10; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listBibl">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:bibl">
            <xsl:text> {&#10; "title":&#10; "</xsl:text>
            <xsl:value-of select="tei:title"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:title/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listPlace">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:place">
            <xsl:text> {&#10; "title":&#10; "</xsl:text>
            <xsl:value-of select="tei:placeName"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:placeName/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:listOrg">
        <xsl:text> [&#10;</xsl:text>
        <xsl:for-each select="tei:org">
            <xsl:text> {&#10; "title":&#10; "</xsl:text>
            <xsl:value-of select="tei:orgName"/>
            <xsl:text>",&#10; "ref":&#10; "</xsl:text>
            <xsl:value-of select="tei:orgName/@ref"/>
            <xsl:text>"}&#10; </xsl:text>
            <xsl:if test="not(fn:position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template mode="jsonlist" match="tei:event/tei:desc/tei:bibl">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
</xsl:stylesheet>
