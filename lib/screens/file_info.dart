import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class FileInfo extends StatelessWidget {
  FileSystemEntity entity;
  String imagePath;
  FileInfo(this.imagePath, this.entity);

  String directorySize(String path) {
    int totalSize = 0;
    if (path.split('/').last.contains('.')) {
      File file = File(path);
      totalSize = file.lengthSync();
    } else {
      int fileNum = 0;
      var dir = Directory(path);
      try {
        if (dir.existsSync()) {
          dir
              .listSync(recursive: true, followLinks: false)
              .forEach((FileSystemEntity entity) {
            if (entity is File) {
              fileNum++;
              totalSize += entity.lengthSync();
            }
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return filesize(totalSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(8),
                height: 170,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      entity.path.split('/').last,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.black38,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.file_copy,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              entity.path,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.line_weight,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              directorySize(entity.path),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.add_chart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Last modified : ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
