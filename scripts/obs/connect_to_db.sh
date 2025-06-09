#!/bin/bash

function connect(){
    echo "hgrt${username[@]} ${password[@]}"
}

function ui_elements (){
    for arg in "$@"
    do
        case $arg in
            --db=*)                
                
                DatabaseName="${arg#*=}"
                #echo "Base de datos: $DatabaseName"
                shift
            ;;
            --user=*)
                userName="${arg#*=}"
                #echo "Usuario: $userName"
                shift                            
            ;;        
            --password=*)
                password="${arg#*=}"
                #echo "Contraseña: $password"
                shift                                                   
            ;;    
            --tables | --table)
                shift
                TableName=()
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    TableName+=("$1")
                    shift
                done
                #echo "Tablas especificadas: ${TableName[@]}"
            ;;
            --type=*)
                shift
                type_database="${arg#*=}"
                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
                    TableName+=("$1")
                    shift
                done
                echo "Tipo de base de datos: $type_database"
            ;;
        esac
    done
}

ui_elements "$@"