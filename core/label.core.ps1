debug "--- Import label.core.ps1"

# Config label.core.ps1

function find_remote_label($remote_labels, $name){
    # debug "find_remote_label $name in $remote_labels"

    foreach($remote_label in $remote_labels){
        # debug "if($($remote_label.name) -eq $name)"
        if($remote_label.name -eq $name){
            return $remote_label
        }
    }
    return $null
}

function delete_default_labels($remote_labels){
 
  $default_labels = "documentation","duplicate","good first issue","help wanted","question","wontfix","enhancement"
  foreach($default_label in $default_labels ){
      if($remote_labels.name -contains $default_label ){
          gh label delete $default_label --yes
          # $remote_labels_updated = $true
      }
  }
}


function Create_or_Update_remote_labels($remote_labels) {


  $remote_labels_updated = $false
  # Create or Update remote_labels
  $local_labels = @{name = "chapitre"; color = "0E8A16"},
                  @{name = "bug"; color = "d73a4a"},
                  @{name = "feature"; color = "0052CC"},
                  @{name = "new_issue"; color = "FBCA04"},
                  @{name = "sous-tâche"; color = "1D76DB"},
                  @{name = "thème"; color = "D93F0B"},
                  @{name = "user-story"; color = "0E8A16"},
                  @{name = "en_cours"; color = "0E8A16"},
                  @{name = "en_validation"; color = "FBCA04"},
                  @{name = "terminé"; color = "0052CC"},
                  @{name = "thème"; color = "D93F0B"},
                  @{name = "exposé"; color = "C2E0C6"},
                  @{name = "P1"; color = "eeeeee"},
                  {name = "P2"; color = "eeeeee"},
                  {name = "P3"; color = "eeeeee"},
                  {name = "P4"; color = "eeeeee"},
                  {name = "P5"; color = "eeeeee"}

  foreach($local_label in $local_labels ){
      $remote_label = find_remote_label $remote_labels $local_label.name
      if($remote_label -eq $null ){
          debug "Create new label : $local_label.name"
          gh label create $local_label.name -c $local_label.color
          $remote_labels_updated = $true
      }else{
          
          if(-not($remote_label.color -eq $local_label.color) ){
              debug "update remote label : $local_label.name" 
              gh label create $local_label.name -c $local_label.color --force
              $remote_labels_updated = $true
          }
      }
  }

  if($remote_labels_updated -eq $false){
      Write-Host "`n - Tous les labels sont à jour`n"
  }
}



