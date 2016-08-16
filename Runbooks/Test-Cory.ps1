workflow Test-Cory
{
    
    param ( 
        [object]$WebhookData
    ) 

        # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

		$WebhookName
		$WebhookHeaders
		$WebhookBody = $WebhookBody | ConvertFrom-Json
		$WebhookBody | gm
		$WebhookBody
		$WebhookBody | ConvertFrom-Json
		
		
}