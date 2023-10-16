import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureOldText = true;
  bool obscureNewText = true;
  bool obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Account Password.',
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
                CbTextField(
                    label: 'Enter old password',
                    hint: 'Enter old password',
                    obscureText: obscureOldText,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureOldText = !obscureOldText;
                        });
                      },
                      icon: obscureOldText
                          ? Icon(
                              Icons.visibility,
                              color: CbColors.cAccentLighten5,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: CbColors.cAccentLighten5,
                            ),
                    ),
                    controller: _oldPasswordController,
                    validator: Validators.validatePassword),
                YMargin(16),
                CbTextField(
                    label: 'New password',
                    hint: 'New password',
                    obscureText: obscureNewText,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureNewText = !obscureNewText;
                        });
                      },
                      icon: obscureNewText
                          ? Icon(
                              Icons.visibility,
                              color: CbColors.cAccentLighten5,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: CbColors.cAccentLighten5,
                            ),
                    ),
                    controller: _newPasswordController,
                    validator: Validators.validatePassword),
                YMargin(16),
                CbTextField(
                    label: 'Confirm new password',
                    hint: 'Confirm new password',
                    obscureText: obscureConfirmText,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmText = !obscureConfirmText;
                        });
                      },
                      icon: obscureConfirmText
                          ? Icon(
                              Icons.visibility,
                              color: CbColors.cAccentLighten5,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: CbColors.cAccentLighten5,
                            ),
                    ),
                    controller: _confirmPasswordController,
                    validator: Validators.validatePassword),
                YMargin(24),
                CbThemeButton(
                  text: 'Save changes',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: CbColors.transparent,
                        builder: (context) => FloatingBottomSheetContainer(
                                child: SuccessBottomSheet(
                              btnText: 'Go to settings',
                              subtitle:
                                  'You have successfully updated your account password.',
                              callback: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )));
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
