import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool isSigningIn;
  final VoidCallback onPressed;
  final String? error;

  const GoogleSignInButton({
    Key? key,
    required this.isSigningIn,
    required this.onPressed,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (error != null) ...[
          Text(error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
        ],
        isSigningIn
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                // icon: Image.asset(
                //   'assets/images/icon.png',
                //   height: 24,
                //   width: 24,
                // ),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  side: const BorderSide(color: Colors.black12),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                onPressed: onPressed,
              ),
      ],
    );
  }
}
