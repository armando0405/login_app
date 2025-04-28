import os

def mostrar_estructura(ruta, nivel=0):
    """Muestra la estructura de directorios en la terminal"""
    # Nombre base para mostrar
    nombre = os.path.basename(ruta)
    
    # Indentación y prefijos visuales
    indentacion = '    ' * nivel
    prefijo = '├── ' if nivel > 0 else ''
    
    # Mostrar el directorio actual
    print(f"{indentacion}{prefijo}{nombre}/" if nivel > 0 else f"{nombre}/")
    
    try:
        elementos = sorted(os.listdir(ruta))
    except PermissionError:
        return
    
    # Separar archivos y directorios
    archivos = []
    directorios = []
    
    for item in elementos:
        if item.startswith('.'):  # Ignorar archivos ocultos
            continue
        if os.path.isdir(os.path.join(ruta, item)):
            directorios.append(item)
        else:
            archivos.append(item)
    
    # Mostrar archivos primero
    for i, archivo in enumerate(archivos):
        es_ultimo = (i == len(archivos) - 1) and not directorios
        prefijo = '└── ' if es_ultimo else '├── '
        print(f"{indentacion}    {prefijo}{archivo}")
    
    # Mostrar directorios recursivamente
    for i, directorio in enumerate(directorios):
        es_ultimo = i == len(directorios) - 1
        prefijo = '└── ' if es_ultimo else '├── '
        print(f"{indentacion}    {prefijo}", end='')
        nueva_ruta = os.path.join(ruta, directorio)
        mostrar_estructura(nueva_ruta, nivel + 1)

# Ruta que quieres analizar - MODIFICA ESTA LÍNEA CON TU RUTA
ruta_a_analizar = r'C:\Users\SENA\Documents\flutter_app_crud - Final\crud_session\lib'

print(f"\nEstructura de directorios para: {ruta_a_analizar}\n")
mostrar_estructura(ruta_a_analizar)
print()  # Espacio final