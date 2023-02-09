New-Item -Path c:\temp -Name deleteme.txt

Remove-Item -Path C:\TEMP\deleteme.txt



New-Item -Path c:\temp -Name deleteme.txt

Remove-Item -Path C:\TEMP\deleteme.txt -Verbose

########################################################

function Test-Verbose { 

    [CmdletBinding]

    param()

    begin{}

    process{}

    end{}

}

####################################################

function Test-Verbose { 

    [CmdletBinding(SupportsShouldProcess=$true, 

                   ConfirmImpact='Medium')] 

    Param ( 

        [Parameter] 

        $comName, 

        [Parameter] 

        $Strang 

    ) 

    begin { 

        if($PSBoundParameters.ContainsKey('Verbose')) 

        { 

            $scopeVerbosePreference = $PSBoundParameters.SyncRoot['Verbose'].IsPresent 

        } 

        else 

        { 

            $scopeVerbosePreference = $VerbosePreference 

        } 

    } 

    process { 

        Write-Verbose -Message "Test-Verbose: only see this line when -Verbose" -Verbose:$scopeVerbosePreference 

        Write-Host "Test-Verbose: PSBoundParameters" $PSBoundParameters

        Test-V2 -Verbose:$scopeVerbosePreference 

    } 



    end { 

        return $PSBoundParameters 

    } 

} 

############################################################

function Test-V2 { 

    [CmdletBinding(SupportsShouldProcess=$true, 

                   ConfirmImpact='Medium')] 

    param ( 

    ) 

    begin { 

        if($PSBoundParameters.ContainsKey('Verbose')) 

        { 

            $scopeVerbosePreference = $PSBoundParameters.SyncRoot['Verbose'].IsPresent 

        } 

        else 

        { 

            $scopeVerbosePreference = $VerbosePreference 

        } 

    } 



    process { 

        Write-Verbose "Test-V2 : only see this line with -Verbose" -Verbose:$scopeVerbosePreference 

        Write-Host "Test-V2: ScopeVerbosePreference = " $scopeVerbosePreference 

        Write-Host "Test-V2: VerbosePreference = " $VerbosePreference 

    } 

    end { 

        return $PSBoundParameters 

    } 

} 