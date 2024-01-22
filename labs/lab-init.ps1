# Script de création d'un lab-web

## issue : édition de script avec des caractètre en français
# à  éditer avec Encoding : Windows 1252

# issue : Problème d'affichage des caractère en français sur la console
$PSDefaultParameterValues['*:Encoding'] = 'utf8'


# Paramètres 
# $labr_reference=$args[0]
param ($labr_reference='lab-web-1')

# Confirmation
$title    = "Création de lab $labr_reference "
$question = "Are you sure you want to proceed?"
$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 1) {
    Write-Host 'cancelled'
    exit
} 


Write-Host "Initialisation de lab : $labr_reference "

# Création de fichier .code-workspace de vs code
$work_space_file_name = "$labr_reference.code-workspace"
new-item $work_space_file_name
Set-Content $work_space_file_name '{"folders": [{"path": "."}],"settings": {}}'

# init gitflow 
git flow init

#  set develop branch as default 
git push --set-upstream origin develop
gh repo edit --default-branch develop

# Add Branch protection rules