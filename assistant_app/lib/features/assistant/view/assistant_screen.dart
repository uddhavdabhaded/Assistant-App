import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:assistant_app/constants/app_colors.dart';
import 'package:assistant_app/constants/app_strings.dart';
import 'package:assistant_app/features/assistant/controller/assistant_controller.dart';
import 'package:assistant_app/features/assistant/widget/digital_avatar.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;


  final AssistantController _controller = Get.put(AssistantController());

  @override
  void initState() {
    super.initState();

    // Microphone pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent, // Let gradient show through
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E1065), // Deep Purple
              Color(0xFF4C1D95),
              Color(0xFF7C3AED),
              Color(0xFF06B6D4), // Cyan
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: GetBuilder<AssistantController>(
            id: 'assistant',
            builder: (controller) {
              return Column(
                children: [
                  const Spacer(flex: 2),

                  const Spacer(flex: 3),

                  // Digital Live Avatar
                  DigitalAvatar(
                    isSpeaking: controller.isSpeaking,
                    isListening: controller.isListening,
                  ),

                  const Spacer(flex: 1),

                  // Main Text
                  if (controller.isLoading)
                    const Text(
                      'Thinking...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        controller.isListening
                            ? (controller.spokenText.isEmpty
                                  ? 'I\'m listening...'
                                  : controller.spokenText)
                            : controller.isSpeaking
                            ? 'Speaking...'
                            : 'Tap microphone to search',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Subtitle or status
                  if (!controller.isListening && !controller.isSpeaking)
                    Text(
                      'Tap the microphone to speak',
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 20),

                  const Spacer(flex: 3),

                  // Bottom Controls Area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Keyboard Button
                        GestureDetector(
                          onTap: () => _showKeyboardInput(context, controller),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: const Icon(
                              Icons.keyboard_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),

                        // Microphone Button (Center)
                        SizedBox(
                          width: 100, // Reserve space for the pulse effect
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Outer pulse rings
                              if (controller.isListening ||
                                  controller.isLoading ||
                                  controller.isSpeaking)
                                Positioned(
                                  child: AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        width: 100 * _pulseAnimation.value,
                                        height: 100 * _pulseAnimation.value,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                (controller.isSpeaking
                                                        ? AppColors
                                                              .primaryPurple
                                                        : const Color(
                                                            0xFF3B82F6,
                                                          ))
                                                    .withOpacity(
                                                      0.3 /
                                                          _pulseAnimation.value,
                                                    ),
                                            width: 2,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              // Main Mic Button
                              GestureDetector(
                                onTap: () {
                                  controller.listen();
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        (controller.isListening ||
                                            controller.isLoading ||
                                            controller.isSpeaking)
                                        ? (controller.isSpeaking
                                              ? AppColors.primaryPurple
                                              : const Color(0xFF3B82F6))
                                        : const Color(0xFF2563EB),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (controller.isSpeaking
                                                    ? AppColors.primaryPurple
                                                    : const Color(0xFF3B82F6))
                                                .withOpacity(0.5),
                                        blurRadius: 25,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    controller.isSpeaking
                                        ? Icons.stop_rounded
                                        : controller.isLoading
                                        ? Icons.hourglass_bottom_rounded
                                        : controller.isListening
                                        ? Icons.mic_rounded
                                        : Icons.mic_none_rounded,
                                    color: Colors.white,
                                    size: 35, // Slightly smaller icon
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Placeholder for symmetry (maybe settings or history later)
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Invisible spacer
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: paddingBottom > 0 ? paddingBottom + 20 : 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showKeyboardInput(
    BuildContext context,
    AssistantController controller,
  ) {
    final TextEditingController textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2D45),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Type your request",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ask anything...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.primaryCyan,
                      ),
                      onPressed: () {
                        if (textController.text.trim().isNotEmpty) {
                          controller.fetchResponse(textController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.fetchResponse(value.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }


}
