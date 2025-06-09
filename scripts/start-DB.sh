#!/bin/bash
sql_directories=()
sql_tables=()
DatabaseName=()
type_database=()

for dir in ../db/*/; do
    if [ -d "${dir}tables" ]; then
        sql_directories+=("${dir}tables")
        type_database+=("$(basename "$dir")")
    fi
done    

function ui_elements (){
    for arg in "$@"
    do
        case $arg in            
            --type=*)
                type_env="${arg#*=}"
                shift
            ;;
            *)
                echo "Argumento no reconocido: $arg"
                echo "Uso: $0 [db=database_name]"
                exit 1
            ;;
        esac
    done
}

function print_usage() {
    echo "Uso: $0 [db=database_name]"
}

function search_sql_files() {    
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Error: Argumentos inválidos proporcionados."
        echo "   Se requieren tanto el directorio como el tipo de base de datos."
        print_usage
        return 1
        exit 1
    fi
    local dir="$1"
    local db_type="$2"
    echo "🔍 Procesando base de datos: $db_type"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    input_files=$(find "$dir" -maxdepth 1 -type f -name "*.sql" -exec basename {} \;)
    input_files=$(echo "$input_files" | sed 's/\.sql//g')    
    sql_tables+=("$db_type")

    if [ -z "$input_files" ]; then
        echo "❌ Error: No se encontraron archivos SQL en $dir"
        echo "   Asegúrate de que existan archivos .sql en el directorio."
        return 1
        exit 1
    else
        sql_tables+=("$input_files")        
        echo "📁 Archivos encontrados:"
        echo "$input_files" | while IFS= read -r file; do                        
            echo "  ✓ $file"
        done
    fi
    echo ""
}

function check_sql_files() {
    echo "Buscando archivos SQL en las carpetas de tablas..."
    for dir in "${sql_directories[@]}"; do
        db_type=$(basename "$(dirname "$dir")")
        search_sql_files "$dir" "$db_type"
    done        
}
function find_config_file() {
    local config_file="./obs/find_config_file.sh"
    if [ -f "$config_file" ]; then                
        chmod +x "$config_file"        
        "$config_file" --type="$type_env" --tables "${sql_tables[@]}" --type_db "${type_database[@]}" --db="${DatabaseName[@]}"        
        if [ $? -ne 0 ]; then
            echo "❌ Error: No se pudo ejecutar el script de configuración."
            exit 1
        else            
            #echo "Después del source: ${type_database[@]} mmmmmmmmmmmmmmmm"
            echo "✅ Configuración completada exitosamente."
        fi
    else
        echo "❌ Error: No se encontró el archivo de configuración $config_file"
        exit 1
    fi    
}


ui_elements "$@"
check_sql_files
find_config_file
