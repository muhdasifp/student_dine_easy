import 'package:dine_ease/data/images.dart';
import 'package:dine_ease/provider/booking_provider.dart';
import 'package:dine_ease/view/booking/payment_screen.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    context.read<BookingProvider>().getAllBookings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Seat'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                headingText(title: 'Select Table'),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width,
                  child: Stack(
                    children: [
                      buildTable(
                        alignment: const Alignment(-1, -1),
                        color: value.bookingTable == 'table1'
                            ? Colors.amber
                            : Colors.green,
                        image: table1Image,
                        onTap: value.bookedTables.contains('table1')
                            ? null
                            : () {
                                value.selectMyTable('table1');
                              },
                      ),
                      buildTable(
                        alignment: const Alignment(1, -1),
                        image: table2Image,
                        color: value.bookingTable == 'table2'
                            ? Colors.amber
                            : Colors.green,
                        onTap: value.bookedTables.contains('table2')
                            ? null
                            : () {
                                value.selectMyTable('table2');
                              },
                      ),
                      buildTable(
                        alignment: Alignment.center,
                        image: table3Image,
                        color: value.bookingTable == 'table3'
                            ? Colors.amber
                            : Colors.green,
                        onTap: value.bookedTables.contains('table3')
                            ? null
                            : () {
                                value.selectMyTable('table3');
                              },
                      ),
                      buildTable(
                        alignment: const Alignment(-1, 1),
                        image: table4Image,
                        color: value.bookingTable == 'table4'
                            ? Colors.amber
                            : Colors.green,
                        onTap: value.bookedTables.contains('table4')
                            ? null
                            : () {
                                value.selectMyTable('table4');
                              },
                      ),
                      buildTable(
                        alignment: const Alignment(1, 1),
                        image: table5Image,
                        color: value.bookingTable == 'table5'
                            ? Colors.amber
                            : Colors.green,
                        onTap: value.bookedTables.contains('table5')
                            ? null
                            : () {
                                value.selectMyTable('table5');
                              },
                      ),
                    ],
                  ),
                ),
                headingText(title: 'Select TIme'),
                const SizedBox(height: 20),
                value.availableTimes.isNotEmpty
                    ? DropdownMenu(
                        width: size.width * 0.9,
                        menuStyle: MenuStyle(
                            elevation: const WidgetStatePropertyAll(5),
                            alignment: Alignment.center,
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        hintText: 'Select TIme',
                        leadingIcon: const Icon(CupertinoIcons.time),
                        onSelected: (time) {
                          value.selectMyTime(time!);
                        },
                        dropdownMenuEntries: value.availableTimes
                            .map((e) => DropdownMenuEntry(value: e, label: e))
                            .toList())
                    : const Text('Sorry no slot available'),
                const SizedBox(height: 30),
                CustomButton(
                  button: "Book Now",
                  onTap: () {
                    showBottomSheet(
                        context: context,
                        builder: (context) => const PaymentScreen());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Align buildTable({
    required Alignment alignment,
    required AssetImage image,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return Align(
      alignment: alignment,
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onTap,
        child: Image(image: image, height: 80),
      ),
    );
  }

  Text headingText({required String title}) => Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.orange,
        ),
      );
}
