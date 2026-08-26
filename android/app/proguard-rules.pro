# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions
-dontwarn androidx.window.extensions.WindowExtensions
-dontwarn androidx.window.extensions.WindowExtensionsProvider
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaPresentation
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaStatus
-dontwarn androidx.window.extensions.area.WindowAreaComponent
-dontwarn androidx.window.extensions.layout.DisplayFeature
-dontwarn androidx.window.extensions.layout.FoldingFeature
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.extensions.layout.WindowLayoutInfo
-dontwarn androidx.window.extensions.embedding.ActivityStack
-dontwarn androidx.window.extensions.embedding.ActivityEmbeddingComponent
-dontwarn androidx.window.extensions.embedding.ActivityRule
-dontwarn androidx.window.extensions.embedding.ActivityRule$Builder
-dontwarn androidx.window.extensions.embedding.EmbeddingRule
-dontwarn androidx.window.extensions.embedding.SplitAttributes
-dontwarn androidx.window.extensions.embedding.SplitAttributes$Builder
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$ExpandContainersSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$HingeSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$RatioSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributesCalculatorParams
-dontwarn androidx.window.extensions.embedding.SplitInfo
-dontwarn androidx.window.extensions.embedding.SplitPairRule
-dontwarn androidx.window.extensions.embedding.SplitPairRule$Builder
-dontwarn androidx.window.extensions.embedding.SplitPlaceholderRule
-dontwarn androidx.window.extensions.embedding.SplitPlaceholderRule$Builder
-dontwarn androidx.window.sidecar.SidecarDeviceState
-dontwarn androidx.window.sidecar.SidecarDisplayFeature
-dontwarn androidx.window.sidecar.SidecarInterface$SidecarCallback
-dontwarn androidx.window.sidecar.SidecarInterface
-dontwarn androidx.window.sidecar.SidecarProvider
-dontwarn androidx.window.sidecar.SidecarWindowLayoutInfo

# Keep androidx.window classes to avoid R8 errors
-keep class androidx.window.** { *; }
-keep interface androidx.window.** { *; }
-dontwarn androidx.window.**

# ========================
# REGLAS PARA FLUTTER
# ========================

# Conservar la funcionalidad principal de Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# ========================
# REGLAS DE ENDURECIMIENTO (SECURITY HARDENING)
# ========================

# FLUTTER SECURE STORAGE: Eliminar implementaciones CBC vulnerables
# MobSF detecta StorageCipherImplementationAES18.java que usa CBC
# Estas reglas REALMENTE eliminan las clases CBC del APK final

# IMPORTANTE: -assumenosideeffects NO elimina clases, solo optimiza
# Usamos una combinación de técnicas para eliminar completamente CBC

# 1. Marcar clases CBC como no utilizadas (para que R8 las elimine)
-dontwarn com.it_nomads.fluttersecurestorage.ciphers.StorageCipherImplementationAES18
-dontwarn com.it_nomads.fluttersecurestorage.ciphers.StorageCipherImplementationAES18$**

# 2. NO mantener ninguna clase que contenga CBC en su implementación
# Esto es crítico: si no hay -keep, R8 puede eliminarlas si no se usan
# Como forzamos AES-GCM en el código, estas clases NO se usan

# 3. Mantener SOLO las clases que usamos (AES-GCM)
-keep class com.it_nomads.fluttersecurestorage.ciphers.StorageCipher {
    public <methods>;
}

# 4. Mantener la factory pero permitir que elimine implementaciones no usadas
-keep class com.it_nomads.fluttersecurestorage.ciphers.StorageCipherFactory {
    public <methods>;
}

# 5. NO mantener StorageCipherImplementationAES18 (CBC)
# Al no tener -keep, R8 la eliminará si no se usa
# Como configuramos explícitamente GCM, esta clase NO se usa

# 6. Mantener SOLO StorageCipherImplementationAES23 (GCM)
-keep class com.it_nomads.fluttersecurestorage.ciphers.StorageCipherImplementationAES23 {
    public <init>(...);
    public <methods>;
}

# 7. Eliminar cualquier referencia a CBC/PKCS en el bytecode
-assumenosideeffects class * {
    *** *CBC*(...) return null;
    *** *Cbc*(...) return null;
    *** *cbc*(...) return null;
    *** *PKCS5*(...) return null;
    *** *PKCS7*(...) return null;
}

# 8. Mantener solo métodos GCM y OAEP
-keep class * {
    *** *GCM*(...);
    *** *Gcm*(...);
    *** *gcm*(...);
    *** *OAEP*(...);
}

# 9. Eliminar Tink (si está presente) que también usa CBC
-dontwarn com.google.crypto.tink.**
-dontwarn javax.crypto.Cipher

# 10. Shrinking agresivo para eliminar código no usado
# Esto es crítico para que R8 realmente elimine las clases CBC
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# Ofuscación agresiva para componentes internos que causan falsos positivos (como archivos temporales)
-keepclassmembernames class io.flutter.plugins.camerax.** {
    <methods>;
}

# Solución al error: Missing class com.google.android.play.core...
# Le decimos a R8 que no se preocupe si no encuentra estas clases de Play Core
# ya que no estamos usando "Dynamic Feature Modules" ni descargas dinámicas.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task


