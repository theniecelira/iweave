import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthProvider>().clearError();
    final success = await context.read<AuthProvider>().signup(
      _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text,
    );
    if (success && mounted) Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Join the iWeave Community', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Create your account to start your journey', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              Consumer<AuthProvider>(
                builder: (_, auth, __) {
                  if (auth.errorMessage != null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Text(auth.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              AppTextField(
                label: 'Full Name', hint: 'Maria Santos',
                controller: _nameCtrl,
                validator: Validators.name,
                prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email Address', hint: 'maria@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password', hint: 'At least 6 characters',
                controller: _passCtrl, isPassword: true,
                validator: Validators.password,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Confirm Password', hint: 'Repeat your password',
                controller: _confirmCtrl, isPassword: true,
                validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textHint),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 28),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => AppButton(
                  label: 'Create Account',
                  onPressed: _signup,
                  isLoading: auth.status == AuthStatus.loading,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
