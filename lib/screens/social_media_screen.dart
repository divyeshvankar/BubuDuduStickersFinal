import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/Drawer.dart';
import '../widgets/banner_ad_widget.dart';

final Uri _url1 = Uri.parse('https://www.instagram.com/dudu_phudu/');
final Uri _url2 = Uri.parse('https://www.facebook.com/profile.php?id=100095227631542&mibextid=ZbWKwL');
final Uri _url3 = Uri.parse('https://whatsapp.com/channel/0029VaUL1a82UPBCV7Stct0G');
final Uri _url4 = Uri.parse('https://youtube.com/@Dudu_Phudu_Official');

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({Key? key}) : super(key: key);

  static const routeName = '/social_media';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Social Media",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // backgroundColor: Colors.white,
      // bottomNavigationBar: BannerAdWidget(),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconButton(
              onPressed: _launchUrl4,
              icon: Image.asset(
                'assets/images/youtube_icon.png', // Replace with your icon asset
                width: 40, // Adjust icon width
                height: 40, // Adjust icon height
              ),
              label: 'Youtube',
            ),
            CustomIconButton(
              onPressed: _launchUrl1,
              icon: Image.asset(
                'assets/images/instagram_icon.png', // Replace with your icon asset
                width: 40, // Adjust icon width
                height: 40, // Adjust icon height
              ),
              label: 'Instagram',
            ),
            CustomIconButton(
              onPressed: _launchUrl2,
              icon: Image.asset(
                'assets/images/facebook_icon.png', // Replace with your icon asset
                width: 40, // Adjust icon width
                height: 40, // Adjust icon height
              ),
              label: 'Facebook',
            ),


            CustomIconButton(
              onPressed: _launchUrl3,
              icon: Image.asset(
                'assets/images/whatsapp_icon.png', // Replace with your icon asset
                width: 40, // Adjust icon width
                height: 40, // Adjust icon height
              ),
              label: 'Whatsapp Channel',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl1() async {
    if (!await launch(_url1.toString())) {
      throw 'Could not launch $_url1';
    }
  }

  Future<void> _launchUrl2() async {
    if (!await launch(_url2.toString())) {
      throw 'Could not launch $_url2';
    }
  }

  Future<void> _launchUrl3() async {
    if (!await launch(_url3.toString())) {
      throw 'Could not launch $_url3';
    }
  }

  Future<void> _launchUrl4() async {
    if (!await launch(_url4.toString())) {
      throw 'Could not launch $_url4';
    }
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  const CustomIconButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(fontSize: 18), // Adjust text size as needed
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust button size as needed
        ),
      ),
    );
  }
}
