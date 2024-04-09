import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/Drawer.dart';
import '../constants/constants.dart';
import '../models/sticker_data.dart';
import 'package:dio/dio.dart';
import '../widgets/sticker_pack_item.dart';
import '../widgets/banner_ad_widget.dart';

class StickersScreen extends StatefulWidget {
  static const routeName = '/';

  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {

  bool _isLoading = false;

  late StickerData stickerData;

  List stickerPacks = [];
  List installedStickerPacks = [];
  late String stickerFetchType;
  late Dio dio;
  var downloads = <Future>[];
  var data;

  void _loadStickers() async {
    if (stickerFetchType == 'staticStickers') {
      data = await rootBundle.loadString("sticker_packs/sticker_packs.json");
    } else {
      dio = Dio();
      data = await dio.get("${BASE_URL}contents.json");
    }
    setState(() {
      stickerData = StickerData.fromJson(jsonDecode(data.toString()));
      _isLoading = false;
    });
  }

  @override
  didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments as String?;
    stickerFetchType = args ?? "staticStickers";
    setState(() {
      _isLoading = true;
    });
    _loadStickers();
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bubu Dudu Stickers",
          style: TextStyle(fontWeight: FontWeight.bold ,color:Colors.black ),
        ),
        // backgroundColor: Colors.white,
        //   Color.fromRGBO(38, 38, 38, 0.4)
        // backgroundColor: Color(0xFF8A80),
        //   (255,138,128)
        // Customize app bar background color
        // Customize app bar background color
      ),


      // bottomNavigationBar: BannerAdWidget(),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 4, // Increase stroke width for better visibility
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Match app color
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the list
        child: ListView.builder(
          itemCount: stickerData.stickerPacks!.length,
          itemBuilder: (context, index) {
            return StickerPackItem(
              stickerPack: stickerData.stickerPacks![index],
              stickerFetchType: stickerFetchType,
            );
          },
        ),
      ),
    );
  }
}