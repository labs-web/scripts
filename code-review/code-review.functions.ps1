
# Initialisation des paramètres de script
function get_script_params($arguments,$params){
debug "Script params : $arguments"
# Param 1 : Nom du pullrequest
$params.pullrequest_name = $arguments[0]
if($null -eq $params.pullrequest_name) { error "Il manque le paramètre 0 : Nom_Pullrequest"}

# Param 2 :Nombre de commits à valider dans le branch liée à l'issue
# Ce paramètre n'est pas utilisé, car nous comparons HEAD avec develop
$commits = $arguments[1]
if($null -eq $commits) { error "Il manque le paramètre 1 : Nombre_Commits (Nombre de commit à valider)"}

# Param 3 : Les issues reliés au pullrequest
$params.linked_issues = $arguments[2]
if($null -eq $params.linked_issues) { error "Il manque le paramètre 2 : linked_issues"}
$params.linked_issues= $params.linked_issues.TrimStart("[").TrimEnd("]").Split(',')

}


function get_package_json($depot_path){
    $packages_json_file_path = "$depot_path/backlog/Packages.json"
    $default_packages_json_file_path = "$depot_path/scripts/backlog/Packages.json"
    $packages_json = $null

    if( Test-Path $packages_json_file_path ){
        $packages_json = Get-Content $packages_json_file_path  | ConvertFrom-Json
    }else{
        $packages_json = Get-Content $default_packages_json_file_path  | ConvertFrom-Json
    }
    return $packages_json
}

# Trouver la configuration selon le nom du package
function find_package_config ($package_name,$packages_config){

    foreach($package_config in $packages_config ){
        if($package_config.Titre -eq $package_name ){
            return $package_config
        }
    }
    return $null
}

function replace_array_string ($array,$string1,$string2){
    for ($i = 0; $i -lt $array.Length; $i++) {
        $array[$i] = $array[$i] -replace "$string1","$string2"
    }
}

function get_algorithme_params($pullrequest_name){

    $algorithme_params = @{}

    # Calculer : issue_number
    $pullrequest_parts_array = $pullrequest_name.Split('-')
    $algorithme_params.issue_number = $pullrequest_parts_array[0]
    # Calculer : issue_title
    $algorithme_params.issue_title = $pullrequest_name -replace "$($algorithme_params.issue_number)-",""
    # Calculer : $task_name
    # - Le nom de l'issue peut être est sous la forme : PackageName_TaskName
    # - Exemple gestion-projet_backend,gestion-projet_unitTest,gestion-projet_frontend
    $issue_title_parts_array = $algorithme_params.issue_title.Split('_')
    $algorithme_params.package_name = $issue_title_parts_array[0]
    if($issue_title_parts_array.length -gt 0){
        $algorithme_params.task_name = $issue_title_parts_array[1]
    }
    return $algorithme_params

}
