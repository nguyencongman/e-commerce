import 'package:flutter/material.dart';

class TextFieldV2 extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obs;
  TextFieldV2(
      {super.key,
      required this.controller,
      required this.label,
      this.obs = false});

  @override
  State<TextFieldV2> createState() => _TextFieldV2State();
}

class _TextFieldV2State extends State<TextFieldV2> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obs,
      decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return value.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                      },
                      icon: const Icon(Icons.clear))
                  : const SizedBox();
            },
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the ${widget.label}";
        }
        return null;
      },
      onChanged: (value) {},
    );
  }
}
