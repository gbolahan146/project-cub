import 'dart:io';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/dropdown.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cubex/src/core/state_registry.dart';

class IdDocumentPage extends StatefulHookWidget {
  @override
  _IdDocumentPageState createState() => _IdDocumentPageState();
}

class _IdDocumentPageState extends State<IdDocumentPage> {
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _idTypeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? frontImage;
  File? backImage;
  pickImageFromGallery() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      File imagefile = File(image!.path);
      return imagefile;
    } catch (e) {

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var authState = useProvider(authProvider);
    var uploadState = useProvider(uploadProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'ID Document.',
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
                CbDropDown(
                  options: [
                    'NIN',
                    'Intl. Passport',
                    'Drivers License',
                    'Voters Card'
                  ],
                  label: 'Select ID type',
                  selected: _idTypeController.text.isEmpty
                      ? null
                      : _idTypeController.text,
                  onChanged: (val) {
                    setState(() {
                      _idTypeController.text = val!;
                    });
                  },
                  hint: 'Select ID type',
                ),
                YMargin(16),
                CbTextField(
                    label: 'ID number',
                    hint: 'ID number',
                    controller: _idNumberController,
                    validator: Validators.validateField),
                YMargin(16),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [10, 1],
                  color: CbColors.cPrimaryBase,
                  child: Container(
                    color: CbColors.cBase,
                    child: GestureDetector(
                        onTap: () {
                          pickImageFromGallery().then((image) {
                            setState(() {
                              frontImage = image;
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload ID front',
                                style: CbTextStyle.book16,
                              ),
                              XMargin(16),
                              Icon(Icons.add_circle_outline_rounded,
                                  color: CbColors.cAccentLighten5)
                            ],
                          ),
                        )),
                  ),
                ),
                if (frontImage != null)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: CbColors.cBase,
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Center(
                            child: SizedBox(
                                height: config.sh(150),
                                width: config.sw(150),
                                child: Image.file(frontImage!))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  frontImage = null;
                                });
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: CbColors.cAccentLighten5,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                YMargin(16),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [10, 1],
                  color: CbColors.cPrimaryBase,
                  child: Container(
                    color: CbColors.cBase,
                    child: GestureDetector(
                        onTap: () {
                          pickImageFromGallery().then((image) {
                            setState(() {
                              backImage = image;
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload ID back',
                                style: CbTextStyle.book16,
                              ),
                              XMargin(16),
                              Icon(Icons.add_circle_outline_rounded,
                                  color: CbColors.cAccentLighten5)
                            ],
                          ),
                        )),
                  ),
                ),
                if (backImage != null)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: CbColors.cBase,
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Center(
                            child: SizedBox(
                                height: config.sh(150),
                                width: config.sw(150),
                                child: Image.file(backImage!))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  backImage = null;
                                });
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: CbColors.cAccentLighten5,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                YMargin(24),
                CbThemeButton(
                  text: 'Submit',
                  loadingState: uploadState.uploadBusy || authState.getUserBusy,
                  onPressed: () async {
                    String? imageUrl = '';
                    if (frontImage != null) {
                      String? contentType = lookupMimeType(frontImage!.path);
                      FormData formData = FormData.fromMap({
                        "upload": await MultipartFile.fromFile(frontImage!.path,
                            filename: frontImage!.path.split('/').last,
                            contentType: MediaType.parse(contentType!))
                      });
                      imageUrl =
                          await uploadState.uploadAssetImages(data: formData);
                    }
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      'idCardUrl': imageUrl,
                    };
                    authState.updateUser(
                        data: data,
                        context: context,
                        onSuccess: () async {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: CbColors.transparent,
                              builder: (context) =>
                                  FloatingBottomSheetContainer(
                                      child: SuccessBottomSheet(
                                    btnText: 'Go to settings',
                                    subtitle:
                                        'You have successfully submitted your ID and It is now been reviewed.',
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
