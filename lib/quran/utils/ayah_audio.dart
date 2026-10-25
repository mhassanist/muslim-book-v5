import 'package:audioplayers/audioplayers.dart';

/// Verse-by-verse recitations, served by cdn.islamic.network.
///
/// The old cdn.alquran.cloud host no longer resolves. The new CDN puts the
/// bitrate in the path and each reciter is only published in some bitrates
/// (e.g. ar.husary: 128/64, ar.abdulsamad: 64 only), so [play] falls back
/// through them and remembers the one that worked.
class AyahAudio {
  static const _host = "https://cdn.islamic.network/quran/audio";
  static const _bitrates = [128, 64, 192, 48, 32];
  static final Map<String, int> _bitrateFor = {};

  static String url(String sheikhId, int? ayahNumber, [int? bitrate]) =>
      "$_host/${bitrate ?? _bitrateFor[sheikhId] ?? _bitrates.first}"
      "/$sheikhId/$ayahNumber.mp3";

  static Future<void> play(
      AudioPlayer player, String sheikhId, int? ayahNumber) async {
    final known = _bitrateFor[sheikhId];
    final order = [
      if (known != null) known,
      ..._bitrates.where((b) => b != known),
    ];
    for (final bitrate in order) {
      try {
        await player.play(UrlSource(url(sheikhId, ayahNumber, bitrate)));
        _bitrateFor[sheikhId] = bitrate;
        return;
      } catch (_) {
        if (bitrate == order.last) rethrow;
      }
    }
  }
}
