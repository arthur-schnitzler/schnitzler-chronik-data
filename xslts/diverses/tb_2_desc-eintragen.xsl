<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/listperson.xml')"
        name="tb_listPerson"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/listwork.xml')"
        name="tb_listWork"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/listplace.xml')"
        name="tb_listPlace"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/index_person_day.xml')"
        name="tb_index-person-day"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/index_work_day.xml')"
        name="tb_index-work-day"/>
    <xsl:param select="document('../../../schnitzler-tagebuch-data/indices/index_place_day.xml')"
        name="tb_index-place-day"/>
    <xsl:key name="person-name" match="tei:listPerson/tei:person" use="@xml:id"/>
    <xsl:key name="personentag" match="item" use="@target"/>
    <xsl:key name="work-name" match="tei:listBibl/tei:bibl" use="@xml:id"/>
    <xsl:key name="workstag" match="item" use="@target"/>
    <xsl:key name="place-name" match="tei:listPlace/tei:place" use="@xml:id"/>
    <xsl:key name="placestag" match="item" use="@target"/>
    
    <!-- Dieses XSLT funktioniert mit der Liste der Tage, entweder
    neu aufsetzen aus index-days.xml und der ersten xslt-transformation.
    oder die alte liste verwenden, dann rechnet es hier nur die desc-elemente
    neue-->
    
    <xsl:template match="tei:event">
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*|tei:head"/>
            
                <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if
                        test="key('personentag', @when-iso, $tb_index-person-day)/ref[1]">
                        <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each
                                select="key('personentag', @when-iso, $tb_index-person-day)/ref">
                                <xsl:variable name="current-id" select="."/>
                                <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="ref">
                                            <xsl:value-of select="$current-id"/>
                                        </xsl:attribute>
                                        <xsl:variable name="eintrag"
                                            select="key('person-name', $current-id, $tb_listPerson)/tei:persName[1]"/>
                                        <xsl:choose>
                                            <xsl:when test="$eintrag[tei:forename and tei:surname]">
                                                <xsl:value-of
                                                    select="concat($eintrag/tei:forename, ' ', $eintrag/tei:surname)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="fn:normalize-space($eintrag)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if
                        test="key('workstag', @when-iso, $tb_index-work-day)/ref[1]">
                        <xsl:element name="listBibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each
                                select="key('workstag', @when-iso, $tb_index-work-day)/ref">
                                <xsl:variable name="current-id" select="."/>
                                <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="ref">
                                            <xsl:value-of select="$current-id"/>
                                        </xsl:attribute>
                                        <xsl:variable name="eintrag"
                                            select="key('work-name', $current-id, $tb_listWork)/tei:title[1]"/>
                                        <xsl:value-of select="fn:normalize-space($eintrag)"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if
                        test="key('placestag', @when-iso, $tb_index-place-day)/placeName[1]">
                        <xsl:element name="listPlace" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each
                                select="key('placestag', @when-iso, $tb_index-place-day)/placeName">
                                <xsl:variable name="current-id" select="@ref"/>
                                <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="ref">
                                            <xsl:value-of select="$current-id"/>
                                        </xsl:attribute>
                                        <xsl:variable name="eintrag"
                                            select="key('place-name', $current-id, $tb_listPlace)/tei:placeName[1]"/>
                                        <xsl:value-of select="fn:normalize-space($eintrag)"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                
                
            
            
            
            <xsl:copy-of select="tei:idno"/>
        </xsl:element>
        
        
    </xsl:template>
    
    
    
      
</xsl:stylesheet>
