
# Calculer $issue_number and $issue_title

# Règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee
function rule_pullrequest_name ($pullrequest_name){
    
    $pullrequest_parts_array = $pullrequest_name.Split('-')
    if(-not($pullrequest_parts_array[0] -match "^\d+$" )){
        Write-Host "::error:: Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee"
        exit 1
    }else{
        debug "Règle 1 : Le nom de pullrequest est correcte : $pullrequest_name"
    }
}






