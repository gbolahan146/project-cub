import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/views/notification/notification.dart';
import 'package:cubex/src/presentation/views/settings/bank-accounts_page.dart';
import 'package:cubex/src/presentation/views/settings/bvn_page.dart';
import 'package:cubex/src/presentation/views/settings/change-password.dart';
import 'package:cubex/src/presentation/views/settings/edit-profile.dart';
import 'package:cubex/src/presentation/views/settings/id-document_page.dart';
import 'package:cubex/src/presentation/views/settings/transaction_pin.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/presentation/widgets/webview.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulHookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool activateBiometrics = true;

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    var userAcctState = useProvider(userAccountsProvider);
    var authState = useProvider(authProvider);
    var user = authState.fetchUserResponse.data;
    return CbScaffold(
      backgroundColor: CbColors.cBase,
      appBar: CbAppBar(
        isTransparent: true,
        title: 'Settings.',
        actions: [
          GestureDetector(
            onTap: () async {
              await LocalStorage.setItem("loggedIn", false);
              await LocalStorage.clearDB();
              await LocalStorage.setItem("hasSeenOnboarding", true);
              navigateReplaceTo(context, LoginPage());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 24.0),
              child: Row(
                children: [
                  Text('Sign out',
                      style: CbTextStyle.bold14
                          .copyWith(color: CbColors.cAccentLighten4)),
                  XMargin(8),
                  Image.asset('exit'.png, scale: 1.8)
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YMargin(24),
              GestureDetector(
                onTap: () => navigate(EditProfilePage(data: user)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CbColors.cDarken0,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      user.profilePhoto == null
                          ? Image.asset(
                              'avatarplaceholder'.png,
                              scale: 2.8,
                              color: CbColors.cAccentLighten3,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                height: config.sh(100),
                                width: config.sw(95),
                                child: Image.network(
                                  user.profilePhoto ?? '',
                                  fit: BoxFit.cover,
                                  // scale: 1.6,
                                ),
                              ),
                            ),
                      XMargin(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${user.firstName} ${user.lastName}.",
                              style: CbTextStyle.bold18.copyWith(
                                color: CbColors.cPrimaryBase,
                              )),
                          YMargin(4),
                          Text(
                            '${user.email}',
                            style: CbTextStyle.book14,
                          )
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: CbColors.cPrimaryBase,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              YMargin(40),
              Text(
                'Account',
                style: CbTextStyle.medium
                    .copyWith(color: CbColors.cAccentLighten3),
              ),
              YMargin(16),
              Divider(
                color: CbColors.cDarken2,
                thickness: .5,
              ),
              YMargin(20),
              SettingsRow(
                  title: 'BVN',
                  leadingImg: 'bvn',
                  onTap: user.bvn == null ? () => navigate(BvnPage()) : null,
                  trailing: Row(
                    children: [
                      if (user.bvnStatus != 'verified')
                        Image.asset('verified'.png),
                      XMargin(16),
                      if (user.bvn == null)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: CbColors.cPrimaryBase,
                          size: 15,
                        )
                    ],
                  )),
              SettingsRow(
                  title: 'ID Document',
                  leadingImg: 'id',
                  onTap: () => navigate(IdDocumentPage()),
                  trailing: Row(
                    children: [
                      Image.asset('timer'.png),
                      XMargin(16),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: CbColors.cPrimaryBase,
                        size: 15,
                      )
                    ],
                  )),
              SettingsRow(
                title: 'Bank Accounts',
                leadingImg: 'bank2',
                onTap: () => navigate(BankAccountsPage()),
              ),
              SettingsRow(
                title: 'Notifications',
                leadingImg: 'bell',
                onTap: () => navigate(NotificationPage()),
              ),
              YMargin(10),
              Text(
                'Security.',
                style: CbTextStyle.medium
                    .copyWith(color: CbColors.cAccentLighten3),
              ),
              YMargin(16),
              Divider(
                color: CbColors.cDarken2,
                thickness: .5,
              ),
              YMargin(20),
              SettingsRow(
                title: 'Biometrics',
                leadingImg: 'fingerprint2',
                trailing: Container(
                  height: config.sh(10),
                  child: Switch(
                      activeTrackColor: CbColors.cPrimaryBase,
                      activeColor: Colors.white,
                      value: activateBiometrics,
                      onChanged: (val) {
                        setState(() {
                          activateBiometrics = val;
                        });
                      }),
                ),
              ),
              SettingsRow(
                title: 'Transaction PIN',
                leadingImg: 'password',
                onTap: () {
                  navigate(TransactionPinPage());
                },
              ),
              SettingsRow(
                title: 'Account Password',
                leadingImg: 'lock',
                onTap: () {
                  navigate(ChangePasswordPage());
                },
              ),
              YMargin(10),
              Text(
                'About Cubex.',
                style: CbTextStyle.medium
                    .copyWith(color: CbColors.cAccentLighten3),
              ),
              YMargin(16),
              Divider(
                color: CbColors.cDarken2,
                thickness: .5,
              ),
              YMargin(20),
              SettingsRow(
                title: 'Chat with Us',
                leadingImg: 'chat',
                onTap: () {
                  _launchLink("https://wa.me/" +
                      userAcctState.cubexSettingsResponse.appPhone! +
                      "?text=Hello%20Cubex,%20");
                },
              ),
              SettingsRow(
                title: 'Terms & Conditions',
                leadingImg: 'terms',
                onTap: () {
                  navigate(WebviewPage(
                      title: 'Terms And Condition',
                      url: userAcctState
                          .cubexSettingsResponse.termsAndCondition));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchLink(url) async {
    // ignore: deprecated_member_use
    launch(url);
  }
}

class SettingsRow extends StatelessWidget {
  final String? title;
  final String? leadingImg;
  final Function()? onTap;
  final Widget? trailing;
  const SettingsRow({
    Key? key,
    required this.title,
    required this.leadingImg,
    this.trailing,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: Row(
          children: [
            Image.asset(
              '$leadingImg'.png,
            ),
            XMargin(16),
            Text('$title',
                style:
                    CbTextStyle.book16.copyWith(color: CbColors.cAccentBase)),
            Spacer(),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: CbColors.cPrimaryBase,
                  size: 15,
                )
          ],
        ),
      ),
    );
  }
}
