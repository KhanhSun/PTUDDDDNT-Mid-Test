import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  bool isLoading = false;

  Future<void> saveProduct() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final priceText = priceController.text.trim();
    final imageUrl = imageController.text.trim();

    // VALIDATION
    if (name.isEmpty ||
        description.isEmpty ||
        priceText.isEmpty ||
        imageUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));

      return;
    }

    // PRICE VALIDATION
    final price = double.tryParse(priceText);

    if (price == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Price must be a number')));

      return;
    }

    setState(() {
      isLoading = true;
    });

    final product = ProductModel(
      id: '',
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).addProduct(product);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // IMAGE URL
            TextField(
              controller: imageController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Image URL',
                prefixIcon: const Icon(Icons.image),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // IMAGE PREVIEW
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageController.text.isEmpty
                    ? 'https://via.placeholder.com/300'
                    : imageController.text,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 80),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // PRODUCT NAME
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Product Name',
                prefixIcon: const Icon(Icons.shopping_bag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DESCRIPTION
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Price',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProduct,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Product',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
