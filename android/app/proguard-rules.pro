-keep class * implements java.io.Serializable { *; }

# Suppress warnings for j$.util.concurrent classes
-dontwarn j$.util.concurrent.**

# Suppress warnings for j$.util classes
-dontwarn j$.util.**
