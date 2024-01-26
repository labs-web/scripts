# Update workflow to all labs

. "./scripts/core/core.ps1"
# Core : Params
$debug = $true
$confirm_message = $true

# Emplacement des labs 
$organisation_repositories_path = $PSScriptRoot + "/../../"


$repositories_paths = Get-ChildItem . -Filter * 

# Copy template from gestion-projet to all labs
foreach($repository in $repositories_paths){

    # Nom de lab
    $repository_name = $repository.Name
    $repository_full_name =$repository.FullName 

    # Ne pas toucher les template de gestion-projet
    if($repository.Name -eq "scripts"){continue}


    confirm_to_continue "Modifier les workflow de $repository_name"

    # Delete templates if exist
    # $issue_template_path = $repository_full_name + "/.github/ISSUE_TEMPLATE"
    # if (Test-Path $issue_template_path) {
    #     Write-Host "Delete : $issue_template_path "
    #     rm $issue_template_path -r -force
    # }

    # Create .github folder if not exist 
    if (-not(Test-Path ($repository_full_name + "/.github"))) {
        mkdir ($repository_full_name + "/.github")
    }

    # Create workflows folder if not exist
    if (-not(Test-Path ($repository_full_name + "/.github/workflows"))) {
        mkdir ($repository_full_name + "/.github/ISSUE_TEMPLATE")
    }

    # Copy files
    $script_workflows_path = $organisation_repositories_path + "scripts/.github/workflows/"

    confirm_to_continue "Copy update-issues-from-backlog.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-issues-from-backlog.yml" "$repository_full_name/.github/workflows/"
    
    confirm_to_continue "Copy update-readme-file.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-readme-file.yml" "$repository_full_name/.github/workflows/"


}

