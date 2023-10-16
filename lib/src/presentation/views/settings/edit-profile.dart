import 'dart:io';

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/presentation/widgets/textfields/dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/data/models/fetch_user_response.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

class EditProfilePage extends StatefulHookWidget {
  final Data? data;
  const EditProfilePage({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _doBController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  String unformattedDate = '';
  DateFormat fmt = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.data?.email ?? '';
    _nameController.text = '${widget.data?.firstName} ${widget.data?.lastName}';
    _numberController.text = widget.data?.phoneNumber ?? '';
    _genderController.text = widget.data?.gender ?? '';
    _doBController.text = fmt.format(DateTime.parse(widget.data?.dob ?? ''));
  }

  pickImageFromGallery() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = File(image!.path);
      });
    } catch (e) {

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    var uploadState = useProvider(uploadProvider);
    SizeConfig config = SizeConfig();
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Edit Profile.',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YMargin(40),
                GestureDetector(
                  onTap: () {
                    pickImageFromGallery();
                  },
                  child: Stack(
                    children: [
                      widget.data?.profilePhoto == null
                          ? SizedBox(
                              child: imageFile == null
                                  ? Image.asset(
                                      'avatarplaceholder'.png,
                                      scale: 2.8,
                                      color: CbColors.cAccentLighten3,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        height: config.sh(100),
                                        width: config.sw(95),
                                        child: Image.file(
                                          imageFile!,
                                          scale: 7,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            )
                          : SizedBox(
                              child: imageFile == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SizedBox(
                                        height: config.sh(100),
                                        width: config.sw(95),
                                        child: Image.network(
                                          widget.data?.profilePhoto ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        height: config.sh(100),
                                        width: config.sw(95),
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                      Positioned.fill(
                        child: Image.asset('camera'.png),
                      )
                    ],
                  ),
                ),
                YMargin(24),
                CbTextField(
                    label: 'Full name',
                    hint: 'Full name',
                    controller: _nameController,
                    validator: Validators.validateFullName),
                YMargin(16),
                CbTextField(
                    label: 'Email address',
                    hint: 'Email address',
                    controller: _emailController,
                    validator: Validators.validateEmail),
                YMargin(16),
                CbTextField(
                  label: 'Phone number',
                  hint: 'Phone number',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _numberController,
                ),
                YMargin(16),
                CbDropDown(
                  options: ['Male', 'Female', 'I prefer not to answer'],
                  label: 'Select Gender',
                  enabled: true,
                  selected: _genderController.text.isEmpty
                      ? null
                      : _genderController.text,
                  onChanged: (val) {
                    setState(() {
                      _genderController.text = val ?? '';
                    });
                  },
                  hint: 'Select Gender',
                ),
                YMargin(16),
                GestureDetector(
                  onTap: () async {
                    DateTime? d = await showDatePicker(
                        context: context,
                        initialDate: _doBController.text.isEmpty
                            ? DateTime.now()
                            : fmt.parse(_doBController.text),
                        firstDate: DateTime(1890),
                        lastDate: DateTime.now());

                    if (d == null) {
                      _doBController.text = '';
                      return;
                    }
                    unformattedDate = d.toIso8601String();
                    _doBController.text = fmt.format(d);
                  },
                  child: CbTextField(
                    label: 'DOB',
                    enabled: false,
                    suffix: Icon(Icons.date_range),
                    controller: _doBController,
                    onChanged: null,
                    hint: 'Select Date of Birth',
                  ),
                ),
                YMargin(24),
                CbThemeButton(
                  text: 'Save changes',
                  loadingState: uploadState.uploadBusy || authState.getUserBusy,
                  onPressed: () async {
                    String? imageUrl = '';
                    if (imageFile != null) {
                      String? contentType = lookupMimeType(imageFile!.path);
                      FormData formData = FormData.fromMap({
                        "upload": await MultipartFile.fromFile(imageFile!.path,
                            filename: imageFile!.path.split('/').last,
                            contentType: MediaType.parse(contentType!))
                      });
                      imageUrl =
                          await uploadState.uploadAssetImages(data: formData);
                    }
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      'email': _emailController.text,
                      'firstName': _nameController.text.split(' ')[0],
                      'lastName': _nameController.text.split(' ')[1],
                      'phoneNumber': _numberController.text,
                      'profilePhoto': imageUrl,
                      'dob': unformattedDate,
                      'gender': _genderController.text
                    }..removeWhere(
                        (key, value) => value == null || value == '');
                    authState.updateUser(
                        data: data,
                        context: context,
                        onSuccess: () async {
                          await LocalStorage.setItem(
                              "username", _emailController.text);
                          await LocalStorage.setItem(
                              "firstname", _nameController.text.split(' ')[0]);
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: CbColors.transparent,
                              builder: (context) =>
                                  FloatingBottomSheetContainer(
                                      child: SuccessBottomSheet(
                                    btnText: 'Go to settings',
                                    subtitle:
                                        'You have successfully updated your profile details.',
                                    callback: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )));
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
