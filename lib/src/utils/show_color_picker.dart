import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
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
  double _colorSliderPosition = 0.5;
  double _shadeSliderPosition = 0.5;
  Color _currentColor = Format.hexStringToColor(spareMainColor);
  Color _shadedColor = Format.hexStringToColor(spareMainColor);
  List<Color> _basicColorPalettes = colorPickerBasicPalettes;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    // _currentColor = _calculateSelectedColor(_colorSliderPosition);
    _currentColor =
        widget.currentColor ?? _calculateSelectedColor(_colorSliderPosition);
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    _directColorController.text = Format.colorToHexString(_shadedColor);
    _basicColorPalettes = widget.colorPalettes ?? colorPickerBasicPalettes;
  }

  @override
  void dispose() {
    _isCancelled = true;
    _directColorController.dispose();
    super.dispose();
  }

  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  Color _calculateShadedColor(double position) {
    try {
      if (position > 0.5) {
        //Calculate new color (values converge to 255 to make the color lighter)
        double redVal = _currentColor.r != 1.0
            ? (_currentColor.r +
                (1.0 - _currentColor.r) * (position - 0.5) / 0.5)
            : 1.0;
        double greenVal = _currentColor.g != 1.0
            ? (_currentColor.g +
                (1.0 - _currentColor.g) * (position - 0.5) / 0.5)
            : 1.0;
        double blueVal = _currentColor.b != 1.0
            ? (_currentColor.b +
                (1.0 - _currentColor.b) * (position - 0.5) / 0.5)
            : 1.0;
        return Color.from(
            alpha: 1.0, red: redVal, green: greenVal, blue: blueVal);
      } else if (position < 0.5) {
        //Calculate new color (values converge to 0 to make the color darker)
        double redVal =
            _currentColor.r != 0.0 ? (_currentColor.r * position / 0.5) : 0.0;
        double greenVal =
            _currentColor.g != 0.0 ? (_currentColor.g * position / 0.5) : 0.0;
        double blueVal =
            _currentColor.b != 0.0 ? (_currentColor.b * position / 0.5) : 0.0;
        return Color.from(
            alpha: 1.0, red: redVal, green: greenVal, blue: blueVal);
      } else {
        //return the base color
        return _currentColor;
      }
    } catch (e) {
      debugPrint(
          'CustomColorPicker-_calculateShadedColor-error: ${e.toString()}');
      return Format.hexStringToColor(spareMainColor);
    }
  }

  Color _calculateSelectedColor(double position) {
    try {
      //determine color
      double positionInColorArray = (position * (colorPickerColors.length - 1));
      int index = positionInColorArray.truncate();
      double remainder = positionInColorArray - index;
      if (remainder == 0.0) {
        _currentColor = colorPickerColors[index];
      } else {
        //calculate new color
        double redValue = colorPickerColors[index].r ==
                colorPickerColors[index + 1].r
            ? colorPickerColors[index].r
            : (colorPickerColors[index].r +
                (colorPickerColors[index + 1].r - colorPickerColors[index].r) *
                    remainder);
        double greenValue = colorPickerColors[index].g ==
                colorPickerColors[index + 1].g
            ? colorPickerColors[index].g
            : (colorPickerColors[index].g +
                (colorPickerColors[index + 1].g - colorPickerColors[index].g) *
                    remainder);
        double blueValue = colorPickerColors[index].b ==
                colorPickerColors[index + 1].b
            ? colorPickerColors[index].b
            : (colorPickerColors[index].b +
                (colorPickerColors[index + 1].b - colorPickerColors[index].b) *
                    remainder);
        _currentColor = Color.from(
            alpha: 1.0, red: redValue, green: greenValue, blue: blueValue);
      }
      return _currentColor;
    } catch (e) {
      debugPrint(
          'CustomColorPicker-_calculateSelectedColor-error: ${e.toString()}');
      return Format.hexStringToColor(spareMainColor);
    }
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
                      _currentColor = _basicColorPalettes[e];
                      _shadeSliderPosition = 0.5;
                      _shadedColor =
                          _calculateShadedColor(_shadeSliderPosition);
                      _directColorController.text =
                          Format.colorToHexString(_shadedColor);
                      _safeSetState();
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
                      _currentColor = _basicColorPalettes[e];
                      _shadeSliderPosition = 0.5;
                      _shadedColor =
                          _calculateShadedColor(_shadeSliderPosition);
                      _directColorController.text =
                          Format.colorToHexString(_shadedColor);
                      _safeSetState();
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
            // label: (_colorSliderPosition * 100).round().toString(),
            onChanged: (value) {
              _colorSliderPosition = value;
              _currentColor = _calculateSelectedColor(_colorSliderPosition);
              _shadedColor = _calculateShadedColor(_shadeSliderPosition);
              _directColorController.text =
                  Format.colorToHexString(_shadedColor);
              _safeSetState();
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
              _shadeSliderPosition = value;
              _shadedColor = _calculateShadedColor(_shadeSliderPosition);
              _directColorController.text =
                  Format.colorToHexString(_shadedColor);
              _safeSetState();
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
                        _currentColor = Format.hexStringToColor(value);
                        _shadeSliderPosition = 0.5;
                        _shadedColor =
                            _calculateShadedColor(_shadeSliderPosition);
                        _safeSetState();
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

/*
const List<Color> colorPickerColors = [
  Color.fromARGB(255, 255, 0, 0),
  Color.fromARGB(255, 255, 128, 0),
  Color.fromARGB(255, 255, 255, 0),
  Color.fromARGB(255, 128, 255, 0),
  Color.fromARGB(255, 0, 255, 0),
  Color.fromARGB(255, 0, 255, 128),
  Color.fromARGB(255, 0, 255, 255),
  Color.fromARGB(255, 0, 128, 255),
  Color.fromARGB(255, 0, 0, 255),
  Color.fromARGB(255, 127, 0, 255),
  Color.fromARGB(255, 255, 0, 255),
  Color.fromARGB(255, 255, 0, 127),
  Color.fromARGB(255, 128, 128, 128),
];
*/

const List<Color> colorPickerColors = [
  Color.from(alpha: 1.0, red: 0.0, green: 0.0, blue: 0.0), // Black
  Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 0.0), // Red
  Color.from(alpha: 1.0, red: 1.0, green: 0.5, blue: 0.0), // Orange
  Color.from(alpha: 1.0, red: 1.0, green: 1.0, blue: 0.0), // Yellow
  Color.from(alpha: 1.0, red: 0.0, green: 1.0, blue: 0.0), // Green
  Color.from(alpha: 1.0, red: 0.0, green: 1.0, blue: 1.0), // Cyan
  Color.from(alpha: 1.0, red: 0.0, green: 0.0, blue: 1.0), // Blue
  Color.from(alpha: 1.0, red: 0.5, green: 0.0, blue: 1.0), // Purple
  Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 1.0), // Magenta
  Color.from(alpha: 1.0, red: 1.0, green: 1.0, blue: 1.0), // White
];
