<#
    # TODO update name of file with main module name
    .SYNOPSIS
    Give brief description of what the module does

    .DESCRIPTION
    Give detailed description of what the module does

    .PARAMETER ParamName
    Replace `ParamName` with name of parameter,
    and give description of parameter here

    .INPUTS
    give type if input, usually `string`

    .OUTPUTS
    give type of output, if none, use `$null`

    .EXAMPLE
    .\main.ps1 -ParamName ...

    .NOTES
    Author: Michael A. Warren
    E-Mail: mawarren24@gmail.com

    Provide any additional notes for this module

    .LINK
    n/a
#>
[CmdletBinding()]
param(
    # [Parameter(Mandatory)]
    # [<type>]
    # $ParamName
)

BEGIN {
    Import-Module .\src\modules\Functions.psm1
}
PROCESS {
    # Do stuff
}