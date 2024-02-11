# Config all repositorues 
# Init ou Update the repositories configuration

# TODO : add label thème to defaul label et backlog folder

Write-Host "`n - Ce script ne peut pas être exécuter dans github action `n"
Write-Host "`n - Ce script doit être excuter au racine de dépôt `n"

. "./scripts/core/core.ps1"
# Core : Params
$debug = $true
$confirm_message = $false

. "./scripts/core/synchroniser.codre.ps1"
. "./scripts/core/config-repository.core.ps1"

# inputs
$depot_path = $(Get-Location).Path
$organisation_repositories_path = $depot_path + "/../"
$repositories_paths = Get-ChildItem $organisation_repositories_path -Filter * 

confirm_to_continue "Mise à jour de tous les dépôts : $organisation_repositories_path"


foreach($repository in $repositories_paths){

    # Ne pas traiter les dossier qui commance par "_"
    if($repository.Name -like "_*") {continue}

    $repository_name = $repository.Name
    $repository_full_name =$repository.FullName 
    init_or_updat_config_repository   $repository_name $repository_full_name
}
