#! /usr/bin/pwsh
# Import-Module .\src\modules\<ModuleName>.psm1

#########################
####### Functions #######
#########################
function EndingMessage {
    <#
    .SYNOPSIS
        Random Message from the [.\src\responses.list] file
    
    .DESCRIPTION
        Randomly selects a line from the [.\src\responses.list] file
        Randomly selects a color that is available
    
        Prints the line in that color

    .PARAMETER Error
    Determines whether or not this cmdlet is called for an error

    .NOTES
        Author: Michael A. Warren
        E-Mail: mawarren24@gmail.com
    #>
    param (
        [switch]
        $Error
    )
    PROCESS {
        $Responses = @(Get-Content .\src\responses.list)
        $ResponseIdx = Get-Random -Maximum $Responses.Length
        # $Colors = @([enum]::GetValues([System.ConsoleColor]))
        # $ColorIdx = Get-Random -Maximum $Colors.Length
        if ($Error) {
            $Color = "Yellow"
        } else {
            $Color = "Green"
        }
    
        Write-Output ""
        Write-Host $Responses[$ResponseIdx] -ForegroundColor $Color
        Write-Output ""
    }
}

function Get {
    <#
    .SYNOPSIS
    Make an HTTP GET request
    
    .DESCRIPTION
    Given the needed parameters, sending a GET request to get the requested data in the response

    .PARAMETER Headers
    Headers needed to make the HTTP request
    
    .PARAMETER Uri
    Uri to send the request to

    .PARAMETER MAC
    MAC address of device to delete profile on error

    .EXAMPLE
    Get -Headers $Headers -Uri $Uri -MAC $MAC
    
    .NOTES
    Author: Michael A. Warren
    E-Mail: mawarren24@gmail.com
    
    Modified from https://medium.com/@chuck.connell.3/http-post-from-powershell-45a36581572
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]
        $Headers,
        [Parameter(Mandatory)]
        [Uri]
        $Uri,
        [Parameter(Mandatory)]
        [ValidatePattern("^[A-F0-9]{12}")]
        [string]
        $MAC
    )

    PROCESS {
        $response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -ContentType "application/x-www-form-urlencoded"

        if ($response.StatusCode -eq 200) {
            return
        }

        # Assigned but not used to avoid unnecessary printing in console
        $DisconnectProfileResponse = netsh wlan disconnect
        $DeleteProfileResponse = netsh wlan delete name=$Name
        ThrowError "Error with GET command
$Uri
statuscode: ${response.StatusCode}
error: ${(ConvertFrom-Json $response).error}
        "
    }
}

function Post {
    <#
    .SYNOPSIS
    Make an HTTP POST request
    
    .DESCRIPTION
    Given the needed parameters, sending a POST request to get the requested data in the response
    
    .PARAMETER Headers
    Headers needed for the HTTP request
    
    .PARAMETER Body
    Body needed for the HTTP request
    
    .PARAMETER Uri
    Uri to send the request to

    .OUTPUTS
    JSON

    .EXAMPLE
    Post -Headers $Headers -Body $Body -Uri $Uri
    
    .NOTES
    Author: Michael A. Warren
    E-Mail: mawarren24@gmail.com
    
    Modified from https://medium.com/@chuck.connell.3/http-post-from-powershell-45a36581572
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]
        $Headers,
        [Parameter(Mandatory)]
        [Object]
        $Body,
        [Parameter(Mandatory)]
        [Uri]
        $Uri
    )

    PROCESS {
        $response = Invoke-WebRequest -Method Post -Uri $Uri -Body $Body -Headers $Headers -ContentType "application/x-www-form-urlencoded"

        if ($response.StatusCode -eq 200) {
            return $response.Content
        }
        ThrowError "Error with POST command
$Uri
statuscode: ${response.StatusCode}
error: ${(ConvertFrom-Json $response).error}
        "
    }
}

function ThrowError {
    <#
    .SYNOPSIS
        Terminating error that adds a specific decoration
    
    .DESCRIPTION
        Throws a specific error explaining where the problem is 
        and what the user should do about it
    
    .PARAMETER ErrorMsg
        message to explain where the problem actually is
    
    .PARAMETER HandleSuggestion
        submessage to show a suggestion for handling the error

    .EXAMPLE
        Throw-Error "The system cannot find the file specified"

    .NOTES
        Author: Michael A. Warren
        E-Mail: mawarren24@gmail.com
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ErrorMsg,
        [Parameter()]
        [string]
        $HandleSuggestion = "Contact Developer with this error"
    )

    PROCESS {

        $Stars = '*' * ((Get-Host).UI.RawUI.MaxWindowSize.Width)
    
        Write-Error "
$Stars

$ErrorMsg

$HandleSuggestion

$Stars
        "
        EndingMessage -Error
        Exit
    }
}