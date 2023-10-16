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
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddBankPage extends StatefulHookWidget {
  @override
  _AddBankPageState createState() => _AddBankPageState();
}

class _AddBankPageState extends State<AddBankPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _acctNumberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _bankController = TextEditingController();
  ValueNotifier _searchNotifier = ValueNotifier<String>("");
  BankData? _selectedBank;
  String? accountName = '';

  @override
  Widget build(BuildContext context) {
    var accountState = useProvider(accountsProvider);
    var userAccountState = useProvider(userAccountsProvider);
    var transferState = useProvider(transferProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'ADD BANK',
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
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 1.5,
                        minHeight: MediaQuery.of(context).size.height / 1.5),
                    context: context,
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
                                      color: CbColors.cAccentLighten5)),
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
                                                setState(() {
                                                  _selectedBank =
                                                      accountState.banks[index];
                                                  _bankController.text =
                                                      accountState
                                                          .banks[index].name;
                                                });

                                                Navigator.pop(context);
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
                                                  setState(() {
                                                    _selectedBank =
                                                        items[index];
                                                    _bankController.text =
                                                        items[index].name;
                                                  });
                                                  Navigator.pop(context);
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
                    selected: _bankController.text.isEmpty
                        ? null
                        : _bankController.text,
                    onChanged: null,
                    hint: 'Select bank',
                  ),
                ),
                YMargin(24),
                CbTextField(
                    label: 'Account number',
                    hint: 'Account number',
                    controller: _acctNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.length >= 10) {
                        Map<String, dynamic> data = <String, dynamic>{
                          "accountNumber": value,
                          "bankCode": _selectedBank?.code
                        };
                        transferState.validateAccountNumber(
                            data: data, context: context);
                        setState(() {
                          accountName = transferState.accountName ?? '';
                        });
                      }
                    },
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
                                    : '$accountName',
                                style: CbTextStyle.bold14
                                    .copyWith(color: CbColors.cAccentLighten4))
                          ]),
                    ),
                  ],
                ),
                YMargin(24),
                CbThemeButton(
                  text: 'Save Changes',
                  loadingState: userAccountState.createAccountBusy,
                  onPressed: transferState.validateAccountNumberBusy
                      ? () {}
                      : () {
                          if (!_formKey.currentState!.validate()) return;
                          Map<String, dynamic> data = <String, dynamic>{
                            "accountNumber": _acctNumberController.text,
                            "bank": _selectedBank?.id,
                            "accountName": accountName,
                          };
                          userAccountState.createUserAccount(
                            data: data,
                            context: context,
                            onSuccess: () => showModalBottomSheet(
                                context: context,
                                backgroundColor: CbColors.transparent,
                                builder: (context) =>
                                    FloatingBottomSheetContainer(
                                        child: SuccessBottomSheet(
                                      btnText: 'Go to home',
                                      subtitle:
                                          'You have successfully added a new Bank account to your profile.',
                                      callback: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // Navigator.pop(context);
                                      },
                                    ))),
                          );
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
