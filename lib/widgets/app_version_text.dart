import 'package:flutter/material.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// "Version 4.7.0 (5001)", read from the installed build. If the lookup fails
/// for any reason it renders nothing, so it can't break the screen it is on.
class AppVersionText extends StatefulWidget {
  const AppVersionText({super.key});

  @override
  State<AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  late final Future<String?> _version = _loadVersion();

  static Future<String?> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (info.version.isEmpty) return null;
      return info.buildNumber.isEmpty
          ? info.version
          : '${info.version} (${info.buildNumber})';
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _version,
      builder: (context, snapshot) {
        final version = snapshot.data;
        if (version == null) return const SizedBox.shrink();
        final label =
            AppLocalizations.of(context)?.translate("app_version") ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            '${label.isEmpty ? 'Version' : label} $version',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        );
      },
    );
  }
}
