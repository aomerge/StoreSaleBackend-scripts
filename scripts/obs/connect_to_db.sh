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
            --exec=*)
                exec_number="${arg#*=}"
                echo "Número de ejecución: $exec_number"
                if [[ ! $exec_number =~ ^[0-9]+$ ]]; then
                    echo "❌ Error: El número de ejecución debe ser un número entero."
                    exit 1
                fi                
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
        echo "✅ Ejecutando operación número 1"
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



function check_type_tables() {
    echo "Tablas a crear:"
    for table_file in "../db/${type_database}/tables/"*.sql; do
        if [ -f "$table_file" ]; then
            TableName+=("$table_file")
        fi
    done
    echo "- ${TableName[@]}"
  echo "-------------------------------------------"
       
}

ui_elements "$@"
check_type_tables
#check_sql_files