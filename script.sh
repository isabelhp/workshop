'def release = readYaml (file: 'release.yml')'
echo "La version de APP_JAVA-INT es: ${release[:][0]}"
