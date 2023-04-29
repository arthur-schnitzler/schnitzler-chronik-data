<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 https://www.loc.gov/standards/mods/v3/mods-3-7.xsd"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <!-- Das hier, angewandt auf das result.xml aus kallìas, löscht Einträge ohne
    Datumsangaben und markiert ISO-Daten. In Fällen, wo das Entstehungsdatum als Zeitraum mit Schrägstrich
    als zwei Isodaten angegeben wird, wird ein Attribut @type 'timespan-begin' resp. 'timespan-end'
    gesetzt
    -->
    <xsl:template match="ns0:mods[not(descendant::ns0:originInfo/ns0:dateCreated)]"/>
    <!-- Einträge ohne Daten löschen -->
    <xsl:template match="ns0:dateCreated/text()">
        <xsl:analyze-string select="."
            regex="(\d{{4}}-\d{{1,2}}-\d{{1,2}})/(\d{{4}}-\d{{1,2}}-\d{{1,2}})">
            <xsl:matching-substring>
                <xsl:element name="date">
                    <xsl:attribute name="when-iso">
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>timespan-begin</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="date">
                    <xsl:attribute name="when-iso">
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>timespan-end</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(\d{{4}}-\d{{1,2}}-\d{{1,2}})">
                    <xsl:matching-substring>
                        <xsl:element name="date">
                            <xsl:attribute name="when-iso">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>
