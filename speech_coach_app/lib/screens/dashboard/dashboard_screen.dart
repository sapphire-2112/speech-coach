import 'package:flutter/material.dart';
import '../../services/streak_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;
  int _selectedNavIndex = 0;
  int _streakCount = 0;
  bool _isLoadingStreak = true;
  String? _lastVisitDate;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _loadStreak();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _loadStreak() async {
    final streakCount = await StreakService.updateStreakForToday();
    final lastVisit = await StreakService.getLastVisitDate();
    if (!mounted) return;
    setState(() {
      _streakCount = streakCount;
      _lastVisitDate = lastVisit;
      _isLoadingStreak = false;
    });
  }

  Future<void> _resetStreak() async {
    await StreakService.resetStreak();
    if (!mounted) return;
    setState(() {
      _streakCount = 0;
      _lastVisitDate = null;
      _isLoadingStreak = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top AppBar
            SliverAppBar(
              floating: true,
              backgroundColor: const Color(0xFFf7f9fb),
              elevation: 0,
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu, color: Color(0xFF006d36)),
                      const SizedBox(width: 8),
                      Text(
                        'Speech Coach',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF006d36),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF4ade80),
                        width: 2,
                      ),
                      color: const Color(0xFF40c2fd),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuArR7czLWztdp0aP7ChET0ruRbiBiBXxPo_d5UaO39cO2g7qSxb8kZQi1FEfQkqtbepSZbuYiw5dpXuGlLwhChrhCfYYzDZOTctjsXJdcjHG6fFt_zqhbgKKp_Hkozkp2ln7__KoRJaANAyfHkqzrXUlxwEXWn-GT5xTc9tvKsMHlOaodK_JGqxuGR9e7aazi_x9dxu8qxY8hJh0g9tX13jDgi4RF6bo8-4GiltmRxxGwAP_yasg1Di61X19h5zNC7vu2cCLzBKX8I',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.person, size: 24),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello 👋, Ready to level up today?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: const Color(0xFF191c1e),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Keep your streak alive 🔥',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: const Color(0xFF3d4a3e),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Streak Counter Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFffffff),
                        border: Border.all(
                          color: const Color(0xFFe0e3e5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://lh3.googleusercontent.com/aida/AP1WRLvv4VUF0ght5bJn2Uh6ocHGhAtK15D98NS6dhns6sgmFUf0UeB9_TPKmhzxtZfzOikMe6E1Qbp_4vWAB3iji-mmfw18qQDB45XSfgqcPxTe5HhsoX3tL0mxuUIz3RxV63UYpb8ZlXmE8ls1Rd2TG0itirUGPW-HUFfQlYDKnlWwU0b8UilizRWGhAzSyrqjqOeS_H4ieQGmA-HZ0eMQrHr1om-KpTy5Huuu0HAKegsZsJIxpJHNJx6nu_E',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.local_fire_department,
                                  size: 40);
                            },
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isLoadingStreak
                                    ? 'Loading streak...'
                                    : _streakCount == 0
                                        ? 'No active streak'
                                        : '$_streakCount day streak',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: const Color(0xFF191c1e),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isLoadingStreak
                                    ? 'Checking today’s visit'
                                    : _streakCount == 0
                                        ? 'Start your streak today'
                                        : _lastVisitDate == null
                                            ? 'Start your streak today'
                                            : 'Last visit: $_lastVisitDate',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: const Color(0xFF006d36),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _resetStreak,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf3f9f4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF4ade80),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    'Reset streak',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: const Color(0xFF006d36),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ),
                              Text(
                                'Mastering the flow!',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: const Color(0xFF006d36),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Main Action Card
                    _buildMainActionCard(),
                    const SizedBox(height: 24),
                    // Progress Section
                    _buildProgressSection(),
                    const SizedBox(height: 24),
                    // Feature Cards Grid
                    Text(
                      'Features',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF191c1e),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.menu_book,
                      bgColor: const Color(0xFF6dfe9c),
                      title: 'Vocabulary 📚',
                      description: 'Learn new words daily and expand your range of expression.',
                      badge: '12 words today',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.edit_note,
                      bgColor: const Color(0xFFc4e7ff),
                      title: 'Grammar ✍️',
                      description: 'Fix your sentence structure with interactive real-time drills.',
                      badge: '3 lessons left',
                      badgeColor: const Color(0xFF00668a),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.person,
                      bgColor: const Color(0xFFffdcc5),
                      title: 'Profile 👤',
                      description: 'Track your progress and review your speech history achievements.',
                      badge: 'Top 5% Learner',
                      badgeColor: const Color(0xFF944a00),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMainActionCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF4ade80),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFF006d36),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF006d36).withValues(alpha: 0.2),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF005e2d).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic,
                  color: Color(0xFF005e2d),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Next Adventure',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF005e2d),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Practice daily greetings and conversational fillers to sound like a pro.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF005e2d).withValues(alpha: 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Start Speaking Practice 🎤',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF006d36),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -24,
          right: -12,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              final offset = 10 * (_floatingController.value * 2 - 1).abs() - 10;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Opacity(
              opacity: 0.4,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.mic, size: 96);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        border: Border.all(
          color: const Color(0xFFe0e3e5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFffb47e),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF944a00),
                          width: 3,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'L3',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF804000),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Level 3',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF191c1e),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Text(
                'Daily XP: 450/500',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF00668a),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFc4e7ff),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF40c2fd),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        right: BorderSide(
                          color: const Color(0xFF00668a),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Only 50 XP more to hit today\'s goal! You\'re crushing it.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF3d4a3e),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color bgColor,
    required String title,
    required String description,
    required String badge,
    Color badgeColor = const Color(0xFF006d36),
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf2f4f6),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFe2e8f0),
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF191c1e),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF3d4a3e),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFe0e3e5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf7f9fb),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFe0e3e5),
            width: 2,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, 'Home'),
            _buildNavItem(1, Icons.school, 'Lessons'),
            _buildNavItem(2, Icons.leaderboard, 'Stats'),
            _buildNavItem(3, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF4ade80),
                borderRadius: BorderRadius.circular(24),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF006d36),
                    width: 3,
                  ),
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF005e2d) : const Color(0xFF3d4a3e),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? const Color(0xFF005e2d)
                        : const Color(0xFF3d4a3e),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
