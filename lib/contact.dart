import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ติดต่อเรา'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        child: Text(
                          'ติดต่อ  Wash Car',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.blue,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 300,
                      child: Image.asset('images/LINE.jpg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              'ดาวน์โหลด',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Kodchasan',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Text(
                              'รีเฟรช',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Kodchasan',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        child: Text(
                          'ข้อมูลที่อยู่',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        child: Text(
                          'แผนที่',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
