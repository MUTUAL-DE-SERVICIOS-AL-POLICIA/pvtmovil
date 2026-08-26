#!/bin/bash

# Script de Verificación del APK Seguro
# Ejecutar después de que termine el build

echo "=========================================="
echo "  Verificación de APK Seguro - MUSERPOL"
echo "=========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si existe el APK
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_PATH" ]; then
    echo -e "${GREEN}✓${NC} APK encontrado: $APK_PATH"
    
    # Mostrar información del APK
    echo ""
    echo "Información del APK:"
    echo "-------------------"
    ls -lh "$APK_PATH"
    echo ""
    
    # Mostrar fecha de creación
    echo "Fecha de generación:"
    stat "$APK_PATH" | grep "Modify"
    echo ""
    
    # Calcular hash SHA256
    echo "Hash SHA256 (para verificación):"
    sha256sum "$APK_PATH"
    echo ""
    
    # Verificar tamaño (un APK optimizado debería ser más pequeño)
    SIZE=$(stat -c%s "$APK_PATH")
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "Tamaño: ${SIZE_MB} MB"
    echo ""
    
    # Verificar si ProGuard se aplicó (buscar en logs)
    if [ -f "build_log.txt" ]; then
        if grep -q "R8" build_log.txt; then
            echo -e "${GREEN}✓${NC} ProGuard/R8 se aplicó correctamente"
        else
            echo -e "${YELLOW}⚠${NC} No se detectó ProGuard/R8 en los logs"
        fi
    fi
    
    echo ""
    echo "=========================================="
    echo "  Próximos Pasos"
    echo "=========================================="
    echo "1. Sube el APK a MobSF:"
    echo "   $APK_PATH"
    echo ""
    echo "2. Ejecuta el análisis de seguridad"
    echo ""
    echo "3. Verifica que NO aparezca:"
    echo "   - Vulnerabilidad CBC"
    echo "   - Archivo j2/P3.java con CBC"
    echo "   - CWE-649"
    echo ""
    echo "4. El score de seguridad debería mejorar"
    echo "   (de 51/100 a un valor mayor)"
    echo ""
    
else
    echo -e "${RED}✗${NC} APK no encontrado en: $APK_PATH"
    echo ""
    echo "Verifica que el build haya terminado correctamente."
    echo "Ejecuta: flutter build apk --release"
    echo ""
fi

# Verificar APKs divididos por arquitectura
echo "Verificando APKs divididos por arquitectura:"
echo "--------------------------------------------"
for arch in armeabi-v7a arm64-v8a x86_64; do
    APK_ARCH="build/app/outputs/flutter-apk/app-$arch-release.apk"
    if [ -f "$APK_ARCH" ]; then
        SIZE=$(stat -c%s "$APK_ARCH")
        SIZE_MB=$((SIZE / 1024 / 1024))
        echo -e "${GREEN}✓${NC} $arch: ${SIZE_MB} MB"
    fi
done

echo ""
echo "=========================================="
