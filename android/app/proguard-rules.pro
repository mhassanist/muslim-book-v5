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
