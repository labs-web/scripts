debug "--- Import backlog.core.ps1"

# Issue_obj : convert backlog_item_file to issue_obj
function get_issue_object([String]$file_name, [String] $file_fullname){
  # $item_full_path = Split-Path  -Path $file_fullname
  # Règle : L'issue est existe si le fichier item commence par le numéro de l'issue
  # Exemple des nom 
  # issue: 2.conception.10.md : 2:ordre,conception:title,10:numéro de l'issue sur github
  # order_file:   3.codage.md
  # create_file : test.md
  # State : create_file,order_file,issue
  $Issue_obj = [PSCustomObject]@{ordre = 0
    number =  0
    title = ''
    labels = ''
    state = ''
    body_file = $file_fullname
    file_name = $file_name
    member = $null
  }
  $file_name_array = $file_name.Split(".")
  # si file is issue : l'élément avant dernier est un nombre
  $last_element_index = $file_name_array.Length - 1 
  $avant_dernier_element = $file_name_array[$last_element_index - 1]
  $first_element = $file_name_array[0]
  # Titre : si l'avant dernier élémet est un nombre 
  if($avant_dernier_element -match "^\d+$")
  {
    $Issue_obj.number = $avant_dernier_element
    $Issue_obj.title = $file_name_array[$last_element_index - 2]
  } else
  {
    $Issue_obj.title = $file_name_array[$last_element_index - 1]
    $Issue_obj.number = 0
  }
  # si number = 0 et issue existe dans github
  if($Issue_obj.number -eq 0){
    $issue = find_issue_by_title $Issue_obj.title
    if(-not($issue -eq $null)){
      $Issue_obj.number = $issue.number
    }
  }
  # Detection de membre 
  $membre_title_array = $Issue_obj.title.Split("_")
  if($membre_title_array.Length -eq 2){
    $Issue_obj.member = $membre_title_array[1]
  }else{ 
    $Issue_obj.member = $null
  }
  # L'odre est le premier nombre
  if($first_element -match "^\d+$") { 
    $Issue_obj.ordre = $first_element
  } else{ 
    $Issue_obj.ordre = "0"
  }
  return $Issue_obj
}


function change_backlog_item_file_name($file_fullname, $file_name, $Issue_obj){
  # debug "Rename file : $Issue_obj"
  $Issue_obj_file_name = "$($Issue_obj.ordre).$($Issue_obj.title).$($Issue_obj.number).md"
    if(-not($Issue_obj_file_name -eq $Issue_obj.file_name )){
        # Update file name
        debug "Rename $file_name to $Issue_obj_file_name "
        debug "- Source : $file_fullname"
        debug "- Destination : $item_full_path\$Issue_obj_file_name"
        Rename-Item -Path $file_fullname -NewName "$item_full_path/$Issue_obj_file_name"
        return $true
    }
    return $false
}



function find_local_issue($remote_issue){

  confirm_to_continue "find_local_issue $($remote_issue.title)"
  
  $backlog_items=  Get-ChildItem "$depot_path/backlog" -Filter *.md  -Recurse
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


function add_issue_from_github($depot_path){

  confirm_to_continue "add issue for $depot_path/backlog "
  $add_issue_from_github_chaned_files = $false

  $all_remote_issues = gh issue list -s all --json number,title,labels,body | ConvertFrom-Json
  foreach($remote_issue in  $all_remote_issues){
    $local_issue_exist = find_local_issue $remote_issue
    if($local_issue_exist -eq $false){
      $item_full_path = "$depot_path/backlog"
      create_remote_issue_in_backlog $item_full_path $remote_issue 
      $add_issue_from_github_chaned_files = $true
    }
  }

  return $add_issue_from_github_chaned_files
}


