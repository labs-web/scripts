# Create repositories for all members

$members = "Betroji-Jalil", 
"Assaid-Amina",
"Faiz-Safaa",
"Achaou-Hamid",
"Boukhar-Soufiane",
"Daifane-Yasmine",
"Lamchatab-Amine",
"Bouik-Hussein",
"Zaani-Hamza",
"Grain-Reda",
"Lharrak-Adnan",
"Sarsri-Imrane",
"Ben-nasar-adnan"

foreach ($member in $members) {

    gh repo create "solicoders/$member-autoformation-android" --public
}


