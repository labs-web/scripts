debug "--- Import config-repository.core.ps1"

function create_workspace_file_if_not_exist($repository_full_name,$repository_name){
    $work_space_full_file_name = "$repository_full_name/$repository_name.code-workspace"
    if (-not(Test-Path $work_space_full_file_name)) {
        confirm_to_continue "Création de fichier workspace : $work_space_full_file_name"
        new-item $work_space_full_file_name
        Set-Content $work_space_full_file_name '{"folders": [{"path": "."}],"settings": {}}'
    }
}


function create_issues_template_files_if_not_exists($repository_full_name,$repository_name){
    
    confirm_to_continue "create_issues_template_files_if_not_exists "

    $repository_issue_templates_path = "$repository_full_name/.github/ISSUE_TEMPLATE"
    $scripts_issue_templates_path = $repository_full_name + "/scripts/.github/ISSUE_TEMPLATE/"

     # Create .github folder if not exist 
     if (-not(Test-Path ($repository_full_name + "/.github"))) {
        mkdir ($lab_web_full_nrepository_full_nameame + "/.github")
    }
    if (-not(Test-Path ($repository_full_name + "/.github/ISSUE_TEMPLATE"))) {
        mkdir ($repository_full_name + "/.github/ISSUE_TEMPLATE")
    }

    # Copy bug.md
    $issues_templates_names = "bug.md","exposé.md","feature.md", "sous-tâche.md"
    foreach($issue_template_name in $issues_templates_names  ){
        if (-not(Test-Path "$repository_issue_templates_path/$issue_template_name")) {
            confirm_to_continue "Création fichier :  $repository_issue_templates_path/$issue_template_name"
            copy-Item -Path "$scripts_issue_templates_path/$issue_template_name" "$repository_issue_templates_path/$issue_template_name"  
        }
    }
  
}
function update_workflow_files($repository_full_name,$repository_name){

    confirm_to_continue "update_workflow_files "
    debug "Modifier les workflow de $repository_name"

    # Create .github folder if not exist 
    if (-not(Test-Path ($repository_full_name + "/.github"))) {
        debug "run : mkdir ($repository_full_name/.github) "
        mkdir ($repository_full_name + "/.github")
    }

    # Create workflows folder if not exist
    if (-not(Test-Path ($repository_full_name + "/.github/workflows"))) {
        mkdir ($repository_full_name + "/.github/workflows")
    }

    # Copy files
    $script_workflows_path = $repository_full_name + "/scripts/.github/workflows/"

    debug "Copy update-issues-from-backlog.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-issues-from-backlog.yml" "$repository_full_name/.github/workflows/"
    
    debug "Copy update-readme-file.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/update-readme-file.yml" "$repository_full_name/.github/workflows/"

    debug "Copy jekyll-gh-pages.yml to $repository_full_name/.github/workflows/  "
    copy-Item "$script_workflows_path/jekyll-gh-pages.yml" "$repository_full_name/.github/workflows/"
    
}
function create_backlog_folder($repository_full_name,$repository_name){
    confirm_to_continue "create_backlog_folder "
    $backlog_folder_path = "$repository_full_name/backlog"
    if (-not(Test-Path $backlog_folder_path)) {
        mkdir $backlog_folder_path
    }

    $labels_names = "feature","sous-tâche","exposé", "chapitre","thème"
    foreach($labels_name in $labels_names  ){
        $backlog_labels_folder_path = "$repository_full_name/backlog/$labels_name"
        if (-not(Test-Path $backlog_labels_folder_path)) {
            mkdir $backlog_labels_folder_path
            New-Item "$backlog_labels_folder_path/README.txt"
        }
    }

}

function create_doc_folder ($repository_full_name,$repository_name){
    confirm_to_continue "create_doc_folder "
    $docs_folder_path = "$repository_full_name/docs"
    if (-not(Test-Path $docs_folder_path)) {
        debug "mkdir $docs_folder_path"
        mkdir $docs_folder_path
        New-Item "$docs_folder_path/index.md"
    }

    # Copy folder 
    $item_names = "_layouts","assets","images"
    foreach($item_name in $item_names  ){
        if (Test-Path "$docs_folder_path/$item_name") {
            Remove-Item "$docs_folder_path/$item_name" -Recurse
        }
        copy-Item "$repository_full_name/scripts/docs/$item_name" "$docs_folder_path/$item_name" -Recurse
    }

    # Copy files 
    $item_names = ".gitignore", "_config.yml","Gemfile","Gemfile.lock","index.md","presentation.md","run_jekyll.ps1"
    foreach($item_name in $item_names  ){
        if (Test-Path "$docs_folder_path/$item_name") {
            Remove-Item "$docs_folder_path/$item_name"
        }
        copy-Item "$repository_full_name/scripts/docs/$item_name" "$docs_folder_path/" 
    }


  

}

function update_snippets($repository_full_name,$repository_name){
    confirm_to_continue "update_snippets "
     # Create .vscode folder if not exist 
     if (-not(Test-Path ($repository_full_name + "/.vscode"))) {
        debug "run : mkdir ($repository_full_name/.vscode) "
        mkdir ($repository_full_name + "/.vscode")
    }

    $script_snippets_path = $repository_full_name + "/scripts/.vscode/"
    $snippets_files_names = "doc-item.code-snippets","issue.code-snippets"
    foreach($snippet_file_name in $snippets_files_names  ){
        debug "Update : $repository_full_name/.vscode/$snippet_file_name "
        copy-Item "$script_snippets_path/$snippet_file_name" "$repository_full_name/.vscode/$snippet_file_name"
    }
}

function create_readme_json_file($repository_full_name,$repository_name){
    confirm_to_continue "create_readme_json_file "
    $script_readme_json_file_path = $repository_full_name + "/scripts/README.json"
    $json_file_path = "$repository_full_name/README.json"
    if (-not(Test-Path "$json_file_path")) {
        debug "Création fichier :  $json_file_path"
        copy-Item -Path "$script_readme_json_file_path" "$json_file_path"  
    }
  
}

function install_submodule_scripts_if_not_installed($repository_full_name,$repository_name){
    confirm_to_continue "install_submodule_scripts_if_not_installed: $repository_full_name/scripts "
    $script_folder = "$repository_full_name/scripts"
    debug "Install or update $script_folder "
    if (-not(Test-Path "$script_folder")) {
        cd $repository_full_name
        git submodule add https://github.com/labs-web/scripts.git
        cd $depot_path
    }else{
        cd $script_folder
        git pull
        cd $depot_path
    }
}


function init_or_updat_config_repository($repository_name,$repository_full_name){

    
    # Ne pas toucher repository scripts
    if($repository.Name -eq "scripts"){continue}

    confirm_to_continue "Mise à jour de dépôt : $repository_name"
    pull_respository $repository_full_name $repository_name
    install_submodule_scripts_if_not_installed $repository_full_name $repository_name
    create_workspace_file_if_not_exist  $repository_full_name $repository_name
    create_issues_template_files_if_not_exists  $repository_full_name $repository_name
    update_workflow_files $repository_full_name $repository_name
    create_backlog_folder $repository_full_name $repository_name
    create_doc_folder $repository_full_name $repository_name
    update_snippets $repository_full_name $repository_name
    create_readme_json_file $repository_full_name $repository_name
    push_respository $repository_full_name $repository_name
}