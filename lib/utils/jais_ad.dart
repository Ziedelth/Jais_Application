import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class JaisAd {
  static RewardedAd? _rewardedAd;

  static void createVideo() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-5658764393995798/3650456466',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) => _rewardedAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _rewardedAd = null,
      ),
    );
  }

  static void showVideo() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        createVideo();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        createVideo();
      },
    );

    _rewardedAd?.setImmersiveMode(true);

    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      // TODO: Reward
      debugPrint('REWARD AD');
    });

    _rewardedAd = null;
  }
}
