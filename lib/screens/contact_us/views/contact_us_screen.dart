import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            // Header Section
            ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF005D40), Color.fromARGB(255, 2, 161, 71)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Contact ",
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          TextSpan(
                            text: "6amMart",
                            style: TextStyle(
                              fontSize: 28,
                              color: const Color.fromARGB(255, 7, 142, 45),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We're here and ready to help whenever you need us!",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _ContactItem(
                          icon: FontAwesomeIcons.whatsapp,
                          text: '+8801810494911',
                        ),
                        _ContactItem(
                          icon: Icons.email,
                          text: 'support@6amtech.com',
                        ),
                        _ContactItem(
                          icon: Icons.location_on,
                          text: 'Dhaka 1216, BD',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),

            // Help Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Need Help? ',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: 'We’re Here to Assist You',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Our expert team helps you with proper solutions for all.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            backgroundColor: const Color(0xFF00B56A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit a Ticket',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/6ammart.webp',
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // FAQ Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Frequently Asked ",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: "Questions",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Here are some very basic technical issues we receive.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // FAQ Tiles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: const [
                      _FaqTile(
                        question:
                            '1. Do You Offer 6amMart Customization Services?',
                        answer:
                            'Certainly! Our expert customization team is ready to take whatever your customization is.',
                      ),
                      SizedBox(height: 12),
                      _FaqTile(
                        question: '2. How Do I Connect with The 6amMart Team?',
                        answer:
                            'If you are stuck and need help, just send us a message by creating a support ticket. We have got your back!',
                      ),
                      SizedBox(height: 12),
                      _FaqTile(
                        question:
                            '3. Where Can I Find Documentation Available for 6amMart?',
                        answer:
                            'You will find all the detailed and technical documentation here.',
                      ),
                      SizedBox(height: 12),
                      _FaqTile(
                        question: '4. I Need To Install 6amMart. Can You Help?',
                        answer:
                            'You can check the installation plans we offer and choose the one that suits you the best.',
                      ),
                    ],
                  ),
                ),
                // CTA Section (Call to Action)
                const SizedBox(height: 38),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Container(
                      width: 1500, // ปรับขนาดความกว้างของกล่อง
                      padding: const EdgeInsets.symmetric(
                        vertical: 100,
                        horizontal: 84,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF014C32), Color(0xFF00B56A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // เพิ่มความโค้งมุมกล่อง
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Build Your eCommerce',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Business Today!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Join Now',
                              style: TextStyle(
                                color: Color(0xFF00B56A),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromARGB(168, 199, 246, 200),
              borderRadius: BorderRadius.circular(10),
            ), //บ็อกไอคอน
            child: Icon(icon, color: Colors.white), //สีไอคอน
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isExpanded ? Colors.green : Colors.green.shade100,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          if (!_isExpanded)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(4),
          child: Icon(
            _isExpanded ? Icons.remove : Icons.add,
            color: Colors.white,
            size: 16,
          ),
        ),
        title: Text(
          widget.question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              widget.answer,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 50);

    path.cubicTo(
      size.width * 0.25,
      size.height + 20, // control point 1
      size.width * 0.75,
      size.height - 100, // control point 2
      size.width,
      size.height - 40, // end point
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
