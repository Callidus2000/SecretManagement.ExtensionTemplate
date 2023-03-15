function Reset-SMERunspace {
    <#
    .SYNOPSIS
    Determines the runspace used by SecretManagement and disposes it.

    .DESCRIPTION
    Determines the runspace used by SecretManagement and disposes it.

    .EXAMPLE
    Reset-SMERunspace

    Resets the runspace of SecretManagement.

    .NOTES
    This function is based on llewellyn-marriott solution around the following issue:
    https://github.com/PowerShell/SecretManagement/issues/206#issuecomment-1469306985
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param (

    )
    # Get the runspace field
    $RunspaceField = (([Microsoft.PowerShell.SecretManagement.SecretVaultInfo].Assembly.GetTypes() | Where-Object Name -eq 'PowerShellInvoker').DeclaredFields | Where-Object Name -eq '_runspace')
    # Get current runspace value and dispose of it
    $RunspaceValue = $RunspaceField.GetValue($null)
    if ($NULL -ne $RunspaceValue) {
        $RunspaceValue.Dispose()
    }
    # Set the runspace field to null
    $RunspaceField.SetValue($null, $null)
}