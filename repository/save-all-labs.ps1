# Enregistrement de tous les labs 
Write-Host "`n Ce script ne peut pas être exécuter dans github action `n"


. "./scripts/core/core.ps1"
# Core : Params
$debug = $true
$confirm_message = $false


# Emplacement des labs 
$depot_path = $(Get-Location).Path
$labs_web_path = $depot_path+ "/../"

confirm_to_continue "Push $labs_web_path"
cd $labs_web_path

Get-ChildItem . -Filter * | 
Foreach-Object {

    # Nom de lab
    $FullName = $_.FullName
    $File_Name = $_.Name

    # Message de confirmation
    Write-Host $FullName

    # git push
    confirm_to_continue "push $FullName"
    cd $FullName
    git add .
    git commit -m "save"
    git push
}