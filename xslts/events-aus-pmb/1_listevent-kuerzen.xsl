<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:number="http://dummy/" xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all"
    xmlns:functx="http://www.functx.com" version="3.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="false"/>
    <!-- Dieses XSLT wird auf die bestehende Datei
        pmb-event_tage.xml angewandt und ersetzt sie durch
        die neuesten Daten aus der PMB: 
        https://pmb.acdh.oeaw.ac.at/media/listevent.xml
        (anpassung eventName -> head, alles in desc)
    -->
    
    <xsl:param name="listEvent" select="document('https://pmb.acdh.oeaw.ac.at/media/listevent.xml')"/>
   
  <xsl:template match="/">
      <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
      <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                  <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:attribute name="level">
                          <xsl:text>s</xsl:text>
                      </xsl:attribute>
                      <xsl:text>Arthur Schnitzler: Briefwechsel mit Autorinnen und
                        Autoren</xsl:text>
                  </xsl:element>
                  <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:attribute name="level">
                          <xsl:text>a</xsl:text>
                      </xsl:attribute>
                      <xsl:text>Verzeichnis der Ereignisse</xsl:text>
                  </xsl:element>
                  <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                          <xsl:text>providing the content</xsl:text>
                      </xsl:element>
                      <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                          <xsl:text>Martin Anton Müller</xsl:text>
                      </xsl:element>
                      <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                          <xsl:text>Gerd-Hermann Susen</xsl:text>
                      </xsl:element>
                      <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                          <xsl:text>Laura Untner</xsl:text>
                      </xsl:element>
                      <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                          <xsl:text>PMB (Personen der Moderne Basis)</xsl:text>
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
                  <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:attribute name="type">
                          <xsl:text>URI</xsl:text>
                      </xsl:attribute>
                      <xsl:value-of
                          select="'https://id.acdh.oeaw.ac.at/arthur-schnitzler-briefe/v1/indices/listevent.xml'"
                      />
                  </xsl:element>
                  <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:attribute name="type">
                          <xsl:text>handle</xsl:text>
                      </xsl:attribute>
                      <xsl:text>XXXX</xsl:text>
                  </xsl:element>
              </xsl:element>
              <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                  <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                      <xsl:text>Entitäten für die Edition der beruflichen Korrespondenz Schnitzlers</xsl:text>
                  </xsl:element>
              </xsl:element>
          </xsl:element>
      </xsl:element>
      <xsl:element name="text">
          <xsl:element name="body">
              <xsl:apply-templates select="$listEvent/descendant::tei:body/tei:listEvent"/>
          </xsl:element>
      </xsl:element>
      
      </xsl:element>
  </xsl:template>
   
    <xsl:template match="tei:event[descendant::tei:persName/@key='pmb2121']">
        <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="when-iso">
                <xsl:value-of select="@when-iso"/>
            </xsl:attribute>
            <xsl:apply-templates select="tei:eventName"/>
            <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates select="tei:listPerson|tei:listPlace|tei:listBibl[not(child::tei:bibl/@type='collections')]|tei:note[@type='listorg']/tei:listOrg"/>
            </xsl:element>
            <xsl:apply-templates select="tei:idno"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:eventName">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:event[not(descendant::tei:persName/@key='pmb2121')]"/>
    
    <xsl:template match="tei:idno[@subtype='pmb' and @type='URL']">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:text>pmb</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
