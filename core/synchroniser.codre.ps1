debug "--- Import synchroniser.codre.core.ps1"


function pull_respository($repository_full_name,$repository_name){
    confirm_to_continue "git pull : $repository_full_name "
    debug "git pull : $repository_name "
    cd $repository_full_name
    git add . 
    git commit -m "save to do git pull"
    git pull
}

function push_respository($repository_full_name,$repository_name){
    confirm_to_continue "git push : $repository_full_name "
    debug "git push : $repository_name "
    cd $repository_full_name
    git add . 
    git commit -m "save to do git push"
    git push
}