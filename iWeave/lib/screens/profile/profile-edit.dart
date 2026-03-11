import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // add to pubspec.yaml

// ─── iWeave Brand Colors ───────────────────────────────────────────────────
const kMaroon = Color(0xFF7A1530);
const kOrange = Color(0xFFFF6B00);
const kBg     = Color(0xFFF7F4F9);
const kBorder = Color(0xFFE0DCF0);

// ─── Entry point (for standalone testing) ─────────────────────────────────
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Roboto'),
    home: const EditProfileScreen(),
  ),
);

// ─── Screen ────────────────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl   = TextEditingController(text: 'Maria');
  final _lastNameCtrl    = TextEditingController(text: 'Santos');
  final _emailCtrl       = TextEditingController(text: 'tourist@iweave.ph');
  final _addressCtrl     = TextEditingController(text: 'Basey, Samar');
  final _contactCtrl     = TextEditingController(text: '+63 912 345 6789');
  final _passwordCtrl    = TextEditingController(text: '••••••••');

  String _city  = 'Basey';
  String _state = 'Samar';
  File?  _avatarFile;
  bool   _emailVerified    = true;
  bool   _passwordVerified = true;
  bool   _obscurePassword  = true;
  bool   _isSaving         = false;

  final List<String> _cities  = ['Basey', 'Tacloban', 'Ormoc', 'Borongan'];
  final List<String> _states  = ['Samar', 'Leyte', 'Eastern Samar', 'Biliran'];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _contactCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Pick avatar image ───────────────────────────────────────────────────
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _avatarFile = File(picked.path));
  }

  // ── Save handler ────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: kMaroon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [

            // ── Avatar ───────────────────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: kMaroon.withOpacity(0.15),
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!) as ImageProvider
                        : null,
                    child: _avatarFile == null
                        ? const Text(
                            'M',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: kMaroon,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kOrange,
                        ),
                        child: const Icon(Icons.edit, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── First Name / Last Name ────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    label: 'First Name',
                    controller: _firstNameCtrl,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    label: 'Last Name',
                    controller: _lastNameCtrl,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Email ─────────────────────────────────────────────────────
            _buildField(
              label: 'Email',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              suffix: _emailVerified
                  ? _verifiedBadge()
                  : null,
              validator: (v) {
                if (v!.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Address ───────────────────────────────────────────────────
            _buildField(
              label: 'Address',
              controller: _addressCtrl,
              hint: 'Street, Barangay',
            ),

            const SizedBox(height: 16),

            // ── Contact Number ────────────────────────────────────────────
            _buildField(
              label: 'Contact Number',
              controller: _contactCtrl,
              keyboardType: TextInputType.phone,
              hint: '+63 9XX XXX XXXX',
              validator: (v) {
                if (v!.trim().isEmpty) return 'Required';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── City / State ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _buildDropdown(label: 'City',  value: _city,  items: _cities,  onChanged: (v) => setState(() => _city  = v!))),
                const SizedBox(width: 12),
                Expanded(child: _buildDropdown(label: 'State', value: _state, items: _states, onChanged: (v) => setState(() => _state = v!))),
              ],
            ),

            const SizedBox(height: 16),

            // ── Password ──────────────────────────────────────────────────
            _buildField(
              label: 'Password',
              controller: _passwordCtrl,
              obscure: _obscurePassword,
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  if (_passwordVerified) ...[
                    const SizedBox(width: 6),
                    _verifiedBadge(),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Buttons ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kOrange),
                      foregroundColor: kOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      disabledBackgroundColor: kOrange.withOpacity(0.6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Helper: text field ──────────────────────────────────────────────────
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            suffixIcon: suffix != null
                ? Padding(padding: const EdgeInsets.only(right: 10), child: suffix)
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kMaroon, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helper: dropdown ────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ── Helper: green verified badge ────────────────────────────────────────
  Widget _verifiedBadge() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.check, size: 14, color: Colors.white),
    );
  }
}