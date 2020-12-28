changelog=$(git log --oneline -n 5)
echo "$changelog"
echo "::set-output name=changelog::$changelog"