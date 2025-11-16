import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const AuthField({
    super.key, 
    required this.hintText,
    required this.controller,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.hintText == 'Password' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    // Form field can reuse for many situations
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscureText,

      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.hintText == 'Password'
        ? const Icon(Icons.lock_outline)
        : const Icon(Icons.person_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.hintText == 'Password'
        ? IconButton(
          icon: Icon(
            _isObscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState((){
              _isObscureText = !_isObscureText;
            });// Handle visibility toggle if needed
          },
        )
        : null,
      ),
      validator: (value) {
        if(value!.isEmpty) {
          return "$widget.hintText is missing!";
        }
        return null;
      } ,
    );
  }
}