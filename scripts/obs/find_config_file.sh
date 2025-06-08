TableName=()
DatabaseName=()
username=()
password=()

function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --type=*)
                echo "Tipo de configuración: ${arg#*=}"
                filter_files "${arg#*=}"            
                shift
            ;;
            --tables)
                shift                
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    TableName+=("$1")
                    shift
                done
                connect_to_db
                #echo "Tablas especificadas: ${TableName[@]}"                
            ;;
            *)
                echo "Argumento no reconocido: $1"
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
        DatabaseName+="$database_name"
        username+=$(echo "$file_content" | grep "username" | sed 's/.*=//')
        password+=$(echo "$file_content" | grep "password" | sed 's/.*=//')
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
            echo "done"
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
    echo "Conectando a la base de datos..."
    #echo "$DatabaseName"
    if [ -z "$DatabaseName" ]; then
        echo "Error: No se proporcionó el nombre de la base de datos."
        exit 1
    fi
    
    # Validate if database connection parameters are available
    if [ -z "$username" ] || [ -z "$password" ]; then
        echo "Error: Credenciales de base de datos incompletas."
        exit 1
    fi
    
    

    ./obs/connect_to_db.sh --db="$DatabaseName" --user="$username" --password="$password" "${TableName[@]}"
    if [ $? -ne 0 ]; then
        echo "❌ Error: No se pudo conectar a la base de datos."
        exit 1
    fi
    echo "✅ Conexión exitosa a la base de datos: $DatabaseName"
    echo "Tablas especificadas: ${TableName[@]}"
    echo "Usuario: $username"
    echo "Contraseña: $password"
    echo "done"
    echo "Conexión a la base de datos completada."
    echo "Puedes continuar con las operaciones de la base de datos."
    echo "Si necesitas realizar más operaciones, puedes ejecutar el script nuevamente con los parámetros adecuados."
    echo "Para más información, consulta la documentación del script."
    echo "Gracias por usar este script. ¡Hasta luego!"
    echo "done"
    echo "----------------------------------------"
    echo "Conexión a la base de datos finalizada."
    echo "----------------------------------------"
    
}

ui_elements "$@"
