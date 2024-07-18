import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/user_fetch.dart';

import '../../server.dart';

class portfolioUpdateFreelancer extends StatefulWidget {
  final String imagepath; final String name;final int index;
  const portfolioUpdateFreelancer({Key? key , required this.imagepath, required this.name, required this.index}) : super(key: key);

  @override
  State<portfolioUpdateFreelancer> createState() => _portfolioUpdateFreelancerState(imagepath, name, index);
}

class _portfolioUpdateFreelancerState extends State<portfolioUpdateFreelancer> {
  String imagepath; String name; int index;
  _portfolioUpdateFreelancerState(this.imagepath, this.name, this.index);
  final TextEditingController imageController = TextEditingController();
  var image = new TextEditingController();
  final TextEditingController tittleportcontroller = TextEditingController();
  String? tittleport;

  File? _ImageFile;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  void _picBase64Image(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;
    compressFile(image);
  }

  void compressFile(XFile file) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 20, percentage: 100);
    Uint8List imageByte = await compressedFile.readAsBytes();
    _base64Image = base64.encode(imageByte);
    print('Image ' + _base64Image);
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFile = compressedFile;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  portfolioUpdateFreelancer(imagepath: _base64Image, name: name,index: index ,)));
    });
  }

  String UserName = CrudFunction.UserFind['UserName'];
  @override
  Widget build(BuildContext context) {
    print(imagepath);
    print(name);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insert Portfolio',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreelancerHomeScreen()),
                  (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Container(
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                          child: Column(
                            children: [

                                Image.memory(
                                  base64.decode(
                                     imagepath),
                                  fit: BoxFit.cover,
                                ),
                            ],
                          )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              color: Colors.black,
                            ),
                            child: IconButton(
                              onPressed: () {
                                showGeneralDialog(
                                  barrierLabel: "profileimage",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  transitionDuration:
                                  Duration(milliseconds: 700),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 50, left: 12, right: 12),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(40),
                                            child: Scaffold(
                                              body: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(40),
                                                ),
                                                height: 500,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                               setState(() {
                                                                 _picBase64Image(
                                                                     ImageSource
                                                                         .gallery);
                                                               });
                                                              },
                                                              child: Text(
                                                                  "Upload Picture")),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                            setState(() {
                                                              _picBase64Image(
                                                                  ImageSource
                                                                      .camera);
                                                            });

                                                              },
                                                              child: Text(
                                                                  "Take Picture")),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                          begin: Offset(0, 1),
                                          end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                        },
                        initialValue: name,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Color.fromRGBO(117, 117, 117, 1),
                        ),
                        decoration: InputDecoration(
                          suffixIcon: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromARGB(255, 221, 221, 221))),
                          ),
                          prefixIcon: Icon(
                            Icons.credit_score,
                            color: const Color.fromRGBO(117, 117, 117, 1),
                          ),
                          labelText: "Title",
                          labelStyle: const TextStyle(
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor:
                          Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  insertPortfolio(
                                      imagepath, name, index);
                                }
                              },
                              child: Text("Update")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertPortfolio(String image, String title ,int index) async {
    print("Portfolio inserting!!!!");
    await CrudFunction.updatePortfolio(UserName, image, title, index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Portfolio Updated")),
    );
    print("Refreshing UI...");
  }

}
