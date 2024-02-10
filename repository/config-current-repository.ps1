# Config current repository
# Init or updat the configuration for current repositories
Write-Host "`n - Ce script ne peut pas être exécuter dans github action `n"
Write-Host "`n - Ce script doit être excuter au racine de dépôt `n"

. "./scripts/core/core.ps1"
# Core : Params
$debug = $true
$confirm_message = $true

. "./scripts/core/config-repository.core.ps1"

# inputs
$depot_path = $(Get-Location).Path


$repository_full_name = $depot_path
$repository_name = Split-Path -Path $repository_full_name -Leaf 

confirm_to_continue "Mise à jour de la configuration de dépôt : $repository_name : $repository_full_name "


init_or_updat_config_repository   $repository_name $repository_full_name

