import 'package:flutter/material.dart';

enum InputFieldType { email, password }

class AuthSectionBuilder {
  final List<Widget> _widgets = [];
  Widget? _subsection;

  TextFormField getTextFormField({
    required InputFieldType type,
    required TextEditingController controller,
    required String hintText,
  }) {
    bool obscureText = false;
    Icon? prefixIcon;
    String? Function(String?)? validator = (val) => null;

    switch (type) {
      case InputFieldType.email:
        prefixIcon = const Icon(Icons.person);
        validator = ((val) {
          if (val == null || val.isEmpty) {
            return "Please enter your email";
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(val)) {
            return "Please enter a valid email";
          }
          return null;
        });
        break;
      case InputFieldType.password:
        obscureText = true;
        prefixIcon = const Icon(Icons.key);
        validator = ((val) {
          if (val == null || val.isEmpty) {
            return "Please enter your password";
          }
          if (val.length < 8) {
            return "Password must have at least 8 characters";
          }
          if (val.length > 24) {
            return "The maximum password length is 24 characters";
          }
          return null;
        });
        break;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      validator: validator,
    );
  }

  AuthSectionBuilder withInput(
      InputFieldType fieldType,
      TextEditingController controller,
      BuildContext context,
      String title,
      String hintText) {
    _widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          getTextFormField(
              type: fieldType, controller: controller, hintText: hintText),
        ],
      ),
    ));

    return this;
  }

  AuthSectionBuilder withWidget(Widget widget) {
    _widgets.add(widget);
    return this;
  }

  AuthSectionBuilder withButton(String title, Function func) {
    _widgets.add(SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            func();
          },
          child: Text(title)),
    ));
    return this;
  }

  AuthSectionBuilder withSubsection(Widget subsection) {
    _subsection = subsection;
    return this;
  }

  Widget _getSubsection() {
    if (_subsection == null) {
      return Container();
    }

    return Column(
      children: [
        const Divider(
          color: Colors.black38,
          thickness: 1,
        ),
        _subsection!
      ],
    );
  }

  Widget build() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 6),
        child: Column(
          children: [
            ..._widgets,
            _getSubsection(),
          ],
        ),
      ),
    );
  }
}
