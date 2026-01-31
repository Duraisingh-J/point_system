import 'package:flutter/material.dart';

class OverallAmount extends StatefulWidget {
  const OverallAmount({super.key});

  @override
  State<OverallAmount> createState() => _OverallAmountState();
}

class _OverallAmountState extends State<OverallAmount> {
  DateTime? _selectedDate = DateTime.now();

  void _datePicker() async {
    final now = DateTime.now();
    final initialDate = DateTime(2025, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: initialDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate ?? _selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1.0),
      ),
      shadowColor: Colors.black,
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 150,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text('₹ xxxxx', style: TextStyle(fontSize: 25)),
                ),
                SizedBox(height: 7),
                Divider(color: Colors.black, thickness: 1),
                SizedBox(height: 3),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Income : ₹ xxxx',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                    ),
                    Spacer(),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [// Blue
                            Color.fromARGB(255, 233, 30, 30),
                            Color.fromARGB(255, 236, 64, 122),
                          ],
                        ).createShader(bounds);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Pending : ₹ xxxx',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Required for ShaderMask
                            shadows: [
                              Shadow(
                                // ignore: deprecated_member_use
                                color: Colors.purpleAccent.withOpacity(0.4),
                                offset: Offset(0, 0),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: GestureDetector(
              onTap: _datePicker,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(91, 0, 0, 0),
                ),
                child: Text(
                  '${_selectedDate!.day} - ${_selectedDate!.month} - ${_selectedDate!.year}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
