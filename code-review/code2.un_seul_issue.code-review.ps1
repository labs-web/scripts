
# Règle 2 : Le pullrequest doit être relier avec un seul issue
function rule_pullrequest_doit_etre_relier_avec_un_seul_issue($linked_issues){
    
    if($linked_issues -eq $null) {
        Write-Host "::error:: Le pullrequest doit être relié avec un issue"
        exit 1
    }
    
    if(-not($linked_issues.length -eq  1)) {
        Write-Host "::error:: Le pullrequest doit être relié avec un seul issue"
        $AUTORISED_CHANGE = $false
        exit 1
    }else{
        debug "Règle 2 : Le pullrequest est relier avec un seul issue : $linked_issues"
    }
}