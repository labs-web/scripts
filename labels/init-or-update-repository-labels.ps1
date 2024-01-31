# Init and Update label for current Repository
Write-Host "Params : [-d : debugage]"

# Core : Params
$debug = $false
$confirm_message = $true

. "./scripts/core/core.ps1"

# Param -d
$debug_param = $args[0]
if($debug_param -eq "-d") {
    $debug = $true
}


$remote_labels_updated = $false
confirm_to_continue "Init and Update label for current Repository"

$remote_labels = gh label list --json name,color | ConvertFrom-Json

function find_remote_label($name){
    foreach($remote_label in $remote_labels){
        if($remote_label.name -eq $name){
            return $remote_label
        }
    }
    return $null
}


$default_labels = "documentation","duplicate","good first issue","help wanted","question","wontfix","enhancement"
foreach($default_label in $default_labels ){
    if($remote_labels.name -contains $default_label ){
        gh label delete $default_label --yes
        $remote_labels_updated = $true
    }
}

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
                @{name = "terminé"; color = "0052CC"}

foreach($local_label in $local_labels ){
    $remote_label = find_remote_label($local_label.name)
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