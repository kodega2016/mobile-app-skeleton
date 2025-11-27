import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onResetPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Mock API delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset link sent to ${_emailController.text}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                
                // Icon
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 50.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Header
                Text(
                  _emailSent ? 'Check Your Email' : 'Reset Password',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  _emailSent
                      ? 'We\'ve sent a password reset link to your email address'
                      : 'Enter your email and we\'ll send you a link to reset your password',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 32.h),
                
                if (!_emailSent) ...[
                  // Mock Info Card
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16.sp,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Mock API - Enter any valid email',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Reset Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onResetPressed,
                    child: _isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Send Reset Link'),
                  ),
                ] else ...[
                  // Success Icon
                  Icon(
                    Icons.mark_email_read,
                    size: 64.sp,
                    color: Colors.green,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Resend Link
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _emailSent = false);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Resend Link'),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Back to Login
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRouter.login);
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
                
                SizedBox(height: 24.h),
                
                // Back to Login Link
                if (!_emailSent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppRouter.login);
                        },
                        child: const Text('Sign In'),
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
}