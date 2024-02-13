# Create or updat backlog to issues

# TODO : ajouter les issus de github vers /backlog

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/pullrequest-core.ps1"
. "./scripts/core/backlog.core.ps1"


# Core : Params
$debug = $true
$test = $false
$confirm_message = $false

# Global variable
$branche_name = "update_backlog_files"

# get project name from param : $project_name = "labs-web"
# TODO : exit if project name not exist
$project_name = $args[0]
if ($project_name -ne $null) {
  Write-Host "Variable exists"
  debug("project_name exist = $project_name")
} else {
  $project_name = "labs-web"
  debug("project_name not exist = $project_name")
}

$depot_path = Get-Location

# Message de confirmation
confirm_to_continue("Update or Create issues for repository : $depot_path ")

# 
# Déclaration des fonctions 
# 


# Create new issue from $Issue_obj 
function create_issue($Issue_obj,$label){

  debug("Issue_obj : $Issue_obj ")
  if($Issue_obj.member -eq $null){
    debug "Création nouvelle issue :  $($Issue_obj.title) "
    confirm_to_continue("run : gh issue create --title $($Issue_obj.title) --label $label,new_issue --project $project_name  --body-file $($Issue_obj.body_file)")
    gh issue create --title $Issue_obj.title --label "$label,new_issue" --project $project_name  --body-file $($Issue_obj.body_file)
    # Change $Issue_obj.number
    $remote_issue = find_issue_by_title $Issue_obj.title
    $Issue_obj.number = $remote_issue.number

    # Change file name 
  }else{
    debug "Création nouvelle issue :  $($Issue_obj.title) pour membre $($Issue_obj.member) "
    confirm_to_continue("run : gh issue create --title $($Issue_obj.title) --label $label,new_issue --assignee $($Issue_obj.member)  --project $project_name  --body-file $($Issue_obj.body_file) ")
    gh issue create --title $Issue_obj.title --label "$label,new_issue" --assignee $Issue_obj.member  --project $project_name  --body-file $($Issue_obj.body_file)
  }
}

function edit_issue($Issue_obj,$label){
  debug "Edition de l'issue #$($Issue_obj.number) : $($Issue_obj.title)"
  confirm_to_continue("run gh issue edit $($Issue_obj.number) --title $($Issue_obj.title) --add-label $label,new_issue --add-project $project_name --body-file $($Issue_obj.body_file)")
  gh issue edit $Issue_obj.number --title $Issue_obj.title --add-label $label --add-project $project_name --body-file $($Issue_obj.body_file)
}


$add_or_update_issues_iteration = 0

# Ajouter ou créer une issue
function add_or_update_issues($directory, $label){

  debug "----`n - Update or Create issues for : $label `n - ----"

  $backlog_items=  Get-ChildItem $directory -Filter *.md  
  $add_or_update_issues_chaned_files = $false

  foreach($backlog_item in $backlog_items) {
    # file name and path
    $file_fullname = $backlog_item.FullName
    $file_name = $backlog_item.Name
    $item_full_path = Split-Path  -Path $file_fullname
    # CreateIssue_obj that represente backlog_itm_file
    $Issue_obj = get_issue_object $file_name  $file_fullname
    if($Issue_obj.number -eq 0){ create_issue $Issue_obj $label
    }else{ edit_issue $Issue_obj $label }

    # Change backlog_item_file name
    $change_backlog_item_file_name_retuen_value = change_backlog_item_file_name $file_fullname $file_name $Issue_obj

     # if not yet true
    if($change_backlog_item_file_name_retuen_value) {
      $add_or_update_issues_chaned_files = $true  
    }

    # En cas de test traiter un seul fichier par dossier
    if($test ) { break }

  }
  return $add_or_update_issues_chaned_files
}

# 
# Fin de déclaration des fonction
# 

# 
# Algorithme 
# 

# Create or Update issues
create_branch_to_do_pull_request $branche_name

# Si un fichie est modifier : on envoie un pullrequest vers develop qui contient les modification
# des fichiers backlog item 
$chaned_files = $false

# Dans le dossier backlog, il existe plusieurs dossiers qui représente les labels 
$backlog_directories=  Get-ChildItem "$depot_path/backlog"  -Directory

foreach($backlog_directory in $backlog_directories) {

    # Ne pas traiter les dossier qui commance par "_"
    if($backlog_directory.Name -like "_*") {continue}

    $label = $backlog_directory.Name
    $directory = $backlog_directory.FullName 
    $return_value = add_or_update_issues $directory $label
    
    # if not yet true
    # Dans Powershell, les fonctions ne retourn pas une valeur mais le résultat de console
    if(-not($chaned_files)) {
      $chaned_files = $return_value[$return_value.lenght - 1]
    }
    
    
}

$add_issue_from_github_return_values = add_issue_from_github $depot_path
if(-not($chaned_files)) {
  $chaned_files = $add_issue_from_github_return_values[$add_issue_from_github_return_values.lenght - 1]
}


# Envoie de pullrequest si le programme à modifier les nom des fichiers backlog item
save_and_send_pullrequest_if_files_changes $branche_name $chaned_files 
