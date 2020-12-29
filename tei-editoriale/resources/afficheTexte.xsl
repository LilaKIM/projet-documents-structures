<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <div id="text">
            <div id="head">
                <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc"/>
            </div>
            <div id="body-text">
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc">
        <h2 id="title">
            <xsl:value-of select="tei:titleStmt/tei:title"/>
        </h2>
        <h3 id="author">
            <xsl:value-of select="tei:titleStmt/tei:author"/>
        </h3>
        <div id="metaData">
            <p>Date de publication : <xsl:value-of select="tei:publicationStmt/tei:date"/>
            </p>
            <p>Licence : <xsl:value-of select="tei:publicationStmt/tei:availability/tei:licence/@target"/>
            </p>
            <p>Date de source : <xsl:value-of select="../tei:profileDesc/tei:creation/tei:date"/>
            </p>
            <p>Source : <xsl:value-of select="tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:availability/tei:licence/@target"/>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@n='1']">
        <div id="part">
          <h4 id="head-text">
              <xsl:value-of select="tei:head"/>
          </h4>
          <xsl:apply-templates select="tei:div[@n='2']"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@n='2']">
        <h5 id="small-part">
            <xsl:value-of select="tei:head"/>
        </h5>
        <xsl:apply-templates select="tei:p"/>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
</xsl:stylesheet>