import 'package:google_mobile_ads/google_mobile_ads.dart';

BannerAd? globalBannerAd;

void createGlobalBanner() {
  globalBannerAd = BannerAd(
    adUnitId: 'ca-app-pub-5658764393995798/7021730383',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      },
    ),
  );

  globalBannerAd?.load();
}

BannerAd? searchBannerAd;

void createSearchBanner() {
  searchBannerAd = BannerAd(
    adUnitId: 'ca-app-pub-5658764393995798/3944268183',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      },
    ),
  );

  searchBannerAd?.load();
}
