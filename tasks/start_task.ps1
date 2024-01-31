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

# Les steps 
$steps =    "- 1. Commit current branch" ,
            "- 2. Pull branch develop" ,
            "- 3. Create new branche if not exist",
            "- 4. Merge develop",
            "- 5. Change label to en_cours ",
            "- 6. Création de pullrequest"


# get issue_obj
$issue_obj = find_issue_by_number $issue_number
if($issue_obj -eq $null){
    Write-Error "L'issue #$issue_number n'existe pas "
    exit
}else{
    # Message de confirmation
    # git status
    confirm_to_continue "Start task $($issue_obj.title) avec les étapes suivantes : `n`n$( $steps  | Format-Table| Out-String) "
}

$confirm_message = $false


# 1 - Commit current branche 
confirm_to_continue "1 - Commit current branche to start new task with issue_number : $issue_number  "
git add .
git commit -m "commit current branche to start new task with issue"

# 2 - pull develop branch
confirm_to_continue "2 - Pull develop branch"
git checkout develop
git status
git pull

# 3 - Create new branche if not exist
confirm_to_continue "3 - Create or Change branche from develop"
$branche_name = "$($issue_obj.title).$($issue_obj.number)"
$local_branch_exist = if_local_branch_exist $branche_name
if($local_branch_exist ){
    # checkout issue branch
    confirm_to_continue "Checkout the existant branch :  $($issue_obj.title).$($issue_obj.number) "
    git checkout "$($issue_obj.title).$($issue_obj.number)" 
    git push --set-upstream origin $branche_name
}else{
    confirm_to_continue "Create new branche  : $($issue_obj.title).$($issue_obj.number) "
    git checkout -b "$($issue_obj.title).$($issue_obj.number)" 
    git push --set-upstream origin $branche_name
}

# Merge develop
confirm_to_continue "4 - Merge develop"
git merge develop

## Change label 
confirm_to_continue "5 - add label en_cours"
gh issue edit $issue_number --remove-label en_validation
gh issue edit $issue_number --add-label en_cours


# Création de pullrequest
confirm_to_continue "6 - Create pullrequest"
Create_pull_request_if_not_yet_exist $branche_name $issue_obj 


Write-Host "`n`n"
git status

