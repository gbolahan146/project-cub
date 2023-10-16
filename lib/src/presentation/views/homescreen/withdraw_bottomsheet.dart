import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/presentation/views/settings/add-bank_page.dart';
import 'package:cubex/src/presentation/views/settings/confirm-pin.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/data/models/fetch_user_accounts_resp.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WithdrawBottomSheet extends StatefulHookWidget {
  final bool obscureText;
  const WithdrawBottomSheet({
    Key? key,
    this.obscureText = false,
  }) : super(key: key);
  @override
  _WithdrawBottomSheetState createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<WithdrawBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedIndex = 0;
  UserAccountData? _selectedAccount;
  num amountToPay = 0;

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    var userAccountState = useProvider(userAccountsProvider);
    var user = authState.fetchUserResponse.data;
    var transferState = useProvider(transferProvider);
    var walletState = useProvider(walletProvider);

    return StatefulBuilder(builder: (context, setSecondaryState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YMargin(24),
          CbTextField(
              label: 'Amount to withdraw',
              hint: 'Amount to withdraw',
              suffix: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 20),
                child: Text(
                  '₦',
                  style: CbTextStyle.bold16.copyWith(
                      color: CbColors.cAccentLighten5, fontFamily: 'Roboto'),
                ),
              ),
              onChanged: (val) {
                setSecondaryState(() {
                  amountToPay = ParserService.parseMoneyToNum(val);
                });
              },
              inputFormatters: [
                CurrencyTextInputFormatter(symbol: ''),
              ],
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
                            compact: false,
                            context: context,
                          ),
                          style: CbTextStyle.bold14.copyWith(
                              color: CbColors.cAccentLighten4,
                              fontFamily: 'Roboto'))
                    ]),
              ),
            ],
          ),
          YMargin(24),
          Text(
            'Select Account.',
            style: CbTextStyle.medium.copyWith(color: CbColors.cAccentLighten3),
          ),
          YMargin(16),
          if (userAccountState.userAccounts.isEmpty)
            Center(
              child: Text('No user accounts found.\Kindly add an account.',
                  style: CbTextStyle.medium
                      .copyWith(color: CbColors.cAccentLighten3)),
            )
          else
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setSecondaryState(() {
                          _selectedIndex = index;
                          _selectedAccount =
                              userAccountState.userAccounts[index];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _selectedIndex == index
                                ? CbColors.cDarken1
                                : CbColors.cBase,
                            border: Border.all(
                                color: _selectedIndex == index
                                    ? CbColors.cPrimaryBase
                                    : CbColors.transparent)),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: CbColors.cPrimaryBase,
                              child: Text(
                                userAccountState.userAccounts[index].bank?.name
                                        .substring(0, 2) ??
                                    '',
                                style: CbTextStyle.book16
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            XMargin(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      userAccountState.userAccounts[index]
                                              .accountName?.capitalizeFirst ??
                                          '',
                                      style: CbTextStyle.medium),
                                  YMargin(4),
                                  Text(
                                      '${userAccountState.userAccounts[index].accountNumber} | ${userAccountState.userAccounts[index].bank?.name.capitalizeFirst}',
                                      style: CbTextStyle.book12),
                                  // Spacer(),
                                ],
                              ),
                            ),
                            if (_selectedIndex == index)
                              SvgPicture.asset('selected'.svg)
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (c, i) => YMargin(16),
                itemCount: userAccountState.userAccounts.length),
          YMargin(16),
          GestureDetector(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddBankPage()));
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(4),
              dashPattern: [10, 1],
              color: CbColors.cPrimaryBase,
              child: Container(
                color: CbColors.cBase,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add new account',
                        style: CbTextStyle.book16,
                      ),
                      XMargin(16),
                      Icon(Icons.add_circle_outline_rounded,
                          color: CbColors.cAccentLighten5)
                    ],
                  ),
                ),
              ),
            ),
          ),
          YMargin(40),
          CbThemeButton(
            text: 'Proceed',
            onPressed: () {
              if (userAccountState.userAccounts.length == 1) {
                _selectedAccount = userAccountState.userAccounts[0];
              }
              if (_selectedAccount == null) {
                showErrorToast(message: 'Please select an account.');
                return;
              }
              Map<String, dynamic> data = <String, dynamic>{
                "amount": amountToPay,
                "accountNumber": _selectedAccount?.accountNumber,
                "bankName": _selectedAccount?.bank?.name,
                "accountName": _selectedAccount?.accountName,
                "bankCode": _selectedAccount?.bank?.code,
              };
              showModalBottomSheet(
                  context: context,
                  backgroundColor: CbColors.transparent,
                  builder: (context) => FloatingBottomSheetContainer(
                      child: ConfirmBottomSheet(
                          amount: ParserService.formatToMoney(
                            amountToPay,
                            compact: false,
                            context: context,
                          ),
                          loading: false,
                          type: 'Withdrawal',
                          name: _selectedAccount?.accountName ?? 'User',
                          callback: () async {
                            navigate(ConfirmPinPage(callback: () async {
                              await transferState.transferToBank(
                                data: data,
                                context: context,
                                onSuccess: () {
                                  authState.fetchOnlyUser(context: context);
                                  walletState.fetchHistory(
                                      context: context, refresh: true);
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: CbColors.transparent,
                                      builder: (context) =>
                                          FloatingBottomSheetContainer(
                                              child: SuccessBottomSheet(
                                            btnText: 'Go home',
                                            subtitle:
                                                'Your withdrawal of ${ParserService.formatToMoney(
                                              amountToPay,
                                              compact: false,
                                              context: context,
                                            )} to ${_selectedAccount?.accountName ?? 'User'} was successful!',
                                            callback: () {
                                              int count = 0;
                                              Navigator.popUntil(context,
                                                  (route) {
                                                return count++ == 5;
                                              });
                                            },
                                          )));
                                },
                              );
                            }));
                          })));
            },
          ),
          YMargin(40),
        ],
      );
    });
  }
}
