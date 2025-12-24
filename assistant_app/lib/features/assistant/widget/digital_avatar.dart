import 'dart:math';
import 'package:flutter/material.dart';

class DigitalAvatar extends StatefulWidget {
  final bool isSpeaking;
  final bool isListening;

  const DigitalAvatar({
    super.key,
    required this.isSpeaking,
    required this.isListening,
  });

  @override
  State<DigitalAvatar> createState() => _DigitalAvatarState();
}

class _DigitalAvatarState extends State<DigitalAvatar>
    with TickerProviderStateMixin {
  late AnimationController _mouthController;
  late AnimationController _eyeBlinkController;
  late AnimationController _floatController;
  
  @override
  void initState() {
    super.initState();

    // Mouth animation (fast open/close for talking)
    _mouthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeat(reverse: true);

    // Eye Blink (occasional)
    _eyeBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    // Floating animation (idle movement)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mouthController.dispose();
    _eyeBlinkController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Base color for the cartoon character
    final Color faceColor = widget.isListening 
        ? const Color(0xFFFF6B6B) // Reddish when listening
        : const Color(0xFF4ECDC4); // Cyan/Teal normally

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * sin(_floatController.value * pi)), // Gentle floating
          child: child,
        );
      },
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: faceColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: faceColor.withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
            // Inner highlight for 3D effect
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: -10,
              offset: const Offset(-20, -20),
            ),
          ],
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 1.2,
            colors: [
              faceColor.withOpacity(0.9),
              faceColor, // Darker towards edge
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // EYES
            Positioned(
              top: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCartoonEye(),
                  const SizedBox(width: 40),
                  _buildCartoonEye(),
                ],
              ),
            ),

            // MOUTH
            Positioned(
              bottom: 60,
              child: _buildCartoonMouth(),
            ),
            
            // CHEEKS
            Positioned(
              bottom: 90,
              left: 40,
              child: _buildCheek(),
            ),
            Positioned(
              bottom: 90,
              right: 40,
              child: _buildCheek(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartoonEye() {
    return AnimatedBuilder(
      animation: _eyeBlinkController,
      builder: (context, child) {
        double val = _eyeBlinkController.value;
        // Blink momentarily > 0.95
        bool isBlinking = (val > 0.96);
        
        return Container(
          width: 50,
          height: isBlinking ? 8 : 60, // Squish height when blinking
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.1),
                 blurRadius: 5,
                 offset: const Offset(0, 3)
               )
            ]
          ),
          child: isBlinking 
              ? null 
              : Stack(
                alignment: Alignment.center,
                children: [
                  // Pupil
                  Container(
                    width: 20,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D3436),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Shine
                  Positioned(
                    top: 12,
                    right: 15,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.circle
                      ),
                    ),
                  )
                ],
              ),
        );
      },
    );
  }

  Widget _buildCartoonMouth() {
    return AnimatedBuilder(
      animation: _mouthController,
      builder: (context, child) {
        // If speaking, oscillate height. If not, small smile.
        
        double openAmount = 0.0;
        if (widget.isSpeaking) {
           openAmount = _mouthController.value; // 0.0 to 1.0
        } else if (widget.isListening) {
           openAmount = 0.2; // Slightly open ("O" shape)
        }
        
        // Idle Smile Height = 10 (closed)
        // Speaking Max Height = 50
        double height = 10 + (openAmount * 30);
        double width = 50 - (openAmount * 10); // Narrower when open (O shape)

        return Container(
          width: 60, 
          height: height > 10 ? height : 15, // Minimum smile
          decoration: BoxDecoration(
            color: const Color(0xFF2D3436),
            borderRadius: BorderRadius.only(
               bottomLeft: const Radius.circular(30),
               bottomRight: const Radius.circular(30),
               topLeft: Radius.circular(widget.isSpeaking ? 30 : 5),
               topRight: Radius.circular(widget.isSpeaking ? 30 : 5),
            ),
          ),
          child: widget.isSpeaking 
             ? Center(
               child: Container(
                 width: 30,
                 height: 10,
                   decoration: BoxDecoration(
                     color: Colors.pinkAccent.shade100,
                     borderRadius: BorderRadius.circular(5)
                   ),
                 ),
               )
             : null, // Tongue visible when speaking
        );
      },
    );
  }

  Widget _buildCheek() {
    return Container(
      width: 20, 
      height: 12,
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
