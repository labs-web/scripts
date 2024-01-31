# Init and Update label for current Repository
Write-Host "Params : [-d : debugage]"
Write-Host "`n Ce script ne peut pas être exécuter dans github action `n"

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

$remote_labels = $null


# Le sctipy doit être exécuter dans le dossier racine de lab-web
$depot_path = $(Get-Location).Path
$repository_path = $depot_path+ "/../"
Set-Location $repository_path

confirm_to_continue("Update label pour all rapositories for : $repository_path ")

$repositories = Get-ChildItem . -Filter * 
foreach($repository in $repositories){

    $repository_fullname = $repository.FullName
    $repository_name = $repository.Name
  
    # confirm_to_continue("Update labels pour : $repository_name")
    cd $repository_fullname

    Write-Host "Update labels for $repository"
    
    $remote_labels = gh label list --json name,color | ConvertFrom-Json
    delete_default_labels($remote_labels)
    Create_or_Update_remote_labels($remote_labels)

}

