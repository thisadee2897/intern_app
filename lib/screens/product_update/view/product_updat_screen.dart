import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ProductUpdatScreen extends StatefulWidget {
  const ProductUpdatScreen({super.key});

  @override
  State<ProductUpdatScreen> createState() => _ProductUpdatScreenState();
}

class _ProductUpdatScreenState extends State<ProductUpdatScreen> {
  bool isNotRobot = false;
  String? hoveredCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SelectableText(
                      'Update',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 11, 12, 14),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 240,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xfff5fff8),
                          hintText: 'Search...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/1.png',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24),
                          newsCard(
                            version: '2.7',
                            title:
                                '6amMart v2.7: Cashback to Wallet & Extra Packaging Charge',
                            date: 'April 9, 2025',
                            content:
                                'The 6amMart team brings another exciting news for its existing and new users with the release of version 2.7. The new version brings a fresh wave of features designed specifically to level up the multi vendor delivery business experience. This update is packed with improvements for everyone involved – admins, stores, and customers alike. So ',
                          ),
                          const SizedBox(height: 16),
                          Image.asset(
                            'assets/images/5.png',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24),
                          newsCard(
                            version: '2.8',
                            title:
                                '6amMart v2.8: Subscription Model & 3rd Party Storage',
                            date: 'April 9, 2025',
                            content:
                                'Great news for all 6amMart users! The team 6amMart announces the release of version 2.8, packed with exciting new features designed to enhance your eCommerce experience. This update brings advantages to all the stakeholders of the system – especially the store owners and customers. The new updates offer greater flexibility, improved customer interaction, and efficient ... ',
                          ),
                          const SizedBox(height: 16),
                          Image.asset(
                            'assets/images/6.webp',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24),
                          newsCard(
                            version: '',
                            title:
                                'Introducing 6amMart’s Latest Launch: Car Rental Module Addon',
                            date: 'March 8, 2025',
                            content:
                                'Team 6amMart has officially launched the 6amMart Car Rental Module Addon! This innovative addition comes with powerful features designed to enhance the car rental business. Take a closer look at the exciting new functionalities 6amMart introduced for the rental module  Let’s take a detailed look at these- System Addon Customers receive the addon as a …',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SelectableText(
                            'Recent Posts',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 6, 7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...[
                            {
                              'title':
                                  '8 Best Car Rental Software Solutions for 2025',
                              'date': 'May 26, 2025',
                              'image': 'assets/images/2.webp',
                            },
                            {
                              'title':
                                  'eCommerce Inventory Management: Best Techniques & Practices',
                              'date': 'May 8, 2025',
                              'image': 'assets/images/3.webp',
                            },
                            {
                              'title':
                                  'Discover the Best Zid Alternatives for eCommerce Success',
                              'date': 'May 5, 2025',
                              'image': 'assets/images/4.webp',
                            },
                            {
                              'title':
                                  'How to Start a Car Rental Business: Step-by-Step Guide',
                              'date': 'March 20, 2025',
                              'image': 'assets/images/7.webp',
                            },
                            {
                              'title':
                                  'Introducing 6amMart’s Latest Launch: Car Rental Module Addon',
                              'date': 'February 27, 2025',
                              'image': 'assets/images/8.webp',
                            },
                          ].map(
                            (post) => StatefulBuilder(
                              builder: (context, setState) {
                                bool isHovering = false;
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter:
                                      (_) => setState(() => isHovering = true),
                                  onExit:
                                      (_) => setState(() => isHovering = false),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          post['image']!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['title']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  decoration:
                                                      isHovering
                                                          ? TextDecoration
                                                              .underline
                                                          : TextDecoration.none,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                post['date']!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 80),
                          const SelectableText(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 8, 9, 10),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              categoryChip('Comparison'),
                              categoryChip('Featured'),
                              categoryChip('Guides'),
                              categoryChip('Informative'),
                              categoryChip('Update'),
                            ],
                          ),
                          const SizedBox(height: 48),
                          const SelectableText(
                            'Subscribe',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 4, 5, 5),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Your Name*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Your Email*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNotRobot,
                                  onChanged: (value) {
                                    setState(() {
                                      isNotRobot = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text("I'm not a robot"),
                                const Spacer(),
                                const FlutterLogo(size: 24),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newsCard({
    required String version,
    required String title,
    required String date,
    required String content,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffe4e8ff),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Update',
              style: TextStyle(
                color: Color(0xff001F5B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SelectableText(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SelectableText(
                'by Editorial Team',
                style: TextStyle(
                  color: Colors.teal,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(width: 12),
              SelectableText(date, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          SelectableText.rich(
            TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              children: [
                TextSpan(text: content),
                TextSpan(
                  text: 'Read more',
                  style: const TextStyle(color: Colors.green),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // Read more logic
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryChip(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredCategory = label),
      onExit: (_) => setState(() => hoveredCategory = null),
      child: Chip(
        label: Text(label),
        backgroundColor:
            hoveredCategory == label ? Colors.green.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.green),
        ),
        labelStyle: TextStyle(
          color:
              hoveredCategory == label ? Colors.green.shade700 : Colors.green,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
