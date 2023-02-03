function MyBEGIN ($param1, $param2)

{

    Write-Output "IN BEGIN - Param1: $param1"

    Write-Output "IN BEGIN - Param2: $param2"



    if($param2 -eq 1)

    {

        MyEND -param1 $param1 -param2 $param2

    }

    else

    {

        MyPROCESS -param1 $param1 -param2 $param2

    }

}



function MyPROCESS ($param1, $param2)

{

    Write-Output "IN PROCESS - Param1: $param1"

    Write-Output "IN PROCESS - Param2: $param2"



    MyEND -param1 $param1 -param2 $param2

}



function MyEND ($param1, $param2)

{

    Write-Output "IN END - Param1: $param1"

    Write-Output "IN END - Param2: $param2"

}



function Test-NewF

{

    [CmdletBinding()]



    Param

    (

        # Param1 help description

        [Parameter(Mandatory=$true)]

        [string]

        $Param1,



        # Param2 help description

        [Parameter(Mandatory=$true)]

        [int]

        $Param2

    )



    MyBEGIN -param1 $param1 -param2 $param2

}

