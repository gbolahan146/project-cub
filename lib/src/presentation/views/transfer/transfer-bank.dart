import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/presentation/views/settings/confirm-pin.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';

import 'package:cubex/src/presentation/widgets/textfields/dropdown.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/data/models/fetch_banks.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransferBankPage extends StatefulHookWidget {
  @override
  _TransferBankPageState createState() => _TransferBankPageState();
}

class _TransferBankPageState extends State<TransferBankPage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? accountName = '';
  num amountToPay = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  BankData? _selectedBank;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier _searchNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    var walletState = useProvider(walletProvider);
    var accountState = useProvider(accountsProvider);
    var transferState = useProvider(transferProvider);
    var user = authState.fetchUserResponse.data;
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Transfer to Bank.',
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
                    'Enter the Bank account details of the person you want to transfer to, and the amount also...',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 1.5,
                        minHeight: MediaQuery.of(context).size.height / 1.5),
                    backgroundColor: CbColors.transparent,
                    builder: (context) => BottomSheetContainer(
                      child: Column(
                        children: [
                          YMargin(16),
                          CbTextField(
                              label: 'Search bank',
                              hint: 'Search bank',
                              suffix: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(Icons.search,
                                    color: CbColors.cAccentLighten5),
                              ),
                              onChanged: (String? value) {
                                _searchNotifier.value = value;
                              },
                              controller: _searchController,
                              validator: Validators.validateField),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: ValueListenableBuilder(
                              valueListenable: _searchNotifier,
                              builder: (context, value, child) {
                                if (value == "") {
                                  return Scrollbar(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _selectedBank =
                                                      accountState.banks[index];
                                                  _bankNameController.text =
                                                      accountState
                                                          .banks[index].name;
                                                });
                                              },
                                              leading: Text(
                                                accountState.banks[index].name,
                                                style: CbTextStyle.book16,
                                              ),
                                              trailing: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    CbColors.cPrimaryBase,
                                                child: Text(
                                                  accountState.banks[index].name
                                                      .toString()
                                                      .substring(0, 2),
                                                  style: CbTextStyle.book16
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              color: CbColors.cPrimaryLighten5,
                                            ),
                                        itemCount: accountState.banks.length),
                                  );
                                } else {
                                  var items = accountState.banks
                                      .where((element) => element.name
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              value.toString().toLowerCase()))
                                      .toList();
                                  if (items.isEmpty) {
                                    return Center(
                                        child: Text('No results found'));
                                  }
                                  return Scrollbar(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _selectedBank =
                                                        items[index];
                                                    _bankNameController.text =
                                                        items[index].name;
                                                  });
                                                },
                                                leading: Text(
                                                  items[index].name,
                                                  style: CbTextStyle.book16,
                                                ),
                                                trailing: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      CbColors.cPrimaryBase,
                                                  child: Text(
                                                    items[index]
                                                        .name
                                                        .toString()
                                                        .substring(0, 2),
                                                    style: CbTextStyle.book16
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                )),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              color: CbColors.cPrimaryLighten5,
                                            ),
                                        itemCount: items.length),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      title: 'Select Bank.',
                    ),
                  ),
                  child: CbDropDown(
                    options: List.from(accountState.banks.map((e) => e.name)),
                    label: 'Select Bank',
                    selected: _bankNameController.text.isEmpty
                        ? null
                        : _bankNameController.text,
                    onChanged: null,
                    hint: 'Select bank',
                  ),
                ),
                YMargin(24),
                CbTextField(
                    label: 'Account number',
                    hint: 'Account number',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.length >= 10) {
                        FocusScope.of(context).unfocus();
                        Map<String, dynamic> data = <String, dynamic>{
                          "accountNumber": value,
                          "bankCode": _selectedBank?.code
                        };
                        transferState.validateAccountNumber(
                            data: data, context: context);
                        setState(() {
                          accountName = transferState.accountName;
                        });
                      }
                    },
                    controller: _numberController,
                    validator: Validators.validateAccountNumber),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Account holder:',
                          style: CbTextStyle.book14
                              .copyWith(color: CbColors.cAccentLighten4),
                          children: [
                            TextSpan(
                                text: transferState.validateAccountNumberBusy
                                    ? 'loading...'
                                    : '${accountName?.capitalize ?? 'Try again...'}',
                                style: CbTextStyle.bold14
                                    .copyWith(color: CbColors.cAccentLighten4))
                          ]),
                    ),
                  ],
                ),
                YMargin(24),
                CbTextField(
                    label: 'Amount to transfer',
                    hint: 'Amount to transfer',
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
                    onChanged: (val) {
                      amountToPay = ParserService.parseMoneyToNum(val);
                    },
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
                  loadingState: transferState.validateAccountNumberBusy ||
                      transferState.transferToBankBusy,
                  onPressed: transferState.validateAccountNumberBusy
                      ? () {}
                      : () {
                          if (!_formKey.currentState!.validate()) return;
                          if (transferState.accountName == null) {
                            showErrorToast(
                                message: 'Account information not valid');
                            return;
                          }
                          Map<String, dynamic> data = <String, dynamic>{
                            "amount": amountToPay,
                            "accountNumber": _numberController.text,
                            "bankName": _bankNameController.text,
                            "accountName": transferState.accountName,
                            "bankCode": _selectedBank?.code,
                          };

                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              backgroundColor: CbColors.transparent,
                              builder: (context) => FloatingBottomSheetContainer(
                                  child: ConfirmBottomSheet(
                                      loading: transferState.transferToBankBusy,
                                      amount: ParserService.formatToMoney(
                                        amountToPay,
                                        compact: false,
                                        context: context,
                                      ),
                                      name: '${transferState.accountName!.capitalize ?? 'User'}',
                                      type: 'transfer',
                                      callback: () async {
                                        navigate(ConfirmPinPage(
                                          loadingState:
                                              transferState.transferToBankBusy,
                                          callback: () async {
                                            await transferState.transferToBank(
                                              data: data,
                                              context: context,
                                              onSuccess: () {
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
                                                          )} to ${transferState.accountName!.capitalize ?? 'User'} was successful!',
                                                          callback: () {
                                                            int count = 0;
                                                            Navigator.popUntil(
                                                                context,
                                                                (route) {
                                                              return count++ ==
                                                                  5;
                                                            });
                                                          },
                                                        )));
                                              },
                                            );
                                          },
                                        ));
                                      })));
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
