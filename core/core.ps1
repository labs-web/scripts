# Encoding UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Write-Host "`n--- Import core.ps1 "


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
      
    $title    = "- Run : $message "
    $question = ""
    $choices  = '&Yes', '&No'
  
    if($confirm_message){
      $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 1) {
          Write-Host "`n - Vous devez acepter pour continuer `n"
        exit
      } 
    }else{
      if($debug){
        Write-Host "`n - $message `n"
      }
    }
}


