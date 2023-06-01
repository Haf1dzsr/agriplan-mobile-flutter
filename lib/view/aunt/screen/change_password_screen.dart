import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/utils/widget/show_dialog/show_dialog_icon_widget.dart';
import 'package:mobile_flutter/view/aunt/screen/forgot_password_screen.dart';
import 'package:mobile_flutter/view/aunt/widget/custom_materialbutton.dart';
import 'package:mobile_flutter/utils/widget/custom_textformfield/custom_textformfield.dart';
import 'package:mobile_flutter/view/home/screen/home_screen.dart';
import 'package:mobile_flutter/view_model/aunt_viewmodel/change_password_provider.dart';
import 'package:mobile_flutter/view_model/aunt_viewmodel/validator_aunt_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  void _submit() async {
    final provider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    if (provider.formKey.currentState!.validate()) {
      await customShowDialogIcon(
        context: context,
        iconDialog: FluentIcons.checkmark_circle_16_regular,
        title: 'Kata sandi diubah',
        desc: 'Selamat! kata sandimu akunmu telah berhasil diubah',
      );
      if (context.mounted) {
        _toLogin(context);
        provider.controllerClear();
      }
    }
  }

  void _toLogin(BuildContext context) {
    final provider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1, 0);
          const end = Offset(0, 0);
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final animatedOffset = animation.drive(tween);

          return SlideTransition(
            position: animatedOffset,
            child: child,
          );
        },
      ),
    );
    provider.controllerClear();
  }

  @override
  Widget build(BuildContext context) {
    final validatorProvider =
        Provider.of<ValidatorProvider>(context, listen: false);
    final provider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ForgotPasswordScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1, 0);
              const end = Offset(0, 0);
              const curve = Curves.ease;
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final animatedOffset = animation.drive(tween);

              return SlideTransition(
                position: animatedOffset,
                child: child,
              );
            },
          ),
        );
        provider.controllerClear();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: provider.formKey,
            child: Consumer<ChangePasswordProvider>(
                builder: (context, ubahKataSandi, _) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Ubah Kata Sandi',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Silahkan masukan kata sandi baru untuk melanjutkan',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    controller: provider.changePasswordController,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    maxLength: 20,
                    label: 'Kata Sandi Baru',
                    hint: 'Masukan kata sandi baru',
                    validator: (value) =>
                        validatorProvider.validatePassword(value),
                    obscureText: ubahKataSandi.passwordObscureText,
                    suffixIcon: IconButton(
                      icon: Icon(ubahKataSandi.passwordObscureText
                          ? FluentIcons.eye_off_16_regular
                          : FluentIcons.eye_16_regular),
                      onPressed: () => ubahKataSandi.sandiObscureTextStatus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextFormField(
                    controller: provider.confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 20,
                    label: 'Konfirmasi Kata Sandi Baru',
                    hint: 'Masukan konfirmasi kata sandi baru',
                    validator: (value) =>
                        validatorProvider.validateComfrimPassword(
                      value,
                      provider.confirmPasswordController.text,
                      provider.changePasswordController.text,
                    ),
                    obscureText: ubahKataSandi.confirmObscureText,
                    suffixIcon: IconButton(
                      icon: Icon(ubahKataSandi.confirmObscureText
                          ? FluentIcons.eye_off_16_regular
                          : FluentIcons.eye_16_regular),
                      onPressed: () =>
                          ubahKataSandi.konfirmasiObscureTextStatus(),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  CustomMaterialButton(
                    onPressed: () => _submit(),
                    minWidth:
                        BouncingScrollSimulation.maxSpringTransferVelocity,
                    text: 'Ubah Kata Sandi',
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
