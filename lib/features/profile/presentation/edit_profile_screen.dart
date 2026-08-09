import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(
    text: MockData.currentUser.name,
  );
  final _emailController = TextEditingController(
    text: MockData.currentUser.email,
  );
  final _phoneController = TextEditingController(text: '01032280778');

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل اختيار الصورة: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF182540),
      appBar: AppBar(
        backgroundColor: const Color(0xFF182540),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF39FF14),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF39FF14,
                          ).withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: MockData.currentUser.avatarUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Color(0xFF39FF14),
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF39FF14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF182540),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF182540),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              MockData.currentUser.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'لاعب متميز',
              style: TextStyle(
                color: Color(0xFF39FF14),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),
            _EditableField(
              label: 'الاسم الكامل',
              controller: _nameController,
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _EditableField(
              label: 'البريد الإلكتروني',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _EditableField(
              label: 'رقم الهاتف',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ التغييرات بنجاح'),
                      backgroundColor: Color(0xFF39FF14),
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39FF14),
                  foregroundColor: const Color(0xFF182540),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'حفظ التغييرات',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A96A3),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF1D2C4D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF2A3C60)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon, color: const Color(0xFF39FF14), size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.edit, color: Color(0xFF8A96A3), size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
