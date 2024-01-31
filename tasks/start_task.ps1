# Start Task 

# Création d'un script qui permet de lancer le développement d'une tâche 

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/pullrequest-core.ps1"
# Core : Params
$debug = $true
$test = $false
$confirm_message = $true

# Param : issue_id 

$issue_number = $args[0]
if($issue_number -eq $null) {
    debug("Vous devez exécuter le script avec le paramètre : issue_number")
    exit
}

# Commit current branche 
confirm_to_continue "Commit current branche to start new task with issue_number : $issue_number  "
git add .
git commit -m "commit current branche to start new task with issue"

# get issue_obj
$issue_obj = find_issue_by_number $issue_number
debug $issue_obj

# Create new branche 
confirm_to_continue "Create new branche  : $($issue_obj.title).$($issue_obj.number) "
git checkout -b "$($issue_obj.title).$($issue_obj.number)" 
git status

# - Laison de la branche avec l'issue
# - Création de pullrequest
# - add label :
#   - en_cours

