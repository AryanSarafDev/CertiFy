import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/textbox.dart';
List<String> list = <String>[
  'Personal',
  'Organization',
];
bool isorg = false;
bool isper = true;
String dropdownValue = list.first;
String un = "Username";


class RegisterPageContr extends StatefulWidget {
  RegisterPageContr({Key? key,required this.emailc,required this.passc,required this.namec,required this.signupbutton}) : super(key: key);
  final TextEditingController emailc;
  final TextEditingController passc;
  final TextEditingController namec;
  final Widget signupbutton;


  @override
  State<RegisterPageContr> createState() => _RegisterPageContrState();
}

class _RegisterPageContrState extends State<RegisterPageContr> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [ Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.67,
        decoration: BoxDecoration(
            color: primary, borderRadius: BorderRadius.circular(20)),
      ),
    ),
      //Stack 2: Container for background card
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.70,
          decoration: BoxDecoration(
              color: secondary, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(spadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 8.0),
                  child: TextString(
                    textEditingController: widget.namec,
                    hintText: "Enter $un",
                    textInputType: TextInputType.name,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 8.0),
                  child: TextString(
                      textEditingController: widget.emailc,
                      hintText: "Enter email",
                      textInputType: TextInputType.emailAddress),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 8.0),
                  child: TextString(
                    textEditingController: widget.passc,
                    hintText: "Enter Password",
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 70, vertical: 8),
                  child: DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: fourthdull),
                    underline: Container(
                      height: 2,
                      color: primary,
                    ),
                    onChanged: (String? value) {
// This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;

                        if (dropdownValue == "Organization") {
                          un = "Organization";
                          isorg = true;
                          isper = false;
                        } else if (dropdownValue == "Personal") {
                          un = "Username";
                          isper = true;
                          isorg = false;
                        }
                      });
                    },
                    items: list
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                widget.signupbutton


              ],
            ),
          ),
        ),
      ),],);
  }
}
