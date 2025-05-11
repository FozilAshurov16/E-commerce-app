import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final form = GlobalKey<FormState>();

  final imageForm = GlobalKey<FormState>();

  var product = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
  );

  var hasImage = true;
  var init = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final editingProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        product = editingProduct;
      }
      init = false;
    }
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Add ImageURL"),
        content: Form(
          key: imageForm,
          child: TextFormField(
            initialValue: product.imageUrl,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "ImageURL",
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter an ImageURL";
              } else if (!value.startsWith("http")) {
                return "Please enter a valid URL";
              }
              return null;
            },
            onSaved: (newValue) {
              product = Product(
                id: product.id,
                title: product.title,
                description: product.description,
                price: product.price,
                imageUrl: newValue!,
                isFavorite: product.isFavorite,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Color.fromARGB(
                  255,
                  248,
                  204,
                  102,
                ),
              ),
            ),
            child: const Text(
              "CANCEL",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(
                  255,
                  248,
                  204,
                  102,
                ),
              ),
            ),
            onPressed: saveImageForm,
            child: const Text(
              "ADD",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveImageForm() {
    final isValid = imageForm.currentState!.validate();
    if (isValid) {
      imageForm.currentState!.save();
      setState(() {
        hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = form.currentState!.validate();
    setState(() {
      hasImage = product.imageUrl.isNotEmpty;
    });

    if (isValid && hasImage) {
      form.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (product.id.isEmpty) {
          // Yangi mahsulot qo'shish
          await Provider.of<Products>(context, listen: false)
              .addProduct(product);

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop(product);
          }
        } else {
          // Mavjud mahsulotni yangilash
          await Provider.of<Products>(context, listen: false)
              .updateProduct(product);

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop(product);
          }
        }
      } catch (error) {
        // Xatolik yuz berganda
        if (mounted) {
          setState(() {
            isLoading = false;
          });

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Error!"),
              content: const Text("Something went wrong!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveForm,
          )
        ],
        centerTitle: true,
        title: const Text("Add Product"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(
                  255,
                  248,
                  204,
                  102,
                ),
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: product.title,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          product = Product(
                            id: product.id,
                            title: newValue!,
                            description: product.description,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: product.price == 0.0
                            ? ""
                            : product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Price",
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a price";
                          } else if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          } else if (double.parse(value) < 1) {
                            return "Product price must be greater than 0";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          product = Product(
                            id: product.id,
                            title: product.title,
                            description: product.description,
                            price: double.parse(newValue!),
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: product.description,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          labelText: "Description",
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a description";
                          } else if (value.length < 10) {
                            return "Description must be at least 10 characters long";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          product = Product(
                            id: product.id,
                            title: product.title,
                            description: newValue!,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: hasImage
                                ? Colors.grey
                                : Theme.of(context).colorScheme.error,
                            width: 1.0,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => showImageDialog(context),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            color: Colors.white,
                            height: 200,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: product.imageUrl.isEmpty
                                ? Text(
                                    "Please Add Image URL",
                                    style: TextStyle(
                                      color: hasImage
                                          ? Colors.black
                                          : Theme.of(context).colorScheme.error,
                                    ),
                                  )
                                : Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
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
