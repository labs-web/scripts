debug "--- Import issue.core.ps1"
function find_issue_by_title($title){
  
    # confirm_to_continue("find $title in issues by title ")
    $all_issues = gh issue list -s all --json number,title | ConvertFrom-Json
    foreach($issue in  $all_issues){
      # Write-Host $Issue_obj.title
      if($issue.title -eq $title){
        return $issue
      }
    }
    return $null
  }

  function find_issue_by_number($number){
  
    # confirm_to_continue("find $title in issues by number ")
    $all_issues = gh issue list -s all --json number,title | ConvertFrom-Json
    foreach($issue in  $all_issues){
      # Write-Host $Issue_obj.title
      if($issue.number -eq $number){
        return $issue
      }
    }
    return $null
  }