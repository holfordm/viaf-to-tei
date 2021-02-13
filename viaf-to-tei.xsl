<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" 
    xmlns:owl="http://www.w3.org/2002/07/owl#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:void="http://rdfs.org/ns/void#" 
    xmlns:ns1="http://viaf.org/viaf/terms#"
    version="2.0">
    
  
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <xsl:variable name="viafid" select="substring-after(@xml:id, '_')"/>
        <person>
            <xsl:attribute name="xml:id" select="@xml:id"/>
       
        
            <xsl:call-template name="callviaf">
                <xsl:with-param name="viafid" select="$viafid"/>
            </xsl:call-template>
           
        <xsl:apply-templates></xsl:apply-templates>
        </person>
    </xsl:template>
    
    
    
    <xsl:template name="callviaf">
        <xsl:param name="viafid"/>
        
        <!-- get VIAF xml -->
        <xsl:variable name="url" select="concat('https://viaf.org/viaf/', $viafid, '/viaf.xml')"/>
        <xsl:variable name="viafxml" select="document($url)"/>
        
        
        <!-- set up variables for types of heading, variants, sources -->
        <xsl:variable name="mainHeadings" select="$viafxml//ns1:mainHeadingEl"/>
        <xsl:variable name="variants" select="$viafxml//ns1:x400"/>
        <xsl:variable name="viaf_sources" select="$viafxml//ns1:VIAFCluster/ns1:sources//ns1:source"/>
        
            
            <!-- preferred forms
                Look for preferred forms in the following order 
            -->
            
            <xsl:choose>
                <!-- if more than one preferred form from a preferred source, choose the first -->
                <xsl:when test="$mainHeadings//ns1:sources/ns1:s='LC'">
                    <xsl:variable name="data" select="$mainHeadings[descendant::ns1:sources/ns1:s='LC'][1]"/>
                    <xsl:call-template name="persname">
                        <xsl:with-param name="type" select="'variant'"/>
                        <xsl:with-param name="source" select="'LC'"/>
                        <xsl:with-param name="data" select="$data"></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$mainHeadings//ns1:sources/ns1:s='DNB'">
                    <xsl:variable name="data" select="$mainHeadings[descendant::ns1:sources/ns1:s='DNB'][1]"/>
                    <xsl:call-template name="persname">
                        <xsl:with-param name="type" select="'variant'"/>
                        <xsl:with-param name="source" select="'DNB'"/>
                        <xsl:with-param name="data" select="$data"></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$mainHeadings//ns1:sources/ns1:s='BNF'">
                    <xsl:variable name="data" select="$mainHeadings[descendant::ns1:sources/ns1:s='BNF'][1]"/>
                    <xsl:call-template name="persname">
                        <xsl:with-param name="type" select="'variant'"/>
                        <xsl:with-param name="source" select="'BNF'"/>
                        <xsl:with-param name="data" select="$data"></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:variable name="data" select="$mainHeadings[1]"/>
                        <xsl:call-template name="persname">
                            <xsl:with-param name="type" select="'variant'"/>
                            <xsl:with-param name="source" select="$data//ns1:sources/ns1:s"/>
                            <xsl:with-param name="data" select="$data"></xsl:with-param>
                        </xsl:call-template>
                    
                </xsl:otherwise>
            </xsl:choose>
            
            
            <!-- variants. 
                choose only variants provided by one library, in case the VIAF record contains an incorrect merge
                Look for variants from the following sources in this order. DNB/GND is usually the best for medieval names  -->
            
            <xsl:choose>
                <xsl:when test="$variants/ns1:sources/ns1:s[.='DNB']">
                    
                    <xsl:for-each select="$variants[descendant::ns1:s='DNB']">
                    <xsl:call-template name="persname">
                        <xsl:with-param name="type" select="'variant'"/>
                        <xsl:with-param name="source" select="'DNB'"/>
                        <xsl:with-param name="data" select="."></xsl:with-param>
                    </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$variants/ns1:sources/ns1:s[.='LC']">
                    
                    <xsl:for-each select="$variants[descendant::ns1:s='LC']">
                        <xsl:call-template name="persname">
                            <xsl:with-param name="type" select="'variant'"/>
                            <xsl:with-param name="source" select="'LC'"/>
                            <xsl:with-param name="data" select="."></xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$variants/ns1:sources/ns1:s[.='BNF']">
                    
                    <xsl:for-each select="$variants[descendant::ns1:s='BNF']">
                        <xsl:call-template name="persname">
                            <xsl:with-param name="type" select="'variant'"/>
                            <xsl:with-param name="source" select="'BNF'"/>
                            <xsl:with-param name="data" select="."></xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$variants/ns1:sources/ns1:s[.='SUDOC']">
                    <xsl:for-each select="$variants[descendant::ns1:s='SUDOC']">
                        <xsl:call-template name="persname">
                            <xsl:with-param name="type" select="'variant'"/>
                            <xsl:with-param name="source" select="'SUDOC'"/>
                            <xsl:with-param name="data" select="."></xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
               
                
                <xsl:otherwise>
                    <xsl:comment>no variants found in preferred sources</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
           
            
            
            <!-- dates. Do not include dates with a value of '0' -->
            <xsl:if test="$viafxml//ns1:birthDate != '0'">
                <birth>
                <xsl:attribute name="source" select="'VIAF'"/>
                <xsl:attribute name="when">
                    <!-- 'negative' dates -->
                    <xsl:choose>
                        <xsl:when test="$viafxml//ns1:birthDate[starts-with(., '-')]">
                            <xsl:variable name="tempBirthDate" select="substring-after($viafxml//ns1:birthDate, '-')"/>
                            <xsl:choose>
                                <xsl:when test="$tempBirthDate[contains(., '-')]">
                                    
                                    <xsl:value-of select="concat('-', format-number(number(substring-before($tempBirthDate, '-')), '0000'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('-', format-number(number($tempBirthDate), '0000'))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- positive dates  -->
                    <xsl:otherwise><xsl:choose>
                        <xsl:when test="$viafxml//ns1:birthDate[contains(., '-')]">
                            <xsl:value-of select=" format-number(number(substring-before($viafxml//ns1:birthDate, '-')), '0000')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select=" format-number(number($viafxml//ns1:birthDate), '0000')"/>
                        </xsl:otherwise>
                    </xsl:choose></xsl:otherwise></xsl:choose>
                </xsl:attribute> 
                <xsl:value-of select="$viafxml//ns1:birthDate"/>
            </birth></xsl:if>
            
        <xsl:if test="$viafxml//ns1:deathDate != '0'">
            <death>
                <xsl:attribute name="source" select="'VIAF'"/>
                <xsl:attribute name="when">
                    <!-- 'negative' dates -->
                    <xsl:choose>
                        <xsl:when test="$viafxml//ns1:deathDate[starts-with(., '-')]">
                            <xsl:variable name="tempDeathDate" select="substring-after($viafxml//ns1:deathDate, '-')"/>
                            <xsl:choose>
                                <xsl:when test="$tempDeathDate[contains(., '-')]">
                                    
                                    <xsl:value-of select="concat('-', format-number(number(substring-before($tempDeathDate, '-')), '0000'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('-', format-number(number($tempDeathDate), '0000'))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- positive dates -->
                        <xsl:otherwise><xsl:choose>
                        <xsl:when test="$viafxml//ns1:deathDate[contains(., '-')]">

                            <xsl:value-of select="format-number(number(substring-before($viafxml//ns1:deathDate, '-')), '0000')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number(number($viafxml//ns1:deathDate), '0000')"/>
                        </xsl:otherwise>
                    </xsl:choose></xsl:otherwise></xsl:choose>
                </xsl:attribute> 
                <xsl:value-of select="$viafxml//ns1:deathDate"/>
            </death></xsl:if>
                
                <!-- LINKS add links to selected other systems -->
                
                
                <note type="links">
                    <list type="links">
                        <xsl:for-each select="$viaf_sources">
                            <xsl:if test="contains(., 'BNF')">
                                <xsl:variable name="target" select="./@nsid"/>
                                <item>
                                    <ref>
                                        <xsl:attribute name="target" select="$target"/>
                                        <title>BNF</title>
                                    </ref>
                                </item>
                            </xsl:if>
                            <xsl:if test="contains(., 'DNB')">
                                <xsl:variable name="target" select="./@nsid"/>
                                <item>
                                    <ref>
                                        <xsl:attribute name="target" select="$target"/>
                                        <title>GND</title>
                                    </ref>
                                </item>
                            </xsl:if>
                            <xsl:if test="contains(., 'LC')">
                                <xsl:variable name="target" select="./@nsid"/>
                                <item>
                                    <ref>
                                        <xsl:attribute name="target" select="concat('http://id.loc.gov/authorities/names/', $target)"/>
                                        <title>LC</title>
                                    </ref>
                                </item>
                            </xsl:if>
                            <xsl:if test="contains(., 'WKP')">
                                <xsl:variable name="target" select="./@nsid"/>
                                <item>
                                    <ref>
                                        <xsl:attribute name="target" select="concat('http://www.wikidata.org/entity/', $target)"/>
                                        <title>Wikidata</title>
                                    </ref>
                                </item>
                            </xsl:if>
                            <xsl:if test="contains(., 'ISNI')">
                                <xsl:variable name="target" select="./@nsid"/>
                                <item>
                                    <ref>
                                        <xsl:attribute name="target" select="concat('http://www.isni.org/isni/', $target)"/>
                                        <title>ISNI</title>
                                    </ref>
                                </item>
                            </xsl:if>
                            
                        </xsl:for-each>
                            <item>
                                <ref>
                                    <xsl:attribute name="target" select="concat('https://viaf.org/viaf/', $viafid)"/>
                                        <title>VIAF</title>
                                </ref>
                            </item>
                    </list>
                </note>
               
        
      
        
    </xsl:template>
    
    
    
    
    
      <xsl:template name="persname">
          <xsl:param name="type"/>
          <xsl:param name="data"/>
          <xsl:param name="source"/>
          
         
          <xsl:variable name="indicator" select="$data/ns1:datafield/@ind1"/>
          <persName>
              <xsl:attribute name="type" select="$type"/>
              <xsl:attribute name="subtype">
                  <xsl:choose>
                    <xsl:when test="$indicator='0'">
                        <xsl:value-of select="'forenameFirst'"/>
                    </xsl:when>   
                      <xsl:when test="$indicator='1'">
                          <xsl:value-of select="'surenameFirst'"/>
                      </xsl:when>   
                      <xsl:otherwise>
                          <xsl:value-of select="'unparsed'"/>
                      </xsl:otherwise>
                  </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="source" select="$source"/>
              
              
             
              <xsl:for-each select="$data/ns1:datafield/ns1:subfield">
                  <xsl:variable name="name" select="."/>
                  <name>
                      <xsl:attribute name="type" select="concat('marc-', $name/@code)"/>
                      <xsl:value-of select="normalize-unicode($name, 'NFC')"/>
                  </name>
              </xsl:for-each>
          </persName>
          
        </xsl:template>
    
    
    <!-- By default copy the input to the output -->
    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>