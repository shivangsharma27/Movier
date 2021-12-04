import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/global.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NewMovie extends StatefulWidget {
  final Function addTx;

  NewMovie(this.addTx);

  @override
  _NewMovieState createState() => _NewMovieState();
}

class _NewMovieState extends State<NewMovie> {
  final _movieNameController = TextEditingController();
  final _directorNameController = TextEditingController();
  String pickedFilePath;
  String fileStatus = "No File Uploaded";
  bool retry = false;
  double rating = 5.0;

  void _submitData() {
    // if (_amountController.text.isEmpty) {
    //   globals.showSnackBar('One or more fields are empty !',context);
    //   return;
    // }
    final enteredTitle = _movieNameController.text;
    final enteredDirector = _directorNameController.text;

    if (enteredTitle.isEmpty || enteredDirector.isEmpty || pickedFilePath == null) {
      globals.showSnackBar('One or more fields are empty !', context);
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredDirector,
      pickedFilePath,
      rating,
    );

    Navigator.of(context).pop();
  }

  uploadFile() async {
    if (await Permission.storage.request().isGranted) {
      final FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['png', 'jpeg', 'jpg']);
      pickedFilePath = pickedFile.paths.last;
      //TODO Complete Upload Function
      setState(() {
        // File _imageFile = pickedFile.files.last;
        retry = false;
        fileStatus = "Image Uploaded";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/images/Movier.png',
            width: 140,
            height: 45,
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset:
                                  Offset(1, 7), // changes position of shadow
                            )
                          ]),
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextField(
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Movie name',
                        ),
                        controller: _movieNameController,
                        onSubmitted: (_) => _submitData(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset:
                                  Offset(1, 7), // changes position of shadow
                            )
                          ]),
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextField(
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(hintText: 'Director name'),
                        controller: _directorNameController,
                        onSubmitted: (_) => _submitData(),
                        // onChanged: (val) => amountInput = val,
                      ),
                    ),

                    // SizedBox(height: 15),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 43, bottom: 10),
                      child: Text(
                        "Upload Movie Poster",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),

                    //Upload Button & File Name Text Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            uploadFile();
                          },
                          child: Text(
                            "Choose a File",
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              fileStatus + "  ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Visibility(
                              visible: fileStatus == "Image Uploaded",
                              child: Image.asset(
                                'assets/images/checked.png',
                                height: 20,
                                width: 20,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Rating : " + rating.toString(),
                      style: TextStyle(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        inactiveTrackColor: Colors.grey[200],
                        activeTrackColor: Color(0xffCAAF68),
                        thumbColor: Color(0xffAF8B4A),
                        // ? Colors.purple[900]
                        // : Colors.pink[400],
                        overlayColor: Color(0x33ffe0b2),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 30.0),
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: Slider(
                        value: rating,
                        min: 1,
                        max: 5,
                        onChanged: (double newValue) {
                          setState(() {
                            rating = (newValue * 10).truncateToDouble() / 10;
                          });
                        },
                      ),
                    ),

                    ElevatedButton(
                      child: Text(
                        'Add Movie',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.button.color,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(globals.themeColor[900]),
                      ),
                      onPressed: _submitData,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
