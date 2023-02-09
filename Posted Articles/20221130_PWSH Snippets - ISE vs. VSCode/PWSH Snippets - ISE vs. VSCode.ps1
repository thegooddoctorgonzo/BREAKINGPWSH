New-IseSnippet -Title "1_Script-Header" -Description "1_Script-Header" -Text ` #<Grave Accent

' #<Single Quote

<#	

    .NOTES

    ===========================================================================

        Created on:   	***

        Created by:   	***

        Organization: 	***

        Filename:     	***

        DESCRIPTION:    ***

    ===========================================================================



#>

'

######################################################

Get-IseSnippet

######################################################

(Get-IseSnippet)[2] | Remove-Item

#####################################################

"Name": {

    "prefix": ["for", "for-const"],

    "body": ["FUNC_TEXT"],

    "description": "A for loop."

  }