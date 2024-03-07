

# Règle 3 : Le nom de pullrequest doit être identique au nom de l'issue
function code3($linked_issues,$issue_title,$issue_number){
    # intput : issue name and number
    $linked_issue = $linked_issues[0]
    $linked_issue_number = $linked_issue.Split('#')[1]
    $issue  = find_issue_by_number $linked_issue_number
    $linked_issue_name = $issue.title
  
    if(-not($issue_title -eq $issue.title) -or -not($issue_number -eq $issue.number) ){
    
        debug "issue_title = $issue_title
        - issue_number = $issue_number
        - remote isuue = $issue "

    Write-Host "::error:: Le nom de pullrequest doit être identique au nom de l'issue :  $($issue.number)-$($issue.title)"
    exit 1
    }else{
        debug "Règle 3 : Le nom de pullrequest est identique au nom de l'issue"
    }
}