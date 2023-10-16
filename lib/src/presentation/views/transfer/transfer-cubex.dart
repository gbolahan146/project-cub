import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/presentation/views/settings/confirm-pin.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/data/models/fetch_user_response.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransferCubexPage extends StatefulHookWidget {
  @override
  _TransferCubexPageState createState() => _TransferCubexPageState();
}

class _TransferCubexPageState extends State<TransferCubexPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  num amountToPay = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FetchUserResponse? userRecipientData = FetchUserResponse(data: Data());
  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    var walletState = useProvider(walletProvider);
    var transferState = useProvider(transferProvider);
    var user = authState.fetchUserResponse.data;

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Transfer to Cubex.',
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
                Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Text(
                    'Enter the email address of the Cubex account you want to transfer to, and the amount also...',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'Email address of account',
                    hint: 'Email address of account',
                    controller: _emailController,
                    onChanged: (val) async {
                      if (val.contains('.com')) {
                        FocusScope.of(context).unfocus();
                        userRecipientData = await authState.fetchUserByUser(
                            context: context, username: _emailController.text);
                      }
                    },
                    validator: Validators.validateEmail),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Account holder:',
                          style: CbTextStyle.book14
                              .copyWith(color: CbColors.cAccentLighten4),
                          children: [
                            authState.getUserBusy
                                ? TextSpan(
                                    text: 'loading...',
                                    style: CbTextStyle.bold14.copyWith(
                                        color: CbColors.cAccentLighten4))
                                : TextSpan(
                                    text: userRecipientData?.data.firstName ==
                                            null
                                        ? ''
                                        : '${userRecipientData?.data.firstName} ${userRecipientData?.data.lastName}',
                                    style: CbTextStyle.bold14.copyWith(
                                        color: CbColors.cAccentLighten4))
                          ]),
                    ),
                  ],
                ),
                YMargin(24),
                CbTextField(
                    label: 'Amount to transfer',
                    hint: 'Amount to transfer',
                    onChanged: (val) {
                      amountToPay = ParserService.parseMoneyToNum(val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(symbol: ''),
                    ],
                    suffix: Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 20),
                      child: Text(
                        '${user.wallet?.balance?.currency}',
                        style: CbTextStyle.bold16.copyWith(
                            fontFamily: 'Roboto',
                            color: CbColors.cAccentLighten5),
                      ),
                    ),
                    controller: _amountController,
                    validator: Validators.validateField),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Wallet balance: ',
                          style: CbTextStyle.book14
                              .copyWith(color: CbColors.cAccentLighten4),
                          children: [
                            TextSpan(
                                text: ParserService.formatToMoney(
                                    user.wallet?.balance?.value ?? 0,
                                    context: context,
                                    compact: false),
                                style: CbTextStyle.bold14.copyWith(
                                    fontFamily: 'Roboto',
                                    color: CbColors.cAccentLighten4))
                          ]),
                    ),
                  ],
                ),
                YMargin(24),
                CbThemeButton(
                  text: 'Proceed',
                  loadingState: transferState.transferToCubexBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "amount": amountToPay,
                      "recipientUserID":
                          authState.fetchRecipientUserResponse.data.id,
                    };

                    showModalBottomSheet(
                        context: context,
                        backgroundColor: CbColors.transparent,
                        isDismissible: false,
                        builder: (context) => FloatingBottomSheetContainer(
                              child: ConfirmBottomSheet(
                                  loading: transferState.transferToCubexBusy,
                                  amount: ParserService.formatToMoney(
                                    amountToPay,
                                    compact: false,
                                    context: context,
                                  ),
                                  type: 'transfer',
                                  name:
                                      '${userRecipientData?.data.firstName} ${userRecipientData?.data.lastName}',
                                  callback: () async {
                                    navigate(ConfirmPinPage(
                                      loadingState:
                                          transferState.transferToCubexBusy,
                                      callback: () async {
                                        setState(() {});

                                        await transferState.transferToCubex(
                                            data: data,
                                            context: context,
                                            onSuccess: () async {
                                              // Navigator.pop(context);
                                              authState.fetchOnlyUser(
                                                  context: context);
                                              walletState.fetchHistory(
                                                  context: context,
                                                  refresh: true);
                                              showModalBottomSheet(
                                                  isDismissible: false,
                                                  context: context,
                                                  backgroundColor:
                                                      CbColors.transparent,
                                                  builder: (context) =>
                                                      FloatingBottomSheetContainer(
                                                          child:
                                                              SuccessBottomSheet(
                                                        btnText: 'Go home',
                                                        subtitle:
                                                            'Your transfer of ${ParserService.formatToMoney(
                                                          amountToPay,
                                                          compact: false,
                                                          context: context,
                                                        )} to ${userRecipientData?.data.firstName} ${userRecipientData?.data.lastName} was successful!',
                                                        callback: () {
                                                          int count = 0;
                                                          Navigator.popUntil(
                                                              context, (route) {
                                                            return count++ == 5;
                                                          });
                                                        },
                                                      )));
                                            });
                                      },
                                    ));
                                  }),
                            ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
