# Update README file for lab
 
# Encoding utf8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Functions : confirmation
function confirm_to_continue($message) {
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) { 
        exit
    } 
}
 
# L'utilisateur doit exécuter ce script sur le racine du lab
confirm_to_continue("Vous devez exécuter ce script sur la racine du lab")

# lab-reference

$depot_path = Get-Location
$depot_path = $depot_path.Path
$readme_path= "$depot_path\README.md"
$lab_web_data = "$depot_path/lab-web.json"
# Confirmation
# confirm_to_continue("Update de fichier $readme_path ")


# Load JSON
$json_data = Get-Content $lab_web_data  | ConvertFrom-Json


# Création de fichier README
$readme_string = "# $($json_data.Introduction.Titre) `n"
$readme_string += "- Référence :  $($json_data.Introduction.Référence) `n`n"
$readme_string += "$($json_data.Introduction.Description) `n"

# Enregistrement de fichier README
Set-Content $readme_path $readme_string
