# End task

# Création d'un script qui permet de terminer une tâche
Write-Host "Params : [-d : debugage]"

# Core : Params
$debug = $false
$confirm_message = $true

# Param -d
$debug_param = $args[0]
if($debug_param -eq "-d") {
    $debug = $true
}

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/pullrequest-core.ps1"

# Les steps 
$steps = "Commit current change" ,"Push change" ,"Create Pullrequest"


# Find issue 
$currebt_branch_name = git branch --show-current
$issue_number = $currebt_branch_name.Split(".")[1]
$issue_obj = $null
if($issue_number -match "^\d+$")
{
  debug "issue number : $issue_number "
  $issue_obj = find_issue_by_number $issue_number
}else{
  Write-Error "Le nom de branch n'est pas correcte, Il doit être commencé par l'issue_number"
  exit
}

git status
confirm_to_continue "End task $issue_obj avec les étapes suivantes : `n`n$( $steps  | Format-Table| Out-String) "

# commit le travail
confirm_to_continue "Commit current branche to end task $issue_obj  "
git add .
git commit -m "commit to end task $currebt_branch_name"

# Change labels
# gh issue edit 88 --add-label en_validation

git edit $issue_number --remove-label en_cours
git edit $issue_number --add-label en_validation

# - demande de code review
# - add label
#   - en_validation