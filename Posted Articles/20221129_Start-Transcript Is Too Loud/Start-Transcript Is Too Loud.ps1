<# 

.Synopsis 

   Start a transcript - but without the string output 

.EXAMPLE 

   Start-QuietTranscript -Path ".\test.log" 

.INPUTS 

   NONE 

.OUTPUTS 

   NONE 

.NOTES 

   NONE 

#> 



function Start-QuietTranscript 

{ 

    [CmdletBinding(DefaultParameterSetName='Parameter Set 1',  

                  SupportsShouldProcess=$true,  

                  PositionalBinding=$false, 

                  ConfirmImpact='Medium')] 



    Param 

    ( 

        # Param1 help description 

        [Parameter(Mandatory=$false)]  

        [STRING]$Path, 



        # Param2 help description 

        [Parameter(Mandatory=$false)] 

        [switch]$Append 

    ) 

    Begin 

    { 

        if($PSBoundParameters.ContainsKey('Verbose')) 

        { 

            $scopeVerbosePreference = $PSBoundParameters.SyncRoot['Verbose'].IsPresent 

        } 

        else 

        { 

            $scopeVerbosePreference = $VerbosePreference 

        } 

        Write-Verbose "BEGIN $($MyInvocation.mycommand.name)" -Verbose:$scopeVerbosePreference 

    } 

    Process 

    { 

        Write-Verbose "PROCESS $($MyInvocation.mycommand.name)" -Verbose:$scopeVerbosePreference 

        if ($pscmdlet.ShouldProcess("Target", "Operation")) 

        { 

        } 

        Get-Location -Verbose:$scopeVerbosePreference

        Start-Transcript -Path $Path -Append:$Append | Out-Null 

    } 

    End 

    { 

        Write-Verbose "END $($MyInvocation.mycommand.name)" -Verbose:$scopeVerbosePreference 

        Write-Verbose "EXIT $($MyInvocation.mycommand.name)" -Verbose:$scopeVerbosePreference 

    } 

} 