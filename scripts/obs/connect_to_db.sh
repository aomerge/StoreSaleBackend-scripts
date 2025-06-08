
function check_database_name() {
    if [ -z "$DatabaseName" ]; then
        echo "Error: No se proporcionó el nombre de la base de datos."
        print_usage
        exit 1
    fi
}