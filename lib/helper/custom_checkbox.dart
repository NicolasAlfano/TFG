import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class CustomCheckBox extends StatefulWidget {
  final bool isChecked;
  final double? size;
  final double? iconSize;
  final Color? iconColorSelected;
  final Color? iconColorNotSelected;
  final Color? selectedColor;
  final IconData? iconSelected;
  final IconData? iconUnselected;
  final String? title;
  final Day day;
  final ServiceFrequency frequency;

  const CustomCheckBox(
      {Key? key,
      required this.isChecked,
      this.size,
      this.iconSize,
      this.iconColorSelected,
      this.iconColorNotSelected,
      this.selectedColor,
      this.iconSelected,
      this.iconUnselected,
      this.title,
      required this.day,
      required this.frequency})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });
          switch (widget.day) {
            case Day.monday:
              widget.frequency.monday = _isSelected;
              break;
            case Day.tuesday:
              widget.frequency.tuesday = _isSelected;
              break;
            case Day.wednesday:
              widget.frequency.wednesday = _isSelected;
              break;
            case Day.thursday:
              widget.frequency.thursday = _isSelected;
              break;
            case Day.friday:
              widget.frequency.friday = _isSelected;
              break;
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          //decoration: _buildDecoration(),
          width: widget.size ?? 30,
          height: widget.size ?? 30,
          child: Row(
            children: [
              _isSelected
                  ? Icon(
                      widget.iconSelected ?? Icons.check_box,
                      color: widget.iconColorSelected ?? Colors.deepPurple,
                      size: widget.iconSize ?? 40,
                    )
                  : Icon(
                      widget.iconUnselected ?? Icons.crop_square_outlined,
                      color: widget.iconColorNotSelected ?? Colors.deepPurple,
                      size: widget.iconSize ?? 40,
                    ),
              Text(widget.title.toString()),
            ],
          ),
        ),
      ),
    );
  }

//Este metodo ahora no es necesario, pero prodia servir esteticamente
  BoxDecoration _buildDecoration() => BoxDecoration(
        color: _isSelected
            ? widget.selectedColor ?? Colors.deepPurple
            : Colors.white,
        // color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(5.0),
      );
}
