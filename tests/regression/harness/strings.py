"""UI labels the suite looks for (Arabic, the app's default language).

Keep these in sync with assets/langs/ar.json; when a label changes in the
app, update it here.
"""

# Onboarding
ENABLE_AZAN = "تفعيل الآذان"
LOCATION_TITLE = "ضبط الموقع"
AUTO_LOCATE = "تحديد موقعك تلقائياً"
METHOD_PLACEHOLDER = "طريقة حساب توقيت الصلاة"
EGYPTIAN_METHOD = "الهيئة المصرية العامة للمساحة"
SAVE_TIMING = "حفظ إعدادات التوقيت"
ERR_NO_COUNTRY = "من فضلك حدد بلدك لضبط وقت الآذان"
ERR_NO_METHOD = "برجاء إختيار المذهب و طريقة حساب الآذان"
ALLOW_NOTIFICATIONS = "السماح بالتنبيهات"

# Home
MAIN_SECTIONS = "الأقسام الرئيسية"
PRAYER_TIMES = "مواقيت الصلاة"
REMAINING = "متبقي"
TILES = ["المسابقات", "السبحة", "الأذكار", "القرآن الكريم", "اتجاة القبلة", "المزيد"]
ISLAMIYAT = "إسلاميات"
COMMUNITY = "مجتمعنا"
EXIT_APP_QUESTION = "هل انت متأكد انك تريد الخروج من التطبيق؟"
CANCEL = "الغاء"
SKIP = "تخطي"  # competitions intro popup; Back does not close it
TAB_SUFFIX = "علامة التبويب"
TABS = {  # bottom tab label -> a label expected on its screen
    "القرآن الكريم": "المصحف الشريف",
    "اتجاة القبلة": "معايرة البوصلة",
    "المسابقات": "تسجيل الدخول بالبريد",  # logged out
    "الأذكار": "أذكار الصباح",
    "الرئيسية": MAIN_SECTIONS,
}
LANGUAGES = ["العربية", "الانجليزية", "الفرنسية"]

# Side menu
MENU_ITEMS = ["مواقيت الصلاة", "اتجاة القبلة", "القرآن الكريم", "السبحة", "الأذكار",
              "المسابقات", "المزيد", "الأوائل", "حسابي الشخصي", "سياسة الاستخدام",
              "الاعدادات"]
TOP_USERS = "الأوائل"
TOP_USERS_TABS = ["أوائل المسابقات", "أوائل التسبيح"]
PRIVACY_POLICY = "سياسة الاستخدام"

# Prayers (key -> name); key 2 is Duha/sunrise and has no azan
PRAYERS = {"1": "الفجر", "2": "الضحي", "3": "الظهر", "4": "العصر",
           "5": "المغرب", "6": "العشاء"}
SHARE_APP_POPUP = "صدقة جارية"
SHARE_APP_BUTTON = "نشر التطبيق"

# Muezzin pickers
PICKER_TITLE = "إختيار الشيخ المفضل لك"
FAJR_PICKER_TITLE = "اختر شيخ أذان الفجر"
SAVE = "حفظ"
MORE_VOICES = "إضغط هنا"
BUILTIN_SHEIKHS = ["عبدالباسط عبدالصمد", "مشاري بن راشد العفاسي", "الحرم المكي",
                   "مصطفي إسماعيل", "المسجد الأقصي (ناجي قزاز)"]
DEFAULT_SHEIKH = "مشاري بن راشد العفاسي"  # native default (azan_1)
FAJR_DEFAULT_SHEIKH = "مشاري بن راشد العفاسي"

# Settings
SETTINGS = "الاعدادات"
SECTIONS = ["التنبيهات", "حدد البلد", "طريقة حساب الصلاة", "تصحيح مواقيت الصلاة",
            "شيخ الآذان", "شيخ أذان الفجر", "الإعدادات العامة"]
SEC_NOTIFICATIONS, SEC_COUNTRY, SEC_METHOD, SEC_CORRECTION, SEC_SHEIKH, \
    SEC_FAJR_SHEIKH, SEC_GENERAL = SECTIONS
SAVE_SETTINGS = "حفظ الإعدادات"
HANAFI = "الحنفي"
SHAFII = "الشافعي - الحنبلي - المالكي"
VERSION_PREFIX = "الإصدار"
CORRECTION_ROW = "تصحيح {} بالدقائق"

# Quran
QURAN_TITLE = "المصحف الشريف"
QURAN_READ = "قراءة"
QURAN_LISTEN = "استماع"
QURAN_INDEX_TITLE = "قراءة القرءان بالصور"
SURAH_FATIHA = "الفاتحة"
SURAH_BAQARA = "البقرة"
SURAH_NAMES_TITLE = "أسماء السور"

# Azkar
MORNING_AZKAR = "أذكار الصباح"
REPEAT = "التكرار"
LEAVE_AZKAR = "الخروج من الأذكار"
CONTINUE = "متابعه"
EXIT = "خروج"

# More
MORE_TITLE = "المزيد"
MORE_CATEGORIES = ["أدعية", "أدعية سنن", "أحاديث", "أسماء الله الحسنى", "عظماء",
                   "الثقة والاعتزاز بالنفس", "أحاديث قصيرة", "أدعية للميت",
                   "أسماء زوجات الأنبياء", "صلاة الإستخارة", "يوم الجمعة", "التوابين"]
SHOW_MORE = "عرض المزيد"

# Auth (logged out)
LOGIN_FACEBOOK = "تسجيل الدخول بالفيسبوك"
LOGIN_GOOGLE = "تسجيل الدخول بجوجل"
LOGIN_EMAIL = "تسجيل الدخول بالبريد"
CREATE_ACCOUNT = "انشاء حساب جديد بالبريد"
MUST_LOGIN = "يجب عليك تسجيل الدخول"
ERR_EMAIL_REQUIRED = "برجاء تسجيل البريد الالكتروني"
ERR_PASSWORD_REQUIRED = "برجاء تسجيل كلمه المرور"
ERR_EMAIL_INVALID = "الايميل غير صحيح"
ERR_COUNTRY_REQUIRED = "من فضلك إختر دولتك"

# Feed
LIKE = "اعجبني"
SHARE = "مشاركة"
RETRY = "أعد المحاولة"

# Qibla
QIBLA_CALIBRATE = "معايرة البوصلة"

# English / French spot checks
EN_MAIN_SECTIONS = "Main Sections"
EN_PRAYER_TIMINGS = "Prayer Timings"
FR_MAIN_SECTIONS = "Sections principales"

# Logged in
LOGOUT = "تسجيل الخروج"
LOGOUT_QUESTION = "هل انت متأكد انك تريد تسجيل الخروج؟"
YES = "نعم"
PROFILE = "حسابي الشخصي"
COMPETITION_POINTS = "نقاط المسابقات"
CANT_REACH = "لا يمكن الوصول"
START_NOW = "إبدأ الآن"
NEXT_QUESTION = "السؤال التالي"
QUESTIONS_LEFT = r"لديك (\d+) اسئله"
COMPETITION_BOARD = "أوائل المسابقات"
TASBEEH_BOARD = "أوائل التسبيح"
POST = "نشر"
TEST_POST = "Alhamdulillah"   # adb can't type Arabic
