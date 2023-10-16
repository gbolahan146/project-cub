import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/presentation/widgets/textfields/dropdown_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/data/models/fetch_giftcard.dart';
import 'package:cubex/src/presentation/views/trade/trade-giftcard/trade_giftcard3.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/dummydata.dart';
import 'package:cubex/src/presentation/widgets/textfields/dropdown.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellGiftcardPage2 extends StatefulHookWidget {
  @override
  _SellGiftcardPage2State createState() => _SellGiftcardPage2State();
}

class _SellGiftcardPage2State extends State<SellGiftcardPage2> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cardTypeController = TextEditingController();
  final TextEditingController _cardCategoryController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  List<Categories> listOfCardCategories = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  clearTextController() {
    _amountController.clear();
    _countryController.clear();
    _cardTypeController.clear();
    _cardCategoryController.clear();
    _qtyController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var tradeState = useProvider(tradeProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Giftcards.',
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
                YMargin(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sell card details',
                      style: CbTextStyle.book12,
                    ),
                    Text(
                      'Step 2 / 3',
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
                    value: 5 / 10,
                    backgroundColor: CbColors.cPrimaryLighten5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CbColors.cPrimaryBase),
                  ),
                ),
                YMargin(40),
                CbDropDownDynamic<GiftCardsData>(
                  getDisplayName: (val) => val.name,
                  options: tradeState.giftCardData,
                  label: 'Select Giftcard',
                  selected: tradeState.selectedGiftCard,
                  onChanged: (val) {
                    clearTextController();
                    tradeState.selectedGiftCard = val;
                  },
                  hint: 'Select Giftcard',
                ),
                YMargin(16),
                GestureDetector(
                  onTap: () {
                    _cardTypeController.clear();
                    _cardCategoryController.clear();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: CbColors.transparent,
                      builder: (context) => BottomSheetContainer(
                        child: Column(
                          children: [
                            YMargin(16),
                            if (tradeState.selectedGiftCard!.countries ==
                                    null ||
                                tradeState.selectedGiftCard!.countries == [])
                              Center(child: Text('No countries available'))
                            else
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      getImage() {
                                        if (dummycountries.firstWhere(
                                                (element) =>
                                                    element
                                                        .toString()
                                                        .toLowerCase() ==
                                                    tradeState.selectedGiftCard!
                                                        .countries![index]
                                                        .toString()
                                                        .toLowerCase(),
                                                orElse: () => null) !=
                                            null) {
                                          return dummycountries[index]['image'];
                                        }
                                      }

                                      return ListTile(
                                        onTap: () {
                                          Navigator.pop(context);

                                          setState(() {
                                            _countryController.text = tradeState
                                                .selectedGiftCard!
                                                .countries![index];
                                          });
                                        },
                                        leading: Text(
                                          tradeState.selectedGiftCard!
                                              .countries![index],
                                          style: CbTextStyle.book16,
                                        ),
                                        trailing: SvgPicture.asset(
                                          '${getImage()}'.svg,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: CbColors.cPrimaryLighten5,
                                        ),
                                    itemCount: tradeState
                                        .selectedGiftCard!.countries!.length),
                              ),
                          ],
                        ),
                        title: 'Select Country.',
                      ),
                    );
                  },
                  child: CbDropDown(
                    options: tradeState.selectedGiftCard!.countries,
                    label: 'Select Country',
                    enabled: false,
                    selected: _countryController.text.isEmpty
                        ? null
                        : _countryController.text,
                    onChanged: null,
                    hint: 'Select Country',
                  ),
                ),
                YMargin(16),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: CbColors.transparent,
                      builder: (context) => BottomSheetContainer(
                        child: Column(
                          children: [
                            YMargin(16),
                            if (tradeState.selectedGiftCard!.types == null ||
                                tradeState.selectedGiftCard!.types == [])
                              Center(child: Text('No types available'))
                            else
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: ListView.separated(
                                  itemCount: tradeState
                                      .selectedGiftCard!.types!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: ListTile(
                                        onTap: () {
                                          _cardCategoryController.clear();
                                          tradeState.selectedCategory = null;
                                          listOfCardCategories = [];
                                          Navigator.pop(context);
                                          for (var i in tradeState
                                              .selectedGiftCard!.categories!) {
                                            if (i.name!.toLowerCase().contains(
                                                    tradeState.selectedGiftCard!
                                                        .types![index]
                                                        .toLowerCase()) &&
                                                i.name!
                                                    .toLowerCase()
                                                    .startsWith(
                                                        _countryController.text
                                                            .substring(0, 2)
                                                            .toLowerCase())) {
                                              listOfCardCategories.add(i);
                                            }
                                          }
                                          setState(() {
                                            _cardTypeController.text =
                                                tradeState.selectedGiftCard!
                                                    .types![index];
                                          });
                                        },
                                        leading: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tradeState.selectedGiftCard!
                                                  .types![index],
                                              style: CbTextStyle.book16,
                                            ),
                                            // Text(
                                            //   '$25 – $1,000',
                                            //   style: CbTextStyle.book12,
                                            // ),
                                          ],
                                        ),
                                        trailing: SvgPicture.asset(
                                          tradeState.selectedGiftCard!
                                                      .types![index]
                                                      .toLowerCase() ==
                                                  'ecode'
                                              ? 'e-code'.svg
                                              : 'receipt'.svg,
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (c, i) {
                                    return Divider(
                                      color: CbColors.cPrimaryLighten5,
                                      thickness: .5,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                        title: 'Select Card type',
                      ),
                    );
                  },
                  child: CbDropDown(
                    enabled: false,
                    options: tradeState.selectedGiftCard!.types,
                    label: 'Select Card type',
                    selected: _cardTypeController.text.isEmpty
                        ? null
                        : _cardTypeController.text,
                    onChanged: null,
                    hint: 'Select Card type',
                  ),
                ),
                YMargin(24),
                CbDropDownDynamic<Categories>(
                  // enabled: false,

                  options: listOfCardCategories,
                  label: 'Select Card Category',
                  selected: tradeState.selectedCategory,
                  getDisplayName: (val) => val.name,

                  onChanged: (val) {
                    setState(() {
                      tradeState.selectedCategory = val;
                      _cardCategoryController.text =
                          tradeState.selectedCategory?.name ?? '';
                    });
                  },
                  hint: 'Select Card Category',
                ),
                if (listOfCardCategories.isEmpty &&
                    _cardTypeController.text.isNotEmpty) ...[
                  YMargin(10),
                  Text(
                    'No available categories, Kindly check back',
                    style: CbTextStyle.book14.copyWith(
                        color: CbColors.cErrorBase,
                        fontStyle: FontStyle.italic),
                  ),
                ],
                YMargin(24),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CbTextField(
                          label: 'Amount',
                          hint: 'Amount',
                          onChanged: (str) {
                            String splitValue = "";
                            splitValue = _cardCategoryController.text;

                            if (splitValue.isNotEmpty) {
                              splitValue =
                                  _cardCategoryController.text.split('(')[1];
                              String min = splitValue.split('-')[0];
                              String max =
                                  splitValue.split('-')[1].replaceAll(")", "");
                              if (str.isEmpty) str = '0';
                              if (num.parse(str) > num.parse(max) ||
                                  num.parse(str) < num.parse(min)) {
                                showErrorToast(
                                    duration: 1,
                                    message:
                                        "Amount must be within ${splitValue.replaceAll(')', "")}");
                                return;
                              }
                            }
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          suffix: Padding(
                            padding: const EdgeInsets.only(top: 18.0, left: 20),
                            child: Text(
                              '\$',
                              style: CbTextStyle.bold16
                                  .copyWith(color: CbColors.cAccentLighten5),
                            ),
                          ),
                          controller: _amountController,
                          validator: (str) {
                            String splitValue = "";
                            splitValue = _cardCategoryController.text;

                            if (str!.isEmpty) {
                              return "Cannot be empty";
                            } else if (splitValue.isNotEmpty) {
                              splitValue =
                                  _cardCategoryController.text.split('(')[1];

                              String min = splitValue.split('-')[0];
                              String max =
                                  splitValue.split('-')[1].replaceAll(")", "");

                              if (num.parse(str) > num.parse(max) ||
                                  num.parse(str) < num.parse(min)) {
                                return " must be within ${splitValue.replaceAll(')', "")}";
                              }
                              return null;
                            } else {
                              return null;
                            }
                          }),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (_qtyController.text.isEmpty) {
                          _qtyController.text = '0';
                        }
                        if (_qtyController.text == '0') return;
                        setState(() {
                          _qtyController.text =
                              (int.parse(_qtyController.text) - 1).toString();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: CbColors.cDarken1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        child: Text(
                          '-',
                          style: CbTextStyle.black.copyWith(
                              color: CbColors.cPrimaryBase,
                              fontSize: config.sp(24)),
                        ),
                      ),
                    ),
                    XMargin(4),
                    Container(
                      decoration: BoxDecoration(
                        color: CbColors.cDarken1,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: CbColors.cPrimaryBase,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                      child: Text(
                        '${_qtyController.text}',
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cPrimaryBase),
                      ),
                    ),
                    XMargin(4),
                    GestureDetector(
                      onTap: () {
                        if (_qtyController.text.isEmpty) {
                          _qtyController.text = '0';
                        }
                        setState(() {
                          _qtyController.text =
                              (int.parse(_qtyController.text) + 1).toString();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: CbColors.cDarken1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Text(
                          '+',
                          style: CbTextStyle.black.copyWith(
                              color: CbColors.cPrimaryBase,
                              fontSize: config.sp(24)),
                        ),
                      ),
                    ),
                    XMargin(4),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Amount expected: ',
                          style: CbTextStyle.book12
                              .copyWith(color: CbColors.cAccentLighten4),
                          children: [
                            TextSpan(
                                text: _amountController.text.isNotEmpty &&
                                        _qtyController.text.isNotEmpty
                                    ? ParserService.formatToMoney(
                                        double.parse(_amountController.text) *
                                            tradeState.selectedCategory!.rate! *
                                            double.parse(_qtyController.text),
                                        context: context,
                                        compact: false)
                                    : 'loading',
                                style: CbTextStyle.bold14.copyWith(
                                    fontSize: config.sp(12),
                                    fontFamily: 'Roboto',
                                    color: CbColors.cAccentLighten4))
                          ]),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Rate: ',
                          style: CbTextStyle.book12
                              .copyWith(color: CbColors.cAccentLighten4),
                          children: [
                            TextSpan(
                                text: tradeState.selectedCategory == null
                                    ? ""
                                    : '@${tradeState.selectedCategory?.rate}/\$',
                                style: CbTextStyle.bold14.copyWith(
                                    fontSize: config.sp(12),
                                    color: CbColors.cAccentLighten4))
                          ]),
                    ),
                  ],
                ),
                YMargin(40),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: CbColors.cPrimaryBase)),
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Amount you will receive',
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text(
                          _amountController.text.isNotEmpty &&
                                  _qtyController.text.isNotEmpty
                              ? ParserService.formatToMoney(
                                  double.parse(_amountController.text) *
                                      tradeState.selectedCategory!.rate! *
                                      double.parse(_qtyController.text),
                                  context: context,
                                  compact: false)
                              : '----',
                          style: CbTextStyle.bold28.copyWith(
                              fontFamily: 'Roboto', fontSize: config.sp(32))),
                      YMargin(16),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: CbColors.cBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Rate: ',
                                  style: CbTextStyle.book12.copyWith(
                                      color: CbColors.cAccentLighten3),
                                  children: [
                                    TextSpan(
                                        text:
                                            '@${tradeState.selectedCategory?.rate}/\$',
                                        style: CbTextStyle.bold14.copyWith(
                                            fontSize: config.sp(12),
                                            color: CbColors.cAccentLighten3))
                                  ]),
                            ),
                          ))
                    ],
                  ),
                ),
                YMargin(40),
                CbThemeButton(
                  text: 'Proceed',
                  onPressed: () {
                    if (_qtyController.text == '0' ||
                        _qtyController.text == '') {
                      showErrorToast(
                          message: 'Add at least one card to proceed');
                      return;
                    }
                    if (listOfCardCategories.isEmpty) {
                      showErrorToast(
                          message: 'Card category is required to proceed');
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      var data = {
                        "giftCard": {
                          "id": tradeState.selectedGiftCard!.id,
                          "name": tradeState.selectedGiftCard!.name,
                          "type": _cardCategoryController.text,
                          "country": _countryController.text,
                        },
                        "amount": num.parse(_qtyController.text),
                        "amountExpected": _amountController.text.isNotEmpty &&
                                _qtyController.text.isNotEmpty
                            ? double.parse(_amountController.text) *
                                tradeState.selectedCategory!.rate! *
                                double.parse(_qtyController.text)
                            : _amountController.text,
                        "quantity": _amountController.text.isNotEmpty &&
                                _qtyController.text.isNotEmpty
                            ? double.parse(_amountController.text) *
                                tradeState.selectedCategory!.rate! *
                                double.parse(_qtyController.text)
                            : _amountController.text,
                        "rate": tradeState.selectedCategory?.rate,
                      };
                      navigate(SellGiftCardPage3(
                        data: data,
                      ));
                    }
                  },
                ),
                YMargin(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
