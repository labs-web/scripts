const { info_message, error_message, warning_message } = require('./Utils/uiUtils');

const {run_commande} = require('./Utils/child_process')


function init_develop_branche(){
    run_commande("git add .")
    run_commande("git commit -m 'save'")
    run_commande("git push")
    run_commande("git checkout -b 'develop'")
    run_commande("git push --set-upstream origin develop")
    run_commande("gh repo edit --default-branch develop")
}

init_develop_branche()