# CyberShield
Herramienta profesional para protección avanzada de archivos y directorios con interfaz TUI (Terminal User Interface) y Cifrado de protección militar.

**CyberShield**: Un script Bash para la seguridad avanzada de archivos, que ofrece permisos personalizados, cifrado AES-256/GPG/Vernam, atributos inmutables y sobreescritura segura de archivos, diseñado para la ciberseguridad defensiva.

## 🚀 Características Principales

cInterfaz Interactiva Ncurses**: Facilita la navegación y configuración.
- **Cifrado Avanzado**: Soporte para AES-256 Cifrado de protección militar, GPG, y Vernam (One-Time Pad) para máxima seguridad.
- **Modo Paranoico**: Protección de nivel militar para tus datos más sensibles.
- **Gestión de Permisos**: Control avanzado con POSIX y ACL.
- **Destrucción Segura**: Cumple con el estándar DoD 5220.22-M.
- **Generación de Reportes Forenses**: Documenta actividades para auditoría y análisis.

## 📦 Instalación

### Requisitos (Debian/Ubuntu):
```bash
sudo apt install dialog openssl gnupg auditd

# Clonar repositorio:
git clone https://github.com/tuusuario/SecureForge.git
cd SecureForge

# Ejecutar:
sudo ./src/SecureShield.sh [archivo|directorio]
```

## 📚 Documentación Completa
Consulta el Manual Técnico para:

- **Configuración avanzada**
- **Opciones de cifrado cuántico**
- **Integración con sistemas de auditoría**
- **Desarrollo de plugins**

##  Ejemplos de uso
ejecutar: 
```bash
sudo bash ./cybershield.sh confidencial.txt      

```
## ⚒️ cambiar permisos y dar seguridad

![Captura de pantalla_20250225_204442](https://github.com/user-attachments/assets/d84fdfb6-d93f-4ab7-bd19-d867fa09593f)

## 🛡️ Generar reportes y auditoria de seguridad

![Captura de pantalla_20250225_203837](https://github.com/user-attachments/assets/f829f53c-8572-4240-bc57-19b9a2f319e3)



