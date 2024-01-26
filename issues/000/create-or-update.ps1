﻿# Create or updat backlog to issues

# Le sctipy doit être exécuter dans la racine de dépôt

# 
# Description
# 
# - Création des issues 
# - Mise à jour des issues 
# - Affectation de l'issue à TeamPlanning
# - Nom de fichier : 1.nom_issue.23.md

$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()


#
# Functions : Message de confirmation
#

function confirm_to_continue($message) {
      
  $title    = $message 
  $question = "Are you sure you want to proceed?"
  $choices  = '&Yes', '&No'

  # Write-Host $message 
  
  # $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
  # if ($decision -eq 1) {
  #  exit
  # } 
}
# get organisation name
function get_org_name {
  $current_script_path = $PSScriptRoot.Split('\')
  return $current_script_path[1] 
}



function find_issue_by_title($title){
  
  # confirm_to_continue("find $title in issues ")
  
  $all_issues = gh issue list --json number,title | ConvertFrom-Json

  foreach($issue in  $all_issues){
    # Write-Host $Issue_obj.title
    if($issue.title -eq $title){
      return $issue
    }
  }
  return $null
}

function get_issue_object([String]$file_name, [String] $file_fullname){
  $item_full_path = Split-Path  -Path $file_fullname
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
  }else{
    if($issue -eq $null){
      $Issue_obj.number = "0"
      Write-Host("Issue avec le nombre $($Issue_obj.number) doit être existe sur github")
      exit 1
    }
  }
    
  # Dection de membre 
  $membre_title_array = $Issue_obj.title.Split("_")
  if($membre_title_array.Length -eq 2){
    $Issue_obj.member = $membre_title_array[0]
  }else{ 
    $Issue_obj.member = $null
  }
   
    
  # L'odre est le premier nombre
  if($first_element -match "^\d+$") { 
    $Issue_obj.ordre = $first_element
  } 
  else{ 
    $Issue_obj.ordre = "0"
  }
  
  
  return $Issue_obj
}

# Input
$depot_path = Get-Location
$project_name = get_org_name

# Message de confirmation
confirm_to_continue("Update or Create issues for repository : $depot_path ")


# Traitement pour chaque fichier(item) dans /backlog
Get-ChildItem "$depot_path/backlog" -Filter *.md | 
Foreach-Object {

    # file name and path
    $file_fullname = $_.FullName
    $file_name = $_.Name
    $item_full_path = Split-Path  -Path $file_fullname
    # issue_object
    $Issue_obj = get_issue_object $file_name  $file_fullname

    # Create new issue 
    if($Issue_obj.number -eq 0){
            confirm_to_continue("Création de l'issue : $Issue_obj ")
            if($Issue_obj.member -eq $null){
                gh issue create --title $Issue_obj.title--label feature,new_issue --project $project_name  --body-file $file_fullname
            }else{
                gh issue create --title $Issue_obj.title --label feature,new_issue --assignee $Issue_obj.member  --project $project_name  --body-file $file_fullname 
            }
    }else{
        # Edit existant issue
        confirm_to_continue("Update de l'issue $($Issue_obj) ")
        gh issue edit $Issue_obj.number --title $Issue_obj.title --add-label feature,new_issue --add-project $project_name --body-file $file_fullname
    }

    # Change file name if is incorrect
    $Issue_obj_file_name = "$($Issue_obj.ordre).$($Issue_obj.title).$($Issue_obj.number).md"
    if(-not($Issue_obj_file_name -eq $file_name )){
        # Update file name
        Write-Host "Rename $file_name to $Issue_obj_file_name "
        Rename-Item -Path $file_fullname -NewName "$item_full_path\$Issue_obj_file_name"
    }

}