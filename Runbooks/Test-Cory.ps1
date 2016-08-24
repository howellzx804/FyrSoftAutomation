workflow Test-Cory
{
    
    param ( 
        [object]$WebhookData
    ) 

        # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

		#$WebhookName
		#$WebhookHeaders
		
		Write-Output | ConvertFrom-Json -InputObject $WebhookBody
		
}