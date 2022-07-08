import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/utils/utils.dart';

class Navbar extends StatelessWidget {
  final NavbarMapper navbarMapper;
  final Function(int)? onPageChanged;

  Navbar({
    required this.navbarMapper,
    this.onPageChanged,
    super.key,
  }) {
    createGlobalBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          RoundBorderWidget(
            widget: Image.asset('assets/icon.png'),
          ),
          const SizedBox(width: 10),
          Text(
            'Jaïs',
            style: GoogleFonts.pacifico(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: globalBannerAd != null
                ? AdWidget(ad: globalBannerAd!)
                : Container(color: Theme.of(context).backgroundColor),
          ),
          const SizedBox(width: 10),
          if (navbarMapper.currentPage == 1) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, "/search"),
            ),
          ],
        ],
      ),
    );
  }
}
