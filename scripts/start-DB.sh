#!/bin/bash
sql_directories=()
sql_tables=()
DatabaseName=()
type_database=()

function ui_elements (){
    for arg in "$@"
    do
        case $arg in            
            --type=*)
                type_env="${arg#*=}"
                shift
            ;;
            --exec=*)
                exec_number="${arg#*=}"
                #echo "Número de ejecución: $exec_number"
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
function find_config_file() {
    local config_file="./obs/find_config_file.sh"

    if [ -f "$config_file" ]; then                
        chmod +x "$config_file"        
        "$config_file" --type="$type_env" --type_db "${type_database[@]}" --db="${DatabaseName[@]}" --exec="$exec_number"       
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
find_config_file
