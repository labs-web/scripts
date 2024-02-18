. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"
# Core : Params
$debug = $true
$confirm_message = $false


# Encoding utf-8
# debug "Encoding utf-8"
# $PSDefaultParameterValues['*:Encoding'] = 'utf8'
# $prev = [Console]::OutputEncoding
# [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()


# 
# Paramètres
#
# Param 1 : Nom du pullrequest
$pullrequest_name = $args[0]
# Param 2 :Nombre de commits à valider dans le branch liée à l'issue
$commits = $args[1]
# Param 3 : Les issues reliés au pullrequest
$linked_issues = $args[2]
$linked_issues= $linked_issues.TrimStart("[").TrimEnd("]").Split(',')


# 
# Input d'algorithme
#
$package_name = $pullrequest_name.Split('/')[0]
$autorised_change = $true
     

# Règle 1 : Le pullrequest doit être relier avec un seul issue 
debug "Règle 1 : Le pullrequest doit être relier avec un seul issue"
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

## Règle 2 : nom de pullrequest = nom issue
debug "Règle 2 : nom de pullrequest = nom issue"
# intput : issue name and number
$linked_issue = $linked_issues[0]
$issue_number = $linked_issue.Split('#')[1]
$issue  = find_issue_by_number $issue_number
$issue_name = $issue.title
debug "Issue : number = $issue_number, name = $issue_name"
if(-not($pullrequest_name -eq $issue.title) ){
    Write-Host "::error:: Le nom de pullrequest doit être égale le nom de l'issue :  $($issue.title)"
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

# Les dossiers autorisés à modifier pour le package $package_name
$autorized_directories = "app/Http/Controllers/$package_name",
                 "app/Models/$package_name",
                 "docs/$package_name",
                 "$package_name"



foreach($file in $chanded_files){

    $autorised_change_file = $false

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


