import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _floatingAnimationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with PageView
          Column(
            children: [
              // Header
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        const Icon(Icons.mic_external_on,
                            color: Color(0xFF4ade80), size: 32),
                        const SizedBox(width: 8),
                        Text(
                          'Speech Coach',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF4ade80),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF3d4a3e),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // PageView for screens
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildOnboardingScreen(
                      index: 0,
                      title: 'Start your speaking journey 🚀',
                      description: 'Practice English speaking daily in a fun way',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk',
                      gradientColors: [
                        const Color(0xFF4ade80).withValues(alpha: 0.3),
                        const Color(0xFF40c2fd).withValues(alpha: 0.2),
                      ],
                      floatingDelay: 0,
                    ),
                    _buildOnboardingScreen(
                      index: 1,
                      title: 'Get instant AI feedback 🎯',
                      description:
                          'Improve pronunciation and fluency with real-time suggestions',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAb98vQfNlf8Bp3rhvatV3IgZ3_awk-JHTcnpYKskfRazxkhswbD9ZniIn_bxr7EpTDb-4pn9iQW6yXqJ6CUhHjdejPYEyOvi7Ei7z5xEtv_9-eW5nH5sOWYxeV40EE-UQ4f6CK_92L2qCsDJYQrYZuEdlEvlmpAgDqLl49hVwicR6ZX1m0FTXaSDD0C3UIds6RYkbLyLdb7tVP5FvSKl2BoIr8NiXxo56ZubtX7aBUNv8ea1KEpRTdb6039JY26NDfNKFCcepwPnc',
                      gradientColors: [
                        const Color(0xFF40c2fd).withValues(alpha: 0.3),
                        const Color(0xFFffb47e).withValues(alpha: 0.2),
                      ],
                      floatingDelay: 0.5,
                    ),
                    _buildOnboardingScreen(
                      index: 2,
                      title: 'Level up every day 🔥',
                      description:
                          'Build streaks, track progress, and improve daily',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuABmDNg6xTO1hYz--EAsK0tAQ-XIgiu31FyyJF_Nuz7wCbJY4INpd__TfFtiU8uk3JAHZW4kpQKHc5Vy1xFzSzw8L0srDoqDLJps4bauIQM-jsud81vQX21t6UefzY0C2kM5itJLdR_qsUMAiiXl476hVx69bsBsBSrQsIG81k51ECnMTJLb7Tcm3_RzJwC2TFua8M9Nyxf_LHDXi8l3KKKzXGp3jj4-uh4MWPJxfgnQTT5Q-vDkfCAfQw9l-ALnLbc8fomeftEu1U',
                      gradientColors: [
                        const Color(0xFFffb47e).withValues(alpha: 0.3),
                        const Color(0xFF4ade80).withValues(alpha: 0.2),
                      ],
                      floatingDelay: 1.0,
                      isLastScreen: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Progress indicators and buttons at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFf7f9fb),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 10,
                        width: _currentPage == index ? 32 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF4ade80)
                              : const Color(0xFFd8dadc),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Next/Get Started button
                  if (_currentPage < 2)
                    _buildSquishyButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                      label: 'Next',
                      isSmall: true,
                    )
                  else
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: _buildSquishyButton(
                        onPressed: () async {
                          await OnboardingService.completeOnboarding();
                          if (mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        },
                        label: 'Get Started',
                        isSmall: false,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingScreen({
    required int index,
    required String title,
    required String description,
    required String imageUrl,
    required List<Color> gradientColors,
    required double floatingDelay,
    bool isLastScreen = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradientColors,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Floating animated image container
                    _buildFloatingImageContainer(
                      imageUrl: imageUrl,
                      floatingDelay: floatingDelay,
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFF191c1e),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF3d4a3e),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingImageContainer({
    required String imageUrl,
    required double floatingDelay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: floatingDelay),
      duration: const Duration(milliseconds: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            0,
            20 * _floatingAnimationController.value * 2 - 20,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4ade80).withValues(alpha: 0.2),
                      blurRadius: 60,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
              // Image
              Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSquishyButton({
    required VoidCallback onPressed,
    required String label,
    required bool isSmall,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {});
      },
      onTapUp: (_) {
        setState(() {});
      },
      onTapCancel: () {
        setState(() {});
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 40 : 0,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4ade80),
              borderRadius: BorderRadius.circular(24),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF005227),
                  width: 4,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFf7f9fb),
                    fontWeight: FontWeight.w700,
                    fontSize: isSmall ? 16 : 24,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
