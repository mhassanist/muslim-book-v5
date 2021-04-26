import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/ramadan/models/ramadan_cannon_model.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageManager {
  static final LocalStorage storage = new LocalStorage('azan_sounds');

  saveRamadanCannonModelList(List<RamadanSoundsModel> sounds) async {
    await storage.ready;
    storage.setItem('ramadan_cannonModel_sounds', RamadanSoundsModel().toJSON(sounds));
  }
  saveRamadanMashraatModelList(List<RamadanSoundsModel> sounds) async {
    await storage.ready;
     storage.setItem('ramadan_mashraat_sounds_list', RamadanSoundsModel().toJSON(sounds));
    var data =storage.getItem('ramadan_mashraat_sounds_list');


  }

  saveAzanSoundsList(List<AzanSound> sounds) async {
    await storage.ready;
    storage.setItem('azan_sounds', AzanSoundsList().toJSON(sounds));
  }

  Future<List<AzanSound>> loadAzanSoundsList() async {
    await storage.ready;
    if (storage.getItem('azan_sounds') == null)
      return null;

    List<AzanSound> soundList = await AzanSoundsList().fromJson(storage.getItem('azan_sounds'));

    return soundList.where((element) => element.fajr==0).toList();
  }


  Future<List<RamadanSoundsModel>> loadRamadanCannonModel() async {
    await storage.ready;
    if (storage.getItem('ramadan_cannonModel_sounds') == null)
      return null;
    List<RamadanSoundsModel> soundList=List<RamadanSoundsModel>.from(storage.getItem('ramadan_cannonModel_sounds').map((x) => RamadanSoundsModel.fromJson(x)));
    return soundList ;

    // return soundList.where((element) => element.fajr==0).toList();
  }

  Future<List<RamadanSoundsModel>> loadRamadanMashraatModel() async {
    await storage.ready;
    if (storage.getItem('ramadan_mashraat_sounds_list') == null)
      return null;
    List<RamadanSoundsModel> soundList=List<RamadanSoundsModel>.from(storage.getItem('ramadan_mashraat_sounds_list').map((x) => RamadanSoundsModel.fromJson(x)));



    return soundList ;

    // return soundList.where((element) => element.fajr==0).toList();
  }

  Future<List<AzanSound>> loadFajrAzanSoundsList() async {
    await storage.ready;
    if (storage.getItem('azan_sounds') == null)
      return null;

    List<AzanSound> soundList = await AzanSoundsList().fromJson(storage.getItem('azan_sounds'));

    return soundList.where((element) => element.fajr==1).toList();
  }

  void updateAzanSoundsList(AzanSound azanSound) async{
    await storage.ready;
    if (storage.getItem('azan_sounds') == null)
      return null;

    List<AzanSound> soundList = await AzanSoundsList().fromJson(storage.getItem('azan_sounds'));
    for(int i=0; i< soundList.length; i++){
      if(soundList[i].id == azanSound.id){
        soundList[i].fajr = azanSound.fajr;
        soundList[i].name = azanSound.name;
        soundList[i].localPath = azanSound.localPath;
        soundList[i].fileUrl = azanSound.fileUrl;
        break;
      }
    }
    saveAzanSoundsList(soundList);
  }
  void updateRamadanCannonList(RamadanSoundsModel ramadanCannonSound) async{
    await storage.ready;
    if (storage.getItem('ramadan_cannonModel_sounds') == null)
      return null;

    List<RamadanSoundsModel> soundList=List<RamadanSoundsModel>.from(storage.getItem('ramadan_cannonModel_sounds').map((x) => RamadanSoundsModel.fromJson(x)));
    for(int i=0; i< soundList.length; i++){
      if(soundList[i].id == ramadanCannonSound.id){
        soundList[i].name = ramadanCannonSound.name;
        soundList[i].localPath = ramadanCannonSound.localPath;
        soundList[i].file = ramadanCannonSound.file;
        break;
      }
    }
    saveRamadanCannonModelList(soundList);
  }
  void updateRamadanMashraatList(RamadanSoundsModel ramadanCannonSound) async{
    await storage.ready;
    if (storage.getItem('ramadan_mashraat_sounds_list') == null)
      return null;

    List<RamadanSoundsModel> soundList=List<RamadanSoundsModel>.from(storage.getItem('ramadan_mashraat_sounds_list').map((x) => RamadanSoundsModel.fromJson(x)));
    for(int i=0; i< soundList.length; i++){
      if(soundList[i].id == ramadanCannonSound.id){
        soundList[i].name = ramadanCannonSound.name;
        soundList[i].localPath = ramadanCannonSound.localPath;
        soundList[i].file = ramadanCannonSound.file;
        break;
      }
    }
    saveRamadanMashraatModelList(soundList);
  }
}
