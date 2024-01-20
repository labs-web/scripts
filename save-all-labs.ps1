# Enregistrement de tous les labs 

# Emplacement des labs 
$labs_web_path = $PSScriptRoot + "/../../"
cd $labs_web_path

Get-ChildItem . -Filter * | 
Foreach-Object {

    # Nom de lab
    $FullName = $_.FullName
    $File_Name = $_.Name

    # Message de confirmation
    Write-Host $FullName

    # git push
    cd $FullName
    git add .
    git commit -m "save"
    git push
}