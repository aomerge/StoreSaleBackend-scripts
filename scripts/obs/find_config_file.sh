TableName=()
DatabaseName=()
username=()
password=()
type_database=()

function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --type=*)
                echo "Tipo de configuración: ${arg#*=}"
                filter_files "${arg#*=}"            
                shift
            ;;
            # --type_db)
            #     shift             
            #     #type_database="${arg#*=}"                
            #     while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
            #         type_database+=("$1")
            #         shift
            #     done                
                
            # ;;
            --tables)
                shift                
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    TableName+=("$1")
                    shift
                done                
                #echo "Tablas especificadas: ${TableName[@]}"                
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
        DatabaseName+=("$database_name")
        username+=($(echo "$file_content" | grep "username" | sed 's/.*=//'))
        password+=($(echo "$file_content" | grep "password" | sed 's/.*=//'))
        # Extract database type from JDBC URL
        type_database+=($(echo "$file_url" | sed -n 's/.*jdbc:\([^:]*\):.*/\1/p'))
        if [ -z "${type_database[-1]}" ]; then
            type_database[-1]="java"
            echo "No se pudo detectar el tipo de base de datos, usando 'java' por defecto"
        else
            echo "Tipo de base de datos detectado: ${type_database[-1]}"
        fi
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

function parcer_data_input(){
    # Iterate through each database
        DatabaseName=($(echo "${DatabaseName[@]}" | tr ' ' '\n' | sort -u))  # Remove duplicates and sort
        # echo ""
        # echo "----------${username[0]}"
        # echo "----------${username[1]}"
        # echo "----------${username[2]}"
        # echo ""
        # echo "+++++++++${password[0]}"
        # echo "+++++++++${password[1]}"
        # echo "+++++++++${password[2]}"
        # echo ""
        # echo "---${DatabaseName[@]}"
        # echo "----------Type DB--------------"
        # echo "----------${type_database[0]}"
        # echo "----------${type_database[1]}"
        # echo "----------${type_database[2]}"
        # echo "----------------------------"
        # echo "---Conectando a lasdatos 1: ${DatabaseName[0]}"
        # echo "---Conectando a lasdatos 2: ${DatabaseName[1]}"
        # echo "---Conectando a lasdatos 3: ${DatabaseName[2]}"
}

function connect_to_db() {
    echo "Conectando a la base de datos..."
    #echo "$DatabaseName"
    if [ ${#DatabaseName[@]} -eq 0 ]; then
        echo "Error: No se proporcionó el nombre de la base de datos."
        exit 1
    fi
    
    # Validate if database connection parameters are available
    if [ ${#username[@]} -eq 0 ] || [ ${#password[@]} -eq 0 ]; then
        echo "Error: Credenciales de base de datos incompletas."
        exit 1
    fi
    local config_file="./obs/connect_to_db.sh"

    if [ -f "$config_file" ]; then
        chmod +x "$config_file"                
        parcer_data_input        
        for i in "${!DatabaseName[@]}"; do
            echo "Conectando a las bases de datos: ${DatabaseName[$i]} - [$i]"
            echo "Usuario: -----------------------------------------------------------"
            if [ ${#type_database[@]} -gt 0 ]; then
                "$config_file" --db="${DatabaseName[$i]}" --user="${username[$i]}" --password="${password[$i]}" --type "${type_database[$i]}" --tables "${TableName[@]}"            
            fi            
            if [ $? -ne 0 ]; then
                echo "❌ Error: No se pudo conectar a la base de datos ${DatabaseName[$i]}."
                exit 1
            fi
        done        
    else
        echo "❌ Error: No se encontró el archivo de configuración $config_file"
        exit 1
    fi
}

ui_elements "$@"
connect_to_db
