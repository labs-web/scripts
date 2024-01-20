# Création des issue : Publication des éléments de backlog comme issues
# Le sctipy doit être exécuter dans le dossier racine de dépôt

# Organisation name
function get_org_name {
    $current_script_path = $PSScriptRoot.Split('\')
    return $current_script_path[1] 
}
$project_name = get_org_name

# Encoding utf8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()



# Liste des éléments de backlog 
$depot_path = Get-Location


# Function : Message de confirmation
function confirm_to_continue($message) {
    $title    = $message 
    $question = "Are you sure you want to proceed?"
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        exit
    } 
}



function find_issue_by_title($title){
    $all_issues = gh issue list --json number,title | ConvertFrom-Json
    
    foreach($issue in  $all_issues){
        # Write-Host $issue.title
        if($issue.title -eq $title){
            return $issue
        }
    }
    return $null
}
# $issue_test = find_issue_by_title("backlog")
# Write-Host( $issue_test)
# $issue_test = find_issue_by_title("suivi-réalisation-labs-web")
# Write-Host( $issue_test)

confirm_to_continue("Update or Create issues")

Get-ChildItem "$depot_path/backlog" -Filter *.md | 
Foreach-Object {

    # item : name,path
    $item_full_name = $_.FullName
    $item_name = $_.Name
    $item_full_path = Split-Path  -Path $item_full_name

 
    # L'issue est existe si le fichier item commence par le numéro de l'issue
    $item_name_array = $item_name.Split(".");
    $issue_titre = ""
    $issue_number = ""

    # Create or Update
    # item = issue => number.titre.md
    if( $item_name_array.Length -eq 3 ) { 
        $issue_titre = $item_name_array[1]
        $issue_number = $item_name_array[0]
        Write-Host("Update de l'issue $issue_titre ")
        # confirm_to_continue("Update de l'issue $issue_titre ")
        gh issue edit $issue_number --add-label feature,new_issue --add-project $project_name --body-file $item_full_name
    }else{

        # Create issue
        $issue_titre = $item_name_array[0]

        # Dection de membre 
        $membre_titre_array = $issue_titre.Split("_");
        Write-Host("membre_titre_array = $membre_titre_array")
        $membre_reference = $null
        if($membre_titre_array.Length -eq 2){
            $membre_reference = $membre_titre_array[0]
        }

               

        Write-Host("Création de l'issue : $issue_titre ")
        # confirm_to_continue("Création de l'issue : $issue_titre pour $membre_reference ")

        if($membre_reference -eq $null){
            gh issue create --title $issue_titre --label feature,new_issue --project $project_name  --body-file $item_full_name
        }else{
            gh issue create --title $issue_titre --label feature,new_issue --assignee $membre_reference  --project $project_name  --body-file $item_full_name 
        }


        # Update item file name
        $created_issue = find_issue_by_title($issue_titre)
        $issue_number = $created_issue.number
        if($created_issue -eq $null){
            Write-Host "L'issue $item_full_name doit être existe dans le dépôt aprés sa création"
            exit
        }else{
            Write-Host "Rename item file name : $issue_titre"
            # Change issue file name 
            $item_new_name = "$issue_number.$issue_titre.md"
            Rename-Item -Path $item_full_name -NewName "$item_full_path\$item_new_name"
        }
    }
}

# Trouver les éléments à créer et à modifier

# Modification

# Création 