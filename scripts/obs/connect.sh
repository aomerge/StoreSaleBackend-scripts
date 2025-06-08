TableName=()
DatabaseName=()
username=()
password=()

function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --type=*)
                echo "Tipo de conexión: ${arg#*=}"
                filter_files "${arg#*=}"            
                shift
            ;;
            --tables)
                shift
                TableName=()
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    TableName+=("$1")
                    shift
                done
                #echo "Tablas especificadas: ${TableName[@]}"
                exit 1
            ;;
            *)
                echo "Argumento no reconocido: $arg"
                echo "Uso: $0 [db=database_name]"
                exit 1
            ;;
        esac
    done
}

function find_files_java() {
    file_dir="../files/"
    file_env=($(ls "$file_dir"*.properties 2>/dev/null))
    if [ ${#file_env[@]} -gt 0 ]; then
        file_content=$(cat "${file_env[@]}" | grep "datasource")
        file_url=$(echo "$file_content" | grep "url")                
        database_name=$(echo "$file_url" | sed -n 's/.*databaseName=\([^;]*\).*/\1/p; s/.*\/\([^/?]*\).*/\1/p')
        if [ -z "$database_name" ]; then
            echo "No se pudo extraer el nombre de la base de datos."
            exit 1
        fi
        DatabaseName="$database_name"
        username=$(echo "$file_content" | grep "username" | sed 's/.*=//')
        password=$(echo "$file_content" | grep "password" | sed 's/.*=//')
        #echo "Usuario: $username"
        #echo "Contraseña: ${password[@]}"
        #echo DatabaseName="$DatabaseName"
    else
        echo "No se encontraron archivos .properties"
    fi    
}

function filter_files() {
    case "$1" in
        "java")
            echo "Buscando archivos de base de datos..."
            find_files_java
            ;;
        "php")
            echo "Buscando archivos de API..."
            ;;
        "node")
            echo "Buscando archivos de configuración..."
            ;;
        "c#")

            ;;
        *)
            echo "Tipo no reconocido: $1"
            ;;
    esac    
}

connect_to_db() {
    if [ -z "$DatabaseName" ]; then
        echo "❌ Error: No se proporcionó el nombre de la base de datos."
        echo "   Asegúrate de que el archivo .properties contenga la información correcta."
        exit 1
    fi

    echo "Conectando a la base de datos: $DatabaseName"
    echo "Usuario: $username"
    echo "Contraseña: $password"
    # Aquí iría el comando para conectarse a la base de datos, por ejemplo:
    # psql -U "$username" -d "$DatabaseName" -W "$password"
}

ui_elements "$@"
