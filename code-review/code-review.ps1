. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"
. "./scripts/code-review/code-review.functions.ps1"
. "./scripts/code-review/code1.nom-pullrequest.code-review.ps1"
. "./scripts/code-review/code2.un_seul_issue.code-review.ps1"
. "./scripts/code-review/code3.code-review.ps1"

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
$default_authorized_directories = $packages_json.DefaultAuthorizedDirectories
$laravel_authorized_directories = $packages_json.LaravelAuthorizedDirectories


# Règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee
rule_pullrequest_name $pullrequest_name


# 
# Les paramètres d'algorithme
#

$algorithme_params = get_algorithme_params $pullrequest_name
$AUTORISED_CHANGE  = $true
$issue_number = $algorithme_params.issue_number
$issue_title =$algorithme_params.issue_number
$task_name = $algorithme_params.task_name
$package_name =$algorithme_params.package_name

# Règle 2 : Le pullrequest doit être relier avec un seul issue 
rule_pullrequest_doit_etre_relier_avec_un_seul_issue $linked_issues

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
$package_config = find_package_config $package_name $packages_config
replace_array_string $default_authorized_directories "{{package_name}}" "$package_name"
$autorized_directories = $default_authorized_directories
if($package_config -eq $null){
    $laravel_app = "app/"
    replace_array_string $laravel_authorized_directories "{{package_name}}" "$package_name"
    replace_array_string $laravel_authorized_directories "{{directory_code}}" "app"
    $autorized_directories = $autorized_directories +  $laravel_authorized_directories
}else{
    if($package_config.IsValidaionAvecFormateur){
        Write-Host "::error:: Vous ne pouvez pas valider cette tâche($package_name) sans l'accord du formateur"
        $AUTORISED_CHANGE  = $false
    }
    $autorized_directories = $autorized_directories + $package_config.Chemins
}
debug "Les chemins autorisés"
$autorized_directories


foreach($file in $chanded_files){

    $autorised_change_file = $false



    # Vérifier si le fichier $file est situé dans l'un des dossiers autorisé
    # TODO : utilisez des expression régulière
    foreach($autorized_directory in $autorized_directories ){
        if($file -like "$autorized_directory*"){
            $autorised_change_file = $true
        }
    }

  
      # Interdiction de modifier le fichier /backlog/Pacakges.json
      $backlog_Pacakges_json = "backlog/Packages.json"
      if($file -eq "backlog/Packages.json"){
          $autorised_change_file = $false
          
      }

    # Afficahge de message d'erreur sir le membre n'est pas autorisé à modifier le fichier
    if(-not($autorised_change_file)) {
        Write-Host "::error:: Vous n'avez pas le droit de modifier le fichier : $file"
        $AUTORISED_CHANGE  = $false
    } 
}

Write-Host "AUTORISED_CHANGE  = $AUTORISED_CHANGE "
if(-not($AUTORISED_CHANGE )){
    exit 1
}


