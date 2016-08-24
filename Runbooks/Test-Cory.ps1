workflow Test-Cory
{
    
    param ( 
        [string]$WebhookData
    ) 

        # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

		#$WebhookName
		#$WebhookHeaders
		
		Write-Output | ConvertFrom-Json -InputObject $WebhookBody
		
}