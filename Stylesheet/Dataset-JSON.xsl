<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3" 
	xmlns:def="http://www.cdisc.org/ns/def/v2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Root of the metadata -->
<xsl:variable name="root" select="/odm:ODM"/> 
	
<!-- Variables -->
<xsl:variable name="lf" select="'&#xA;'"/> 

<!-- Parameters -->
<xsl:param name="libname"/>
	
<xsl:template match="/"> 
	<xsl:variable name="studyOID" select="normalize-space($root/odm:Study/@OID)"/> 
	<xsl:variable name="metaDataVersionOID" select="normalize-space($root/odm:Study/odm:MetaDataVersion/@OID)"/> 
    <xsl:text>libname __tmp &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>&quot;;</xsl:text> 
    <xsl:value-of select="$lf"/> 
    <xsl:value-of select="$lf"/> 
    <xsl:for-each select="$root/odm:Study/odm:MetaDataVersion/odm:ItemGroupDef">
        <xsl:variable name="OID" select="@OID"/>
        <xsl:variable name="SASDatasetName" select="@SASDatasetName"/>
        <xsl:variable name="Data" select="if (@IsReferenceData = 'No') then 'clinicalData' else if (@IsReferenceData = 'Yes') then 'referenceData' else ' '"/>
        <xsl:variable name="Label" select="odm:Description/odm:TranslatedText"/>
		<xsl:text>%let __dsid = %sysfunc(open(__tmp.</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>,i));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>%let __nobs  = %sysfunc(attrn(&amp;__dsid.,nlobsf));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>%let __rc   = %sysfunc(close(&amp;__dsid.));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>data __data_</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	retain ITEMGROUPDATASEQ;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	set __tmp.</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	ITEMGROUPDATASEQ+1;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>run;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>filename __out  &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>\</xsl:text><xsl:value-of select="$SASDatasetName"/><xsl:text>.json&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>proc json out=__out pretty nosastags;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write values &quot;</xsl:text> <xsl:value-of select="$Data"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;studyOID&quot; &quot;</xsl:text> <xsl:value-of select="$studyOID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;metaDataVersionOID&quot; &quot;</xsl:text> <xsl:value-of select="$metaDataVersionOID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;itemGroupData&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write values &quot;</xsl:text> <xsl:value-of select="$OID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;records&quot; &quot;&amp;__nobs.&quot;;</xsl:text>
		<xsl:value-of select="$lf"/>
		<xsl:text>					write values &quot;name&quot; &quot;</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;label&quot; &quot;</xsl:text> <xsl:value-of select="$Label"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;items&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write open array;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;OID&quot; &quot;ITEMGROUPDATASEQ&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;name&quot; &quot;ITEMGROUPDATASEQ&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;label&quot; &quot;Record identifier&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;type&quot; &quot;Record integer&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
        <xsl:for-each select="odm:ItemRef">
			<xsl:variable name="ItemOID" select="@ItemOID"/>
			<xsl:variable name="OID" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@OID)"/>
			<xsl:variable name="Name" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@Name)"/>
			<xsl:variable name="DataType" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@DataType)"/>
			<xsl:variable name="Label" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/odm:Description/odm:TranslatedText)"/>
			<xsl:variable name="Length" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@Length)"/>
			<xsl:text>						write open object;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;OID&quot; &quot;</xsl:text> <xsl:value-of select="$OID"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;name&quot; &quot;</xsl:text> <xsl:value-of select="$Name"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;label&quot; &quot;</xsl:text> <xsl:value-of select="$Label"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;type&quot; &quot;</xsl:text> 
				<xsl:choose>
					<xsl:when test="$DataType = 'text' or $DataType = 'datetime' or $DataType = 'date' or $DataType = 'time' or $DataType = 'partialDate' or $DataType = 'partialTime' or
					                $DataType = 'partialDatetime' or $DataType = 'incompleteDatetime' or $DataType = 'durationDatetime'">
						<xsl:text>string</xsl:text>
					</xsl:when>
					<xsl:when test="$DataType = 'integer'">
						<xsl:text>integer</xsl:text>
					</xsl:when>
					<xsl:when test="$DataType = 'float'">
						<xsl:text>float</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose> 
			 <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:if test="$Length">
				<xsl:text>							write values &quot;length&quot; &quot;</xsl:text> <xsl:value-of select="$Length"/> <xsl:text>&quot;;</xsl:text>
				<xsl:value-of select="$lf"/> 
			</xsl:if>
			<xsl:text>						write close;</xsl:text>
			<xsl:value-of select="$lf"/> 
        </xsl:for-each>
		<xsl:text>					write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;itemdata&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write open array;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						export __data_</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text> / nokeys;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>run;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>filename __out clear;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>proc sql noprint;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	drop table __data_</xsl:text><xsl:value-of select="$SASDatasetName"/><xsl:text>;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>quit;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
    </xsl:for-each>
	<xsl:value-of select="$lf"/> 
	<xsl:text>libname __tmp clear;</xsl:text>   
</xsl:template> 
	
</xsl:stylesheet>