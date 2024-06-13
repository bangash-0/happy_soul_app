import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import '../../constants.dart';

class QuoteDisplay extends StatelessWidget {
  static const String id = 'quote_display';
  QuoteDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final text = ModalRoute.of(context)?.settings.arguments;
    var imageUrl = '';

    if (text is String) {
      imageUrl = text;
    }

    return Scaffold(
      body: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          ),
        ),
        onPressed: null,
        onLongPress: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
