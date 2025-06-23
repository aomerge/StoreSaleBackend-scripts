#bin/bash

function installed_dependencies() {
    local dependencies=("curl" "wget" "git" "docker" "podman" )
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "❌ Error: $dep no está instalado. Por favor, instálalo antes de continuar."
            exit 1
        else
            echo "✅ $dep está instalado."
        fi
    done
}