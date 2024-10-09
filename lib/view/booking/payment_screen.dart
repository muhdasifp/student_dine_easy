import 'package:dine_ease/provider/booking_provider.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameOnCardController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Amount: \$100',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLength: 19,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter cart number";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 4) {
                    _cardNumberController.text += '/';
                  } else if (value.length == 9) {
                    _cardNumberController.text += '/';
                  } else if (value.length == 14) {
                    _cardNumberController.text += '/';
                  }
                },
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) =>
                    null,
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234/1234/1234/1234',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 5,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter expiry date";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 2) {
                          _expiryDateController.text += "/";
                        }
                      },
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              required maxLength}) =>
                          null,
                      controller: _expiryDateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)*',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.length != 3) {
                          return "enter valid CVV";
                        }
                        return null;
                      },
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVV*',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter name";
                  }
                  return null;
                },
                controller: _nameOnCardController,
                decoration: const InputDecoration(
                  labelText: 'Name on Card*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                button: 'Pay Now',
                onTap: () {
                  final provider =
                      Provider.of<MyProvider>(context, listen: false);
                  final user = Provider.of<UserProvider>(context, listen: false)
                      .currentUser;

                  if (formKey.currentState!.validate()) {
                    provider.toggle();
                    context
                        .read<BookingProvider>()
                        .bookTable(
                          generateRandomString(12),
                          user.name.toString(),
                          user.number.toString(),
                        )
                        .then((value) {
                      provider.toggle();
                    }).onError((error, stackTrace) {
                      provider.toggle();
                      snackMessage(message: error.toString(), context: context);
                    });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
