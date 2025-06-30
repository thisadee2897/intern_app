import 'package:flutter/material.dart';
import 'dart:math' as math;

class AbstractBackground extends StatelessWidget {
  final Widget child;
  final bool isLeftSide;

  const AbstractBackground({
    super.key,
    required this.child,
    this.isLeftSide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isLeftSide ? Alignment.topLeft : Alignment.topRight,
          end: isLeftSide ? Alignment.bottomRight : Alignment.bottomLeft,
          colors: isLeftSide 
            ? [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.6),
              ]
            : [
                Colors.grey.shade50,
                Colors.white,
                Colors.grey.shade100,
              ],
        ),
      ),
      child: Stack(
        children: [
          // Abstract shapes
          if (isLeftSide) ...[
            _buildAbstractShape(
              context,
              top: -100,
              left: -100,
              size: 200,
              color: Colors.white.withOpacity(0.1),
            ),
            _buildAbstractShape(
              context,
              top: 100,
              right: -50,
              size: 150,
              color: Colors.white.withOpacity(0.08),
            ),
            _buildAbstractShape(
              context,
              bottom: 50,
              left: -50,
              size: 180,
              color: Colors.white.withOpacity(0.05),
            ),
            _buildAbstractShape(
              context,
              bottom: -80,
              right: -80,
              size: 160,
              color: Colors.white.withOpacity(0.12),
            ),
          ] else ...[
            _buildAbstractShape(
              context,
              top: -80,
              right: -80,
              size: 160,
              color: Theme.of(context).primaryColor.withOpacity(0.03),
            ),
            _buildAbstractShape(
              context,
              top: 150,
              left: -50,
              size: 120,
              color: Theme.of(context).primaryColor.withOpacity(0.05),
            ),
            _buildAbstractShape(
              context,
              bottom: 100,
              right: -60,
              size: 140,
              color: Theme.of(context).primaryColor.withOpacity(0.04),
            ),
          ],
          
          // Floating particles
          ..._buildFloatingParticles(context),
          
          // Content
          child,
        ],
      ),
    );
  }

  Widget _buildAbstractShape(
    BuildContext context, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingParticles(BuildContext context) {
    final List<Widget> particles = [];
    
    // Create floating particles
    for (int i = 0; i < 8; i++) {
      particles.add(
        Positioned(
          top: (i * 80.0) + 50,
          left: (i % 2 == 0) ? 50 + (i * 30.0) : null,
          right: (i % 2 == 1) ? 50 + (i * 25.0) : null,
          child: Container(
            width: 6 + (i % 3) * 2,
            height: 6 + (i % 3) * 2,
            decoration: BoxDecoration(
              color: isLeftSide 
                ? Colors.white.withOpacity(0.3)
                : Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }
    
    return particles;
  }
}

// Animated floating bubbles for more dynamic effect
class AnimatedFloatingBubbles extends StatefulWidget {
  final bool isLeftSide;
  
  const AnimatedFloatingBubbles({
    super.key,
    this.isLeftSide = false,
  });

  @override
  State<AnimatedFloatingBubbles> createState() => _AnimatedFloatingBubblesState();
}

class _AnimatedFloatingBubblesState extends State<AnimatedFloatingBubbles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) => AnimationController(
      duration: Duration(seconds: 3 + index),
      vsync: this,
    ));
    
    _animations = _controllers.map((controller) => 
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
    ).toList();
    
    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _animations.asMap().entries.map((entry) {
        int index = entry.key;
        Animation<double> animation = entry.value;
        
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              top: 100 + (index * 120.0) + (animation.value * 30),
              left: widget.isLeftSide 
                ? 100 + (index * 50.0) + (animation.value * 20)
                : null,
              right: !widget.isLeftSide 
                ? 100 + (index * 50.0) + (animation.value * 20)
                : null,
              child: Transform.rotate(
                angle: animation.value * math.pi * 2,
                child: Container(
                  width: 12 + (index * 4),
                  height: 12 + (index * 4),
                  decoration: BoxDecoration(
                    color: widget.isLeftSide 
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
