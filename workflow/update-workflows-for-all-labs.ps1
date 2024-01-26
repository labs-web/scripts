# Update workflow to all labs
Write-Host "`n Ce script ne peut pas être exécuter dans github action `n"

. "./scripts/core/core.ps1"
# Core : Params
$debug = $true
$confirm_message = $false

# inputs
$depot_path = $(Get-Location).Path
$organisation_repositories_path = $depot_path + "/../"
$repositories_paths = Get-ChildItem $organisation_repositories_path -Filter * 

confirm_to_continue "Mise à jour de tous les workflow de : $organisation_repositories_path"

# Copy template from gestion-projet to all labs
foreach($repository in $repositories_paths){

    # Nom de lab
    $repository_name = $repository.Name
    $repository_full_name =$repository.FullName 

    # Ne pas toucher les template de gestion-projet
    if($repository.Name -eq "scripts"){continue}


    confirm_to_continue "Modifier les workflow de $repository_name"

    # Create .github folder if not exist 
    if (-not(Test-Path ($repository_full_name + "/.github"))) {
        debug "run : mkdir ($repository_full_name/.github) "
        mkdir ($repository_full_name + "/.github")
    }

    # Create workflows folder if not exist
    if (-not(Test-Path ($repository_full_name + "/.github/workflows"))) {
        mkdir ($repository_full_name + "/.github/workflows")
    }

    # Copy files
    $script_workflows_path = $organisation_repositories_path + "scripts/.github/workflows/"

    confirm_to_continue "Copy update-issues-from-backlog.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-issues-from-backlog.yml" "$repository_full_name/.github/workflows/"
    
    confirm_to_continue "Copy update-readme-file.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-readme-file.yml" "$repository_full_name/.github/workflows/"


}

