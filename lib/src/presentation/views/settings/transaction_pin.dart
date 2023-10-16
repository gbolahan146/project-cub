import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionPinPage extends StatefulHookWidget {
  @override
  _TransactionPinPageState createState() => _TransactionPinPageState();
}

class _TransactionPinPageState extends State<TransactionPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Transaction PIN.',
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
                    label: 'Enter 6 digit PIN',
                    hint: 'Enter 6 digit PIN',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _pinController,
                    validator: Validators.validateField),
                YMargin(16),
                CbTextField(
                    label: 'Confirm 6 digit PIN',
                    hint: 'Confirm 6 digit PIN',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _confirmPinController,
                    validator: Validators.validateField),
                YMargin(24),
                CbThemeButton(
                  text: 'Save changes',
                  loadingState: authState.pinBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "pin": _pinController.text,
                    };
                    authState.setupPin(
                        context: context,
                        data: data,
                        onSuccess: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: CbColors.transparent,
                              builder: (context) =>
                                  FloatingBottomSheetContainer(
                                      child: SuccessBottomSheet(
                                    btnText: 'Go to settings',
                                    subtitle:
                                        'You have successfully updated your transaction PIN.',
                                    callback: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )));
                        });
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
