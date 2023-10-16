import 'dart:io';

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:share/share.dart';

class SellCryptoPage3 extends StatefulHookWidget {
  final Map<String, dynamic> data;
  final String rawAmount;
  const SellCryptoPage3({
    Key? key,
    required this.rawAmount,
    required this.data,
  }) : super(key: key);

  @override
  _SellCryptoPage3State createState() => _SellCryptoPage3State();
}

class _SellCryptoPage3State extends State<SellCryptoPage3> {
  final ImagePicker _picker = ImagePicker();
  File? proofImage;
  List<File?> _images = [];
  final TextEditingController _commentController = TextEditingController();
  pickImageFromGallery() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(image!.path);
      setState(() {
        _images.add(imageFile);
      });
    } catch (e) {

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var tradeState = useProvider(tradeProvider);
    var cryptoRate = tradeState.getCryptoRate?.data;
    var uploadState = useProvider(uploadProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Crypto',
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
                    'Wallet to pay into',
                    style: CbTextStyle.book14,
                  ),
                  Text(
                    'Step 3 / 3',
                    style: CbTextStyle.medium.copyWith(
                      color: CbColors.cAccentLighten3,
                      fontSize: config.sp(14),
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
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                        onDoubleTap: () async {
                          var response = await http.get(Uri.parse(
                              "${tradeState.selectedCryptoNetwork?.barcode}"));
                          Directory documentDirectory =
                              await getApplicationDocumentsDirectory();
                          File file = new File(join(
                              documentDirectory.path, 'cubex-barcode.png'));
                          file.writeAsBytesSync(response.bodyBytes);

                          Share.shareFiles(
                            ['${documentDirectory.path}/cubex-barcode.png'],
                          ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Image saved to your device !')));
                          });
                        },
                        child: Image.network(
                            "${tradeState.selectedCryptoNetwork?.barcode}",
                            scale: 5.4)),
                    XMargin(8),
                    Text(
                      'Double-tap QR code to save the image, \nor tap below to copy wallet address...',
                      style: CbTextStyle.book14,
                    )
                  ],
                ),
              ),
              YMargin(16),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: CbColors.cPrimaryBase),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: config.sw(210),
                          child: Text(
                            "${widget.data['crypto']['address']}",
                            style: CbTextStyle.bold16
                                .copyWith(color: CbColors.cAccentBase),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Clipboard.setData(ClipboardData(
                                    text:
                                        "${widget.data['crypto']['address']}"))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Copied to your clipboard !')));
                            }),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: CbColors.cPrimaryBase),
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.symmetric(
                              vertical: 17, horizontal: 16),
                          child: Text(
                            'Tap to Copy',
                            style: CbTextStyle.bold14
                                .copyWith(color: CbColors.cPrimaryBase),
                          ),
                        ))
                  ],
                ),
              ),
              YMargin(10),
              Text(
                tradeState.selectedCrypto!.name! == 'Bitcoin'
                    ? 'To prevent asset loss, only send ${tradeState.selectedCrypto?.name} to this wallet.'
                    : 'To prevent asset loss, only send ${tradeState.selectedCrypto?.name} (${tradeState.selectedCryptoNetwork?.name}) to this wallet.',
                style: CbTextStyle.book16.copyWith(
                    color: CbColors.cErrorBase, fontStyle: FontStyle.italic),
              ),
              YMargin(40),
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
                            proofImage = image;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upload proof of payment',
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
                                      child: Image.file(e!))),
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
              TradeSummaryCard(
                data: tradeState.selectedCrypto!,
                context: context,
                rate: cryptoRate,
                amountExpected: widget.data['amountExpected'],
                amount: num.parse(widget.rawAmount),
              ),
              YMargin(40),
              CbThemeButton(
                loadingState:
                    uploadState.uploadBusy || tradeState.createCryptoTransBusy,
                text: 'Submit',
                onPressed: () async {
                  List<String> imageUrls = [];
                  // ignore: unused_local_variable
                  if (_images.isEmpty) {
                    showErrorToast(message: 'Proof of payment is required');
                    return;
                  }
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

                  tradeState.createCryptoTransaction(
                      data: transactionData,
                      onSuccess: () {
                        context.read(tradeProvider).fetchCryptoTransactions(
                              refresh: true,
                            );
                        showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            backgroundColor: CbColors.transparent,
                            builder: (context) => FloatingBottomSheetContainer(
                                    child: SuccessBottomSheet(
                                  btnText: 'Go to crypto',
                                  subtitle:
                                      'Your transaction has been submitted and is now processing.',
                                  callback: () {
                                    int count = 0;

                                    Navigator.popUntil(context, (route) {
                                      return count++ == 4;
                                    });
                                  },
                                )));
                      });
                },
              ),
              YMargin(20),
            ],
          ),
        ),
      ),
    );
  }
}
