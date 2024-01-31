# Init and Update label for current Repository
Write-Host "Params : [-d : debugage]"

# Core : Params
$debug = $false
$confirm_message = $true

# Param -d
$debug_param = $args[0]
if($debug_param -eq "-d") {
    $debug = $true
}

. "./scripts/core/core.ps1"
. "./scripts/core/label.core.ps1"

confirm_to_continue "Init and Update label for current Repository"
$remote_labels = gh label list --json name,color | ConvertFrom-Json
delete_default_labels $remote_labels
Create_or_Update_remote_labels $remote_labels
