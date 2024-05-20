import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<Color?> showColorPicker({
  required BuildContext context,
  Color? currentColor,
  List<Color>? colorPalettes,
}) async {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(context.loc.selectColor),
      contentPadding: const EdgeInsets.all(32),
      children: [
        CustomColorPicker(
          context: context,
          currentColor: currentColor,
          colorPalettes: colorPalettes,
        ),
      ],
    ),
  );
}

class CustomColorPicker extends StatefulWidget {
  const CustomColorPicker({
    super.key,
    required this.context,
    this.currentColor,
    this.colorPalettes,
  });

  final BuildContext context;
  final Color? currentColor;
  final List<Color>? colorPalettes;

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  final _directColorController = TextEditingController();
  double _colorSliderPosition = 0;
  late double _shadeSliderPosition = 0.5;
  late Color _currentColor;
  late Color _shadedColor;
  late List<Color> _basicColorPalettes;

  @override
  void initState() {
    super.initState();
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    _directColorController.text = Format.colorToHexString(_shadedColor);
    _basicColorPalettes = widget.colorPalettes ?? colorPickerBasicPalettes;
  }

  @override
  void dispose() {
    _directColorController.dispose();
    super.dispose();
  }

  Color _calculateShadedColor(double position) {
    if (position > 0.5) {
      //Calculate new color (values converge to 255 to make the color lighter)
      int redVal = _currentColor.red != 255
          ? (_currentColor.red +
                  (255 - _currentColor.red) * (position - 0.5) / 0.5)
              .round()
          : 255;
      int greenVal = _currentColor.green != 255
          ? (_currentColor.green +
                  (255 - _currentColor.green) * (position - 0.5) / 0.5)
              .round()
          : 255;
      int blueVal = _currentColor.blue != 255
          ? (_currentColor.blue +
                  (255 - _currentColor.blue) * (position - 0.5) / 0.5)
              .round()
          : 255;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else if (position < 0.5) {
      //Calculate new color (values converge to 0 to make the color darker)
      int redVal = _currentColor.red != 0
          ? (_currentColor.red * position / 0.5).round()
          : 0;
      int greenVal = _currentColor.green != 0
          ? (_currentColor.green * position / 0.5).round()
          : 0;
      int blueVal = _currentColor.blue != 0
          ? (_currentColor.blue * position / 0.5).round()
          : 0;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else {
      //return the base color
      return _currentColor;
    }
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray = (position * (colorPickerColors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = colorPickerColors[index];
    } else {
      //calculate new color
      int redValue =
          colorPickerColors[index].red == colorPickerColors[index + 1].red
              ? colorPickerColors[index].red
              : (colorPickerColors[index].red +
                      (colorPickerColors[index + 1].red -
                              colorPickerColors[index].red) *
                          remainder)
                  .round();
      int greenValue =
          colorPickerColors[index].green == colorPickerColors[index + 1].green
              ? colorPickerColors[index].green
              : (colorPickerColors[index].green +
                      (colorPickerColors[index + 1].green -
                              colorPickerColors[index].green) *
                          remainder)
                  .round();
      int blueValue =
          colorPickerColors[index].blue == colorPickerColors[index + 1].blue
              ? colorPickerColors[index].blue
              : (colorPickerColors[index].blue +
                      (colorPickerColors[index + 1].blue -
                              colorPickerColors[index].blue) *
                          remainder)
                  .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [0, 1, 2, 3, 4]
              .map((e) => InkWell(
                    onTap: () {
                      setState(() {
                        _shadedColor = _basicColorPalettes[e];
                        _directColorController.text =
                            Format.colorToHexString(_shadedColor);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: _basicColorPalettes[e],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [5, 6, 7, 8, 9]
              .map((e) => InkWell(
                    onTap: () {
                      setState(() {
                        _shadedColor = _basicColorPalettes[e];
                        _directColorController.text =
                            Format.colorToHexString(_shadedColor);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: _basicColorPalettes[e],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 32),
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: colorPickerColors),
          ),
          child: Slider(
            value: _colorSliderPosition,
            label: (_colorSliderPosition * 100).round().toString(),
            onChanged: (value) {
              setState(() {
                _colorSliderPosition = value;
                _currentColor = _calculateSelectedColor(_colorSliderPosition);
                _shadedColor = _calculateShadedColor(_shadeSliderPosition);
                _directColorController.text =
                    Format.colorToHexString(_shadedColor);
              });
            },
            // min: 0,
            // max: 1,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                colors: [Colors.black, _currentColor, Colors.white]),
          ),
          child: Slider(
            value: _shadeSliderPosition,
            onChanged: (value) {
              setState(() {
                _shadeSliderPosition = value;
                _shadedColor = _calculateShadedColor(_shadeSliderPosition);
                _directColorController.text =
                    Format.colorToHexString(_shadedColor);
              });
            },
            // min: 0,
            // max: 1,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.currentColor != null) ...[
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: widget.currentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right_alt),
                const SizedBox(width: 8),
              ],
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: _shadedColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextFormField(
                    controller: _directColorController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixText: '#',
                    ),
                    maxLength: 6,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length != 6 ||
                          !Regex.hexColorRegex.hasMatch(value)) {
                        return widget.context.loc.enterValidColor;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (value) {
                      if (value.trim().length == 6 &&
                          Regex.hexColorRegex.hasMatch(value)) {
                        setState(() {
                          _shadedColor = Format.hexStringToColorForCat(value);
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.pop(null);
              },
              child: Text(widget.context.loc.cancel),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                context.pop(_shadedColor);
              },
              child: Text(widget.context.loc.ok),
            ),
          ],
        ),
      ],
    );
  }
}
