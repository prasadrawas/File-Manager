import 'dart:io';

import 'package:file_manager/data/data.dart';
import 'package:file_manager/screens/category_viewer.dart';
import 'package:file_manager/screens/storage_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  static List<FileSystemEntity> category = [];
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<StorageInfo> _storageInfo = [];

  @override
  initState() {
    super.initState();
    requestStoragePermission().then((value) {
      initPlatformState();
    });
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (status.isUndetermined) {
        await Permission.storage.request();
      }
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if (status.isDenied) {
        await Permission.storage.request();
      }
    }
  }

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}
    if (mounted) {
      setState(() {
        _storageInfo = storageInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(0xFF0D3E86),
          title: Row(
            children: [
              Image.asset(
                'assets/icons/app_logo.png',
                height: 44,
                width: 44,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'File Manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                ),
              ),
            ],
          )),
      body: Container(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15),
                child: Text(
                  'STORAGE DEVICES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StorageView(
                          'Internal Storage', '/storage/emulated/0')));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/internal_storage.png',
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Internal Storage',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            (_storageInfo.length > 0)
                                ? _storageInfo[0].availableGB.toString() +
                                    ".0 GB free"
                                : "unavailable",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.0),
                child: Divider(
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              InkWell(
                onTap: _storageInfo.length != 2
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StorageView(
                                'Internal Storage', _storageInfo[1].rootDir)));
                      },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        (_storageInfo.length != 2)
                            ? 'assets/icons/external_storage_disabled.png'
                            : 'assets/icons/external_storage.png',
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'External Storage',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: (_storageInfo.length != 2)
                                  ? Colors.black38
                                  : Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            (_storageInfo.length == 2)
                                ? _storageInfo[1].availableGB.toString() +
                                    ".0 GB free"
                                : "unavailable",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'CATEGORIES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CategoryView(
                                categoryItems[index].categoryName,
                                categoryItems[index].imagePath)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    categoryItems[index].imagePath,
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    categoryItems[index].categoryName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 50.0),
                              child: Divider(
                                height: 1,
                                color: Colors.black12,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
