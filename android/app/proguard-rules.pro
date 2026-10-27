# Gson needs generic signatures and annotations to deserialize
-keepattributes Signature
-keepattributes *Annotation*
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# The prayer timetables saved by Flutter are parsed natively with Gson by field
# name (AzanUtils, CompetitionsAlarmReceiver, RamadanCannonUtils). If R8 renames
# these fields the timetable parses as empty and no azan is ever scheduled.
-keep class com.muslim_book.muslim_book.models.** { *; }

# WorkManager 2.7 (pulled in by plugins) bundles Room 2.2, whose rules predate
# R8 full mode (AGP 9 default): the generated WorkDatabase_Impl constructor was
# removed and the app crashed on launch creating the database
-keep class * extends androidx.room.RoomDatabase { <init>(); }

# Firebase finds its components by name (ComponentDiscoveryService metadata);
# under R8 full mode their constructors were removed ("FirebaseCrashlytics
# component is not present")
-keep class * implements com.google.firebase.components.ComponentRegistrar { <init>(); }
