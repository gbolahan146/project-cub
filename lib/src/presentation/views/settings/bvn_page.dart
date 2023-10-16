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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BvnPage extends StatefulHookWidget {
  @override
  _BvnPageState createState() => _BvnPageState();
}

class _BvnPageState extends State<BvnPage> {
  final TextEditingController _bvnController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'BVN.',
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
                    label: 'Enter BVN',
                    hint: 'Enter BVN',
                    controller: _bvnController,
                    validator: Validators.validateBvn),
                YMargin(24),
                CbThemeButton(
                  text: 'Submit',
                  loadingState: authState.getUserBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      'bvn': _bvnController.text,
                    };
                    authState.updateUser(
                        data: data,
                        context: context,
                        onSuccess: () async {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: CbColors.transparent,
                              builder: (context) =>
                                  FloatingBottomSheetContainer(
                                      child: SuccessBottomSheet(
                                    btnText: 'Go to settings',
                                    subtitle:
                                        'You have successfully submitted your BVN and It is now been reviewed.',
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
