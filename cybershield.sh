#!/usr/bin/env bash
# CyberShield File Defender - Ultimate File Protection
# Autor: Asier Rios
# Licencia: MIT


VERSION="5.6.0"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
LOG_FILE="/var/log/cshield.log"
ORIGINAL_USER=$(logname 2>/dev/null || echo "${SUDO_USER:-$(whoami)}")
KEY_STORE="${HOME}/.cshield_keys"


show_banner() {
    clear
    echo -e "${BLUE}
   ____           __  __       _     _ _
  / ___|_ __ ___ |  \/  | __ _| |__ | | | ___ _ __
 | |   | '_ \` _ \| |\/| |/ _\` | '_ \| | |/ _ \ '__|
 | |___| | | | | | |  | | (_| | |_) | | |  __/ |
  \____|_| |_| |_|_|  |_|\__,_|_.__/|_|_|\___|_|
  ${NC}Versión ${VERSION} | Protección de Archivos Nivel Militar
  "
}


init_environment() {
    mkdir -p "$KEY_STORE"
    touch "$LOG_FILE"
}

cleanup() {
    echo "[$(date)] Operación completada en $1" >> "$LOG_FILE"
}


show_menu() {
    choice=$(dialog --title " CYBER SHIELD FILE DEFENDER " \
           --colors \
           --backtitle "Protección Avanzada de Archivos" \
           --menu "\nSeleccione una acción para: ${GREEN}$1${NC}" 18 60 10 \
           1 "🔒 Modo Paranoico (Máxima Protección)" \
           2 "🛡️ Configurar Permisos Específicos" \
           3 "🔐 Cifrado Avanzado" \
           4 "👑 Cambiar Propiedad" \
           5 "📡 Auditoría de Seguridad" \
           6 "🧼 Destrucción Segura" \
           7 "📋 Generar Reporte" \
           8 "🚪 Salir" 3>&1 1>&2 2>&3)
    echo "$choice"
}


paranoid_mode() {
    local target=$1
    (
    echo -e "XXX\n0\nIniciando protocolo de seguridad máxima...\nXXX"
    chmod 600 "$target" 2>/dev/null || { echo "Error en permisos"; exit 1; }
    echo -e "XXX\n25\nPermisos configurados\nXXX"
    chown root:root "$target" || { echo "Error en cambio de propietario"; exit 1; }
    echo -e "XXX\n50\nPropiedad cambiada a root\nXXX"
    chattr +i "$target" 2>/dev/null || { echo "Error en atributos"; exit 1; }
    echo -e "XXX\n75\nAtributos inmutables aplicados\nXXX"
    setfacl -b "$target" 2>/dev/null || { echo "Error en ACL"; exit 1; }
    echo -e "XXX\n100\nProtección completa finalizada\nXXX"
    ) | dialog --title " MODO PARANOID " --gauge "Por favor espere..." 8 60 0
    sudo chown "${ORIGINAL_USER}":"${ORIGINAL_USER}" "$target" 2>/dev/null
}

custom_permissions() {
    local target=$1
    choice=$(dialog --menu "Seleccione nivel de permisos:" 12 40 5 \
            1 "600 (Solo propietario)" \
            2 "400 (Solo lectura)" \
            3 "700 (Ejecutable)" \
            4 "Personalizado" 3>&1 1>&2 2>&3)

    case $choice in
        1) chmod 600 "$target" && dialog --msgbox "Permisos 600 aplicados" 6 40;;
        2) chmod 400 "$target" && dialog --msgbox "Permisos 400 aplicados" 6 40;;
        3) chmod 700 "$target" && dialog --msgbox "Permisos 700 aplicados" 6 40;;
        4)
            custom_perm=$(dialog --inputbox "Ingrese permisos en formato octal (ej: 644):" 8 40 3>&1 1>&2 2>&3)
            [[ "$custom_perm" =~ ^[0-7]{3,4}$ ]] && chmod "$custom_perm" "$target" || dialog --msgbox "Formato inválido!" 5 40
            ;;
        *) dialog --msgbox "Operación cancelada" 5 40;;
    esac
}

secure_wipe() {
    local target=$1
    dialog --yesno "¿Destruir archivo irreversiblemente? (10 pasadas DoD)" 8 60 && {
        (shred -v -n 10 -z -u "$target" 2>/dev/null | dialog --title "🧼 DESTRUCCIÓN" --gauge "Procesando..." 10 60) &&
        [ ! -f "$target" ] && dialog --msgbox "Archivo destruido con DoD 5220.22-M" 7 60
    } || dialog --msgbox "Operación cancelada" 5 40
}


aes_encrypt() {
    local target=$1
    local encrypted_file="${target}.aes"


    while true; do
        password=$(dialog --passwordbox "Ingrese una contraseña (mínimo 12 caracteres):" 8 50 3>&1 1>&2 2>&3)
        [ ${#password} -ge 12 ] && break
        dialog --msgbox "¡La contraseña debe tener al menos 12 caracteres!" 6 50
    done


    if openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 -in "$target" -out "$encrypted_file" -k "$password"; then
        chmod 600 "$encrypted_file"
        dialog --msgbox "${GREEN}✅ Cifrado completado\n🔒 Archivo cifrado: ${YELLOW}$encrypted_file${NC}" 10 60
    else
        dialog --msgbox "${RED}Error en el cifrado${NC}" 6 50
    fi
}


generate_report() {
    local target=$1
    local target_dir

    if [ -d "$target" ]; then
        target_dir="$target"
    else
        target_dir=$(dirname "$target")
    fi

    local filename=$(basename "$target")
    local report_file="${target_dir}/${filename}_reporte.log"

    {
        echo "=== Información del Archivo ==="
        stat "$target"
        echo -e "\n=== Permisos Detallados ==="
        ls -l "$target"
        echo -e "\n=== Atributos Extendidos ==="
        lsattr "$target"
        echo -e "\n=== Hash SHA-256 ==="
        sha256sum "$target"
    } > "$report_file"

    dialog --msgbox "✅ Reporte generado en:\n${YELLOW}${report_file}${NC}" 8 60
    dialog --textbox "$report_file" 20 70
}

file_encryption() {
    local target=$1
    method=$(dialog --radiolist "Método de cifrado:" 12 40 4 \
            1 "AES-256 (Recomendado)" on \
            2 "GPG (Asimétrico)" off 3>&1 1>&2 2>&3)

    case $method in
        1) aes_encrypt "$target";;
        2)
            gpg_user=$(dialog --inputbox "ID de usuario GPG:" 8 40 3>&1 1>&2 2>&3)
            if gpg --list-keys "$gpg_user" >/dev/null 2>&1; then
                gpg --encrypt --recipient "$gpg_user" "$target" &&
                chmod 600 "${target}.gpg" && secure_wipe "$target"
            else
                dialog --msgbox "¡Clave GPG no encontrada!" 6 40
            fi
            ;;
        *) dialog --msgbox "Operación cancelada" 5 40;;
    esac
}

main() {
    [[ $(id -u) -ne 0 ]] && { echo -e "${RED}Ejecutar con sudo!${NC}"; exit 1; }
    [[ -f "$1" || -d "$1" ]] || { echo -e "${RED}Objetivo inválido!${NC}"; exit 1; }

    init_environment
    show_banner

    while true; do
        choice=$(show_menu "$1")
        case $choice in
            1) paranoid_mode "$1";;
            2) custom_permissions "$1";;
            3) file_encryption "$1";;
            4)
                new_owner=$(dialog --inputbox "Nuevo propietario (usuario:grupo):" 8 40 3>&1 1>&2 2>&3)
                id "${new_owner%%:*}" &>/dev/null && chown "$new_owner" "$1" || dialog --msgbox "Usuario inválido!" 6 40
                ;;
            5)
                audit_rule=$(dialog --inputbox "Regla de auditoría (ej: -w /path -p rwxa):" 10 50 3>&1 1>&2 2>&3)
                auditctl $audit_rule && dialog --msgbox "Regla aplicada!" 6 40
                ;;
            6) secure_wipe "$1";;
            7) generate_report "$1";;
            8) exit 0;;
            *) exit 1;;
        esac
    done
}


main "$@"
