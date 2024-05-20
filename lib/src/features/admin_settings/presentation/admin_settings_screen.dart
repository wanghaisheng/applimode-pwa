import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/show_color_picker.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/src/utils/show_selection_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

enum HomeBarTitleStyle {
  text,
  image,
  textimage;
}

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  late int _titleStyle;
  late String _titleImageUrl;
  XFile? _pickedFile;
  late Color _mainColor;
  final List<CategoryController> _categories = [];

  @override
  void initState() {
    super.initState();
    final currentValues = ref.read(adminSettingsProvider);
    _titleTextController.text = currentValues.homeBarTitle;
    _titleStyle =
        List<int>.generate(HomeBarTitleStyle.values.length, (index) => index)
                .contains(currentValues.homeBarStyle)
            ? currentValues.homeBarStyle
            : 0;
    _titleImageUrl = currentValues.homeBarImageUrl;
    _mainColor = currentValues.mainColor;
    for (final mainCategory in currentValues.mainCategory) {
      final index = mainCategory.index;
      debugPrint('index: $index');
      _categories.add(
        CategoryController(
          index: index,
          pathController: TextEditingController(),
          titleController: TextEditingController(),
          color: mainCategory.color,
        ),
      );
      _categories[index].pathController.text =
          currentValues.mainCategory[index].path.substring(1);
      _categories[index].titleController.text =
          currentValues.mainCategory[index].title;
    }
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    for (final category in _categories) {
      category.pathController.dispose();
      category.titleController.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final mainCategory = _categories
          .map((e) => MainCategory(
                index: e.index,
                path: '/${e.pathController.text}',
                title: e.titleController.text,
                color: e.color,
              ))
          .toList();
      debugPrint('mainCategory: $mainCategory');
      final result = await ref
          .read(adminSettingsScreenControllerProvider.notifier)
          .saveAdminSettings(
            homeBarTitle: _titleTextController.text,
            homeBarStyle: _titleStyle,
            mainColor: _mainColor,
            mainCategory: mainCategory,
            xFile: _pickedFile,
          );
      if (mounted && result) {
        if (kIsWeb) {
          WebBackStub().back();
        } else {
          if (context.canPop()) {
            context.pop();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adminSettingsScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });

    final isLoading =
        ref.watch(adminSettingsScreenControllerProvider).isLoading;

    final titleHeaderStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.adminSettings),
      ),
      body: SafeArea(
        child: ResponsiveScrollView(
          child: Form(
            key: _formKey,
            child: IgnorePointer(
              ignoring: isLoading ? true : false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.loc.homeTitleSetting,
                        style: titleHeaderStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor:
                        ColorScheme.fromSeed(seedColor: _mainColor).surface,
                    surfaceTintColor:
                        ColorScheme.fromSeed(seedColor: _mainColor).surfaceTint,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_titleStyle == 1 || _titleStyle == 2)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: mainScreenAppBarPadding),
                            child: SizedBox(
                              height: mainScreenAppBarHeight -
                                  2 * mainScreenAppBarPadding,
                              child: _pickedFile != null
                                  ? FlatformImage(
                                      xFile: _pickedFile!,
                                      hPadding: 0,
                                      vPadding: 0,
                                    )
                                  : _titleImageUrl.startsWith('assets')
                                      ? Image.asset(_titleImageUrl)
                                      : PlatformNetworkImage(
                                          imageUrl: _titleImageUrl,
                                          /*
                          cacheHeight: (mainScreenAppBarHeight -
                                  2 * mainScreenAppBarPadding)
                              .round(),
                          */
                                          errorWidget: const SizedBox.shrink(),
                                        ),
                            ),
                          ),
                        if (_titleStyle == 2) const SizedBox(width: 8),
                        if (_titleStyle == 0 || _titleStyle == 2)
                          Text(_titleTextController.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MenuAnchor(
                          builder: (context, controller, child) {
                            return FilledButton.tonal(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ))),
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  FocusScope.of(context).unfocus();
                                  controller.open();
                                }
                              },
                              child: Text(
                                _getTitleStyleString(
                                    HomeBarTitleStyle.values[_titleStyle]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () {
                                setState(() {
                                  _titleStyle = 0;
                                });
                              },
                              child: Text(context.loc.textStyle),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                setState(() {
                                  _titleStyle = 1;
                                });
                              },
                              child: Text(context.loc.imageStyle),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                setState(() {
                                  _titleStyle = 2;
                                });
                              },
                              child: Text(context.loc.textImageStyle),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.tonal(
                          style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            showSelectionDialog(
                              context: context,
                              firstTitle: context.loc.defaultImage,
                              firstTap: () async {
                                context.pop();
                                setState(() {
                                  _titleImageUrl = spareHomeBarImageUrl;
                                  _pickedFile = null;
                                });
                              },
                              secondTitle: context.loc.chooseFromGallery,
                              secondTap: () async {
                                context.pop();
                                _pickedFile = await showImagePicker(
                                  maxHeight: 128,
                                );
                                setState(() {});
                              },
                            );
                          },
                          child: Text(context.loc.changeHomeAppBarTitleImage),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: context.loc.homeAppBarTitleText,
                    ),
                    maxLength: 32,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.loc.enterTitle;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        context.loc.mainColorSetting,
                        style: titleHeaderStyle,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(_mainColor),
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ))),
                          onPressed: () async {
                            final selectedColor = await showColorPicker(
                              context: context,
                              currentColor: _mainColor,
                            );
                            if (selectedColor != null) {
                              setState(() {
                                _mainColor = selectedColor;
                              });
                            }
                          },
                          child: Text(context.loc.changeMainColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        context.loc.categorySetting,
                        style: titleHeaderStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ..._categories.map(
                    (controller) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.pathController,
                                decoration: InputDecoration(
                                  labelText: context.loc.pathName,
                                  // helperText: context.loc.onlyLowercase,
                                  hintText: context.loc.onlyLowercase,
                                  prefixText: '/',
                                  border: const OutlineInputBorder(),
                                ),
                                maxLength: 24,
                                validator: (value) {
                                  final paths = _categories
                                      .map((e) => e.pathController.text)
                                      .toList();
                                  final pathsSet = paths.toSet();
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      Regex.urlPathStringRegex
                                          .hasMatch(value)) {
                                    return context.loc.invalidName;
                                  }
                                  if (paths.length != pathsSet.length) {
                                    return context.loc.duplicateName;
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: controller.titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title name',
                                  border: OutlineInputBorder(),
                                ),
                                maxLength: 24,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return context.loc.invalidName;
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            const SizedBox(width: 16),
                            /*
                            InkWell(
                              onTap: () async {
                                final selectedColor = await showColorPicker(
                                  context: context,
                                  currentColor: _mainColor,
                                  colorPalettes: boxSingleColorPalettes,
                                );
                                if (selectedColor != null) {
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: controller.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            */
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            setState(() {
                              final currentIndex = _categories.length;
                              _categories.add(
                                CategoryController(
                                  index: currentIndex,
                                  pathController: TextEditingController(),
                                  titleController: TextEditingController(),
                                  color: boxSingleColorPalettes[
                                      _categories.length %
                                          boxSingleColorPalettes.length],
                                ),
                              );
                              debugPrint('index: $currentIndex');
                              final indexForName = (_categories.length)
                                  .toString()
                                  .padLeft(3, '0');
                              _categories[currentIndex].pathController.text =
                                  'cat$indexForName';
                              _categories[currentIndex].titleController.text =
                                  'cat$indexForName';
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.loc.addCategory),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            if (_categories.length > 1) {
                              setState(() {
                                // remove controllers
                                _categories.last.pathController.dispose();
                                _categories.last.titleController.dispose();
                                _categories.removeLast();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove),
                          label: Text(context.loc.deleteCategory),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? const SizedCircularProgressIndicator()
                          : Expanded(
                              child: FilledButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(context.loc.save),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitleStyleString(HomeBarTitleStyle style) {
    switch (style) {
      case HomeBarTitleStyle.text:
        return context.loc.textStyle;
      case HomeBarTitleStyle.image:
        return context.loc.imageStyle;
      case HomeBarTitleStyle.textimage:
        return context.loc.textImageStyle;
    }
  }
}

class CategoryController {
  const CategoryController({
    required this.index,
    required this.pathController,
    required this.titleController,
    required this.color,
  });

  final int index;
  final TextEditingController pathController;
  final TextEditingController titleController;
  final Color color;
}
