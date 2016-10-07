 ############################################################################################################################################################################################################
## SAMPLE CODE ONLY
## Written by:  Shawn Tierney
## December 19, 2015
##
## 1. The WebHookData parameter is passed from the OMS Alert as an input parameter to the runbook.  This cannot be changed.  
## 2. Visit my blog post at for detailed insight into the code configuration.
############################################################################################################################################################################################################


Param(
    [Parameter(Mandatory=$false)][object]$WebHookData
	)

#Function to restart service on server
Function OMS-RestartService
{
    Param(
        [Parameter(Mandatory=$true)][String]$ComputerName,
		[Parameter(Mandatory=$true)][String]$ServiceName
        #[Parameter(Mandatory=$true)][PSCredential]$Credential
    	)
		
	Try
		{
		$Service = Get-WmiObject -Class Win32_Service -Filter "name='$ServiceResult'" -ComputerName $ComputerName #-Credential $Credential  
		$ServiceDisplay = ($Service).Name
	    $ServiceStatus = ($Service).State
		If ($ServiceStatus -eq "Stopped")
			{
			$Service.StartService()
			Write-Verbose "The $ServiceDisplay service on $ComputerName has been started."
			}	
	    Else
	        {
	        Write-Verbose "The $ServiceDisplay service is already running on $ComputerName. Runbook execution terminated."
	        Break
	        }
		}
	Catch 
		{
		#write-host "Caught an exception:" -ForegroundColor Red
		#write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
		$ErrorMessage= "Exception Message: $($_.Exception.Message)" 
		#write-host "ExceptionMessage: $($_.Exception.Message)" -ForegroundColor Red
		}
		
	#Check service status
	$ServiceCheck=Get-WmiObject -Class Win32_Service -Filter "name='$ServiceResult'" -ComputerName $ComputerName #-Credential $Credential
	$ServiceCheckStatus=($ServiceCheck).state
	
	If ($ErrorMessage)
		{
	    If ($ServiceCheckStatus -eq "Stopped")
	        {
		    Write-Verbose "`
	The $ServiceDisplay service did not start successfully on $ComputerName. `
	$ErrorMessage"
		    }
	    Else 
		    {
		    Write-Verbose "`
	The $ServiceDisplay service is running on $ComputerName but the runbook executed with errors. `
	$ErrorMessage"
		    }
		}
	Else
	    {
	    If ($ServiceCheck -eq "Stopped")
	        {
	        Write-Verbose " The $ServiceDisplay service on $ComputerName failed to start with no errors."
			}
	    }
}
#End Function

#Get credentials 
#$CredentialAsset="OMDemoCred"
#$OMDemoCred = Get-AutomationPSCredential -Name $CredentialAsset
#Process inputs from webhook data
Write-Verbose "Processing inputs from webhook data."
$WebhookBody    =   $WebhookData.RequestBody
$SearchResults = (ConvertFrom-JSON $WebhookBody).SearchResults
$SearchResultsValue = $SearchResults.value

#For each computer generating the alert, restart the service.  We are using the SourceServer_CF field to identify the server, which is a custom field created in OMS.
Foreach ($item in $SearchResultsValue)
	{
	$ComputerName=$item.SourceDisplayName
	$ServiceResult=$item.ServiceName_CF
	
	#Execute OMS-RestartService function
	OMS-RestartService -ComputerName $ComputerName -ServiceName $ServiceResult #-Credential $OMDemoCred
	}
