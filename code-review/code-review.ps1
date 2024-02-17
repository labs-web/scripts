
# Paramètres
$pullrequest_name = $args[0]
$package_name = $pullrequest_name.Split('/')[0]
$commits = $args[1]

# Les fichiers changés
$chanded_files = git diff --name-only HEAD HEAD~"$commits"


# Les dossiers autorisé à modifier pour le package $package_name
$autorized_directories = "app/Http/Controllers/$package_name",
                 "app/Models/$package_name",
                 "docs/$package_name"

$autorised_change = $true

foreach($file in $chanded_files){

    $autorised_change_file = $false

    # Vérifier si le fichier $file est situé dans l'un des dossiers autorisé
    # TODO : utilisez des expression régulière
    foreach($autorized_directory in $autorized_directories ){
        if($file -like "$autorized_directory*"){
            $autorised_change_file = $true
        }
    }

    # Afficahge de message d'erreur sir le membre n'est pas autorisé à modifier le fichier
    if(-not($autorised_change_file)) {
        Write-Host "::error:: +Vous n'avez pas le droit de modifier le fichier : $file"
        $autorised_change = $false
    } 
}

Write-Host "autorised_change = $autorised_change"
if(-not($autorised_change)){
    exit 1
}


