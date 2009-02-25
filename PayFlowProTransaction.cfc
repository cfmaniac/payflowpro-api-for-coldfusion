<cfcomponent>

<cffunction name="init" output="no">
	<cfargument name="gateway">
	<cfset variables.transactionID = CreateUUID()>
	<cfset variables.gateway = arguments.gateway>
	<cfreturn this>
</cffunction>

<cffunction name = "setAmount" output="no">
	<cfargument name="amount">
	<cfset variables.amount = arguments.amount>
</cffunction>

<cffunction name = "setVendor" output="no">
	<cfargument name="vendor">
	<cfset variables.vendor = arguments.vendor>
</cffunction>

<cffunction name = "setUsernameAndPassword" output="no">
	<cfargument name="username">
	<cfargument name="password">
	<cfset variables.username = arguments.username>
	<cfset variables.password = arguments.password>
</cffunction>

<cffunction name = "setCardNumber" output="no">
	<cfargument name="cardNumber">
	<cfset variables.cardNumber = arguments.cardNumber>
</cffunction>

<cffunction name = "setExpirationMonthAndYear" output="no">
	<cfargument name="month">
	<cfargument name="year">
	<cfset variables.expiresMonth = arguments.month>
	<cfset variables.expiresYear = arguments.year>
</cffunction>

<cffunction name = "authCode" output="no">
	<cfif isDefined("variables.response.authCode")>
		<cfreturn variables.response.authCode>
	<cfelse>
		<cfreturn "">		
	</cfif>
</cffunction>
	
<cffunction name = "pnRef" output="no">
	<cfif isDefined("variables.response.pnRef")>
		<cfreturn variables.response.pnRef>
	<cfelse>
		<cfreturn "">		
	</cfif>
</cffunction>
	
<cffunction name="run" output="no">
	<cfset var params = structNew()>
	<cfset params.user = variables.username>
	<cfset params.pwd = variables.password>
	<cfset params.partner = "Verisign">
	<cfset params.vendor = variables.vendor>
	<cfset params.trxtype = "S">
	<cfset params.tender = "C">
	<cfset params.amt = variables.amount>
	<cfset params.expdate = formatExpirationDate()>
	<cfset params.acct = "#variables.cardNumber#">
	<cfset params.comment1 = "SBC#dateFormat(now(), 'mmddyy')#">
	
	<cfset variables.response = variables.gateway.chargeCard(params, variables.transactionID)>
	
</cffunction>



<cffunction name = "formatExpirationDate" output="no">
	<cfreturn numberFormat(variables.expiresMonth, "00") & numberFormat(right(variables.expiresYear, 2), "00")>
</cffunction>



<cffunction name = "resultCode" output="no">
	<cfif isDefined("variables.response.result")>
		<cfreturn variables.response.result>
	<cfelse>
		<cfreturn -1/>
	</cfif>
</cffunction>

<cffunction name = "responseMessage" output="no">
	<cfif isDefined("variables.response.respmsg")>
		<cfreturn variables.response.respmsg>
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name = "approved" output="no">
	<cfreturn 0 eq resultCode()>
</cffunction>
		
</cfcomponent>

