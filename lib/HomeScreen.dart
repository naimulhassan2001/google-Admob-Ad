import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobAd extends StatefulWidget {
  @override
  _AdmobAdState createState() => _AdmobAdState();
}

class _AdmobAdState extends State<AdmobAd> {
  late BannerAd bannerAd;
  bool isBannerAdReady = false;
  bool isInterstitialAdReady = false;
  late InterstitialAd interstitialAd;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    loadInterstitialAd();
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
            print("isBannerAdReady");
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  void loadInterstitialAd() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            setState(() {
              isInterstitialAdReady = true;
              print("InterstitialAdReady");
            });
          },
          onAdFailedToLoad: (error) {
            print("InterstitialAdError");
            interstitialAd.dispose();

            isInterstitialAdReady = false;
          },
        ));
  }

  @override
  void dispose() {
    bannerAd.dispose();
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Ad Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Your app content goes here

            SizedBox(height: (Get.height *0.4),),

            ElevatedButton(
                onPressed: () {
                  interstitialAd.show();
                },
                child: const Text("show Interstitial")),
            Spacer(),
            isBannerAdReady
                ? Container(
                    height: AdSize.banner.height.toDouble(),
                    width: AdSize.banner.width.toDouble(),
                    child: AdWidget(ad: bannerAd))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
