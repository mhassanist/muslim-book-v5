import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdmobInterstitial {
  final String adUnitId =
      AdManager.getInterstitialAdUnitId(BannerName.INTERSTITIAL);
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  late InterstitialAd? _interstitialAd;
  void createInterstitialAd() {
    const AdRequest request = AdRequest(
      keywords: <String>['foo', 'bar'],
      contentUrl: 'http://foo.com/bar.html',
      nonPersonalizedAds: true,
    );
    InterstitialAd.load(
        // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        adUnitId: adUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
