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
  $issue = find_issue_by_title $Issue_obj.title
  if($Issue_obj.number -eq 0){
    if(-not($issue -eq $null)){
      $Issue_obj.number = $issue.number
    }
  }
  # Detection de membre 
  $membre_title_array = $Issue_obj.title.Split("_")
  if($membre_title_array.Length -eq 2){
    $Issue_obj.member = $membre_title_array[0]
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



