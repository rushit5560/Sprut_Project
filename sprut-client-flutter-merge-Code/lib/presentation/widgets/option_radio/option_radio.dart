import 'package:flutter/material.dart';

class OptionRadio extends StatefulWidget {
  final String? text;
  final int? index;
  final int? selectedButton;
  final Function? press;

  const OptionRadio({
    Key? key,
    this.text,
    this.index,
    this.selectedButton,
    this.press,
  }) : super();

  @override
  OptionRadioPage createState() => OptionRadioPage();
}

class OptionRadioPage extends State<OptionRadio> {
  // QuestionController controllerCopy =QuestionController();

  int id = 1;
  bool? _isButtonDisabled;
  @override
  void initState() {
    _isButtonDisabled = false;
  }

  int? _selected = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.press!(widget.index);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                // height: 60.0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Color(0xffC9CED6),
                        disabledColor:Color(0xff4C6FFF)),
                    child: Column(children: [
                      RadioListTile(
                        title: Text(
                          "${widget.text}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff27272E),
                            fontSize: 12,
                          ),
                          softWrap: true,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        /*Here the selectedButton which is null initially takes place of value after onChanged. Now, I need to clear the selected button when other button is clicked */
                        groupValue: widget.selectedButton,
                        value: widget.index!,
                        activeColor: Color(0xff4C6FFF),
                        onChanged: (obj) async {
                          debugPrint('Radio button is clicked onChanged ${obj.toString()}');
                          // setState(() {
                          //   debugPrint('Radio button setState $val');
                          //   selectedButton = val;
                          //   debugPrint('Radio button is clicked onChanged $widget.index');
                          // });
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // prefs.setInt('intValue', val);
                          widget.press!(widget.index);
                        },
                        toggleable: true,
                      ),
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}