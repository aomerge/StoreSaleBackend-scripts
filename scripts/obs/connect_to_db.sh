#!/bin/bash
TableName=()
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
    #input_files=$(echo "$input_files" | sed 's/\.sql//g')    
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


function check_type_tables() {
  ls "../db/${type_database}/tables/"
  echo "-------------------------------------------"
       
}

ui_elements "$@"
check_type_tables
#check_sql_files