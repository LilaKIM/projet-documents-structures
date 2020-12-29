<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="utf8"/>
<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title data-template="config:app-title">TAL M2 - Documents structurés</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta data-template="config:app-meta"/>
        <link rel="shortcut icon" href="$shared/resources/images/exist_icon_16x16.ico"/>
        <link rel="stylesheet" type="text/css" href="$shared/resources/css/bootstrap-3.0.3.min.css"/>
        <link rel="stylesheet" type="text/css" href="/db/apps/documents-structures/resources/css/style.css"/>
        <script type="text/javascript" src="$shared/resources/scripts/jquery/jquery-1.7.1.min.js"/>
        <script type="text/javascript" src="$shared/resources/scripts/loadsource.js"/>
        <script type="text/javascript" src="$shared/resources/scripts/bootstrap-3.0.3.min.js"/>
    </head>
    <body>
      <div>
        <div class="row">
          <div class="col-md-8">
            <div class="page-header">
              <h1 align="center">TAL M2 - Documents structurés</h1>
            </div>
            
            <div class="col-md-12">
              <h3 align="right"><xsl:value-of select="page/head/auteur"/></h3>
              <xsl:apply-templates select="page/body/presentation"/>
              <xsl:apply-templates select="page/body/difficulte"/>
            </div>
          </div>
          <div class="col-md-4">
            <h2><xsl:value-of select="local-name(page/body/navigation)"/></h2>
            <div>
              <ul>
                <xsl:apply-templates select="//link"/>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </body>
  </html>
</xsl:template>
  
<xsl:template match="link">
  <li>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </li>
</xsl:template>
  
<xsl:template match="presentation">
  <h4><xsl:value-of select="local-name(.)"/></h4>
  <div>
    <h5><xsl:value-of select="projet/titre"/></h5>
    <p><xsl:value-of select="projet/texte"/></p>
  </div>
  <div>
    <h5><xsl:value-of select="etapes/titre"/></h5>
    <xsl:apply-templates select="etapes/texte"/>
  </div>
</xsl:template>
  
<xsl:template match="difficulte">
  <h4><xsl:value-of select="local-name(.)"/></h4>
  <xsl:apply-templates select="texte"/>
</xsl:template>

<xsl:template match="texte">
  <p><xsl:value-of select="."/></p>
</xsl:template>
</xsl:stylesheet>