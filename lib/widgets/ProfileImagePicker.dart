import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final ImageProvider? image;

  const ProfileImagePicker({
    super.key,
    required this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFE9EEE4),
            backgroundImage: image,
            child: image == null
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  )
                : null,
          ),

          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF6E8E68),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}