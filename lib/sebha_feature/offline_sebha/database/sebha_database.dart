import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sebha_database.g.dart';

@DataClassName("Tasbeeh")
class Tsabeeh extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get note => text()();

  IntColumn get totalCounter => integer()();

  IntColumn get counted => integer()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // return VmDatabase(file);
    // return DynamicLibrary.open(file);
    return FlutterQueryExecutor(path: file.path);
  });
}

@UseMoor(tables: [Tsabeeh])
class SebhaDataBase extends _$SebhaDataBase {
  late SharedPreferences prefs;

  SebhaDataBase() : super(_openConnection()) {
    initializeDatabase();
  }

  @override
  int get schemaVersion => 1;

  Stream<List<Tasbeeh>> get watchAllTsabeeh => select(tsabeeh).watch();

  Future<List<Tasbeeh>> get allTsabeeh => select(tsabeeh).get();

  Future<Tasbeeh> getTasbeehById(int id) {
    return (select(tsabeeh)..where((t) => t.id.equals(id))).getSingle();
  }

  Future updateTasbeeh(Tasbeeh zikr) {
    return update(tsabeeh).replace(zikr);
  }

  Future<int> addTasbeeh(TsabeehCompanion entry) {
    return into(tsabeeh).insert(entry);
  }

  Future removeTasbeeh(int id) {
    return (delete(tsabeeh)..where((t) => t.id.equals(id))).go();
  }

  Future removeTsabeeh() {
    return (delete(tsabeeh)).go();
  }

  void initializeDatabase() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("tsabeehDatabaseInitialized") == null ||
        !prefs.getBool("tsabeehDatabaseInitialized")!) {
      List<Map<String, dynamic>> tsabeeh = [
        {
          "name": "سبحان الله",
          "note":
              "عن رسول الله صلّى الله عليه وسلّم: من قال حين يصبحُ وحين يمسي: سبحانَ اللهِ وبحمدِه مئةَ مرةٍ، لم يأتِ أحدٌ يومَ القيامةِ بأفضلِ ممّا جاء به، إلّا أحدٌ قال مثلَ ما قال، أو زاد عليه",
          "total": 33,
        },
        {
          "name": "الحمد لله",
          "note":
              "قال رسول الله صلى الله عليه وسلم: «أفضلُ الذكرِ لا إله إلا اللهُ وأفضلُ الدعاءِ الحمدُ للهِ» الترمذي:3383",
          "total": 33
        },
        {
          "name": "الله أكبر",
          "note":
              "قال النبيُّ صلَّى اللهُ عليه وسلَّم: «أحبُّ الكلامِ إلى اللهِ أربعٌ : سبحانَ اللهِ ، والحمدُ للهِ ، ولا إله إلا اللهُ ، واللهُ أكبرُ . لا يضرُّك بأيِّهنَّ بدأتَ» مسلم:2137",
          "total": 33
        },
        {
          "name": "لا اله الا الله",
          "note":
              "قال رسول الله صلى الله عليه وسلم: «أفضلُ الذكرِ لا إله إلا اللهُ وأفضلُ الدعاءِ الحمدُ للهِ» الترمذي:3383",
          "total": 33
        },
        {
          "name":
              "لا اله الا الله وحدة لا شريك له الملك وله الحمد يحي ويميت وهو علي كل شي قدير",
          "note":
              "قال  صلى الله عليه وسلم: من قال إذا أصبح: لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير كان له عدل رقبة من ولد إسماعيل، وكتب له عشر حسنات وحط عنه عشر سيئات، ورفع له عشر درجات وكان في حرز من الشيطان حتى يمسي، وإن قالها إذا أمسى كان له مثل ذلك حتى يصبح. رواه أبو داود وصححه الألباني.",
          "total": 100
        },
        {
          "name": "سبحان الله وبحمده .. سبحان الله العظيم",
          "note":
              "قال النبي صلى الله عليه وسلم: كلمتان حبيبتان إلى الرحمن، خفيفتان على اللسان، ثقيلتان في الميزان: سبحان الله وبحمده، سبحان الله العظيم.",
          "total": 100,
        },
        {
          "name": "لا حول ولا قوة الا بالله",
          "note":
              "عن أبي ذر قال: قال لي رسول الله صلى الله عليه وسلم ألا أدلك على كنز من كنوز الجنة، قلت بلى يا رسول الله، قال لا حول ولا قوة إلا بالله. رواه أحمد وابن ماجه",
          "total": 100,
        },
        {
          "name": "اللهم صلي وسلم وبارك علي سيدنا محمد",
          "note":
              "قال رسول الله   .. أولى النَّاسِ بي يومَ القيامةِ أَكثرُهم عليَّ صلاةً",
          "total": 100,
        },
        {
          "name": "استغفر الله العظيم",
          "note":
              "فَقُلْتُ اسْتَغْفِرُوا رَبَّكُمْ إِنَّهُ كَانَ غَفَّارًا (10) يُرْسِلِ السَّمَاء عَلَيْكُم مِّدْرَارًا (11) وَيُمْدِدْكُمْ بِأَمْوَالٍ وَبَنِينَ وَيَجْعَل لَّكُمْ جَنَّاتٍ وَيَجْعَل لَّكُمْ أَنْهَارًا ",
          "total": 100,
        },
        {
          "name": "حسبي الله ونعم الوكيل",
          "note": "طلب العون والتوكل علي الله ",
          "total": 100,
        },
        {
          "name": "سبحان والحمد لله والله اكب",
          "note":
              "قال رسول الله صلى الله عليه وآله وسلم ..لأن أقول: سبحان الله والحمد لله ولا إله إلا الله والله أكبر، أحبُّ إليَّ مما طلعت عليه الشمس",
          "total": 100,
        },
      ];
      for (var val in tsabeeh) {
        await addTasbeeh(TsabeehCompanion(
          name: Value(val["name"]),
          note: Value(val["note"]),
          counted: Value(0),
          totalCounter: Value(val["total"]),
        ));
      }
      await prefs.setBool("tsabeehDatabaseInitialized", true);
    }
  }
}
