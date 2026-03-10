import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../providers/admin_provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});
  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _search = '';
  String _roleFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final users = admin.users.where((u) {
      final matchRole = _roleFilter == 'all' || u['role'] == _roleFilter;
      final matchSearch = _search.isEmpty ||
          (u['name'] as String).toLowerCase().contains(_search.toLowerCase()) ||
          (u['email'] as String).toLowerCase().contains(_search.toLowerCase());
      return matchRole && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Users (${admin.users.length})'),
        actions: [
          IconButton(onPressed: () => admin.loadDashboard(), icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(children: [
              _FilterChip('All', _roleFilter == 'all', () => setState(() => _roleFilter = 'all')),
              _FilterChip('Tourist', _roleFilter == 'tourist', () => setState(() => _roleFilter = 'tourist')),
              _FilterChip('Weaver', _roleFilter == 'weaver', () => setState(() => _roleFilter = 'weaver')),
              _FilterChip('Admin', _roleFilter == 'admin', () => setState(() => _roleFilter = 'admin')),
            ]),
          ),
          Expanded(
            child: admin.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : users.isEmpty
                ? const Center(child: Text('No users found', style: TextStyle(color: AppColors.textHint)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final u = users[i];
                      return _UserCard(
                        name: u['name'] as String? ?? 'Unknown',
                        email: u['email'] as String? ?? '',
                        role: u['role'] as String? ?? 'tourist',
                        createdAt: u['createdAt'] != null ? DateTime.tryParse(u['createdAt'] as String) : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip(this.label, this.isActive, this.onTap);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.success : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.success : AppColors.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    ),
  );
}

class _UserCard extends StatelessWidget {
  final String name, email, role;
  final DateTime? createdAt;
  const _UserCard({required this.name, required this.email, required this.role, this.createdAt});

  @override
  Widget build(BuildContext context) {
    final roleColor = role == 'admin' ? AppColors.error : role == 'weaver' ? AppColors.accent : AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: roleColor.withOpacity(0.12),
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: roleColor)),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          Text(email, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
          if (createdAt != null)
            Text('Joined ${AppFormatters.date(createdAt!)}', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: roleColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: Text(role[0].toUpperCase() + role.substring(1),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: roleColor)),
        ),
      ]),
    );
  }
}
