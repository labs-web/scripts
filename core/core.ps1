Write-Host "--- Import core.ps1 ---"

# Encoding UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()


# Paramètre pardéfaut
$debug = $true
$confirm_message = $true


# Debug : Afficher les message de débugage
function debug($message){
  if($debug){
    Write-Host "`n - $message "
  }
}

# Message de confirmation
function confirm_to_continue($message) {
      
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
  
    if($confirm_message){
      $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 1) {
        exit
      } 
    }else{
      if($debug){
        Write-Host "`n - $message `n"
      }
    }
}


