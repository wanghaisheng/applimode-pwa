import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_bio_screen/edit_bio_screen_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class EditBioScreen extends ConsumerStatefulWidget {
  const EditBioScreen({
    super.key,
    required this.bio,
  });

  final String bio;

  @override
  ConsumerState<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends ConsumerState<EditBioScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.bio == noBio ? '' : widget.bio;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final result = await ref
        .read(editBioScreenControllerProvider.notifier)
        .submit(_controller.text);
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

  @override
  Widget build(BuildContext context) {
    ref.listen(editBioScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });
    final isLoading = ref.watch(editBioScreenControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.editBio),
      ),
      body: SafeArea(
        child: ResponsiveScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.loc.bio,
                ),
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const SizedCircularProgressIndicator()
                  : FilledButton(
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(CircleBorder()),
                      ),
                      onPressed: _submit,
                      child: const Icon(Icons.done),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
