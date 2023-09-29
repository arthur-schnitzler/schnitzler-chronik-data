<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:foo="whatever" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <!-- Diese Datei, angewandt auf 
        schnitzler-ohne-dubletten
        oder
        schnitzler-briefe_cmif.xml d
    holt alle gedruckten Briefe raus, schnitzler-briefe wird
    ignoriert. Briefe an Schnitzler werden dem mutmaßlichen Empfang geordnet.
    Wenn die Zeile 70 abgeändert wird, geht das ganze auch mit schnitzler-briefe-cmif
    -->
    <xsl:template match="tei:profileDesc">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Arthur Schnitzler CMIF</title>
                        <respStmt>
                            <resp>providing the content</resp>
                            <name>Arthur Schnitzler</name>
                            <name>Martin Anton Müller</name>
                            <name>Laura Untner</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <orgName>Austrian Centre for Digital Humanities, Austrian Academy of
                                Sciences </orgName>
                            <address>
                                <addrLine>Sonnenfelsgasse 19</addrLine>
                                <addrLine>1010 Vienna</addrLine>
                            </address>
                        </publisher>
                        <pubPlace ref="http://d-nb.info/gnd/4066009-6">Vienna</pubPlace>
                        <date when="2022">2022</date>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by/4.0/">
                                <p>The Creative Commons Attribution 4.0 International (CC BY 4.0)
                                    License applies to this text.</p>
                                <p>The CC BY 4.0 License also applies to this TEI XML file.</p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Basically all printed letters from Schnitzler that can be located within
                            a time-frame of 5 days.</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div>
                        <xsl:element name="listEvent" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:function name="foo:loop-string">
        <!-- Diese Funktion gibt eine sequence aus, mit der Anzahl notwendigen
    Iterationen als x, die in Folge tokenisiert wird-->
        <xsl:param name="current-number"/>
        <xsl:param name="duration"/>
        <xsl:text>x,</xsl:text>
        <xsl:if test="$current-number &lt; $duration">
            <xsl:value-of select="foo:loop-string($current-number + 1, $duration)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:correspDesc">
    <!--<xsl:template match="tei:correspDesc[not(starts-with(@ref, 'https://schnitzler-briefe.'))]">-->
        <!-- Diese Variable gibt die einzelnen Daten aus, bei denen ein Eintrag erstellt werden soll -->
        <xsl:variable name="entry" select="."/>
        <xsl:variable name="unsicheres-absendedatum" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="$entry/tei:correspAction[1]/tei:date[@cert = 'low']">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="unsicheres-empfangsdatum" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="$entry/tei:correspAction[last()]/tei:date[@cert = 'low']">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="werk" select="replace(@source, '#', '')"/>
        <xsl:variable name="werk-inhalt"
            select="ancestor::tei:TEI/descendant::tei:sourceDesc[1]/tei:listBibl/tei:bibl[@xml:id = $werk]/text()"/>
        <xsl:variable name="beteiligte-personen" as="node()?">
            <xsl:if test="descendant::tei:persName[not(@ref = 'https://d-nb.info/gnd/118609807')]">
                <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="descendant::tei:persName[not(@ref = 'https://d-nb.info/gnd/118609807')]">
                        <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:copy-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="beteiligte-organisationen" as="node()?">
            <xsl:if test="descendant::tei:orgName">
                <xsl:element name="listOrg" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each select="descendant::tei:orgName">
                        <xsl:element name="org" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:copy-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="beteiligte-entitaeten" as="node()?">
            <xsl:if test="descendant::tei:ab[@type='entitaeten']">
                <xsl:copy-of select="descendant::tei:ab[@type='entitaeten']"/>
            </xsl:if>
        </xsl:variable>
        <!-- 1) Alle Briefe -->
        <xsl:variable name="zeitraum" as="node()">
            <xsl:element name="dates">
                <xsl:choose>
                    <xsl:when test="child::tei:correspAction[1]/tei:date/@when">
                        <xsl:element name="date">
                            <xsl:attribute name="when">
                                <xsl:value-of select="child::tei:correspAction[1]/tei:date/@when"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="child::tei:correspAction[1]/tei:date[@from and @to]">
                        <xsl:variable name="from"
                            select="child::tei:correspAction[1]/tei:date/xs:date(@from)"/>
                        <xsl:variable name="to"
                            select="child::tei:correspAction[1]/tei:date/xs:date(@to)"/>
                        <xsl:variable name="duration" select="fn:days-from-duration($to - $from)"/>
                        <xsl:if test="$duration &lt; 9">
                            <xsl:variable name="loopstring">
                                <xsl:sequence select="foo:loop-string(1, $duration)"/>
                            </xsl:variable>
                            <xsl:for-each select="tokenize($loopstring, ',')">
                                <xsl:variable name="i" select="position() - 1"/>
                                <xsl:element name="date">
                                    <xsl:attribute name="when">
                                        <xsl:value-of
                                            select="$from + xs:dayTimeDuration(concat('P', $i, 'D'))"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="child::tei:correspAction[1]/tei:date[@notBefore and @notAfter]">
                        <xsl:variable name="from"
                            select="child::tei:correspAction[1]/tei:date/xs:date(@notBefore)"/>
                        <xsl:variable name="to"
                            select="child::tei:correspAction[1]/tei:date/xs:date(@notAfter)"/>
                        <xsl:variable name="duration" select="fn:days-from-duration($to - $from)"/>
                        <xsl:if test="$duration &lt; 9">
                            <xsl:variable name="loopstring">
                                <xsl:sequence select="foo:loop-string(1, $duration)"/>
                            </xsl:variable>
                            <xsl:for-each select="tokenize($loopstring, ',')">
                                <xsl:variable name="i" select="position() - 1"/>
                                <xsl:element name="date">
                                    <xsl:attribute name="when">
                                        <xsl:value-of
                                            select="$from + xs:dayTimeDuration(concat('P', $i, 'D'))"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:variable>
        <xsl:for-each select="$zeitraum/date">
            <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="when-iso">
                    <xsl:value-of select="@when"/>
                </xsl:attribute>
                <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each select="$entry/tei:correspAction[1]/tei:persName">
                        <xsl:value-of select="foo:nameUmreihenBeimKomma(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="$entry/tei:correspAction[1]/tei:orgName">
                        <xsl:value-of select="$entry/tei:correspAction[1]/tei:orgName"/>
                    </xsl:if>
                    <xsl:text> an </xsl:text>
                    <xsl:for-each select="$entry/tei:correspAction[last()]/tei:persName">
                        <xsl:value-of select="foo:nameUmreihenBeimKomma(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="$entry/tei:correspAction[last()]/tei:orgName">
                        <xsl:value-of select="$entry/tei:correspAction[last()]/tei:orgName"/>
                    </xsl:if>
                    <xsl:text>, </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$entry/tei:correspAction[1]/tei:date[1]/text() != ''">
                            <xsl:value-of select="$entry/tei:correspAction[1]/tei:date[1]/text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$entry/tei:correspAction[1]/tei:date/@when">
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@when, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="$entry/tei:correspAction[1]/tei:date/@from and $entry/tei:correspAction[1]/tei:date/@to">
                                    <xsl:text>zwischen </xsl:text>
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@from, '[D1o][M1o][Y]', 'de', (), ())"/>
                                    <xsl:text> und </xsl:text>
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@to, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when test="$entry/tei:correspAction[1]/tei:date/@from">
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@from, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="$entry/tei:correspAction[1]/tei:date/@notBefore and $entry/tei:correspAction[1]/tei:date/@notAfter">
                                    <xsl:text>nach </xsl:text>
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notBefore, '[D1o][M1o][Y]', 'de', (), ())"/>
                                    <xsl:text> und vor </xsl:text>
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notAfter, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when test="$entry/tei:correspAction[1]/tei:date/@notBefore">
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notBefore, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when test="$entry/tei:correspAction[1]/tei:date/@to">
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@to, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                                <xsl:when test="$entry/tei:correspAction[1]/tei:date/@notAfter">
                                    <xsl:value-of
                                        select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notAfter, '[D1o][M1o][Y]', 'de', (), ())"
                                    />
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$unsicheres-absendedatum">
                        <xsl:text>?</xsl:text>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:choose>
                        <xsl:when test="$beteiligte-entitaeten//tei:persName">
                            <xsl:copy-of select="$beteiligte-entitaeten/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="$beteiligte-personen//tei:person">
                                <xsl:copy-of select="$beteiligte-personen"/>
                            </xsl:if>
                            <xsl:if test="$beteiligte-organisationen//tei:org">
                                <xsl:copy-of select="$beteiligte-organisationen"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$werk-inhalt and not($werk-inhalt='')">
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="$werk-inhalt"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="contains($entry/@ref, 'schnitzler-briefe')">
                        <xsl:attribute name="type">
                        <xsl:text>schnitzler-briefe</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$entry/@ref"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="type">
                        <xsl:text>schnitzler-cmif</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="$entry/@source"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <!-- 2. Schnitzler erhält Briefe -->
        <xsl:if test="tei:correspAction[last()]/tei:persName[contains(@ref, '118609807')]">
            <!-- Diese Variable gibt die einzelnen Daten aus, bei denen ein Eintrag erstellt werden soll -->
            <xsl:variable name="zeitraum-erhalt" as="node()">
                <xsl:element name="dates">
                    <xsl:choose>
                        <xsl:when test="child::tei:correspAction[last()]/tei:date/@when">
                            <xsl:element name="date">
                                <xsl:attribute name="when">
                                    <xsl:value-of
                                        select="child::tei:correspAction[last()]/tei:date/@when"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="child::tei:correspAction[last()]/tei:date[@from and @to]">
                            <xsl:variable name="from"
                                select="child::tei:correspAction[last()]/tei:date/xs:date(@from)"/>
                            <xsl:variable name="to"
                                select="child::tei:correspAction[last()]/tei:date/xs:date(@to)"/>
                            <xsl:variable name="duration"
                                select="fn:days-from-duration($to - $from)"/>
                            <xsl:if test="$duration &lt; 9">
                                <xsl:variable name="loopstring">
                                    <xsl:sequence select="foo:loop-string(1, $duration)"/>
                                </xsl:variable>
                                <xsl:for-each select="tokenize($loopstring, ',')">
                                    <xsl:variable name="i" select="position() - 1"/>
                                    <xsl:element name="date">
                                        <xsl:attribute name="when">
                                            <xsl:value-of
                                                select="$from + xs:dayTimeDuration(concat('P', $i, 'D'))"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when
                            test="child::tei:correspAction[last()]/tei:date[@notBefore and @notAfter]">
                            <xsl:variable name="from"
                                select="child::tei:correspAction[last()]/tei:date/xs:date(@notBefore)"/>
                            <xsl:variable name="to"
                                select="child::tei:correspAction[last()]/tei:date/xs:date(@notAfter)"/>
                            <xsl:variable name="duration"
                                select="fn:days-from-duration($to - $from)"/>
                            <xsl:if test="$duration &lt; 9">
                                <xsl:variable name="loopstring">
                                    <xsl:sequence select="foo:loop-string(1, $duration)"/>
                                </xsl:variable>
                                <xsl:for-each select="tokenize($loopstring, ',')">
                                    <xsl:variable name="i" select="position() - 1"/>
                                    <xsl:element name="date">
                                        <xsl:attribute name="when">
                                            <xsl:value-of
                                                select="$from + xs:dayTimeDuration(concat('P', $i, 'D'))"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </xsl:variable>
            <xsl:for-each select="$zeitraum-erhalt/date">
                <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="when-iso">
                        <xsl:value-of select="@when"/>
                    </xsl:attribute>
                    <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>Erhalt von </xsl:text>
                        <xsl:for-each select="$entry/tei:correspAction[1]/tei:persName">
                            <xsl:value-of select="foo:nameUmreihenBeimKomma(.)"/>
                            <xsl:if test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$entry/tei:correspAction[1]/tei:orgName">
                            <xsl:value-of select="$entry/tei:correspAction[1]/tei:orgName"/>
                        </xsl:if>
                        <xsl:text> an </xsl:text>
                        <xsl:for-each select="$entry/tei:correspAction[last()]/tei:persName">
                            <xsl:value-of select="foo:nameUmreihenBeimKomma(.)"/>
                            <xsl:if test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$entry/tei:correspAction[last()]/tei:orgName">
                            <xsl:value-of select="$entry/tei:correspAction[last()]/tei:orgName"/>
                        </xsl:if>
                        <xsl:text>, </xsl:text>
                        <xsl:choose>
                            <xsl:when test="$entry/tei:correspAction[1]/tei:date[1]/text() != ''">
                                <xsl:value-of
                                    select="$entry/tei:correspAction[1]/tei:date[1]/text()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$entry/tei:correspAction[1]/tei:date/@when">
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@when, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="$entry/tei:correspAction[1]/tei:date/@from and $entry/tei:correspAction[1]/tei:date/@to">
                                        <xsl:text>zwischen </xsl:text>
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@from, '[D1o][M1o][Y]', 'de', (), ())"/>
                                        <xsl:text> und </xsl:text>
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@to, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$entry/tei:correspAction[1]/tei:date/@from">
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@from, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="$entry/tei:correspAction[1]/tei:date/@notBefore and $entry/tei:correspAction[1]/tei:date/@notAfter">
                                        <xsl:text>nach </xsl:text>
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notBefore, '[D1o][M1o][Y]', 'de', (), ())"/>
                                        <xsl:text>und vor </xsl:text>
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notAfter, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$entry/tei:correspAction[1]/tei:date/@notBefore">
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notBefore, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$entry/tei:correspAction[1]/tei:date/@to">
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@to, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$entry/tei:correspAction[1]/tei:date/@notAfter">
                                        <xsl:value-of
                                            select="fn:format-date($entry/tei:correspAction[1]/tei:date/@notAfter, '[D1o][M1o][Y]', 'de', (), ())"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$unsicheres-empfangsdatum">
                            <xsl:text>?</xsl:text>
                        </xsl:if>
                    </xsl:element>
                    <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:if test="$beteiligte-personen//tei:person">
                            <xsl:copy-of select="$beteiligte-personen"/>
                        </xsl:if>
                        <xsl:if test="$beteiligte-organisationen//tei:org">
                            <xsl:copy-of select="$beteiligte-organisationen"/>
                        </xsl:if>
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="$werk-inhalt"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type">
                            <xsl:text>schnitzler-cmif</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="$entry/@source"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:function name="foo:nameUmreihenBeimKomma">
        <xsl:param name="eingangsString" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="contains($eingangsString, ', ')">
                <xsl:value-of
                    select="concat(substring-after($eingangsString, ', ')[1], ' ', substring-before($eingangsString, ', ')[1])"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$eingangsString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
