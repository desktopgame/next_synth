changelog=$(git log --oneline -n 5)
changelog="${changelog//$'\n'/\\n}"
echo "$changelog"
echo "::set-output name=changelog::$changelog"