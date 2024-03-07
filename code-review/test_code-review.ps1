
function afficher_titre_test ($titre){
    Write-Host "`n Test : $titre`n" -ForegroundColor DarkGreen 
}

# TODO : vérifier l'affichae de message d'erreur 


afficher_titre_test "Paramètre de script : Appel de script sans paramètres"
.\scripts\code-review\code-review.ps1


afficher_titre_test "Paramètre de script : Appel de script avec un seul paramètre : Nom_Pullrequest"
.\scripts\code-review\code-review.ps1 init-app

afficher_titre_test "Paramètre de script : Appel de script avec deux paramètres : Nom_Pullrequest Nombre_Commits "
.\scripts\code-review\code-review.ps1 init-app 2

# TODO : Test les autres cas de linked_issues : deux sans issue, et plus qu'un issue

# Test règle 1 
afficher_titre_test "Test règle 1 : Le nom de pullrequest doit être en format : IssueeNumber-NomIssuee "
.\scripts\code-review\code-review.ps1 init-app 2 [init-app#1]

# Test règle 2
afficher_titre_test "Test de règle 2 : Appel de script sans isuee relie"
.\scripts\code-review\code-review.ps1 1-init-app 2 

# Test de règle 3
afficher_titre_test "Test de règle 3 : Le nom de pullrequest doit être identique au nom de l'issue  "
.\scripts\code-review\code-review.ps1 1-init-app 2 [init-app#1]


afficher_titre_test "Appel de script avec  "
.\scripts\code-review\code-review.ps1 22-projets_backend 2 [projets_backend#22]


