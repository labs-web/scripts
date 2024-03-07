. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"
. "./scripts/code-review/code-review.functions.ps1"
. "./scripts/code-review/code1.nom-pullrequest.code-review.ps1"
. "./scripts/code-review/code2.un_seul_issue.code-review.ps1"
. "./scripts/code-review/code3.code-review.ps1"
. "./scripts/code-review/code-review.autorized_directories.ps1"

# Core : Params
$debug = $true
$confirm_message = $false


# Paramètres de script
$params = @{}
get_script_params $args $params
$pullrequest_name = $params.pullrequest_name
$commits = $params.commits
$linked_issues = $params.linked_issues

# Load config file
$packages_json = get_package_json $(Get-Location).Path
$packages_config = $packages_json.Packages
$laravel_authorized_directories = $packages_json.LaravelAuthorizedDirectories

# Règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee
rule_pullrequest_name $pullrequest_name

# Les paramètres d'algorithme
$algorithme_params = get_algorithme_params $pullrequest_name
$AUTORISED_CHANGE  = $true
$issue_number = $algorithme_params.issue_number
$issue_title =$algorithme_params.issue_title
$task_name = $algorithme_params.task_name
$package_name =$algorithme_params.package_name
debug "Les paramètres d'algorithme :
 - package_name = $package_name
 - task_name = $task_name
 - issue_title = $issue_title
 - issue_number = $issue_number "

# Règle 2 : Le pullrequest doit être relier avec un seul issue 
rule_pullrequest_doit_etre_relier_avec_un_seul_issue $linked_issues

## Règle 3 : Le nom de pullrequest doit être identique au nom de l'issue
code3 $linked_issues $issue_title $issue_number

# Affichage de liste des fichiers modifiés par le pullrequest
git config core.quotepath off # By default, git will print non-ASCII file names in quoted octal notation
$chanded_files = git diff --name-only HEAD origin/develop
debug "Liste des fichiers modifiés"
$chanded_files


# Appliquer les contrainte de la configuration s'il sont existent
$package_config = find_package_config $package_name $packages_json.Packages
if(-not($package_config -eq $null)){
    if($package_config.IsValidaionAvecFormateur){
        Write-Host "::error:: Vous ne pouvez pas valider cette tâche($package_name) sans l'accord du formateur"
        $AUTORISED_CHANGE  = $false
    }
}

# Calculer les chemins autorisés
$autorized_directories = get_autorized_directories $package_name $package_config $packages_json 
debug "Les chemins autorisés `n"
$autorized_directories

# Varifier les modification autorisés
foreach($file in $chanded_files){
    $autorised_change_file = $false
    foreach($autorized_directory in $autorized_directories ){
        # TODO : utilisez des expression régulière
        if($file -like "$autorized_directory*"){   $autorised_change_file = $true}
    }
    # Interdiction de modifier le fichier /backlog/Pacakges.json
    if($file -eq "backlog/Packages.json"){ $autorised_change_file = $false}
    if(-not($autorised_change_file)) {
        Write-Host "::error:: Vous n'avez pas le droit de modifier le fichier : $file"
        $AUTORISED_CHANGE  = $false
    } 
}

debug "AUTORISED_CHANGE  = $AUTORISED_CHANGE "
if(-not($AUTORISED_CHANGE )){
    exit 1
}