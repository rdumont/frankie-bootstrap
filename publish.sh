./app/frankie.exe run -s source -o site -v m
git branch -D master
git checkout -b master
git filter-branch --subdirecroty-filter site/ -f
git checkout source
git push --all origin