import 'dart:io';

import 'package:file_manager/data/data.dart';
import 'package:file_manager/screens/file_info.dart';
import 'package:flutter/material.dart';

class StorageView extends StatefulWidget {
  String categoryName;
  String path;
  StorageView(this.categoryName, this.path);

  @override
  _StorageViewState createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  Future<List<FileSystemEntity>> getFiles() async {
    List<FileSystemEntity> list = [];
    Directory _dir = Directory(widget.path);
    return _dir.listSync(recursive: false, followLinks: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isFileDisplacing
            ? InkWell(
                onTap: () {
                  isFileDisplacing = false;
                  currentFilePath = '';
                  newFilePath = '';
                  displacingObject = '';
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 18,
                ),
              )
            : null,
        toolbarHeight: 70,
        elevation: 6,
        backgroundColor: Color(0xFF0D3E86),
        title: Text(
          widget.categoryName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getFiles(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: Text('Loading'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          String _fileName =
                              snapshot.data[index].toString().split('/').last;
                          _fileName =
                              _fileName.substring(0, _fileName.length - 1);

                          String _fileEndsWith = _fileName.substring(
                              _fileName.length > 4 ? _fileName.length - 4 : 0,
                              _fileName.length);
                          String _imagePath = '';
                          if (fileFormats.containsKey(_fileEndsWith)) {
                            _imagePath = fileFormats[_fileEndsWith];
                          } else {
                            _imagePath = fileFormats['downloads'];
                          }

                          return _fileName.startsWith('.')
                              ? null
                              : Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (isFileDisplacing) {
                                          newFilePath = snapshot
                                              .data[index].path
                                              .toString();
                                        }
                                        print(snapshot.data[index].path
                                            .toString());
                                        if (!_fileName.contains(
                                            '.', _fileName.length - 4)) {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      StorageView(
                                                          _fileName,
                                                          snapshot
                                                              .data[index].path
                                                              .toString())));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 17,
                                            bottom: 17,
                                            left: 10,
                                            right: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              _imagePath,
                                              height: 28,
                                              width: 28,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                _fileName,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: PopupMenuButton(
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem<int>(
                                                      child:
                                                          const Text('Share'),
                                                      value: 2,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child:
                                                          const Text('Delete'),
                                                      value: 3,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child: const Text(
                                                          'Open with   '),
                                                      value: 4,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child:
                                                          const Text('Move to'),
                                                      value: 5,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child:
                                                          const Text('Copy to'),
                                                      value: 6,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child:
                                                          const Text('Rename'),
                                                      value: 7,
                                                    ),
                                                    PopupMenuItem<int>(
                                                      child: const Text(
                                                          'File info'),
                                                      value: 8,
                                                    ),
                                                  ],
                                                  onSelected: (value) {
                                                    if (value == 3) {
                                                      deleteFile(
                                                          snapshot
                                                              .data[index].path,
                                                          1);
                                                    } else if (value == 5) {
                                                      buttonText = 'Move to';
                                                      isFileDisplacing = true;
                                                      currentFilePath = snapshot
                                                          .data[index].path
                                                          .toString();
                                                      displacingObject =
                                                          _fileName;
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StorageView(
                                                                      'Internal Storage',
                                                                      'storage/emulated/0')));
                                                    } else if (value == 6) {
                                                      buttonText = 'Copy to';
                                                      currentFilePath = snapshot
                                                          .data[index].path
                                                          .toString();
                                                      isFileDisplacing = true;
                                                      displacingObject =
                                                          _fileName;
                                                      StorageView(
                                                          'Internal Storage',
                                                          'storage/emulated/0');
                                                    } else if (value == 8) {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FileInfo(
                                                                  _imagePath,
                                                                  snapshot.data[
                                                                      index]),
                                                        ),
                                                      );
                                                    } else if (value == 7) {
                                                      renameFile(
                                                          snapshot
                                                              .data[index].path
                                                              .toString(),
                                                          _fileName);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
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
                                        color: Colors.black12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                );
                        },
                      );
                    }
                  },
                ),
              ),
              isFileDisplacing
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          moveFile().then((value) {
                            isFileDisplacing = false;
                            currentFilePath = '';
                            newFilePath = '';
                            displacingObject = '';
                            if (mounted) {
                              setState(() {});
                            }
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StorageView(
                                        'Internal Storage',
                                        'storage/emulated/0')),
                                (route) => false);
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 10,
                          decoration: BoxDecoration(
                            color: Color(0xFF0D3E86),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(''),
            ],
          )),
    );
  }

  Future<void> moveFile() async {
    if (currentFilePath.contains('.')) {
      File file = new File(currentFilePath);
      if (buttonText == 'Move to') {
        await file.rename(newFilePath + "/" + displacingObject);
      } else {
        await file.copy(newFilePath + "/" + displacingObject);
      }
    } else {
      Directory dir = new Directory(currentFilePath);
      if (buttonText == 'Move to') {
        await dir.rename(newFilePath + "/" + displacingObject);
      }
    }
  }

  void deleteFile(String filePath, int noOfItems) {
    File file = File(filePath);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Delete $noOfItems  file ?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'This is permanent action and cannot be undone.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton.icon(
                            color: Colors.black12,
                            textColor: Color(0xFF0D3E86),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            label: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: FlatButton.icon(
                          color: Color(0xFF0D3E86),
                          textColor: Colors.white,
                          onPressed: () {
                            file.deleteSync(recursive: true);
                            if (mounted) {
                              setState(() {});
                            }
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 10,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void renameFile(String filePath, String fileName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          final _formKey = GlobalKey<FormState>();
          String newName = fileName;
          return AlertDialog(
            content: Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    'Rename',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: fileName,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Rename file',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FlatButton.icon(
                                  color: Colors.black12,
                                  textColor: Color(0xFF0D3E86),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    size: 10,
                                  ),
                                  label: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: FlatButton.icon(
                                color: Color(0xFF0D3E86),
                                textColor: Colors.white,
                                onPressed: () {
                                  if (newName.isNotEmpty) {
                                    if (filePath.contains('.')) {
                                      File file = File(filePath);
                                      file.renameSync(filePath
                                          .toString()
                                          .replaceAll(fileName, newName));
                                    } else {
                                      Directory dir = Directory(filePath);
                                      dir.renameSync(filePath
                                          .toString()
                                          .replaceAll(fileName, newName));
                                    }

                                    if (mounted) {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.drive_file_rename_outline,
                                  size: 10,
                                ),
                                label: Text(
                                  'Rename',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
