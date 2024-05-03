import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBox extends HookConsumerWidget {
  final Widget icon;
  final String text;
  final double height;
  final double width;
  final Function()? onTap;
  final bool isRow;

  const AppBox({
    super.key,
    required this.icon,
    required this.text,
    required this.height,
    required this.width,
    this.onTap,
    this.isRow = false,
  });

  @override
  Widget build(context, ref) {
    final press = useState(false);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTapDown: (_) => press.value = true,
        onTapCancel: () => press.value = false,
        onTapUp: (_) => press.value = false,
        onTap: Feedback.wrapForTap(onTap, context),
        child: Container(
          decoration: BoxDecoration(
            color: press.value
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          width: width,
          height: height,
          child:
              isRow ? _buildRowContent(context) : _buildColumnContent(context),
        ),
      ),
    );
  }

  Widget _buildRowContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        _buildText(context),
      ],
    );
  }

  Widget _buildColumnContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        _buildText(context),
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.mPlusRounded1c(
        textStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}
