# Start Task 

# Création d'un script qui permet de lancer le développement d'une tâche 

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/pullrequest-core.ps1"
# Core : Params
$debug = $true
$test = $false
$confirm_message = $false

# Param : issue_id 

$issue_number = $args[0]
if($issue_number -eq $null) {
    debug("Vous devez exécuter le script avec le paramètre : issue_number")
    exit
}

# - Création d'une branche
git add .
git commit -m "commit current branche to start new task with issue"

# - Laison de la branche avec l'issue
# - Création de pullrequest
# - add label :
#   - en_cours

