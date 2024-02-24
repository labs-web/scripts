. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"
# Core : Params
$debug = $true
$confirm_message = $false


# TODO : Le nom de l'issue peut être commencer par un lettre majuscule, mais l'espace de nom doit être en miniscule
# <!-- TODO : Tous les fichiers markdown doit être situé dans /docs -->


# 
# Paramètres
#
# Param 1 : Nom du pullrequest
$pullrequest_name = $args[0]

# Ce paramètre n'est pas utilisé, car nous comparons HEAD avec develop
# Param 2 :Nombre de commits à valider dans le branch liée à l'issue
$commits = $args[1]

# Param 3 : Les issues reliés au pullrequest
$linked_issues = $args[2]
$linked_issues= $linked_issues.TrimStart("[").TrimEnd("]").Split(',')


# Load config files
# Input 
$depot_path = $(Get-Location).Path
$packages_json_file_path = "$depot_path/backlog/Packages.json"
$packages_json = Get-Content $packages_json_file_path  | ConvertFrom-Json
$packages_config = $packages_json.Packages
function find_package_config ($package_name){
    foreach($package_config in $packages_config ){
        if($package_config.Titre -eq $package_name ){
            return $package_config
        }
    }
    return $null
}

# 
# Inputs d'algorithme
#

# $issue_number and $issue_title
# Règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee
debug "Règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee"
$issue_number = ""
$issue_title = ""
$pullrequest_parts_array = $pullrequest_name.Split('-')
if($pullrequest_parts_array[0] -match "^\d+$" ){
    $issue_number = $pullrequest_parts_array[0]
    $issue_title = $pullrequest_name -replace "$issue_number-",""
}else{
    Write-Host "::error:: Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee"
    exit 1
}

# $package_name,$task_name
# Le nom de l'issue peut être est sous la forme : PackageName_TaskName
# Exemple gestion-projet_backend,gestion-projet_unitTest,gestion-projet_frontend
$issue_title_parts_array = $issue_title.Split('_')
$package_name = $issue_title_parts_array[0]
$task_name = ""
if($issue_title_parts_array.length -gt 0){
    $task_name = $issue_title_parts_array[1]
}
$autorised_change = $true

debug "Inputs d'algorithme :"
debug "package_name = $package_name
 - task_name = $task_name
 - issue_title = $issue_title 
 - issue_number = $issue_number "


# Règle 2 : Le pullrequest doit être relier avec un seul issue 
debug "Règle 2 : Le pullrequest doit être relier avec un seul issue"
debug "Linked issues : $linked_issues"
if($linked_issues -eq $null) {
    Write-Host "::error:: Le pullrequest doit être relié avec un issue"
    exit 1
}
debug "linked_issues.length = $($linked_issues.length)"
if(-not($linked_issues.length -eq  1)) {
    Write-Host "::error:: Le pullrequest doit être relié avec un seul issue"
    $autorised_change = $false
    exit 1
}

## Règle 3 : Le nom du pullrequest doit être égale IssueNumber-NomIssue
debug "Règle 3 : Le nom du pullrequest doit être égale IssueNumber-NomIssue"
# intput : issue name and number
$linked_issue = $linked_issues[0]
$linked_issue_number = $linked_issue.Split('#')[1]
$issue  = find_issue_by_number $linked_issue_number
$linked_issue_name = $issue.title
debug "linked_issue_number = $linked_issue_number
- linked_issue_name = $linked_issue_name
- remote isuue = $issue "
if(-not($issue_title -eq $issue.title) -or -not($issue_number -eq $issue.number) ){
    Write-Host "::error:: Le nom de pullrequest doit être égale :  $($issue.number)-$($issue.title)"
    exit 1
}

# Debug : affichage des informations le branch actuel
debug "Le branch actuel"
git status

# Affichage de liste des fichiers modifiés par le pullrequest
git config core.quotepath off # By default, git will print non-ASCII file names in quoted octal notation
# $chanded_files = git diff --name-only HEAD HEAD~"$commits"
$chanded_files = git diff --name-only HEAD origin/develop
debug "Liste des fichiers modifiés"
$chanded_files


# $packages_config
# Les dossiers autorisés à modifier pour le package $package_name
$package_config = find_package_config $package_name

$autorized_directories = "docs/$package_name",
"$package_name"

if($package_config -eq $null){
    $chemins = "app/app/Exports/$package_name",
    "app/app/Imports/$package_name",
    "app/app/Http/Controllers/$package_name",
    "app/app/Http/Requests/$package_name",
    "app/app/Models/$package_name",
    "app/app/Repositories/$package_name",
    "app/app/resources/views/$package_name",
    "app/routes/web.php",
    "app/database/factories/$package_name",
    "app/database/migrations/$package_name",
    "app/database/seeders/$package_name",
    "app/test/feature/$package_name"
    $autorized_directories = $autorized_directories +  $chemins 
}else{
    $autorized_directories = $autorized_directories + $package_config.Chemins
}
debug "Les chemins autorisés"
$autorized_directories


foreach($file in $chanded_files){

    $autorised_change_file = $false

    # Interdiction de modifier le fichier /backlog/Pacakges.json
    $backlog_Pacakges_json = "backlog/Pacakges.json"
    if($file -like "$backlog_Pacakges_json"){
        $autorised_change_file = $false
        
    }

    # Vérifier si le fichier $file est situé dans l'un des dossiers autorisé
    # TODO : utilisez des expression régulière
    foreach($autorized_directory in $autorized_directories ){
        if($file -like "$autorized_directory*"){
            $autorised_change_file = $true
        }
    }

    # Afficahge de message d'erreur sir le membre n'est pas autorisé à modifier le fichier
    if(-not($autorised_change_file)) {
        Write-Host "::error:: Vous n'avez pas le droit de modifier le fichier : $file"
        $autorised_change = $false
    } 
}

Write-Host "autorised_change = $autorised_change"
if(-not($autorised_change)){
    exit 1
}


