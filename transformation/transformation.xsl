<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0">
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="name"><xsl:value-of select="lower-case(/office:document-content/office:body/office:text/text:p[contains(@text:style-name/data(),'Title')])"/></xsl:variable>
        <TEI>
            <teiHeader>
                <fileDesc>
                    <xsl:copy-of select="meta:titleStmt($name)"/>
                    <editionStmt/>
                    <xsl:copy-of select="meta:publicationStmt('Date de la publication', $name)"/>
                    <xsl:copy-of select="meta:sourceDesc($name)"/>
                </fileDesc>
                <encodingDesc>
                    <xsl:copy-of select="meta:projectDesc($name)"/>
                </encodingDesc>
            </teiHeader>
            <text>
                <body>
                    <head>
                        <xsl:apply-templates select="//text:p[contains(@text:style-name/data(),'Title')]"/>
                    </head>
                    <xsl:choose>
                        <xsl:when test="//text:h[contains(@text:style-name/data(),'Heading_20_1')]">
                            <xsl:apply-templates select="//text:h[contains(@text:style-name/data(),'Heading_20_1')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="//text:h[contains(@text:style-name/data(),'Heading_20_2')]"/>
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
            <availability>
                <licence><xsl:attribute name="target"><xsl:value-of select="meta:add('Licence', $name)"/></xsl:attribute></licence>
            </availability>
            <date><xsl:value-of select="meta:add($date, $name)"/></date>
        </publicationStmt>
    </xsl:function>
    
    <xsl:template match="//text:p[contains(@text:style-name/data(),'Title')]">
        <xsl:value-of select="./text()"/>
    </xsl:template>
    
    <xsl:template match="text:h[contains(@text:style-name/data(),'Heading_20_1')]">
        <div><xsl:attribute name="n"><xsl:value-of select="@text:outline-level/data()"/></xsl:attribute>
            <head><xsl:value-of select="."/></head>
            <xsl:apply-templates select="//text:h[contains(@text:style-name/data(),'Heading_20_2')]"/>  
        </div>
    </xsl:template>
    
    <xsl:template match="text:h[contains(@text:style-name/data(),'Heading_20_2')]">
        <div><xsl:attribute name="n"><xsl:value-of select="@text:outline-level/data()"/></xsl:attribute>
            <xsl:variable name="text"><xsl:value-of select="text()"/></xsl:variable>
            <head>
                <xsl:for-each select="tokenize($text)">
                    <xsl:copy-of select="text:write_text($text, .,0)"/>
                </xsl:for-each>
            </head>
            <xsl:apply-templates select="//text:p[contains(@text:style-name/data(),'Text_20_body')]"/>
        </div>
    </xsl:template>
    
    <xsl:template match="text:p[contains(@text:style-name/data(),'Text_20_body')]">
        <xsl:variable name="text"><xsl:value-of select="text()"/></xsl:variable>
        <xsl:variable name="token"><xsl:value-of select="tokenize($text)"/></xsl:variable>
        <p>
            <xsl:for-each select="tokenize($text)">
                <xsl:copy-of select="text:write_text($text, .,1)"/>
            </xsl:for-each>
        </p>
    </xsl:template>
    
    <xsl:function name="text:write_text">
        <xsl:param name="text" as="xs:string" required="yes"/>
        <xsl:param name="token" as="xs:string" required="yes"/>
        <xsl:param name="mode" as="xs:integer" required="yes"/>
            <xsl:choose>
                <xsl:when test="not(matches(substring($token,1,1),'^[a-zA-Z]+$'))">
                    <pc><xsl:value-of select="substring($token,1,1)"/></pc>
                    <w><xsl:value-of select="substring($token,2)"/></w>
                    <c><xsl:value-of select="substring(substring-after($text, $token),1,1)"/></c>
                </xsl:when>
                <xsl:when test="not(matches(substring($token,string-length($token)-1,1),'^[a-zA-Z]+$'))
                    and not(matches(substring($token,string-length($token),1),'^[a-zA-Z]+$'))">
                    <w><xsl:value-of select="substring($token,1,string-length($token)-2)"/></w>
                    <pc><xsl:value-of select="substring($token,string-length($token)-1,1)"/></pc>
                    <pc><xsl:value-of select="substring($token,string-length($token),1)"/></pc>
                </xsl:when>
                <xsl:when test="not(matches(substring($token,string-length($token),1),'^[a-zA-Z]+$'))">
                    <w><xsl:value-of select="substring($token,1,string-length($token)-1)"/></w>
                    <pc><xsl:value-of select="substring($token,string-length($token),1)"/></pc>
                </xsl:when>
                <xsl:when test="substring(substring-after($text, $token),1,1)=' '">
                    <w><xsl:value-of select="$token"/></w>
                    <c><xsl:value-of select="substring(substring-after($text, $token),1,1)"/></c>
                </xsl:when>
                <xsl:otherwise>
                    <w><xsl:value-of select="$token"/></w>
                    <xsl:if test="$mode = 1">
                        <c><xsl:text> </xsl:text></c>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
