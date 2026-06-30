import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitLogin() async {
    setState(() {
      _isLoading = true;
    });

    final success = await AuthService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      _showMessage('Invalid email or password. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Mascot
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.mic, size: 80),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Header
                Text(
                  'Welcome Back 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF191c1e),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to continue your speaking journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF3d4a3e),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Login Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffffff),
                    border: Border.all(
                      color: const Color(0xFFe0e3e5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFe0e3e5),
                        blurRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encouragement
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFc4e7ff).withOpacity(0.3),
                            border: Border.all(
                              color: const Color(0xFFc4e7ff),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Let's continue your progress!",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF004c69),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email field
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF3d4a3e),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'hello@speechcoach.com',
                            hintStyle: const TextStyle(color: Color(0xFF6d7b6d)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFe0e3e5),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFe0e3e5),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF40c2fd),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFf7f9fb),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Password field
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF3d4a3e),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(color: Color(0xFF6d7b6d)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFe0e3e5),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFe0e3e5),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF40c2fd),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFf7f9fb),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF3d4a3e),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF00668a),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login button
                        _buildSquishyButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _submitLogin();
                            }
                          },
                          label: 'Login',
                          isFullWidth: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF191c1e),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF00668a),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSquishyButton({
    required VoidCallback onPressed,
    required String label,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTapDown: (_) {},
      onTapUp: (_) {},
      child: Container(
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: const Color(0xFF4ade80),
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF005227),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFffffff),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
