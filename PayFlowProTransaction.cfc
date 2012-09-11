<!---  
     Copyright 2010 Patrick McElhaney

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
	
	
	 Changes:
	 9/5/2012 Pawel Dulak: added "credit", "void", "setBaseParams", "setReferenceTransaction" functions and a possibility to use Reference Transaction ID in "run"
	 
--->

<cfcomponent>

<cffunction name="init" output="no">
	<cfargument name="gateway">
	<cfset variables.transactionID = CreateUUID()>
	<cfset variables.gateway = arguments.gateway>
	<cfset variables.origID = "">
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

<cffunction name = "setReferenceTransaction" output="no">
	<cfargument name="pnref">
	<cfset variables.origid = arguments.pnref>
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

<cffunction name="setBaseParams" output="no">
	<cfset var params = structNew()>
	<cfset params.user = variables.username>
	<cfset params.pwd = variables.password>
	<cfset params.partner = "Verisign">
	<cfset params.vendor = variables.vendor>
	<cfset params.tender = "C">
	<cfreturn params>
</cffunction>

<cffunction name="run" output="no">
	<cfset params = setBaseparams()>
	<cfset params.trxtype = "S">
	<cfset params.amt = variables.amount>
	<cfif variables.origID NEQ "">
		<cfset params.origID = variables.origID>
	<cfelse>
		<cfset params.expdate = formatExpirationDate()>
		<cfset params.acct = variables.cardNumber>
	</cfif>

	<cfset variables.response = variables.gateway.executeTransaction(params, variables.transactionID)>

</cffunction>

<cffunction name="credit" output="no">
	<cfset params = setBaseparams()>
	<cfset params.trxtype = "C">
	<cfset params.amt = variables.amount>
	<cfset params.origID = variables.origID>

	<cfset variables.response = variables.gateway.executeTransaction(params, variables.transactionID)>

</cffunction>

<cffunction name="void" output="no">
	<cfset params = setBaseparams()>
	<cfset params.trxtype = "V">
	<cfset params.origID = variables.origID>

	<cfset variables.response = variables.gateway.executeTransaction(params, variables.transactionID)>

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

<cffunction name = "transactionID" output="no">
	<cfif isDefined("variables.transactionID")>
		<cfreturn variables.transactionID>
	<cfelse>
		<cfreturn -1/>
	</cfif>
</cffunction>

</cfcomponent>