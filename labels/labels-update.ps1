# Update labels for all lab-web

# Encoding utf8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

function confirm_to_continue($message) {
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        exit
    } 
}

function delete_default_labels(){
    gh label delete documentation --yes
    gh label delete duplicate --yes
    gh label delete 'good first issue' --yes
    gh label delete 'help wanted' --yes
    gh label delete invalid --yes
    gh label delete question --yes
    gh label delete wontfix --yes
    gh label delete enhancement --yes

}

# Le sctipy doit être exécuter dans le dossier racine de lab-web
$labs_web_path = $PSScriptRoot + "/../../"
cd $labs_web_path

confirm_to_continue("Update label pour all labs")

$labs_web = Get-ChildItem . -Filter * 
foreach($lab_web in $labs_web){

    $lab_web_fullname = $lab_web.FullName
    $lab_web_name = $lab_web.Name


    # ne pas update labels for gestion-projet 
    if($lab_web_name -eq "gestion-projet" ){ continue }
    # Write-Host("Update label pour : $lab_web_name")
    # confirm_to_continue("Update label pour : $lab_web_name")
    cd $lab_web_fullname

    delete_default_labels

    gh label clone https://github.com/labs-web/gestion-projet.git
}

