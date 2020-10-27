<#
.SYNOPSIS 
    Sample runbook to demonstrate using the Set-RunbookLock runbook to only allow one instance
    of a runbook to execute at a time. You can import the Set-RunbookLock runbook from the gallery and
    must publish it before this runbook can be run.

.DESCRIPTION
    This runbook demonstrates using the Set-RunbookLock runbook to only allow one instance
    of a runbook to execute at a time. It first requests a lock before doing any work by
    calling Set-RunbookLock with the -Lock parameter set to $true and then once it completes
    its work it calls Set-RunbookLock with the -Lock parameter to $false so that the next
    job for this runbook can continue if one is waiting.
    
.PARAMETER AutomationAccountName
    The name of the Automation account where this runbook is started from

.PARAMETER AzureOrgIdCredential
    A credential setting containing an Org Id username / password with access to this Azure subscription 

.EXAMPLE
    Set-RunbookLockSample -AutomationAccountName "finance" -AzureOrgIdCredential "MSDNCredential"

.NOTES
    AUTHOR: System Center Automation Team
    LASTEDIT: Oct 16, 2014 
#>
workflow Set-RunbookLockSample
{  
    Param
    (            
        [parameter(Mandatory=$true)]
        [String]
        $AutomationAccountName,
        
        [parameter(Mandatory=$true)]
        [String]        
        $AzureOrgIdCredential
    )

    # Only run one job for this runbook at a time so set a lock
   Set-RunbookLock -AutomationAccountName $AutomationAccountName -AzureOrgIDCredential $AzureOrgIdCredential -Lock $True
 
    # Do some work...
    Try
    {
        Sleep 30
        
        # Finished. Remove the lock so another job for this runbook can continue if there is one
        Set-RunbookLock -AutomationAccountName $AutomationAccountName -AzureOrgIDCredential $AzureOrgIdCredential -Lock $False
    }
    Catch
    {
        Write-Verbose "Catching exceptions here so this runbook does not continually get restarted and other jobs run"
        # Remove the lock
        Set-RunbookLock -AutomationAccountName $AutomationAccountName -AzureOrgIDCredential $AzureOrgIdCredential -Lock $False
        
        Write-Error "Stopping this job with exception: $_"
        $AzureCred = Get-AutomationPSCredential -Name $AzureOrgIdCredential
        $Null = Add-AzureAccount -Credential $AzureCred      
        
        # Get the automation job id for this runbook job
        $AutomationJobID = $PSPrivateMetaData.JobId.Guid
        
        # Stop this job since it had an exception
        $Null = Stop-AzureAutomationJob -AutomationAccountName $AutomationAccountName -Id $AutomationJobID
        
        # Sleep here for a few minutes to allow the job to stop before it completes
        Sleep 600
    }
}