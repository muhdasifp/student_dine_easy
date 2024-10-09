import 'package:dine_ease/provider/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final String button;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.button, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (_, value, __) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.orange),
            child: value.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    button,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
