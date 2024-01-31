﻿Write-Host "--- Import pullrequest.core.ps1 "

# new core :  branche.core.ps1

# Trouver si une branch exist ou non
function if_remote_branch_exist($branche_name){
    $branch_list = git branch -r
    debug "Remot branches :  $branch_list "
    foreach($item in $branch_list ){
        $item = $item.Trim()
        if($item  -eq "origin/$branche_name"){
            return $true
        }
    }
    return $false
  }



  
# Préparation de git for pullrequest
function create_branch_to_do_pull_request ($branche_name) {

    debug "Création ou changeement de branch : $branche_name  "
    
    # Comit local change in branch develop to do checkout
    debug "Comit local change in branch develop to do checkout to $branche_name"
    git config --global user.name "ESSARRAJ"
    git config --global user.email "essarraj.fouad@gmail.com"
    git add .
    git commit -m "save to run $branche_name.ps1"
  
    # Delete remote branch 
    # On peut pas vérifier l'existance de branch avant de le supprimer sur github action runnner 
    # because checkout@v4 can clone one branch 
    # donc, cette commande affiche une erreur si la branche n'existe pas sur github
    confirm_to_continue("run git push origin --delete $branche_name ")
    git push origin --delete $branche_name 
  
  
    # Delete local branch if exist
    debug "Delete local branch $branche_name "
    git branch -D $branche_name
    git checkout -b $branche_name
  
  }
  
  function save_and_send_pullrequest_if_files_changes($branche_name, $chaned_files ){
  
    debug "Send pullrequest si changed file, chaned_files = $chaned_files "
  
    if(-not($chaned_files)){ 
      git checkout develop
      return $false 
    }
  
    debug "Création de pullrequest pour enregistrer les modification de backlog files"
    confirm_to_continue("run : git push --set-upstream origin $branche_name")
    git push --set-upstream origin $branche_name
    git pull
    
    # push to  $branche_name branch
    confirm_to_continue("run : git push")
    git add .
    git commit -m "$branche_name"
    git push
    
    # Create pull request if not yet exist
    debug "Create pull request if not yet exist"
    confirm_to_continue "run : gh pr create --base develop --title $branche_name --body 'change backlog files'"
    $pull_request_exist = (gh pr list --json title | ConvertFrom-Json).title -contains "$branche_name"
    if(-not($pull_request_exist)){
        gh pr create --base develop --title $branche_name --body $branche_name
    }
  
    git checkout develop
    return $true
  
  }