import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd bannerAd;
  bool isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load the ad initially
    loadBannerAd();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Replace with your ad unit ID
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isBannerLoaded = false;
          });
          print('Ad failed to load: $error');
        },
      ),
      request: AdRequest(),
    );
    await bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerLoaded
        ? SizedBox(
      height: 80, // Adjust height as needed
      child: AdWidget(ad: bannerAd),
    )
        : Container(); // Return an empty container if ad is not loaded
  }
}
