<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:output method="html"/>
<xsl:template match="/">
<html>
<head>
<title>CloudBTS_PreCheck_status_watch</title>
<style>
body {
	margin: 10px;
	padding: 10px;
	line-height: 1.5em;
	font-family: "Times New Roman", Times, serif;
	font-size: 14px;
	color: #000000;
	background:#FFFFFF
	}
</style>
</head>
<body>
<h1 align="center">CloudBTS_PreCheck_status_watch</h1>
<table cellpadding="2px" style="width:90%;background:#FFFFFF;border:1px solid #CCF4FF;text-align:left; margin:0 auto">
<tr style="background:#A8BBC0">
<th>Date</th>
<th>Modify ECL</th>
<th>Frozen</th>
<th>Build</th>
<th>QT</th>
</tr>
<xsl:apply-templates />
</table>
</body>
</html>
</xsl:template>
<!-- </xsl:transform> -->

<xsl:template match="precheck">
<tr>
<td><xsl:value-of select="@date"/></td>
<xsl:apply-templates select="modify_ecl"/>
<xsl:apply-templates select="frozen"/>
<xsl:apply-templates select="build"/>
<xsl:apply-templates select="qt"/>
</tr>
</xsl:template>

<xsl:template match="modify_ecl">
<xsl:variable name="fdd_url" select="@fdd_baseline"/>
<xsl:variable name="nidd_url" select="@nidd_cbts"/>
<xsl:choose>
<xsl:when test='@result = "success"'>
<td bgcolor="#9acd32">
<a href="https://wft.int.net.nokia.com/LTE:WMP:FDD/WMP%20FSM4/builds/{$fdd_url}">
<font size="2" face="arial"><xsl:value-of select="@fdd_baseline"/></font>
</a>
<br />
<a href="https://wft.int.net.nokia.com/SBTS/SBTS_NIDD/builds/{$nidd_url}">
<font size="2" face="arial"><xsl:value-of select="@nidd_cbts"/></font>
</a>
</td>
</xsl:when>
<xsl:when test='@result != ""'>
<td  style="background:red">
<b>
<font size="2" face="arial"><xsl:value-of select="@result"/></font>
<br />
<a href="https://wft.int.net.nokia.com/LTE:WMP:FDD/WMP%20FSM4/builds/{$fdd_url}">
<font size="2" face="arial"><xsl:value-of select="@fdd_baseline"/></font>
</a>
<br />
<a href="https://wft.int.net.nokia.com/SBTS/SBTS_NIDD/builds/{$nidd_url}">
<font size="2" face="arial"><xsl:value-of select="@nidd_cbts"/></font>
</a>
</b>
</td>
</xsl:when>
<xsl:otherwise>
<td></td>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="frozen">
<xsl:choose>
<xsl:when test='@result = "success"'>
<td bgcolor="#9acd32">
<xsl:variable name="tag_url" select="@tag"/>
<a href="https://wft.int.net.nokia.com/C_BTS:CBTS/CI_FSM4/builds/{$tag_url}">
<font size="2" face="arial"><xsl:value-of select="@tag"/></font>
</a>
</td>
</xsl:when>
<xsl:when test='@result = "fail"'>
<td style="background:red"><b><font size="2" face="arial">failed</font></b></td>
</xsl:when>
<xsl:when test='@result = "building"'>
<td>
<b>
<font size="2" face="arial">building</font>
</b>
<img src="http://hzlinb130.china.nsn-net.net:8080/static/96727dcd/images/spinner.gif" />
</td>
</xsl:when>
<xsl:otherwise>
<td></td>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="build">
<xsl:choose>
<xsl:when test='@result = "success"'>
<td bgcolor="#9acd32">
<b><font size="2" face="arial">SUCCESS</font></b>
</td>
</xsl:when>
<xsl:when test='@result = "fail"'>
<td style="background:red"><b><font size="2" face="arial">failed</font></b></td>
</xsl:when>
<xsl:when test='@result = "building"'>
<td>
<b>
<font size="2" face="arial">building</font>
</b>
<img src="http://hzlinb130.china.nsn-net.net:8080/static/96727dcd/images/spinner.gif" />
</td>
</xsl:when>
<xsl:otherwise>
<td></td>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="qt">
<xsl:choose>
<xsl:when test='@result = "success"'>
<td bgcolor="#9acd32">
<b><font size="2" face="arial">released</font></b>
</td>
</xsl:when>
<xsl:when test='@result = "fail"'>
<td style="background:red"><b><font size="2" face="arial">not release</font></b></td>
</xsl:when>
<xsl:when test='@result = "building"'>
<td>
<b>
<font size="2" face="arial">testing</font>
</b>
<img src="http://hzlinb130.china.nsn-net.net:8080/static/96727dcd/images/spinner.gif" />
</td>
</xsl:when>
<xsl:otherwise>
<td></td>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>