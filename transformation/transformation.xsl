<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"/>

    <xsl:template match="/office:document-content/office:body/office:text">
        <xsl:variable name="name"><xsl:value-of select="lower-case(/office:document-content/office:body/office:text/text:p[contains(@text:style-name/data(),'Title')])"/></xsl:variable>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <xsl:copy-of select="meta:titleStmt($name)"/>
                    <editionStmt>
                        <edition></edition>
                    </editionStmt>
                    <xsl:copy-of select="meta:publicationStmt('Date de la publication', $name)"/>
                    <xsl:copy-of select="meta:sourceDesc($name)"/>
                </fileDesc>
                <encodingDesc>
                    <xsl:copy-of select="meta:projectDesc($name)"/>
                </encodingDesc>
            </teiHeader>
            <text>
                <body>
                    <head><xsl:value-of select="text:p[contains(@text:style-name/data(),'Title')]"/></head>
                    <xsl:choose>
                        <xsl:when test="text:h[contains(@text:style-name/data(),'Heading_20_1')]">
                            <xsl:apply-templates select="text:h[contains(@text:style-name/data(),'Heading_20_1')] "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="text:h[contains(@text:style-name/data(),'Heading_20_2')]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:function name="meta:projectDesc">
        <xsl:param name="name" as="xs:string"/>
        <projectDesc>
            <p><xsl:value-of select="meta:add('Description', $name)"/></p>
        </projectDesc>
    </xsl:function>
    
    <xsl:function name="meta:sourceDesc">
        <xsl:param name="name" as="xs:string"/>
        <sourceDesc>
            <biblFull>
                <xsl:copy-of select="meta:titleStmt($name)"/>
                <xsl:copy-of select="meta:publicationStmt('Date de la source', $name)"/>
            </biblFull>
        </sourceDesc>
    </xsl:function>
    
    <xsl:function name="meta:titleStmt">
        <xsl:param name="name" as="xs:string"/>
        <titleStmt>
            <title>
                <xsl:value-of select="meta:add('Titre', $name)"/>
            </title>
            <author>
                <xsl:value-of select="meta:add('Auteur', $name)"/>
            </author>
        </titleStmt>
    </xsl:function>
    
    <xsl:function name="meta:add" as="xs:string">
        <xsl:param name="x" as="xs:string" required="yes"/>
        <xsl:param name="name" as="xs:string" required="yes"/>
        <xsl:variable name="chemin"><xsl:value-of select="concat('/Users/lilakim/Desktop/M2_1/Documents_structures/x/', $name, '/meta.xml')"/></xsl:variable>
        <xsl:value-of select="document($chemin)/office:document-meta/office:meta/meta:user-defined[contains(@meta:name/data(), $x)]"/>
    </xsl:function>
    
    <xsl:function name="meta:publicationStmt">
        <xsl:param name="date" as="xs:string"/>
        <xsl:param name="name" as="xs:string" required="yes"/>
        <publicationStmt>
            <authority></authority>
            <publisher></publisher>
            <availability>
                <licence><xsl:attribute name="target"><xsl:value-of select="meta:add('Licence', $name)"/></xsl:attribute></licence>
            </availability>
            <date><xsl:value-of select="meta:add($date, $name)"/></date>
        </publicationStmt>
    </xsl:function>
    
    <xsl:template match="text:h[contains(@text:style-name/data(),'Heading_20_1')]">
    <xsl:variable name="header-id" select="generate-id(.)"/>
    <div>
        <xsl:attribute name="n"><xsl:value-of select="@text:outline-level"/></xsl:attribute>
        <head><xsl:apply-templates/></head>
        <xsl:for-each select="following-sibling::text:h[contains(@text:style-name/data(),'Heading_20_2')][generate-id(preceding-sibling::text:h[contains(@text:style-name/data(),'Heading_20_1')][1]) = $header-id]">
            <div>
                <xsl:attribute name="n"><xsl:value-of select="@text:outline-level"/></xsl:attribute>
                <head>
                    <xsl:apply-templates/>
                </head>
                <xsl:variable name="div-2" select="generate-id(.)"/>
                <xsl:for-each select="following-sibling::text:p[contains(@text:style-name,'Text_20_body')][generate-id(preceding-sibling::text:h[contains(@text:style-name/data(),'Heading_20_2')][1]) = $div-2]">
                    <p><xsl:apply-templates/></p>
                </xsl:for-each>
            </div>
        </xsl:for-each>
    </div>
    </xsl:template>
    
    <xsl:template match="text:h[contains(@text:style-name/data(),'Heading_20_2')]">
        <xsl:variable name="div-2" select="generate-id(.)"/>
        <div>
            <xsl:attribute name="n"><xsl:value-of select="@text:outline-level"/></xsl:attribute>
            <head>
                <xsl:apply-templates/>
            </head>
            
            <xsl:for-each select="following-sibling::text:p[contains(@text:style-name,'Text_20_body')][generate-id(preceding-sibling::text:h[contains(@text:style-name/data(),'Heading_20_2')][1]) = $div-2]">
                <p><xsl:apply-templates/></p>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="text:span">
        <hi>
            <xsl:attribute name="rend" select="@text:style-name"/>
            <xsl:apply-templates select="text()"/>
        </hi>
    </xsl:template>
    
    <xsl:template match="Title/text()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>