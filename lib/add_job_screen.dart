import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/models/product.dart';
import 'package:provider/provider.dart';

class AddJobScreen extends StatefulWidget {
  final String profileId;
  final Product? product;

  const AddJobScreen({super.key, required this.profileId, this.product});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _productDescription;
  late double _productPrice;
  late String _productLocation;
  File? _productImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productName = widget.product!.name;
      _productDescription = widget.product!.description;
      _productPrice = widget.product!.price;
      _productLocation = widget.product!.location;
      _imageUrl = widget.product!.imageId;
    } else {
      _productName = '';
      _productDescription = '';
      _productPrice = 0.0;
      _productLocation = '';
      _imageUrl = null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
        _imageUrl = null;
      });
    }
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        final appwriteService = context.read<AppwriteService>();
        String? imageId = widget.product?.imageId;

        if (_productImage != null) {
          final file = await appwriteService.uploadFile(
            bytes: await _productImage!.readAsBytes(),
            filename: _productImage!.path.split('/').last,
          );
          imageId = file.$id;
        }

        if (widget.product != null) {
          await appwriteService.updateProduct(
            productId: widget.product!.id,
            data: {
              'name': _productName,
              'description': _productDescription,
              'price': _productPrice,
              'location': _productLocation,
              if (imageId != null) 'imageId': imageId,
            },
          );
        } else {
          await appwriteService.createProduct(
            name: _productName,
            description: _productDescription,
            price: _productPrice,
            profileId: widget.profileId,
            location: _productLocation,
            imageId: imageId,
          );
        }

        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              widget.product != null
                  ? 'Product updated successfully!'
                  : 'Product added successfully!',
            ),
          ),
        );
        navigator.pop();
      } catch (e) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to submit product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appwriteService = context.read<AppwriteService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_productImage != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_productImage!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                else if (_imageUrl != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          appwriteService.getFileViewUrl(_imageUrl!),
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _productName,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a product name' : null,
                  onSaved: (value) => _productName = value ?? '',
                ),
                TextFormField(
                  initialValue: _productDescription,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter a product description'
                      : null,
                  onSaved: (value) => _productDescription = value ?? '',
                ),
                TextFormField(
                  initialValue: _productPrice.toString(),
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                  onSaved: (value) =>
                      _productPrice = double.tryParse(value ?? '') ?? 0.0,
                ),
                TextFormField(
                  initialValue: _productLocation,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
                  onSaved: (value) => _productLocation = value ?? '',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProduct,
                  child: Text(
                    widget.product != null ? 'Update Product' : 'Add Product',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
