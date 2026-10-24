import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/admob_interstitial.dart';

/// Gathers ad consent (UMP) and starts the Mobile Ads SDK only once ads may be
/// requested. Every ad load waits on [canRequestAds].
///
/// Google requires a certified CMP for users in the EEA, UK and Switzerland:
/// https://developers.google.com/admob/flutter/privacy/gdpr
class AdsService {
  AdsService._();

  static final Completer<bool> _canRequestAds = Completer<bool>();
  static bool _started = false;

  /// Completes with whether ads may be requested in this session.
  static Future<bool> get canRequestAds => _canRequestAds.future;

  /// Runs the consent flow, then initializes the SDK. Call once the first frame
  /// is on screen, since the consent form needs an activity to show in.
  static void initialize() {
    if (_started) return;
    _started = true;

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            debugPrint('Consent form error: ${error.message}');
          }
          _startAdsIfAllowed();
        });
      },
      (FormError error) {
        // canRequestAds() still reflects the consent from a previous session
        debugPrint('Consent info update error: ${error.message}');
        _startAdsIfAllowed();
      },
    );
  }

  static Future<void> _startAdsIfAllowed() async {
    if (_canRequestAds.isCompleted) return;
    final allowed = await ConsentInformation.instance.canRequestAds();
    if (allowed) {
      // Restrict ads to content suitable for general audiences
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(maxAdContentRating: MaxAdContentRating.g),
      );
      await MobileAds.instance.initialize();
    }
    _canRequestAds.complete(allowed);
    if (allowed) {
      AdmobInterstitial.instance.preload();
    }
  }

  /// Whether the user must be offered a way to change their consent choices.
  static Future<bool> isPrivacyOptionsRequired() async {
    // Only meaningful once the consent flow has run
    await canRequestAds;
    return await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  static void showPrivacyOptionsForm() {
    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) {
        debugPrint('Privacy options form error: ${error.message}');
      }
    });
  }
}
