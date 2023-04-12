<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="tei:desc[not(text() | child::*)]">
        <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="dateiname"
                select="parent::tei:event/tei:idno/replace(., '.html', '.xml')"/>
            <xsl:if test="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listPerson">
                <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listPerson/tei:person[not(@xml:id = 'pmb2121')]">
                        <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="ref">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="tei:persName[1][tei:forename and tei:surname]">
                                        <xsl:value-of
                                            select="concat(tei:persName[1]/tei:forename, ' ', tei:persName[1]/tei:surname)"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="fn:normalize-space(tei:persName[1])"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listBibl">
                <xsl:element name="listBibl" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listBibl/tei:bibl">
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="ref">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="fn:normalize-space(tei:title[1])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listPlace">
                <xsl:element name="listPlace" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listPlace/tei:place">
                        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="ref">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="fn:normalize-space(tei:placeName[1])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listOrg">
                <xsl:element name="listOrg" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="document($dateiname)/tei:TEI/tei:text/tei:back/tei:listOrg/tei:org">
                        <xsl:element name="org" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="ref">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="fn:normalize-space(tei:orgName[1])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
