# Update README.md file from lab-web.json
# L'utilisateur doit exécuter ce script sur la racine du lab

. "./scripts/core/core.ps1"
. "./scripts/core/pullrequest-core.ps1"

# Core : Params
$debug = $true
$confirm_message = $false

# Input 
$depot_path = $(Get-Location).Path
$readme_path= "$depot_path\README.md"
$readme_json_path = "$depot_path/README.json"
$backlog_files_path = "$depot_path\backlog"
$branche_name = "update-readme-file"
# Load readme_data
$readme_data = Get-Content $readme_json_path  | ConvertFrom-Json

# 
# Génération de contenue de fichier README
#

# Introduction
$readme_string = "# $($readme_data.Introduction.Titre) `n`n"
$readme_string += "- Référence :  $($readme_data.Introduction.Reference) `n`n"
$readme_string += "$($readme_data.Introduction.Description) `n`n"
# Backlog
$readme_string += "## $($readme_data.Backlog.Titre) `n`n"
$readme_string += "$($readme_data.Backlog.Introduction) `n`n"


Get-ChildItem $backlog_files_path |  ForEach-Object {
    $backlog_item_file_name = $_.Name
    $readme_string += "- [$backlog_item_file_name](./Backlog/$backlog_item_file_name) `n"
} 


## Livrables 
$readme_string += "## $($readme_data.Livrables.Titre) `n`n"
$readme_string += "$($readme_data.Livrables.Introduction) `n`n"
$readme_data.Livrables.Livrables |  ForEach-Object {
    $readme_string += "- $($_.Titre) `n"
    if(-not($_.Description -eq "")){
        $readme_string += "  - $($_.Description) `n"
    }
} 
## Références 
$readme_string += "## $($readme_data.References.Titre) `n`n"
$readme_string += "$($readme_data.References.Introduction) `n`n"

$readme_data.References.References |  ForEach-Object {
    $readme_string += "- [$($_.Titre)]($($_.Lien)) `n"
} 

# Enregistrement de fichier README et envoie de pullrequest to branch develop
create_branch_to_do_pull_request $branche_name  
Set-Content $readme_path $readme_string
save_and_send_pullrequest_if_files_changes $branche_name $true

