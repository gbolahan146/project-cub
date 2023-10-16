// ignore_for_file: deprecated_member_use

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/data/models/fetch_cryptos.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/dropdown_dynamic.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/presentation/views/trade/trade-crypto/trade_crypto3.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellCryptoPage2 extends StatefulHookWidget {
  @override
  _SellCryptoPage2State createState() => _SellCryptoPage2State();
}

class _SellCryptoPage2State extends State<SellCryptoPage2> {
  final TextEditingController _amountController = TextEditingController();
  List<Networks> listOfNetworks = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  clearTextController() {
    _amountController.clear();
    listOfNetworks = [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (context.read(tradeProvider).selectedCrypto != null) {
      listOfNetworks =
          context.read(tradeProvider).selectedCrypto?.networks ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var tradeState = useProvider(tradeProvider);
    var cryptoRate = tradeState.getCryptoRate?.data;
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Crypto',
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
                      'Amount to sell',
                      style: CbTextStyle.book14,
                    ),
                    Text(
                      'Step 2 / 3',
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
                    value: 5 / 10,
                    backgroundColor: CbColors.cPrimaryLighten5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CbColors.cPrimaryBase),
                  ),
                ),
                YMargin(40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CbDropDownDynamic<CryptosData>(
                    options: tradeState.cryptoData,
                    getDisplayName: (val) => val.name,
                    label: 'Select Crypto',
                    selected: tradeState.selectedCrypto,
                    onChanged: null,
                    hint: 'Select Crypto',
                  ),
                ),
                YMargin(24),
                CbTextField(
                    label: 'Amount to sell',
                    hint: 'Amount to sell',
                    onChanged: (value) => setState(() {}),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,5}'))
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    suffix: Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 20),
                      child: Text(
                        '\$',
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentLighten5),
                      ),
                    ),
                    controller: _amountController,
                    validator: Validators.validateField),
                YMargin(24),
                CbDropDownDynamic<Networks>(
                  options: listOfNetworks,
                  label: 'Select Network',
                  selected: null,
                  getDisplayName: (val) => val.name,
                  onChanged: (val) {
                    tradeState.selectedCryptoNetwork = val;
                  },
                  hint: 'Select Network',
                ),
                if (listOfNetworks.isEmpty) ...[
                  YMargin(10),
                  Text(
                    'No available networks, Kindly check back',
                    style: CbTextStyle.book14.copyWith(
                        color: CbColors.cErrorBase,
                        fontStyle: FontStyle.italic),
                  )
                ],
                YMargin(24),
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
                                text: _amountController.text.isEmpty
                                    ? 'loading'
                                    : ParserService.formatToMoney(
                                        calculateAmount(
                                            mark: cryptoRate?.mark ?? 0,
                                            above: cryptoRate?.above ?? 0,
                                            below: cryptoRate?.below ?? 0,
                                            value: num.parse(
                                                _amountController.text)),
                                        context: context,
                                        compact: false),
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
                                text: '@${cryptoRate?.mark}/\$',
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
                          _amountController.text.isEmpty
                              ? '----'
                              : ParserService.formatToMoney(
                                  calculateAmount(
                                      mark: cryptoRate?.mark ?? 0,
                                      above: cryptoRate?.above ?? 0,
                                      below: cryptoRate?.below ?? 0,
                                      value: num.parse(_amountController.text)),
                                  context: context,
                                  compact: false),
                          style: CbTextStyle.bold28
                              .copyWith(fontSize: config.sp(32))),
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
                                            '@${cryptoRate?.below} below \$${cryptoRate?.mark} / @${cryptoRate?.above} above \$${cryptoRate?.mark}',
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
                    if (listOfNetworks.isEmpty) {
                      showErrorToast(
                          message: 'Kindly select network to proceed');
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      var data = {
                        "crypto": {
                          "id": tradeState.selectedCrypto!.id,
                          "name": tradeState.selectedCrypto!.name,
                          "network": tradeState.selectedCryptoNetwork?.name,
                          "address": tradeState.selectedCryptoNetwork?.address,
                        },
                        "amount": num.parse(_amountController.text),
                        "amountExpected": _amountController.text.isNotEmpty
                            ? calculateAmount(
                                mark: cryptoRate?.mark ?? 0,
                                above: cryptoRate?.above ?? 0,
                                below: cryptoRate?.below ?? 0,
                                value: num.parse(_amountController.text))
                            : '0',
                        "rate": cryptoRate?.mark,
                      };
                      navigate(SellCryptoPage3(
                        data: data,
                        rawAmount: _amountController.text.isNotEmpty
                            ? _amountController.text
                            : '0',
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  calculateAmount(
      {required num value,
      required num above,
      required num mark,
      required num below}) {
    if (value <= mark) {
      return value * below;
    } else if (value > mark) {
      return value * above;
    }
    return 0;
  }
}
