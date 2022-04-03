import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

RewardedAd? _rewardedAd;

void createVideo() {
  RewardedAd.load(
    adUnitId: 'ca-app-pub-5658764393995798/3650456466',
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) => _rewardedAd = ad,
      onAdFailedToLoad: (LoadAdError error) => _rewardedAd = null,
    ),
  );
}

void showVideo() {
  if (_rewardedAd == null) {
    debugPrint('Warning: attempt to show rewarded before loaded.');
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
      debugPrint('REWARD AD');
    },
  );

  _rewardedAd = null;
}
