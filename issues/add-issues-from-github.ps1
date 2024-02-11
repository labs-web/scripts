# Create or updat backlog to issues

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"


# Core : Params
$debug = $true
$test = $false
$confirm_message = $false

$depot_path = Get-Location




# 
# Algorithme 
# 

add_issue_from_github $depot_path