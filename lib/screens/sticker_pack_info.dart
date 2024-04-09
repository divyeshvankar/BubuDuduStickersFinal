import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Widgets/Drawer.dart';
import '../Widgets/banner_ad_widget.dart';
import '../constants/constants.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../models/sticker_data.dart';

class StickerPackInfoScreen extends StatefulWidget {
  static const String routeName = '/sticker_pack_info';
  const StickerPackInfoScreen({Key? key}) : super(key: key);

  @override
  State<StickerPackInfoScreen> createState() => _StickerPackInfoScreenState();
}

class _StickerPackInfoScreenState extends State<StickerPackInfoScreen> {
  Future<void> addStickerPack() async {
    try {
      // Initialize Dio for network requests
      final dio = Dio();

      // Get sticker pack details
      final arguments = ModalRoute.of(context)?.settings.arguments as Map;
      final StickerPacks stickerPack = arguments['stickerPack'] as StickerPacks;
      final String stickerFetchType = arguments['stickerFetchType'] as String;

      // Prepare stickers data
      final Map<String, List<String>> stickers = {};
      String tryImage = '';

      // Prepare stickers based on fetch type
      if (stickerFetchType == 'staticStickers') {
        for (var e in stickerPack.stickers!) {
          stickers[WhatsappStickerImageHandler.fromAsset(
              "sticker_packs/${stickerPack.identifier}/${e.imageFile as String}")
              .path] = e.emojis as List<String>;
        }
        tryImage = WhatsappStickerImageHandler.fromAsset(
            "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}")
            .path;
      } else {
        final downloads = <Future>[];
        var applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
        var stickersDirectory =
        await Directory.systemTemp.createTemp('${stickerPack.identifier}');
        await stickersDirectory.create(recursive: true);

        downloads.add(
          dio.download(
            "${BASE_URL}${stickerPack.identifier}/${stickerPack.trayImageFile!.toLowerCase()}",
            "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}",
          ),
        );
        tryImage = WhatsappStickerImageHandler.fromFile(
            "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}")
            .path;

        for (var e in stickerPack.stickers!) {
          var urlPath =
              "${BASE_URL}${stickerPack.identifier}/${(e.imageFile as String)}";
          var savePath =
              "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}";
          downloads.add(
            dio.download(
              urlPath,
              savePath,
            ),
          );

          stickers[WhatsappStickerImageHandler.fromFile(
              "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}")
              .path] = e.emojis as List<String>;
        }

        await Future.wait(downloads);
      }
// Call WhatsApp Stickers Handler to add the sticker pack
      final WhatsappStickersHandler _whatsappStickersHandler =
      WhatsappStickersHandler();
      var result = await _whatsappStickersHandler.addStickerPack(
        stickerPack.identifier,
        stickerPack.name as String,
        stickerPack.publisher as String,
        tryImage,
        stickerPack.publisherWebsite,
        stickerPack.privacyPolicyWebsite,
        stickerPack.licenseAgreementWebsite,
        stickerPack.animatedStickerPack ?? false,
        stickers,
      );
      print("RESULT $result");
    } on WhatsappStickersException catch (e) {
      print("INSIDE WhatsappStickersException ${e.cause}");
      var exceptionMessage = e.cause;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exceptionMessage.toString())),
      );
    } catch (e) {
      print("Exception ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while adding sticker pack")),
      );
    }
  }


      @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    final StickerPacks stickerPack = arguments['stickerPack'] as StickerPacks;
    final String stickerFetchType = arguments['stickerFetchType'] as String;

    List<Widget> fakeBottomButtons = [];
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );
    Widget depInstallWidget;
    if (stickerPack.isInstalled) {
      depInstallWidget = const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Sticker Added",
          style: TextStyle(
              color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      depInstallWidget = ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (stickerPack.isInstalled) {
              return Colors.grey; // Change to gray if stickers are already added
            } else {
              return Colors.green; // Keep green if stickers are not added
            }
          }),
        ),
        child: Text(
          stickerPack.isInstalled ? "Sticker Added" : "Add Sticker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          Map<String, List<String>> stickers = <String, List<String>>{};
          var tryImage = '';
          if (stickerFetchType == 'staticStickers') {
            for (var e in stickerPack.stickers!) {
              stickers[WhatsappStickerImageHandler.fromAsset(
                  "sticker_packs/${stickerPack.identifier}/${e.imageFile as String}")
                  .path] = e.emojis as List<String>;
            }
            tryImage = WhatsappStickerImageHandler.fromAsset(
                "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}")
                .path;
          } else {
            final dio = Dio();
            final downloads = <Future>[];
            var applicationDocumentsDirectory =
            await getApplicationDocumentsDirectory();
            var stickersDirectory = await Directory.systemTemp.createTemp('${stickerPack.identifier}');
            await stickersDirectory.create(recursive: true);

            downloads.add(
              dio.download(
                "${BASE_URL}${stickerPack.identifier}/${stickerPack.trayImageFile}",
                "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}",
              ),
            );
            tryImage = WhatsappStickerImageHandler.fromFile(
                "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}")
                .path;

            for (var e in stickerPack.stickers!) {
              var urlPath =
                  "${BASE_URL}${stickerPack.identifier}/${(e.imageFile as String)}";
              var savePath =
                  "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}";
              downloads.add(
                dio.download(
                  urlPath,
                  savePath,
                ),
              );

              stickers[WhatsappStickerImageHandler.fromFile(
                  "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}")
                  .path] = e.emojis as List<String>;
            }

            await Future.wait(downloads);
          }

          try {
            final WhatsappStickersHandler _whatsappStickersHandler =
            WhatsappStickersHandler();
            var result = await _whatsappStickersHandler.addStickerPack(
              stickerPack.identifier,
              stickerPack.name as String,
              stickerPack.publisher as String,
              tryImage,
              stickerPack.publisherWebsite,
              stickerPack.privacyPolicyWebsite,
              stickerPack.licenseAgreementWebsite,
              stickerPack.animatedStickerPack ?? false,
              stickers,
            );
            print("RESULT $result");
          } on WhatsappStickersException catch (e) {
            print("INSIDE WhatsappStickersException ${e.cause}");
            var exceptionMessage = e.cause;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(exceptionMessage.toString())
                ));
          } catch (e) {
            print("Exception ${e.toString()}");
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          stickerPack.name.toString() ,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: MyDrawer(),
      ),
      // bottomNavigationBar: BannerAdWidget(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "All Stickers",
                  style: const TextStyle(
                    fontSize: 20.0,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: stickerFetchType == "remoteStickers"
                    ? FadeInImage(
                  placeholder:
                  const AssetImage("assets/images/loading.gif"),
                  image: NetworkImage(
                      "${BASE_URL}/${stickerPack.identifier}/${stickerPack.trayImageFile}"),
                  height: 100,
                  width: 100,
                )
                    : Image.asset(
                  "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}",
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stickerPack.name as String,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      stickerPack.publisher as String,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    depInstallWidget,
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView( // Wrapping only the stickers with SingleChildScrollView
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: stickerPack.stickers!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: stickerFetchType == "remoteStickers"
                        ? FadeInImage(
                      placeholder:
                      const AssetImage("assets/images/loading.gif"),
                      image: NetworkImage(
                          "${BASE_URL}${stickerPack.identifier}/${stickerPack.stickers![index].imageFile as String}"),
                    )
                        : Image.asset(
                        "sticker_packs/${stickerPack.identifier}/${stickerPack.stickers![index].imageFile as String}"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // persistentFooterButtons: fakeBottomButtons,
    );
  }
}
