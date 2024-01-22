# Update issue template from gestion-projet repository to all labs

# Emplacement des labs 
$labs_web_path = $PSScriptRoot + "/../../"
$gestion_projet_issue_template_path = $labs_web_path + "gestion-projet/.github/ISSUE_TEMPLATE/"
cd $labs_web_path

function confirm_to_continue($message) {
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        exit
    } 
}

$labs_web = Get-ChildItem . -Filter * 

# Copy template from gestion-projet to all labs
foreach($lab_web in $labs_web){

    # Nom de lab
    $lab_web_name = $lab_web.Name
    $lab_web_full_name =$lab_web.FullName 

    # Ne pas toucher les template de gestion-projet
    if($lab_web.Name -eq "gestion-projet"){continue}

    # Message de confirmation
    Write-Host "Modifier les template de $lab_web_name"
    # confirm_to_continue("Modifier les template de $lab_web_name")

    # Delete templates if exist
    $issue_template_path = $lab_web_full_name + "/.github/ISSUE_TEMPLATE"
    if (Test-Path $issue_template_path) {
        Write-Host "Delete : $issue_template_path "
        rm $issue_template_path -r -force
    }

    # Create .github folder if not exist 
    if (-not(Test-Path ($lab_web_full_name + "/.github"))) {
        mkdir ($lab_web_full_name + "/.github")
    }
    if (-not(Test-Path ($lab_web_full_name + "/.github/ISSUE_TEMPLATE"))) {
        mkdir ($lab_web_full_name + "/.github/ISSUE_TEMPLATE")
    }

    # Copy files
    copy-Item -Path ("$gestion_projet_issue_template_path/*") -Destination ($lab_web_full_name + "/.github/ISSUE_TEMPLATE/")

}

