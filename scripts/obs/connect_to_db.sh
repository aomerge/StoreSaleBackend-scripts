#!/bin/bash
TableName=()
userName=()
function connect(){
    echo "hgrt${username[@]} ${password[@]}"
}

function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --db=*)                
                
                DatabaseName="${arg#*=}"
                echo "Base de datos: $DatabaseName"
                shift
            ;;
            --user=*)
                userName="${arg#*=}"
                echo "Usuario: $userName"
                shift                            
            ;;        
            --password=*)
                password="${arg#*=}"
                echo "Contraseña: $password"
                shift                                                   
            ;;
            --exec=*)
                exec_number="${arg#*=}"
                echo "Número de ejecución: $exec_number"
                if [[ ! $exec_number =~ ^[0-9]+$ ]]; then
                    echo "❌ Error: El número de ejecución debe ser un número entero."
                    exit 1
                fi                 
                shift
            ;;
            --port=*)
                port="${arg#*=}"
                echo "Puerto: $port"
                shift
            ;;
            --type)
                shift
                type_database=()
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    type_database+=("$1")
                    shift
                done                
                echo "Tipo de base de datos: ${type_database[@]}"                
            ;;
        esac
    done
}
 

function exec_run_command() {
    case $exec_number in
    1)                
        run_docker_command
    ;;
    2)
        echo "✅ Ejecutando operación número 2"
    ;;
    *)
        echo "❌ Error: El número de ejecución debe ser 1 o 2."
        exit 1
    ;;
    esac
}

function parcer_data(){
    userName=$(echo "$userName" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    password=$(echo "$password" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    DatabaseName=$(echo "$DatabaseName" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
}

function run_docker_command() {
    # Verificar si el contenedor está ejecutándose
    container_status=$(podman ps --filter "name=${type_database[0]}" --format "{{.Names}}")
    parcer_data
    if [ -z "$container_status" ]; then
        echo "⚠️  Alerta: El contenedor '${type_database[0]}' no se encuentra ejecutándose o no existe."
        echo "💡 Sugerencia: Verifique que el contenedor esté iniciado con 'podman ps -a'"
        exit 1
    else
        echo "✅ Contenedor '${type_database[0]}' encontrado y ejecutándose."
    fi
    for table in "${TableName[@]}"; do
        echo "Procesando tabla: $table"
        # Validar tipo de base de datos y ejecutar comando correspondiente
        case "${type_database[0]}" in
            "postgressql" | "postgres")
                echo "🐘 Detectado PostgreSQL - Ejecutando comando para PostgreSQL"
                podman exec -it "${type_database[0]}" psql -U "$userName" -d "$DatabaseName"
                exit
            ;;
            "sqlserver")
            
                echo "🗄️  Detectado SQL Server - Ejecutando comando para SQL Server"
                podman exec -it ${type_database[0]} /opt/mssql-tools18/bin/sqlcmd -S localhost -U "$userName" -P "$password" -d "$DatabaseName" -C
                exit
                ;;
                *)
                echo "❌ Error: Tipo de base de datos no soportado. Use 'postgres' o 'sqlserver'"
                exit 1
            ;;
        esac
        
        echo "podman exec -it "${type_database[0]}" psql -U postgres -d "$DatabaseName""
        
    done
    
}

function check_type_tables() {
    for table_file in "../db/${type_database}/tables/"*.sql; do
        if [ -f "$table_file" ]; then
            TableName+=("$table_file")
        fi
    done    
    echo "Tablas a crear:"
    exec_run_command 
    echo "-------------------------------------------"
       
}

ui_elements "$@"
check_type_tables
#check_sql_files