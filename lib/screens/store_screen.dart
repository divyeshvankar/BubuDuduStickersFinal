import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/Drawer.dart';
import '../widgets/banner_ad_widget.dart';

final Uri _url1 = Uri.parse('https://www.duduphudu.store/');
final Uri _url2 = Uri.parse('https://duduphudueurope.store/');
final Uri _url3 = Uri.parse('https://duduphudu.blinkstore.in/shop');
final Uri _url4 = Uri.parse('https://www.instagram.com/dudu_phudu/');

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Our Store",
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
              onPressed: _launchUrl3,
              icon: Image.asset('assets/images/flag.png',
                  width: 40, // Adjust icon width
                  height: 40), // Replace with your icon asset
              label: 'Indian Store',
            ),
            CustomIconButton(
              onPressed: _launchUrl1,
              icon: Image.asset('assets/images/earth.png',
                  width: 40, // Adjust icon width
                  height: 40), // Replace with your icon asset
              label: 'World Wide Store',
            ),
            CustomIconButton(
              onPressed: _launchUrl2,
              icon: Image.asset('assets/images/european-union.png',
                width: 40, // Adjust icon width
                height: 40), // Adjust icon height), // Replace with your icon asset
              label: 'Europe/Asia Store',
            ),

            CustomIconButton(
              onPressed: _launchUrl4,
              icon: Image.asset('assets/images/product-management_icon.png',
                  width: 40, // Adjust icon width
                  height: 40), // Replace with your icon asset
              label: 'Custom Product Inquiry',
            ),
          ],
        ),
      ),
    );
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

Future<void> _launchUrl1() async {
  if (!await canLaunch(_url1.toString())) {
    throw 'Could not launch $_url1';
  }
  await launch(_url1.toString());
}

Future<void> _launchUrl2() async {
  if (!await canLaunch(_url2.toString())) {
    throw 'Could not launch $_url2';
  }
  await launch(_url2.toString());
}

Future<void> _launchUrl3() async {
  if (!await canLaunch(_url3.toString())) {
    throw 'Could not launch $_url3';
  }
  await launch(_url3.toString());
}

Future<void> _launchUrl4() async {
  if (!await canLaunch(_url4.toString())) {
    throw 'Could not launch $_url4';
  }
  await launch(_url4.toString());
}
