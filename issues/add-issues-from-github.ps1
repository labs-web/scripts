# Create or updat backlog to issues

. "./scripts/core/core.ps1"
. "./scripts/core/issue.core.ps1"
. "./scripts/core/backlog.core.ps1"


# Core : Params
$debug = $true
$test = $false
$confirm_message = $false

$depot_path = Get-Location


function find_local_issue($remote_issue){

  confirm_to_continue "find_local_issue $($remote_issue.title)"
  
  # Dans le dossier backlog, il existe plusieurs dossiers qui représente les labels 
  $backlog_directories=  Get-ChildItem "$depot_path/backlog"  -Directory

  foreach($backlog_directory in $backlog_directories) {

      # Ne pas traiter les dossier qui commance par "_"
      if($backlog_directory.Name -like "_*") {continue}

      $label = $backlog_directory.Name
      $directory = $backlog_directory.FullName 
      
      $backlog_items=  Get-ChildItem $directory -Filter *.md  
      foreach($backlog_item in $backlog_items) {
        # file name and path
        $file_fullname = $backlog_item.FullName
        $file_name = $backlog_item.Name
        $item_full_path = Split-Path  -Path $file_fullname
        # CreateIssue_obj that represente backlog_itm_file
        $Issue_obj = get_issue_object $file_name  $file_fullname
        if($Issue_obj.title -eq $remote_issue.title ){ 
          return $true
        }
      }
  }

  return $false
}


# create backlog item if remote issue not exist in local backlog
function create_remote_issue_in_backlog($item_full_path, $remote_issue ){

  confirm_to_continue "create_remote_issue_in_backlog $remote_issue "

  # find label 
  $label = "feature" # défault label
  foreach($remote_label in $remote_issue.labels){
    if($remote_label.name -eq "feature") { $label = "feature"  }
    if($remote_label.name -eq "exposé") { $label = "exposé"  }
    if($remote_label.name -eq "chapitre") { $label = "chapitre"  }
    if($remote_label.name -eq "thème") { $label = "thème"  }
  }


  # debug "Rename file : $Issue_obj"
  $issue_file_name = "0.$($remote_issue.title).$($remote_issue.number).md"
  
  
  
  
  $issue_file_full_name = "$item_full_path\$label\$issue_file_name"

  # Update file name
  debug "Create $issue_file_full_name"

  new-item $issue_file_full_name
  Set-Content $issue_file_full_name $remote_issue.body

}



# 
# Algorithme 
# 

confirm_to_continue "add issue for $depot_path/backlog "


$all_remote_issues = gh issue list -s all --json number,title,labels,body | ConvertFrom-Json
foreach($remote_issue in  $all_remote_issues){
  $local_issue_exist = find_local_issue $remote_issue
  if($local_issue_exist -eq $false){
    $item_full_path = "$depot_path/backlog"
    create_remote_issue_in_backlog $item_full_path $remote_issue 
  }
}