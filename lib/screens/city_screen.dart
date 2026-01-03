import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController controller = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000428),
                Color(0xFF004e92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // 🔙 BACK BUTTON
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),

                      const SizedBox(height: 40),

                      // 🏙 TITLE
                      const Text(
                        'Search City',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Enter the city name to get weather info',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 🧊 INPUT CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. Kolkata',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.location_city,
                              color: Colors.white70,
                            ),
                          ),
                          onSubmitted: (_) => _submitCity(context),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🚀 CTA BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _submitCity(context),
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'Get Weather',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitCity(BuildContext context) {
    if (controller.text.trim().isEmpty) return;
    Navigator.pop(context, controller.text.trim());
  }
}
