# Clone all labs from organisation if not yet cloned

function confirm_to_continue($message) {
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        exit
    } 
}

# Emplacement des labs 
$labs_web_path = $PSScriptRoot + "/../../"
cd $labs_web_path

# Lists of labs 

# Par défaut la commande repo list affiche 30 dépot
$labs_web_list =  gh repo list labs-web --limit 100 --json name,url,defaultBranchRef | ConvertFrom-Json
 
foreach ($lab_web in  $labs_web_list)  {
    if($lab_web.defaultBranchRef.name = 'develop'){ 
        
        $lab_name =  $lab_web.name
        $lab_url = $lab_web.url

        # $PSScriptRoot l'emplacement de script 
        # les lab doit être placder dans ../../ parapport le script
        $lab_web_path = $labs_web_path +  $lab_web.name
        
        # clone if not yest clonned
        if(-not(Test-Path $lab_web_path)){
            confirm_to_continue("Clone $lab_name to $lab_web_path $")
            git clone $lab_url
        }
       
    }
}