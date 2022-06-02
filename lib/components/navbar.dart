import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/custom_gesture_detector.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/mappers/display_mapper.dart';
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/views/animes_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Navbar extends StatelessWidget {
  final DisplayMapper _displayMapper = DisplayMapper();
  final NavbarMapper navbarMapper;
  final Function(int)? onPageChanged;
  final GlobalKey<AnimesViewState>? animesKey;

  Navbar(
      {required this.navbarMapper,
      this.onPageChanged,
      this.animesKey,
      super.key}) {
    if (_displayMapper.isOnApp) createGlobalBanner();
  }

  @override
  Widget build(BuildContext context) {
    final isOnWebAndMobile =
        _displayMapper.isOnWeb && !_displayMapper.isOnMobile(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CustomGestureDetector(
            duration: const Duration(seconds: 5),
            onLongPress: () async {
              final packageInfo = await PackageInfo.fromPlatform();

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('À propos'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Version ${packageInfo.version}'),
                      Text('© 2021-${DateTime.now().year} Jaïs'),
                      const Text('Powered by Ziedelth.fr'),
                    ],
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundBorderWidget(
                  widget: Image.asset('assets/icon.jpg'),
                ),
                const SizedBox(width: 10),
                Text(
                  'Jaïs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (_displayMapper.isOnApp)
            Expanded(
              child: globalBannerAd != null
                  ? AdWidget(ad: globalBannerAd!)
                  : Container(color: Theme.of(context).backgroundColor),
            ),
          if (isOnWebAndMobile) ...[
            const Spacer(),
            ...navbarMapper.itemsTopNavBar(onPageChanged),
            const Spacer()
          ],
          const SizedBox(width: 10),
          if (navbarMapper.currentPage == 2) ...[
            if (_displayMapper.isOnWeb) const Spacer(),
            IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.search),
              onPressed: () {
                animesKey?.currentState?.showSearch();
              },
            ),
          ],
        ],
      ),
    );
  }
}
