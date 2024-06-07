import 'package:flutter/material.dart';

class Animatedtextswitcher extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback toggleisitem;
  final bool isitem;
  const Animatedtextswitcher({super.key,required this.text1,required this.text2,required this.toggleisitem,required this.isitem});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed:toggleisitem,
        child:
            Text(key: ValueKey<bool>(isitem), isitem ? text1 : text2),
      ),
    );
  }
}