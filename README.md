Sample runbook to demonstrate using the Set-RunbookLock runbook
===============================================================

            

This runbook demonstrates using the Set-RunbookLock runbook to only allow one instance of a runbook to execute at a time. It first requests a lock before doing any work by calling Set-RunbookLock with the -Lock parameter set to $true.


Once it completes its work it calls Set-RunbookLock with the -Lock parameter to $false so that the next job for this runbook can continue if one is waiting.



        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
