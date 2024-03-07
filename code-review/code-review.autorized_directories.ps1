
# Calculer les chemins autorisés
function get_autorized_directories($package_name ,$package_config,$packages_json){

    $autorized_directories = $null
    $default_authorized_directories = $packages_json.DefaultAuthorizedDirectories

    replace_array_string $default_authorized_directories "{{package_name}}" "$package_name"
    $autorized_directories = $default_authorized_directories
    if($package_config -eq $null){

        if(if_code_existe_dans_dossier_app -eq $true){
            replace_array_string $laravel_authorized_directories "{{directory_code}}" "app"
        }else{
            replace_array_string $laravel_authorized_directories "{{directory_code}}/" ""
        }
        replace_array_string $laravel_authorized_directories "{{package_name}}" "$package_name"

        $autorized_directories = $autorized_directories +  $laravel_authorized_directories
    }else{
        $autorized_directories = $autorized_directories + $package_config.Chemins
    }

    return $autorized_directories
}

function if_code_existe_dans_dossier_app(){
    $laravel_app_config_file = "app/config/app.php"
    if(Test-Path $laravel_app_config_file ){
        return $true
    }else{
        return $false
    }
}
