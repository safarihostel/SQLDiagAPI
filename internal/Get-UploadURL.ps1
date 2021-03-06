##############################
#.SYNOPSIS
# Internal Function to return the URL from the API for uploading the file
#
##############################
function Get-UploadURL{
    [cmdletbinding(SupportsShouldProcess = $true)]
    param( 
        [string]$APIKey,
        [string]$MachineGUID,
        [object]$File,
        [string]$Region,
        [string]$Email
        )
            $size = $File.Length/1MB
            $UploadAPIURL = 'https://ecsapi.azure-api.net/DiagnosticAnalysis/SQLAnalysis/GetUploadUrl'
        $headers = @{ "Ocp-Apim-Subscription-Key" = $apiKey }        
        $Body = 
        @{
            clientId          = $MachineGUID
            fileName          = $File.FullName
            region            = $Region
            notificationEmail = $Email
            metadata          = @{
                fileSize = "$size MB"
            }
        } | ConvertTo-Json

        Write-Verbose -Message "Getting the Upload URL for $($File.FullName) with GetUploadURL API $UploadAPIURL"
        if ($PSCmdlet.ShouldProcess('SQL Analysis GetUploadURL', "Getting the Upload URL for $File with $UploadAPIURL")) { 
            try {
                $UploadResponse = Invoke-RestMethod -Method Post -Uri $UploadAPIURL -Headers $headers -Body $Body -ContentType "application/json"  -ErrorAction Stop
                Write-Verbose -Message "Got the Upload URL $UploadResponse"
            }
            catch {
                Write-Warning -Message "Failed to get the Upload URL from API $UploadAPiURL" 
                break
            }
        }

        $UploadResponse 
}