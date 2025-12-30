# Keep TensorFlow Lite classes
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# Keep GPU delegate options
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }

# Flutter-specific rules (optional, for plugins using reflection)
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.plugin.platform.PlatformPlugin { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
