function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --type=*)
                echo "Tipo de conexión: ${arg#*=}"
                print_usage
                
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
    echo "Uso: hols"    
    exit 1
}

ui_elements "$@"