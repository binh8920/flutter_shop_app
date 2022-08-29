import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid != null && isValid == false) {
      return;
    }
    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(children: <Widget>[
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the product title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue.toString(),
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value.toString()) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value.toString()) <= 0) {
                        return 'Please enter a number greater than zero';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue.toString()),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue.toString(),
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 30, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter an image URL')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.contain,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          //can't use initialValues and controller at the same time
                          // initialValue: _initValues['imageUrl'],
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an image URL';
                            }
                            if (!value.toString().startsWith('http') &&
                                !value.toString().startsWith('https')) {
                              return 'Please enter a valid image uRL';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue.toString(),
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ),
    );
  }
}
