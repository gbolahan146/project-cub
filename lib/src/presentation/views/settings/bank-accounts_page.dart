import 'package:cubex/src/presentation/views/settings/add-bank_page.dart';
import 'package:cubex/src/presentation/widgets/emptystate/empty_widget.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BankAccountsPage extends StatefulHookWidget {
  @override
  _BankAccountsPageState createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  bool isBankAccountsEmpty = false;
  @override
  Widget build(BuildContext context) {
    var userAccountState = useProvider(userAccountsProvider);
    return CbScaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigate(AddBankPage());
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: CbColors.cPrimaryBase),
      appBar: CbAppBar(
        title: 'Bank Accounts.',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: userAccountState.userAccounts.isEmpty
              ? EmptyStateWidget(
                  title: 'You have not added any Bank accounts yet.',
                )
              : Container(
                  margin: EdgeInsets.only(top: 40),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => YMargin(16),
                    itemCount: userAccountState.userAccounts.length,
                    itemBuilder: (context, index) => BankAccountsCard(
                      name: userAccountState.userAccounts[index].accountName
                              ?.capitalizeFirst ??
                          '',
                      accountNumber:
                          '${userAccountState.userAccounts[index].accountNumber}',
                      bank:
                          ' ${userAccountState.userAccounts[index].bank?.name.capitalizeFirst}',
                      bankImg: userAccountState.userAccounts[index].bank?.name
                              .substring(0, 2) ??
                          '',
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class BankAccountsCard extends StatelessWidget {
  final String name;
  final String bank;
  final String accountNumber;
  final String bankImg;
  const BankAccountsCard({
    Key? key,
    required this.name,
    required this.bank,
    required this.accountNumber,
    required this.bankImg,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CbColors.cBase,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: CbColors.cPrimaryBase,
            child: Text(
              '$bankImg',
              style: CbTextStyle.book16.copyWith(color: Colors.white),
            ),
          ),
          XMargin(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text('${name.capitalize}',
                    style: CbTextStyle.book16
                        .copyWith(color: CbColors.cAccentBase)),
              ),
              YMargin(4),
              Text('$accountNumber | $bank', style: CbTextStyle.book12),
            ],
          ),
        ],
      ),
    );
  }
}
