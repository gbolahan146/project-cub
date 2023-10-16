import 'dart:io';

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/presentation/views/trade/components/summary_card.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SellGiftCardPage3 extends StatefulHookWidget {
  final Map<String, dynamic> data;
  const SellGiftCardPage3({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _SellGiftCardPage3State createState() => _SellGiftCardPage3State();
}

class _SellGiftCardPage3State extends State<SellGiftCardPage3> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _images = [];
  final TextEditingController _commentController = TextEditingController();

  pickImageFromGallery() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(image!.path);
      setState(() {
        _images.add(imageFile);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var tradeState = useProvider(tradeProvider);
    var uploadState = useProvider(uploadProvider);
    SizeConfig config = SizeConfig();
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Giftcards.',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YMargin(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload card',
                    style: CbTextStyle.book12,
                  ),
                  Text(
                    'Step 3 / 3',
                    style: CbTextStyle.medium.copyWith(
                      color: CbColors.cAccentLighten3,
                      fontSize: config.sp(12),
                    ),
                  ),
                ],
              ),
              YMargin(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: LinearProgressIndicator(
                  value: 1,
                  backgroundColor: CbColors.cPrimaryLighten5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CbColors.cPrimaryBase),
                ),
              ),
              YMargin(40),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(4),
                dashPattern: [8, 1],
                color: CbColors.cPrimaryBase,
                child: Container(
                  color: CbColors.cBase,
                  child: GestureDetector(
                      onTap: () {
                        pickImageFromGallery();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upload card (s)',
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
              if (_images.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._images.map(
                        (e) => Container(
                          margin: EdgeInsets.only(top: 8, right: 8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: CbColors.cBase,
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                  height: config.sh(120),
                                  width: config.sw(120),
                                  child: Image.file(e!)),
                              YMargin(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _images.remove(e);
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
                      )
                    ],
                  ),
                ),
              YMargin(16),
              CbTextField(
                  label: 'Add Comment',
                  hint: 'Add Comment...',
                  onChanged: (value) => setState(() {}),
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  controller: _commentController),
              YMargin(40),
              GiftCardTradeSummaryCard(
                rate: widget.data['rate'],
                amount: widget.data['amountExpected'],
                country: widget.data['giftCard']['country'],
                name: widget.data['giftCard']['name'],
                type: widget.data['giftCard']['type'],
              ),
              YMargin(40),
              CbThemeButton(
                loadingState:
                    uploadState.uploadBusy || tradeState.createCardTransBusy,
                text: 'Submit',
                onPressed: () async {
                  List<String> imageUrls = [];
                  // ignore: unused_local_variable
                  for (var image in _images) {
                    String? contentType = lookupMimeType(image!.path);
                    FormData formData = FormData.fromMap({
                      "upload": await MultipartFile.fromFile(image.path,
                          filename: image.path.split('/').last,
                          contentType: MediaType.parse(contentType!))
                    });
                    var imageUrl =
                        await uploadState.uploadAssetImages(data: formData);
                    imageUrls.add(imageUrl ?? '');
                  }

                  var transactionData = {
                    ...widget.data,
                    'image': imageUrls,
                    'comment': _commentController.text,
                  };



                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: CbColors.transparent,
                      isDismissible: false,
                      builder: (context) => BottomSheetContainer(
                          title: 'Trade Terms',
                          child: TradeTermsBottomSheet(
                            startCode: tradeState.selectedCategory?.startCode,
                            price: widget.data['giftCard']['type']
                                .toString()
                                .split('(')[1]
                                .replaceAll(')', ''),
                            title: tradeState.selectedGiftCard!.name ?? '',
                            country: widget.data['giftCard']['country'] ?? '',
                            callback: () {
                              tradeState.createGiftCardTransaction(
                                  data: transactionData,
                                  onSuccess: () {
                                    context
                                        .read(tradeProvider)
                                        .fetchGiftCardTransactions(
                                          refresh: true,
                                        );
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                        isDismissible: false,
                                        context: context,
                                        backgroundColor: CbColors.transparent,
                                        builder: (context) =>
                                            FloatingBottomSheetContainer(
                                                child: SuccessBottomSheet(
                                              btnText: 'Go to giftcards',
                                              subtitle:
                                                  'Your transaction has been submitted and is now processing.',
                                              callback: () {
                                                //fetch giftcard transactions
                                                int count = 0;

                                                Navigator.popUntil(context,
                                                    (route) {
                                                  return count++ == 4;
                                                });
                                                // navigateReplaceTo(
                                                //     context, MainScreen());
                                              },
                                            )));
                                  });
                            },
                          )));
                },
              ),
              YMargin(40),
            ],
          ),
        ),
      ),
    );
  }
}
