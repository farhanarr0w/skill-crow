import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:project_skillcrow/user_fetch.dart';

import '../../reusable_widgets/reusable_widget.dart';
import '../../server.dart';
import 'package:image_picker/image_picker.dart';

import 'client_home.dart';

class editProfileClient extends StatefulWidget {
  const editProfileClient({Key? key}) : super(key: key);

  @override
  State<editProfileClient> createState() => _editProfileClientState();
}

class _editProfileClientState extends State<editProfileClient> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _lastnameTextController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();
  final TextEditingController _companynameTextController = TextEditingController();
  final TextEditingController _compnaymeailTextController = TextEditingController();


  var image = new TextEditingController();

  File? _ImageFile;
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
    });
  }

  final _formKey = GlobalKey<FormState>();

  String UserName = CrudFunction.ClientFind['UserName'];
  String email = CrudFunction.ClientFind['Email'];


  @override
  Widget build(BuildContext context) {
    _nameTextController.text = CrudFunction.ClientFind['FirstName'].toString();
    _phoneTextController.text =
        '0' + CrudFunction.ClientFind['Phone'].toString();
    _lastnameTextController.text =
        CrudFunction.ClientFind['LastName'].toString();
    _compnaymeailTextController.text =
        CrudFunction.ClientFind['CompanyEmail'].toString();
    _companynameTextController.text =
        CrudFunction.ClientFind['CompanyName'].toString();
    _addressTextController.text =
        CrudFunction.ClientFind['Country'].toString() + " " +
            CrudFunction.ClientFind['City'].toString() + " " +
            CrudFunction.ClientFind['State'].toString();
    String? countryValue = CrudFunction.ClientFind['Country'].toString();
    String? stateValue = CrudFunction.ClientFind['City'];
    String? cityValue = CrudFunction.ClientFind['State'].toString();


    print(_nameTextController.text + _phoneTextController.text +
        _lastnameTextController.text + _companynameTextController.text +
        _compnaymeailTextController.text + _addressTextController.text);

    Uint8List? bytes;

    bytes = base64.decode(CrudFunction.ClientFind['Image']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ClientHome()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                            width: 130,
                            height: 130,
                            child: Column(
                              children: [
                                if (CrudFunction.ClientFind['Image'] == "") ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _ImageFile == null
                                        ? ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        child: Image.asset(
                                            'assets/images/pic_signin.png'))
                                        : Image.file(
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                        _ImageFile!),
                                  ),
                                ] else ...[
                                  CrudFunction.ClientFind['Image'] != ""
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    child: Image.memory(
                                      bytes,
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100),
                                      child: Image.asset(
                                          'assets/images/pic_signin.png'))
                                ]
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
                                                bottom: 50,
                                                left: 12,
                                                right: 12),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              child: Scaffold(
                                                body: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        40),
                                                  ),
                                                  height: 500,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  CrudFunction
                                                                      .ClientFind[
                                                                  'Image'] = "";
                                                                  _picBase64Image(
                                                                      ImageSource
                                                                          .gallery);
                                                                },
                                                                child: Text(
                                                                    "Upload Picture")),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  CrudFunction
                                                                      .ClientFind[
                                                                  'Image'] = "";
                                                                  _picBase64Image(
                                                                      ImageSource
                                                                          .camera);
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

                  const SizedBox(
                    height: 30,
                  ),
                  //get username
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter UserName";
                      }
                      return null;
                    },
                    initialValue: UserName,
                    readOnly: true,
                    //controller: _userNameTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_4_outlined,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      labelText: UserName,
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //Gte email
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      return null;
                    },
                    initialValue: email,
                    readOnly: true,
                    //controller: _userNameTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      labelText: UserName,
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //change name
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter First Name";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _nameTextController.text = value;
                    },
                    initialValue: _nameTextController.text,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_4_outlined,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),

                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Last Name";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _lastnameTextController.text = value;
                    },
                    initialValue: _lastnameTextController.text,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_4_outlined,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),

                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //change Phone
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Phone";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _phoneTextController.text = value;
                    },
                    //initialValue: _userNameTextController,
                    controller: _phoneTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      labelText: _phoneTextController.text,
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),


                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Company Name";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _companynameTextController.text = value;
                    },
                    controller: _companynameTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.apartment,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),

                      labelText: 'Enter Company name',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Company Email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _compnaymeailTextController.text = value;
                    },
                    controller: _compnaymeailTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.apartment,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),

                      labelText: 'Enter Company Email',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Address";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _addressTextController.text = value;
                    },
                    controller: _addressTextController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.pin_drop,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        showGeneralDialog(
                          barrierLabel: "Education Update",
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 700),
                          context: context,
                          pageBuilder: (context, anim1, anim2) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 300,
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
                                              CSCPicker(
                                                showStates: true,
                                                showCities: true,
                                                dropdownDecoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                    color:
                                                    Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                                                    border:
                                                    Border.all(color: Colors.grey.shade300, width: 1)),
                                                countrySearchPlaceholder: countryValue.toString(),
                                                stateSearchPlaceholder: stateValue.toString(),
                                                citySearchPlaceholder: cityValue.toString(),
                                                countryDropdownLabel: countryValue.toString(),
                                                stateDropdownLabel: stateValue.toString(),
                                                cityDropdownLabel: cityValue.toString(),
                                                selectedItemStyle: TextStyle(
                                                  color: Color.fromRGBO(117, 117, 117, 1),
                                                ),
                                                dropdownHeadingStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                                dropdownItemStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                dropdownDialogRadius: 10.0,
                                                searchBarRadius: 10.0,
                                                onCountryChanged: (value) {
                                                  countryValue = value;
                                                  print("country: " + countryValue!);
                                                },
                                                onStateChanged: (value) {
                                                  stateValue = value;
                                                },
                                                onCityChanged: (value) {
                                                  cityValue = value;
                                                },
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(),
                                                  ElevatedButton(
                                                      onPressed:
                                                          () async {
                                                        editaddress(countryValue.toString(), cityValue.toString(), stateValue.toString());
                                                      },
                                                      child:
                                                      Text("Insert")),
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
                      }, icon: Icon(
                        Icons.edit,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),),
                      labelText: 'Enter Address',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                      Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180,
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((90)),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const chnagePassword(),
                            //   ),
                            // );
                          },
                          child: Text('Change Password'),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromRGBO(0, 255, 132, 1);
                              }
                              return const Color.fromRGBO(0, 255, 132, 1);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((90)),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_ImageFile == null) {
                              _base64Image = CrudFunction.ClientFind['Image'];
                            } else {
                              CrudFunction.ClientFind['Image'] = _base64Image;
                            }
                            editfunc(
                                _nameTextController.text,
                                _phoneTextController.text,
                                _base64Image,
                                _lastnameTextController.text,
                            _compnaymeailTextController.text,
                            _companynameTextController.text);
                          },
                          child: Text('Update'),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromRGBO(0, 255, 132, 1);
                              }
                              return const Color.fromRGBO(0, 255, 132, 1);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editfunc(String _name, String _phone, String _image, String lastname , String _companyemail,  String _companyname) async {
    print("Edit Profile Function!!!!");
    await CrudFunction.updateClient(
        UserName, _name, int.parse(_phone), _image, lastname, _companyemail, _companyname);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientHome(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile Updates")),
    );
  }

  void editaddress(String _country, String _city, String _state) async {
    print("Edit Profile Function!!!!");
    await CrudFunction.updateclientAddress(
        UserName, _country, _city, _state);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const editProfileClient(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Address Updates")),
    );
  }
}
