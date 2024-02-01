# TODO : Script d'initialisation d'un lab

# create develop branch
git add .
git commit -m "save"
git push
git checkout -b "develop"
git push --set-upstream origin develop

#  set develop branch as default 
gh repo edit --default-branch develop
