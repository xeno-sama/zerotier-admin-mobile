import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///! BUTTONS
class ButtonBack extends StatelessWidget {
  const ButtonBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(Icons.arrow_back_ios),
    );
  }
}

class ElevatedCustomButton extends StatelessWidget {
  const ElevatedCustomButton({
    required this.function,
    required this.text,
    super.key,
  });
  final Function function;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => function,
      child: Text(text),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}

class ElevatedIconButton extends StatelessWidget {
  const ElevatedIconButton({
    required this.function,
    required this.text,
    required this.icon,
    super.key,
  });
  final VoidCallback function;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            // color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              // color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.only(left: 6, top: 6, right: 8, bottom: 6),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}

SnackBar snackBarText(String text, BuildContext context) {
  return SnackBar(
    content: Text(text),
    backgroundColor: Theme.of(context).colorScheme.surface,
    duration: const Duration(milliseconds: 500),
  );
}

///! DIVIDERS
Divider standartDivider(BuildContext context) {
  return Divider(
    height: 10,
    color: Theme.of(context).colorScheme.inversePrimary,
    thickness: .3,
    // indent: 16,
    // endIndent: 16,
  );
}

Divider wideDivider(BuildContext context) {
  return Divider(
    height: 32,
    color: Theme.of(context).colorScheme.inversePrimary,
    thickness: .3,
  );
}

///! WEB CONSTRAINT
class WebConstraint extends StatelessWidget {
  const WebConstraint({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, minWidth: 400),
          child: child,
        ),
      ),
    );
  }
}

Widget backgroundLight = SvgPicture.asset(
  'assets/svg/back_light.svg',
  fit: BoxFit.fill,

  // colorFilter:
  //     ColorFilter.mode(Colors.blueAccent.withOpacity(0.09), BlendMode.srcIn),
);

Widget backgroundDark = SvgPicture.asset(
  'assets/svg/back_dark.svg',
  fit: BoxFit.fill,
);

class ColorOption extends StatelessWidget {
  final Color color;

  const ColorOption({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
