# Start Task 

# Création d'un script qui permet de lancer le développement d'une tâche 

# Core : Params
$debug = $false
$confirm_message = $true

# Param : issue_id 
$issue_number = $args[0]
if($issue_number -eq $null) {
    Write-host "Vous devez exécuter le script avec le paramètre : issue_number"
    exit
}
# Param -d
$debug_param = $args[1]
if($debug_param -eq "-d") {
    $debug = $true
}

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/pullrequest-core.ps1"

# Commit current branche 
confirm_to_continue "Commit current branche to start new task with issue_number : $issue_number  "
git add .
git commit -m "commit current branche to start new task with issue"

# pull develop branch
confirm_to_continue "pull develop branch"
git checkout develop
git status
git pull

# get issue_obj
$issue_obj = find_issue_by_number $issue_number
# debug $issue_obj

# Create new branche if not exist
$branche_name = "$($issue_obj.title).$($issue_obj.number)"
$local_branch_exist = if_local_branch_exist $branche_name
if($local_branch_exist ){
    # checkout issue branch
    confirm_to_continue "Run  git checkout $($issue_obj.title).$($issue_obj.number) "
    git checkout "$($issue_obj.title).$($issue_obj.number)" 
    git push --set-upstream origin $branche_name
}else{
    confirm_to_continue "Create new branche  : $($issue_obj.title).$($issue_obj.number) "
    git checkout -b "$($issue_obj.title).$($issue_obj.number)" 
    git push --set-upstream origin $branche_name
}

# Merge develop
confirm_to_continue "Run git merge develop"
git merge develop


# - Laison de la branche avec l'issue
# - Création de pullrequest
# - add label :
#   - en_cours

Write-Host "`n`n"
git status

