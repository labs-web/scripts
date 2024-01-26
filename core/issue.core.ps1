﻿Write-Host "--- Import issue.core.ps1 ---"
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