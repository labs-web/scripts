# TODO : Script d'initialisation d'un lab

## Initialisation de dépôt

### Copy snippets
# backlog-item,doc-item

### Copy issues template

### Copy githib workflow
# update-issues-from-backlog

## Initalisation de lab-web ou lab-phase


# Encoding utf8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
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
confirm_to_continue("Vous devez exécuter ce script sur le racine du lab")

# lab-reference
function get_lab_reference {
    $depot_path = Get-Location
    $depot_path = $depot_path.Path
    $depot_path_array = $depot_path.Split('\')
    return $depot_path_array[2] 
}
$lab_reference= get_lab_reference

# Confirmation
confirm_to_continue("Création de lab $lab_reference ")

# Création de fichier .code-workspace de vs code
$work_space_file_name = "$lab_reference.code-workspace"
new-item $work_space_file_name
Set-Content $work_space_file_name '{"folders": [{"path": "."}],"settings": {}}'

# create develop branch
git add .
git commit -m "save"
git push
git checkout -b "develop"
git push --set-upstream origin develop

#  set develop branch as default 
gh repo edit --default-branch develop
