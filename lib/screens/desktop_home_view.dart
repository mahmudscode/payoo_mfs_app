import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../sheets/transactions_sheet.dart';
import '../theme/app_theme.dart';
import '../widgets/action_button.dart';
import '../widgets/transaction_tile.dart';
import 'home_actions.dart';

const _border = Color(0xFFE2E8F0);
const _muted = Color(0xFF64748B);

/// Desktop/web version of the home screen: a sidebar, a top bar and a
/// dashboard with the balance, quick actions and recent transactions.
class DesktopHomeView extends StatelessWidget {
  final ValueChanged<Widget> onOpen;
  final VoidCallback onLogout;

  const DesktopHomeView({super.key, required this.onOpen, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.background,
      child: Row(
        children: [
          _Sidebar(onOpen: onOpen, onLogout: onLogout),
          Expanded(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(child: _Dashboard(onOpen: onOpen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final ValueChanged<Widget> onOpen;
  final VoidCallback onLogout;

  const _Sidebar({required this.onOpen, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
            child: Row(
              children: [
                Image.asset('assets/images/payoo.png', height: 40, width: 40),
                const SizedBox(width: 12),
                const Text('Payoo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const _NavItem(icon: '🏠', label: 'Dashboard', selected: true),
          for (final action in homeActions)
            _NavItem(icon: action.icon, label: action.label, onTap: () => onOpen(action.sheet)),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _NavItem({required this.icon, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppTheme.accent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? AppTheme.accent : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: const Row(
        children: [
          Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Spacer(),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accent,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payoo Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(AppState.correctPhone, style: TextStyle(fontSize: 11, color: _muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final ValueChanged<Widget> onOpen;

  const _Dashboard({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final quickActions = _Panel(
                title: 'Quick Actions',
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    for (final action in homeActions)
                      ActionButton(
                        icon: action.icon,
                        label: action.label,
                        onTap: () => onOpen(action.sheet),
                      ),
                  ],
                ),
              );
              final recent = _RecentTransactions(onViewAll: () => onOpen(const TransactionsSheet()));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BalanceCard(),
                  const SizedBox(height: 24),
                  if (constraints.maxWidth >= 820)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: quickActions),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: recent),
                      ],
                    )
                  else ...[
                    quickActions,
                    const SizedBox(height: 24),
                    recent,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<AppState>().balance;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.accent, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Balance', style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            '\$${NumberFormat('#,##0.00').format(balance)}',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            '🔥 Welcome to Payoo!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enjoy easy and convenient financial services with us. Cashout charge is low.',
            style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final VoidCallback onViewAll;

  const _RecentTransactions({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<AppState>().transactions.take(6).toList();

    return _Panel(
      title: 'Recent Transactions',
      trailing: TextButton(
        onPressed: onViewAll,
        child: const Text('View All', style: TextStyle(fontSize: 12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: transactions.map((t) => TransactionTile(transaction: t)).toList(),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const _Panel({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
