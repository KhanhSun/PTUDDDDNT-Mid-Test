import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();

  final imageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      await provider.fetchUser();

      if (provider.userModel != null) {
        nameController.text = provider.userModel!.name;

        imageController.text = provider.userModel!.imageUrl;

        setState(() {});
      }
    });
  }

  Future<void> saveProfile() async {
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      await provider.updateProfile(
        name: nameController.text.trim(),
        imageUrl: imageController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile Updated')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: imageController.text.isNotEmpty
                  ? NetworkImage(imageController.text)
                  : null,
              child: imageController.text.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: imageController,
              decoration: InputDecoration(
                hintText: 'Image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
