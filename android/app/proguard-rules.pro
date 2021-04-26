# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-keep class sun.misc.Unsafe { *; }
#-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
# -keep class com.google.gson.examples.android.model.** { *; }

# Prevent proguard from stripping interface information from TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer


# Application classes that will be serialized/deserialized over Gson
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Timings$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.AzanModel$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.AzanModelData$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Date$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Designation$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Designation_$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Gregorian$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Hijri$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Meta$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Method$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Month$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Month_$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Offset$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Weekday$innerclass { 
        private <fields>; 
}
-keepclassmembers class com.muslim_book.muslim_book.models.azan_model.Weekday_$innerclass { 
        private <fields>; 
}
-keep class androidx.lifecycle.** { *; }

