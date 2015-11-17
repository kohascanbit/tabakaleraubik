<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [<!ENTITY nbsp "&#160;" >]>

<!-- $Id: MARC21slim2intranetDetail.xsl,v 1.5 2015/08/17 07:35:17 leire Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:items="http://www.koha-community.org/items"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="marc items">
    <xsl:import href="MARC21slimUtils.xsl"/>
    <xsl:output method = "html" indent="yes" omit-xml-declaration = "yes" encoding="UTF-8"/>
    <xsl:template match="/">
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="marc:record">

        <!-- Option: Display Alternate Graphic Representation (MARC 880)  -->
        <xsl:variable name="display880" select="boolean(marc:datafield[@tag=880])"/>
        <xsl:variable name="UseControlNumber" select="marc:sysprefs/marc:syspref[@name='UseControlNumber']"/>
        <xsl:variable name="URLLinkText" select="marc:sysprefs/marc:syspref[@name='URLLinkText']"/>
        <xsl:variable name="OPACBaseURL" select="marc:sysprefs/marc:syspref[@name='OPACBaseURL']"/>
        <xsl:variable name="SubjectModifier"><xsl:if test="marc:sysprefs/marc:syspref[@name='TraceCompleteSubfields']='1'">,complete-subfield</xsl:if></xsl:variable>
        <xsl:variable name="UseAuthoritiesForTracings" select="marc:sysprefs/marc:syspref[@name='UseAuthoritiesForTracings']"/>
 <xsl:variable name="UseAuthoritiesForTracings2" select="marc:sysprefs/marc:syspref[@name='UseAuthoritiesForTracings']"/>
        <xsl:variable name="TraceSubjectSubdivisions" select="marc:sysprefs/marc:syspref[@name='TraceSubjectSubdivisions']"/>
        <xsl:variable name="Show856uAsImage" select="marc:sysprefs/marc:syspref[@name='Display856uAsImage']"/>
        <xsl:variable name="TracingQuotesLeft">
           <xsl:choose>
             <xsl:when test="marc:sysprefs/marc:syspref[@name='UseICU']='1'">{</xsl:when>
             <xsl:otherwise>"</xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <xsl:variable name="TracingQuotesRight">
          <xsl:choose>
            <xsl:when test="marc:sysprefs/marc:syspref[@name='UseICU']='1'">}</xsl:when>
            <xsl:otherwise>"</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="leader" select="marc:leader"/>
        <xsl:variable name="leader6" select="substring($leader,7,1)"/>
        <xsl:variable name="leader7" select="substring($leader,8,1)"/>
        <xsl:variable name="leader19" select="substring($leader,20,1)"/>
        <xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
        <xsl:variable name="materialTypeCode">
            <xsl:choose>
                <xsl:when test="$leader19='a'">ST</xsl:when>
                <xsl:when test="$leader6='a'">
                    <xsl:choose>
                        <xsl:when test="$leader7='c' or $leader7='d' or $leader7='m'">BK</xsl:when>
                        <xsl:when test="$leader7='i' or $leader7='s'">SE</xsl:when>
                        <xsl:when test="$leader7='a' or $leader7='b'">AR</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$leader6='t'">BK</xsl:when>
                <xsl:when test="$leader6='o' or $leader6='p'">MX</xsl:when>
                <xsl:when test="$leader6='m'">CF</xsl:when>
                <xsl:when test="$leader6='e' or $leader6='f'">MP</xsl:when>
                <xsl:when test="$leader6='g' or $leader6='k' or $leader6='r'">VM</xsl:when>
                <xsl:when test="$leader6='i' or $leader6='j'">MU</xsl:when>
                <xsl:when test="$leader6='c' or $leader6='d'">PR</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="materialTypeLabel">
            <xsl:choose>
                <xsl:when test="$leader19='a'">Set</xsl:when>
                <xsl:when test="$leader6='a'">
                    <xsl:choose>
                        <xsl:when test="$leader7='c' or $leader7='d' or $leader7='m'">Book</xsl:when>
                        <xsl:when test="$leader7='i' or $leader7='s'">
                            <xsl:choose>
                                <xsl:when test="substring($controlField008,22,1)!='m'">Continuing Resource</xsl:when>
                                <xsl:otherwise>Series</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$leader7='a' or $leader7='b'">Article</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$leader6='t'">Book</xsl:when>
                <xsl:when test="$leader6='o'">Kit</xsl:when>				
                <xsl:when test="$leader6='p'">Mixed Materials</xsl:when>
                <xsl:when test="$leader6='m'">Computer File</xsl:when>
                <xsl:when test="$leader6='e' or $leader6='f'">Map</xsl:when>
                <xsl:when test="$leader6='g' or $leader6='k' or $leader6='r'">Visual Material</xsl:when>
                <xsl:when test="$leader6='j'">Music</xsl:when>
                <xsl:when test="$leader6='i'">Sound</xsl:when>
                <xsl:when test="$leader6='c' or $leader6='d'">Score</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!-- Title Statement -->
        <!-- Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <h1 class="title">
                <xsl:call-template name="m880Select">
                    <xsl:with-param name="basetags">245</xsl:with-param>
                    <xsl:with-param name="codes">abhfgknps</xsl:with-param>
                </xsl:call-template>
            </h1>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=245]">
        <h1>
            <xsl:for-each select="marc:datafield[@tag=245]">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">a</xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="marc:subfield[@code='h']">
                        <xsl:text> [</xsl:text>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">h</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                    <xsl:if test="marc:subfield[@code='b']">
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">b</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="marc:subfield[@code='f']">
                        <xsl:text>, </xsl:text>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">f</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">gknps</xsl:with-param>
                    </xsl:call-template>
            </xsl:for-each>
        </h1>
        </xsl:if>

        <!-- Author Statement: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <h5 class="author">
                <xsl:call-template name="m880Select">
 <xsl:with-param name="basetags">100,110,111</xsl:with-param>
                    <xsl:with-param name="codes">abc</xsl:with-param>
                    <xsl:with-param name="index">au</xsl:with-param>
                    <xsl:with-param name="UseAuthoritiesForTracings" select="$UseAuthoritiesForTracings"/>
                    <!-- do not use label 'by ' here, it would be repeated for every occurence of 100,110,111,700,710,711 -->
                </xsl:call-template>
            </h5>
        </xsl:if>

        <!-- Author Statement -->
        <xsl:call-template name="showAuthor"><xsl:with-param name="authorfield" select="marc:datafield[@tag=100 or @tag=110 or @tag=111]"/><xsl:with-param name="UseAuthoritiesForTracings" select="$UseAuthoritiesForTracings"/></xsl:call-template>


              
      <xsl:if test="marc:datafield[@tag=999]">
        	<span class="results_summary translated_title"><span class="label">Record number : </span>
            <xsl:for-each select="marc:datafield[@tag=999]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">d</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
        </span>
       </xsl:if>

   <xsl:if test="$materialTypeCode!=''">
        <span class="results_summary type"><span class="label">Type : </span>
        <xsl:element name="img"><xsl:attribute name="src">/intranet-tmpl/prog/img/famfamfam/<xsl:value-of select="$materialTypeCode"/>.png</xsl:attribute><xsl:attribute name="alt"></xsl:attribute></xsl:element>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$materialTypeLabel"/>
        </span>
   </xsl:if>
   
         <!-- 024 -->
         <xsl:if test="$display880">
         <span class="results_summary">
         <xsl:call-template name="m880Select">
         <xsl:with-param name="basetags">024</xsl:with-param>
         <xsl:with-param name="codes">abhfgknps</xsl:with-param>
         </xsl:call-template>
         </span>
         </xsl:if>
         <xsl:if test="marc:datafield[@tag=024]">
         <span class="results_summary">
         <xsl:for-each select="marc:datafield[@tag=024]">
         <span class="label">
         <xsl:if test="marc:subfield[@code='2']">
         <xsl:text> </xsl:text>
         <xsl:call-template name="subfieldSelect">
         <xsl:with-param name="codes">2</xsl:with-param>
         </xsl:call-template>
         <xsl:text> : </xsl:text>
         </xsl:if>
         </span>
         <xsl:if test="marc:subfield[@code='a']">
         <xsl:text> </xsl:text>
         <xsl:call-template name="subfieldSelect">
         <xsl:with-param name="codes">a</xsl:with-param>
         </xsl:call-template>
         </xsl:if>
         <xsl:text> </xsl:text>
         <xsl:call-template name="subfieldSelect">
         <xsl:with-param name="codes">fgknps</xsl:with-param>
         </xsl:call-template>
         </xsl:for-each>
          </span>
         </xsl:if>
        
         <xsl:if test="marc:datafield[@tag=242]">
        <span class="results_summary translated_title"><span class="label">Title translated : </span>
            <xsl:for-each select="marc:datafield[@tag=242]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abchnp</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text>; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>

        <!-- Uniform Title  Statement: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">130,240</xsl:with-param>
                <xsl:with-param name="codes">adfklmor</xsl:with-param>
                <xsl:with-param name="class">results_summary uniform_title</xsl:with-param>
                <xsl:with-param name="label">Uniform Title : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=130]|marc:datafield[@tag=240]|marc:datafield[@tag=730][@ind2!=2]">
        <span class="results_summary uniform_title"><span class="label">Uniform titles : </span>
        <xsl:for-each select="marc:datafield[@tag=130]|marc:datafield[@tag=240]|marc:datafield[@tag=730][@ind2!=2]">
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield">
                    <xsl:if test="(contains('adfklmor',@code) and (not(../marc:subfield[@code='n' or @code='p']) or (following-sibling::marc:subfield[@code='n' or @code='p'])))">
                        <xsl:value-of select="text()"/>
                        <xsl:text> </xsl:text>
                     </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
                        
                </xsl:with-param>
            </xsl:call-template>
            <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
        </xsl:for-each>
        </span>
        </xsl:if>
        
          <!-- Other Title Statement: Alternate Graphic Representation (MARC 880) -->
  <xsl:if test="marc:datafield[@tag=246]">
 <span class="results_summary other_title"><span class="label">Other(s) title(s) : </span>
 <xsl:for-each select="marc:datafield[@tag=246]">
 <xsl:call-template name="chopPunctuation">
 <xsl:with-param name="chopString">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">iabhfgnp</xsl:with-param>
 </xsl:call-template>
 </xsl:with-param>
 </xsl:call-template>
 <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
 </xsl:for-each>
 </span>
 </xsl:if>


        <!-- Analytics -->
  <!--       <xsl:if test="$leader7='s' or $leader7='m' ">
        <span class="results_summary analytics"><span class="label">Analytics: </span>
            <a>
            <xsl:choose>
            <xsl:when test="$UseControlNumber = '1' and marc:controlfield[@tag=001]">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=rcn:<xsl:value-of select="marc:controlfield[@tag=001]"/>+and+(bib-level:a+or+bib-level:b)</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=Host-item:<xsl:value-of select="translate(marc:datafield[@tag=245]/marc:subfield[@code='a'], '/', '')"/></xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:text>Show analytics</xsl:text>
            </a>
        </span>
        </xsl:if>
 -->

        <!-- Volumes of sets and traced series -->
        <xsl:if test="$materialTypeCode='ST' or substring($controlField008,22,1)='m'">
        <span class="results_summary volumes"><span class="label">Volumes : </span>
            <a>
            <xsl:choose>
            <xsl:when test="$UseControlNumber = '1' and marc:controlfield[@tag=001]">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=rcn:<xsl:value-of select="marc:controlfield[@tag=001]"/>+not+(bib-level:a+or+bib-level:b)</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=ti,phr:<xsl:value-of select="translate(marc:datafield[@tag=245]/marc:subfield[@code='a'], '/', '')"/></xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:text>Show volumes</xsl:text>
            </a>
        </span>
        </xsl:if>
        
        <!-- Publisher Statement: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">260</xsl:with-param>
                <xsl:with-param name="codes">abcg</xsl:with-param>
                <xsl:with-param name="class">results_summary publisher</xsl:with-param>
                <xsl:with-param name="label">Publisher : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=260]">
        <span class="results_summary publisher"><span class="label">Publisher : </span>
            <xsl:for-each select="marc:datafield[@tag=260]">
              
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcg</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
        </xsl:if>

        <!-- Edition Statement: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">250</xsl:with-param>
                <xsl:with-param name="codes">ab</xsl:with-param>
                <xsl:with-param name="class">results_summary edition</xsl:with-param>
                <xsl:with-param name="label">Edition : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=250]">
        <span class="results_summary edition"><span class="label">Edition : </span>
            <xsl:for-each select="marc:datafield[@tag=250]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">ab</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
        </xsl:if>

        <!-- Description: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">300</xsl:with-param>
                <xsl:with-param name="codes">abceg</xsl:with-param>
                <xsl:with-param name="class">results_summary description</xsl:with-param>
                <xsl:with-param name="label">Description : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=300]">
        <span class="results_summary description"><span class="label">Description : </span>
            <xsl:for-each select="marc:datafield[@tag=300]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abceg</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>
       
       <!-- Description: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">310</xsl:with-param>
                <xsl:with-param name="codes">abceg</xsl:with-param>
                <xsl:with-param name="class">results_summary description</xsl:with-param>
                <xsl:with-param name="label">Frequency : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=310]">
        <span class="results_summary description"><span class="label">Frequency : </span>
            <xsl:for-each select="marc:datafield[@tag=310]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abceg</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>
       
        <!-- Content Type: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">336</xsl:with-param>
                <xsl:with-param name="codes">ab</xsl:with-param>
                <xsl:with-param name="class">results_summary description</xsl:with-param>
                <xsl:with-param name="label">Content Type : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=336]">
        <span class="results_summary description"><span class="label">Content Type : </span>
            <xsl:for-each select="marc:datafield[@tag=336]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">ab</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>
       
       <!-- Media Type: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">337</xsl:with-param>
                <xsl:with-param name="codes">ab</xsl:with-param>
                <xsl:with-param name="class">results_summary description</xsl:with-param>
                <xsl:with-param name="label">Media Type : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=337]">
        <span class="results_summary description"><span class="label">Media Type : </span>
            <xsl:for-each select="marc:datafield[@tag=337]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">ab</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>
       
       <!-- Carrier Type: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">338</xsl:with-param>
                <xsl:with-param name="codes">ab</xsl:with-param>
                <xsl:with-param name="class">results_summary description</xsl:with-param>
                <xsl:with-param name="label">Carrier Type : </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="marc:datafield[@tag=338]">
        <span class="results_summary description"><span class="label">Carrier Type : </span>
            <xsl:for-each select="marc:datafield[@tag=338]">
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">ab</xsl:with-param>
                    </xsl:call-template>
                   </xsl:with-param>
               </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
            </xsl:for-each>
        </span>
       </xsl:if>
       
       <!--Series: Alternate Graphic Representation (MARC 880) -->
        <xsl:if test="$display880">
            <xsl:call-template name="m880Select">
                <xsl:with-param name="basetags">440,490, 830</xsl:with-param>
                <xsl:with-param name="codes">av</xsl:with-param>
                <xsl:with-param name="class">results_summary series</xsl:with-param>
                <xsl:with-param name="label">Series : </xsl:with-param>
                <xsl:with-param name="index">se</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Series -->
        <xsl:if test="marc:datafield[@tag=440 or @tag=490 or @tag=830]">
        <span class="results_summary series"><span class="label">Series : </span>
        <!-- 440 -->
        <xsl:for-each select="marc:datafield[@tag=440]">
            <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=se,phr:"<xsl:value-of select="marc:subfield[@code='a']"/>"</xsl:attribute>
            <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">av</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
			</a>
                    <xsl:text> </xsl:text><xsl:call-template name="part"/>
            <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
        </xsl:for-each>

 <!-- 490 Series not traced, Ind1 = 0 -->
 <xsl:for-each select="marc:datafield[@tag=490][@ind1!=1]">
 <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=se,phr:"<xsl:value-of select="marc:subfield[@code='a']"/>"</xsl:attribute>
 <xsl:call-template name="chopPunctuation">
 <xsl:with-param name="chopString">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">av</xsl:with-param>
 </xsl:call-template>
 </xsl:with-param>
 </xsl:call-template>
 </a>
 <xsl:call-template name="part"/>
 <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
 </xsl:for-each>
 <!-- 490 Series traced, Ind1 = 1 -->
 <xsl:if test="marc:datafield[@tag=490][@ind1=1]">
 <xsl:for-each select="marc:datafield[@tag=800 or @tag=810 or @tag=811 or @tag=830]">
 <xsl:choose>
 <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
 <a href="/cgi-bin/koha/catalogue/search.pl?q=rcn:{marc:subfield[@code='w']}">
 <xsl:call-template name="chopPunctuation">
 <xsl:with-param name="chopString">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">a_t</xsl:with-param>
 </xsl:call-template>
 </xsl:with-param>
 </xsl:call-template>
 </a>
 </xsl:when>
 <xsl:otherwise>
 <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=se,phr:"<xsl:value-of select="marc:subfield[@code='a']"/>"</xsl:attribute>
 <xsl:call-template name="chopPunctuation">
 <xsl:with-param name="chopString">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">a_t</xsl:with-param>
 </xsl:call-template>
 </xsl:with-param>
 </xsl:call-template>
 </a>
 <xsl:call-template name="part"/>
 </xsl:otherwise>
 </xsl:choose>
 <xsl:if test="marc:datafield[@tag=490][@code='v']">
 	<xsl:text>: </xsl:text>
 </xsl:if>
 <xsl:value-of  select="marc:subfield[@code='v']" />
 <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
 </xsl:for-each>
 </xsl:if>

        </span>
        </xsl:if>


       <xsl:if test="marc:datafield[@tag=020]">
        <span class="results_summary isbn"><span class="label">ISBN : </span>
        <xsl:for-each select="marc:datafield[@tag=020]">
        <xsl:variable name="isbn" select="marc:subfield[@code='a']"/>
                <xsl:value-of select="marc:subfield[@code='a']"/>
                <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
        </xsl:for-each>
        </span>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=022]">
        <span class="results_summary issn"><span class="label">ISSN : </span>
        <xsl:for-each select="marc:datafield[@tag=022]">
                <xsl:value-of select="marc:subfield[@code='a']"/>
                <xsl:choose><xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
        </xsl:for-each>
        </span>
        </xsl:if>

        <xsl:if test="marc:datafield[substring(@tag, 1, 1) = '6']">
            <span class="results_summary subjects"><span class="label">Subject(s) : </span>
            <xsl:for-each select="marc:datafield[substring(@tag, 1, 1) = '6']">
            <a>
            <xsl:choose>
            <xsl:when test="marc:subfield[@code=9] and $UseAuthoritiesForTracings='1'">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=an:<xsl:value-of select="marc:subfield[@code=9]"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="$TraceSubjectSubdivisions='1'">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=<xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcdfgklmnopqrstvxyz</xsl:with-param>
                        <xsl:with-param name="delimeter"> AND </xsl:with-param>
                        <xsl:with-param name="prefix">(su<xsl:value-of select="$SubjectModifier"/>:<xsl:value-of select="$TracingQuotesLeft"/></xsl:with-param>
                        <xsl:with-param name="suffix"><xsl:value-of select="$TracingQuotesRight"/>)</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=su<xsl:value-of select="$SubjectModifier"/>:<xsl:value-of select="$TracingQuotesLeft"/><xsl:value-of select="marc:subfield[@code='a']"/><xsl:value-of select="$TracingQuotesRight"/></xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcdfgklmnopqrstvxyz</xsl:with-param>
                        <xsl:with-param name="subdivCodes">vxyz</xsl:with-param>
                        <xsl:with-param name="subdivDelimiter">-- </xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
            </a>
            <xsl:choose>
            <xsl:when test="position()=last()"></xsl:when>
            <xsl:otherwise> | </xsl:otherwise>
            </xsl:choose>

            </xsl:for-each>
            </span>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=856]">
        <span class="results_summary online_resources"><span class="label">Online Resources : </span>
        <xsl:for-each select="marc:datafield[@tag=856]">
               <xsl:variable name="SubqText"><xsl:value-of select="marc:subfield[@code='q']"/></xsl:variable>
               <a target="_blank"><xsl:attribute name="href"><xsl:value-of select="marc:subfield[@code='u']"/></xsl:attribute>
                <xsl:choose>
                <xsl:when test="($Show856uAsImage='Details' or $Show856uAsImage='Both') and (substring($SubqText,1,6)='image/' or $SubqText='img' or $SubqText='bmp' or $SubqText='cod' or $SubqText='gif' or $SubqText='ief' or $SubqText='jpe' or $SubqText='jpeg' or $SubqText='jpg' or $SubqText='jfif' or $SubqText='png' or $SubqText='svg' or $SubqText='tif' or $SubqText='tiff' or $SubqText='ras' or $SubqText='cmx' or $SubqText='ico' or $SubqText='pnm' or $SubqText='pbm' or $SubqText='pgm' or $SubqText='ppm' or $SubqText='rgb' or $SubqText='xbm' or $SubqText='xpm' or $SubqText='xwd')">
                    <xsl:element name="img"><xsl:attribute name="src"><xsl:value-of select="marc:subfield[@code='u']"/></xsl:attribute><xsl:attribute name="alt"><xsl:value-of select="marc:subfield[@code='y']"/></xsl:attribute><xsl:attribute name="height">100</xsl:attribute></xsl:element><xsl:text></xsl:text>
                </xsl:when>
                <xsl:when test="marc:subfield[@code='y' or @code='3' or @code='z' or @code='x']">
                    <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">xy3z</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="not(marc:subfield[@code='y']) and not(marc:subfield[@code='3']) and not(marc:subfield[@code='z'])">
                    <xsl:choose>
                    <xsl:when test="$URLLinkText!=''">
                            <xsl:value-of select="$URLLinkText"/>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:text>Click here to access online</xsl:text>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                </xsl:choose>
                </a>
                <xsl:choose>
                <xsl:when test="position()=last()"><xsl:text>  </xsl:text></xsl:when>
                <xsl:otherwise> | </xsl:otherwise>
                </xsl:choose>

        </xsl:for-each>
        </span>
        </xsl:if>
        
        	<!-- 760 -->
        <xsl:if test="marc:datafield[@tag=760]">
        <xsl:for-each select="marc:datafield[@tag=760]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Main series : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f760">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 762 -->
        <xsl:if test="marc:datafield[@tag=762]">
        <xsl:for-each select="marc:datafield[@tag=762]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Has subseries : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f762">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 765 -->
        <xsl:if test="marc:datafield[@tag=765]">
        <xsl:for-each select="marc:datafield[@tag=765]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Translation of : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f765">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 767 -->
        <xsl:if test="marc:datafield[@tag=767]">
        <xsl:for-each select="marc:datafield[@tag=767]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Translated as : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f767">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 770 -->
        <xsl:if test="marc:datafield[@tag=770]">
        <xsl:for-each select="marc:datafield[@tag=770]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Has supplement : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f770">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 772 -->
        <xsl:if test="marc:datafield[@tag=772]">
        <xsl:for-each select="marc:datafield[@tag=772]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Supplement to : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f772">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>

        <!-- 773 -->
        <xsl:if test="marc:datafield[@tag=773]">
        <xsl:for-each select="marc:datafield[@tag=773]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            In : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f773">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                    <xsl:if test="marc:subfield[@code='t']">
                    <xsl:if test="marc:subfield[@code='a']">
                      	<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
                      </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                        <xsl:if test="marc:subfield[@code='h']"><xsl:text>. </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                      <xsl:if test="marc:subfield[@code='a']">
                      <a>
                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
                      	<xsl:value-of select="marc:subfield[@code='a']"/>
                      </a>
                      <xsl:text> </xsl:text>
                      </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text>. </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                      <xsl:if test="marc:subfield[@code='a']">
                      	<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
                      </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text>. </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                     <xsl:if test="marc:subfield[@code='a']">
                      	<xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='a']"/>
                      </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
               <a><xsl:if test="marc:subfield[@code='a']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='a']"/></xsl:if></a>
               <xsl:text>. </xsl:text>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text>. </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>
        
        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 774 -->
        <xsl:if test="marc:datafield[@tag=774]">
        <xsl:for-each select="marc:datafield[@tag=774]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Analytics : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f774">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                        <xsl:if test="marc:subfield[@code='h']"><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                     <xsl:if test="marc:subfield[@code='h']"><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        	<!-- 775 -->
        <xsl:if test="marc:datafield[@tag=775]">
        <xsl:for-each select="marc:datafield[@tag=775]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Other edition available : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f775">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 776 -->
        <xsl:if test="marc:datafield[@tag=776]">
        <xsl:for-each select="marc:datafield[@tag=776]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Available in another form : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f776">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 777 -->
        <xsl:if test="marc:datafield[@tag=777]">
        <xsl:for-each select="marc:datafield[@tag=777]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Issued with : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f777">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 780 -->
        <xsl:if test="marc:datafield[@tag=780]">
        <xsl:for-each select="marc:datafield[@tag=780]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Preceding Entry : 
        </xsl:when>
        <xsl:when test="@ind2=0">
            <span class="label">Continues : </span>
        </xsl:when>
        <xsl:when test="@ind2=1">
            <span class="label">Continues in part : </span>
        </xsl:when>
        <xsl:when test="@ind2=2">
            <span class="label">Supersedes : </span>
        </xsl:when>
        <xsl:when test="@ind2=3">
            <span class="label">Supersedes in part : </span>
        </xsl:when>
        <xsl:when test="@ind2=4">
            <span class="label">Formed by the union: ... and: ...</span>
        </xsl:when>
        <xsl:when test="@ind2=5">
            <span class="label">Absorbed : </span>
        </xsl:when>
        <xsl:when test="@ind2=6">
            <span class="label">Absorbed in part : </span>
        </xsl:when>
        <xsl:when test="@ind2=7">
            <span class="label">Separated from : </span>
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f780">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 785 -->
        <xsl:if test="marc:datafield[@tag=785]">
        <xsl:for-each select="marc:datafield[@tag=785]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Succeeding Entry : 
        </xsl:when>
       	<xsl:when test="@ind2=0">
            <span class="label">Continued by : </span>
        </xsl:when>
        <xsl:when test="@ind2=1">
            <span class="label">Continued in part by : </span>
        </xsl:when>
        <xsl:when test="@ind2=2">
            <span class="label">Superseded by : </span>
        </xsl:when>
        <xsl:when test="@ind2=3">
            <span class="label">Superseded in part by:</span>
        </xsl:when>
        <xsl:when test="@ind2=4">
            <span class="label">Absorbed by : </span>
        </xsl:when>
        <xsl:when test="@ind2=5">
            <span class="label">Absorbed in part by : </span>
        </xsl:when>
        <xsl:when test="@ind2=6">
            <span class="label">Split into .. and ...:</span>
        </xsl:when>
        <xsl:when test="@ind2=7">
            <span class="label">Merged with ... to form ...</span>
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f785">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 786 -->
        <xsl:if test="marc:datafield[@tag=786]">
        <xsl:for-each select="marc:datafield[@tag=786]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Data source : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f786">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>
        
        <!-- 787 -->
        <xsl:if test="marc:datafield[@tag=787]">
        <xsl:for-each select="marc:datafield[@tag=787]">
        <xsl:if test="@ind1=0">
        <span class="results_summary in"><span class="label">
        <xsl:choose>
        <xsl:when test="@ind2=' '">
            Related item : 
        </xsl:when>
        <xsl:when test="@ind2=8">
            <xsl:if test="marc:subfield[@code='i']">
                <xsl:value-of select="marc:subfield[@code='i']"/>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        </span>
                <xsl:variable name="f787">
                    <xsl:call-template name="chopPunctuation"><xsl:with-param name="chopString"><xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">at</xsl:with-param>
                    </xsl:call-template></xsl:with-param></xsl:call-template>
                </xsl:variable>
            <xsl:choose>
                <xsl:when test="$UseControlNumber = '1' and marc:subfield[@code='w']">
                     <xsl:if test="marc:subfield[@code='t']">
                     	  <xsl:if test="marc:subfield[@code='a']">
			<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text>
		    </xsl:if>
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:call-template name="extractControlNumber"><xsl:with-param name="subfieldW" select="marc:subfield[@code='w']"/></xsl:call-template></xsl:attribute>
                        <xsl:value-of select="marc:subfield[@code='t']"/>
                    </a>
                         <xsl:if test="marc:subfield[@code='d']">
                           <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                    </xsl:if>
                </xsl:when>
                 <xsl:when test="$UseControlNumber = '0'">
                 	<xsl:if test="marc:subfield[@code='a']">
			 <a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                      <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute>
                     <xsl:value-of select="marc:subfield[@code='t']"/>
                     </a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:when>
                 <xsl:otherwise>
                 	<xsl:if test="marc:subfield[@code='a']">
			<a>
	                      	<xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=au,phr&amp;q=<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
	                      	<xsl:value-of select="marc:subfield[@code='a']"/>
	                      </a>
	                     <xsl:text>. </xsl:text>
		 </xsl:if>
                     <a><xsl:if test="marc:subfield[@code='t']"><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?idx=ti,phr&amp;q=<xsl:value-of select="marc:subfield[@code='t']"/></xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                 </xsl:otherwise>
                <xsl:when test="marc:subfield[@code='0']">
                    <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/detail.pl?biblionumber=<xsl:value-of select="marc:subfield[@code='0']"/></xsl:attribute>
                        <xsl:value-of select="$f773"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:if test="marc:subfield[@code='a']">
		<xsl:value-of select="marc:subfield[@code='a']"/>
 	</xsl:if>
                 <a><xsl:if test="marc:subfield[@code='t']"><xsl:text></xsl:text><xsl:value-of select="marc:subfield[@code='t']"/></xsl:if></a>
                     <xsl:if test="marc:subfield[@code='d']">
                        <span class="label"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/></span>
                     </xsl:if>
                     <xsl:if test="marc:subfield[@code='g']"><xsl:text> - </xsl:text><xsl:value-of select="marc:subfield[@code='g']"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <xsl:if test="marc:subfield[@code='n']">
            <span class="results_summary"><xsl:value-of select="marc:subfield[@code='n']"/></span>
        </xsl:if>

        </xsl:if>
        </xsl:for-each>
        </xsl:if>

        <!-- 866 textual holdings -->
        <xsl:if test="marc:datafield[@tag=866]">
            <span class="results_summary holdings_note"><span class="label">Holdings Note : </span>
                <xsl:for-each select="marc:datafield[@tag=866]">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">axz</xsl:with-param>
                    </xsl:call-template>
                    <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
                </xsl:for-each>
            </span>
        </xsl:if>

        <xsl:if test="$OPACBaseURL!=''">
        <span class="results_summary"><span class="label">OPAC view : </span>
            <a><xsl:attribute name="href">http://<xsl:value-of select="$OPACBaseURL"/>/cgi-bin/koha/opac-detail.pl?biblionumber=<xsl:value-of select="marc:datafield[@tag=999]/marc:subfield[@code='c']"/></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>Open in new window</a>.</span>
 </xsl:if>
 
 <xsl:call-template name="showOtherAuthor"><xsl:with-param name="authorfield" select="marc:datafield[@tag=700 or @tag=710 or @tag=711 or @tag=920 or @tag=921]"/><xsl:with-param name="UseAuthoritiesForTracings2" select="$UseAuthoritiesForTracings2"/></xsl:call-template>
 
  <xsl:if test="$display880">
 <h5 class="author">
 <xsl:call-template name="m880Select">
 <xsl:with-param name="basetags">700,710,711, 920,921</xsl:with-param>
 <xsl:with-param name="codes">abc</xsl:with-param>
 <xsl:with-param name="index">au</xsl:with-param>
 <xsl:with-param name="UseAuthoritiesForTracings2" select="$UseAuthoritiesForTracings2"/>
 <!-- do not use label 'by ' here, it would be repeated for every occurence of 100,110,111,700,710,711 -->
 </xsl:call-template>
 </h5>
 </xsl:if>

<!-- Other Title Statement: Alternate Graphic Representation (MARC 880) -->
 <xsl:if test="marc:datafield[@tag=740]">
 <span class="results_summary publisher"><span class="label">Secondary title(s) : </span>
 <xsl:for-each select="marc:datafield[@tag=740]">
 <xsl:if test="marc:subfield[@code='a']">
 <a href="/cgi-bin/koha/catalogue/search.pl?idx=ti&amp;q=:{marc:subfield[@code='a']}">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">a</xsl:with-param>
 </xsl:call-template>
 </a>
 </xsl:if>
 <xsl:text> </xsl:text>
 <xsl:call-template name="chopPunctuation">
 <xsl:with-param name="chopString">
 <xsl:call-template name="subfieldSelect">
 <xsl:with-param name="codes">hnp568</xsl:with-param>
 </xsl:call-template>
 </xsl:with-param>
 </xsl:call-template>
 <xsl:choose><xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise></xsl:choose>
 </xsl:for-each>
        </span>
        </xsl:if>

    </xsl:template>

    <xsl:template name="nameABCDQ">
	
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">aq</xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="punctuation">
                    <xsl:text>:,;/ </xsl:text>
                </xsl:with-param>
            </xsl:call-template>
        <xsl:call-template name="termsOfAddress"/>
    </xsl:template>

    <xsl:template name="nameABCDN">
        <xsl:for-each select="marc:subfield[@code='a']">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <xsl:text>. </xsl:text>
            <xsl:value-of select="."/>
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text> -- </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code='c'] or marc:subfield[@code='d'] or marc:subfield[@code='n']">
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">cdn</xsl:with-param>
                </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="nameACDEQ">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">acdeq</xsl:with-param>
            </xsl:call-template>
    </xsl:template>
    <xsl:template name="termsOfAddress">
        <xsl:if test="marc:subfield[@code='b' or @code='c']">
            <xsl:if test="marc:subfield[@code='c']">
            	<xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">bc</xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="part">
        <xsl:variable name="partNumber">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">n</xsl:with-param>
                <xsl:with-param name="anyCodes">n</xsl:with-param>
                <xsl:with-param name="afterCodes">fghkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="partName">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">p</xsl:with-param>
                <xsl:with-param name="anyCodes">p</xsl:with-param>
                <xsl:with-param name="afterCodes">fghkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($partNumber))">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partNumber"/>
                </xsl:call-template>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($partName))">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partName"/>
                </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="specialSubfieldSelect">
        <xsl:param name="anyCodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="beforeCodes"/>
        <xsl:param name="afterCodes"/>
        <xsl:variable name="str">
            <xsl:text>. </xsl:text>
            <xsl:for-each select="marc:subfield">
                <xsl:if test="contains($anyCodes, @code)      or (contains($beforeCodes,@code) and following-sibling::marc:subfield[@code=$axis])      or (contains($afterCodes,@code) and preceding-sibling::marc:subfield[@code=$axis])">
                    <xsl:value-of select="text()"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
    </xsl:template>

    <xsl:template name="showAuthor">
	<xsl:param name="authorfield"/>
    <xsl:param name="UseAuthoritiesForTracings"/>
	<xsl:if test="count($authorfield)&gt;0">
        <h5 class="author">
        <xsl:for-each select="$authorfield">
        <xsl:choose>
          <xsl:when test="position()&gt;1"/>
          <xsl:when test="@tag&lt;700">Author(s) : </xsl:when>
          <xsl:otherwise>Additional author(s) : </xsl:otherwise>
        </xsl:choose>
        <a>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code=9] and $UseAuthoritiesForTracings='1'">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=an:<xsl:value-of select="marc:subfield[@code=9]"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
            <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=au:"<xsl:value-of select="marc:subfield[@code='a']"/>"</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
	<xsl:choose>
          <xsl:when test="@tag=100 or @tag=700"><xsl:call-template name="nameABCDQ"/></xsl:when>
          <xsl:when test="@tag=110 or @tag=710 or @tag=920"><xsl:call-template name="nameABCDN"/></xsl:when>
          <xsl:when test="@tag=111 or @tag=711 or @tag=921"><xsl:call-template name="nameACDEQ"/></xsl:when>
	</xsl:choose>
	<!-- add relator code too between brackets-->
	<xsl:if test="marc:subfield[@code='4']">
	  <xsl:text>, [</xsl:text>
	   <xsl:value-of select="marc:subfield[@code='4']"/>
	  <xsl:text>]</xsl:text>
	</xsl:if>
	<xsl:if test="marc:subfield[@code='e']">
	  <xsl:text>, </xsl:text>
	  <xsl:value-of select="marc:subfield[@code='e']"/>
	  <xsl:text></xsl:text>
	</xsl:if>
	</a>
        <xsl:choose>
          <xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
        </h5>
        </xsl:if>
    </xsl:template>
 
 <xsl:template name="showOtherAuthor">
 <xsl:param name="authorfield"/>
 <xsl:param name="UseAuthoritiesForTracings2"/>
 <xsl:if test="count($authorfield)&gt;0">
<span class="results_summary otherAuthors">
 <xsl:for-each select="$authorfield">
 <span class="label">
 <xsl:choose>
 <xsl:when test="position()&gt;1"/>
 <xsl:when test="@tag&lt;700">Autor(es) : </xsl:when>
 <xsl:otherwise>Other(s) author(s) : </xsl:otherwise>
 </xsl:choose>
</span>
 <a>
 <xsl:choose>
 <xsl:when test="marc:subfield[@code=9] and $UseAuthoritiesForTracings2='1'">
 <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=an:<xsl:value-of select="marc:subfield[@code=9]"/></xsl:attribute>
 </xsl:when>
 <xsl:otherwise>
 <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=au:"<xsl:value-of select="marc:subfield[@code='a']"/>"</xsl:attribute>
 </xsl:otherwise>
 </xsl:choose>
 <xsl:choose>
 <xsl:when test="@tag=100 or @tag=700"><xsl:call-template name="nameABCDQ"/></xsl:when>
 <xsl:when test="@tag=110 or @tag=710 or @tag=920"><xsl:call-template name="nameABCDN"/></xsl:when>
 <xsl:when test="@tag=111 or @tag=711 or @tag=921"><xsl:call-template name="nameACDEQ"/></xsl:when>
 </xsl:choose>
 <!-- add relator code too between brackets-->
 <xsl:if test="marc:subfield[@code='4' or @code='e']">
 <xsl:text>, [</xsl:text>
 <xsl:choose>
 <xsl:when test="marc:subfield[@code=4]"><xsl:value-of select="marc:subfield[@code=4]"/></xsl:when>
 <xsl:otherwise><xsl:value-of select="marc:subfield[@code='e']"/></xsl:otherwise>
 </xsl:choose>
 <xsl:text>]</xsl:text>
 </xsl:if>
 </a>
 <xsl:choose>
 <xsl:when test="position()=last()"><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text> ; </xsl:text></xsl:otherwise>
 </xsl:choose>
 </xsl:for-each>
 </span>
 </xsl:if>
 </xsl:template>

</xsl:stylesheet>
