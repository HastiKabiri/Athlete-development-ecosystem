import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum UserRole { player, admin, coach, parent, other }

class AppUser {
  const AppUser({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });

  final String email;
  final String password;
  final String fullName;
  final UserRole role;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<AppUser> _users = [
    const AppUser(
      email: 'admin@jmhockey.com',
      password: 'admin123',
      fullName: 'Admin User',
      role: UserRole.admin,
    ),
    const AppUser(
      email: 'coach@jmhockey.com',
      password: 'coach123',
      fullName: 'Coach Malik',
      role: UserRole.coach,
    ),
    const AppUser(
      email: 'player@jmhockey.com',
      password: 'player123',
      fullName: 'Alicia Tan',
      role: UserRole.player,
    ),
    const AppUser(
      email: 'parent@jmhockey.com',
      password: 'parent123',
      fullName: 'Sarah Tan',
      role: UserRole.parent,
    ),
  ];

  AppUser? _currentUser;
  int _selectedIndex = 0;

  bool _login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        setState(() => _currentUser = user);
        return true;
      }
    }
    return false;
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JM Hockey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        scaffoldBackgroundColor: const Color(0xFFF7FAFF),
        useMaterial3: true,
      ),
      home: _currentUser == null
          ? LoginScreen(onLogin: _login)
          : RoleHomeScreen(
              user: _currentUser!,
              selectedIndex: _selectedIndex,
              onIndexChanged: (index) => setState(() => _selectedIndex = index),
              onLogout: _logout,
            ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final bool Function(String email, String password) onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = widget.onLogin(_emailController.text, _passwordController.text);
    setState(() => _error = ok ? null : 'Invalid email or password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.sports_hockey,
                      size: 56,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your JM Hockey account',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _AuthField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),
                  _AuthField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoleHomeScreen extends StatelessWidget {
  const RoleHomeScreen({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.onLogout,
  });

  final AppUser user;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForRole(user.role);
    final modules = _modulesForRole(user.role);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        title: const Text('JM Hockey'),
        backgroundColor: const Color(0xFFF7FAFF),
        foregroundColor: const Color(0xFF0F4C81),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headlineForRole(user.role),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Welcome back, ${user.fullName}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accent, accent.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _taglineForRole(user.role),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
                children: [
                  for (final module in modules)
                    _DashboardCard(
                      item: module,
                      accent: accent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              title: module.detailTitle,
                              subtitle: module.detailText,
                              accent: accent,
                              icon: module.icon,
                              viewerRole: user.role,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onIndexChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onLogout,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
      ),
    );
  }

  String _headlineForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin control center';
      case UserRole.player:
        return 'Player hub';
      case UserRole.coach:
        return 'Coach command center';
      case UserRole.parent:
        return 'Parent insights';
      case UserRole.other:
        return 'Community home';
    }
  }

  String _taglineForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Monitor analytics, operations, communication, and security from one elegant dashboard.';
      case UserRole.player:
        return 'Track training, attendance, performance, and achievements with ease.';
      case UserRole.coach:
        return 'Plan sessions, evaluate players, and review match stats in real time.';
      case UserRole.parent:
        return 'Follow progress, schedules, and payments for your child.';
      case UserRole.other:
        return 'Stay connected with the club through news, gallery, and events.';
    }
  }

  Color _accentForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFF1E88E5);
      case UserRole.player:
        return const Color(0xFF2E7D32);
      case UserRole.coach:
        return const Color(0xFFB71C1C);
      case UserRole.parent:
        return const Color(0xFF7B1FA2);
      case UserRole.other:
        return const Color(0xFF00838F);
    }
  }

  List<_DashboardItem> _modulesForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const [
          _DashboardItem(
            title: 'Analytics',
            subtitle: 'Overview',
            icon: Icons.insights,
            detailTitle: 'Main Dashboard & Analytics Hub',
            detailText:
                'Review club growth, attendance, and performance metrics in one view.',
          ),
          _DashboardItem(
            title: 'Attendance',
            subtitle: 'Player metrics',
            icon: Icons.fact_check,
            detailTitle: 'Player Attendance Page',
            detailText:
                'Track attendance across players and drill statuses in real time.',
          ),
          _DashboardItem(
            title: 'Operations',
            subtitle: 'Schedule management',
            icon: Icons.calendar_month,
            detailTitle: 'Operations & Schedule Management',
            detailText: 'Keep matches, training, and events smoothly planned.',
          ),
          _DashboardItem(
            title: 'Security',
            subtitle: 'System controls',
            icon: Icons.security,
            detailTitle: 'System Settings & Security',
            detailText: 'Secure the platform with permissions and controls.',
          ),
          _DashboardItem(
            title: 'Communication',
            subtitle: 'Groups and messages',
            icon: Icons.forum,
            detailTitle: 'Communication Portal',
            detailText: 'Send updates to staff, players, and parents.',
          ),
          _DashboardItem(
            title: 'CMS',
            subtitle: 'Content manager',
            icon: Icons.article,
            detailTitle: 'Content Management System',
            detailText: 'Publish announcements, stories, and resources.',
          ),
        ];
      case UserRole.player:
        return const [
          _DashboardItem(
            title: 'Profile',
            subtitle: 'Player profile',
            icon: Icons.account_circle,
            detailTitle: 'Player Profile Page',
            detailText:
                'A clean personal profile for your profile, ID, and details.',
          ),
          _DashboardItem(
            title: 'Attendance',
            subtitle: 'Track sessions',
            icon: Icons.fact_check,
            detailTitle: 'Player Attendance Page',
            detailText: 'See attendance history, session notes, and status.',
          ),
          _DashboardItem(
            title: 'Performance',
            subtitle: 'Training insights',
            icon: Icons.show_chart,
            detailTitle: 'Performance Page',
            detailText: 'Monitor strength, velocity, and training output.',
          ),
          _DashboardItem(
            title: 'Achievements',
            subtitle: 'Rewards',
            icon: Icons.emoji_events,
            detailTitle: 'Achievements Page',
            detailText: 'Celebrate milestones, badges, and MVP moments.',
          ),
        ];
      case UserRole.coach:
        return const [
          _DashboardItem(
            title: 'Coach Desk',
            subtitle: 'Overview',
            icon: Icons.dashboard_customize,
            detailTitle: 'Coach Dashboard',
            detailText:
                'Stay on top of the week with a streamlined coach view.',
          ),
          _DashboardItem(
            title: 'Attendance',
            subtitle: 'Player attendance',
            icon: Icons.fact_check,
            detailTitle: 'Coach Attendance Page',
            detailText: 'Give attendance and review player session status.',
          ),
          _DashboardItem(
            title: 'Team',
            subtitle: 'Manage roster',
            icon: Icons.group,
            detailTitle: 'Team Management Page',
            detailText: 'Coordinate staff, group, and selection decisions.',
          ),
          _DashboardItem(
            title: 'Reports',
            subtitle: 'Export summary',
            icon: Icons.description,
            detailTitle: 'Reports Page',
            detailText: 'Share progress and session reports with colleagues.',
          ),
        ];
      case UserRole.parent:
        return const [
          _DashboardItem(
            title: 'Dashboard',
            subtitle: 'Parent overview',
            icon: Icons.dashboard,
            detailTitle: 'Parent Dashboard',
            detailText: 'A calm, focused place for parent updates.',
          ),
          _DashboardItem(
            title: 'Progress',
            subtitle: 'Child progress',
            icon: Icons.timeline,
            detailTitle: 'Child Progress Page',
            detailText: 'Follow growth, readiness, and performance trends.',
          ),
          _DashboardItem(
            title: 'Attendance',
            subtitle: 'Session tracking',
            icon: Icons.fact_check,
            detailTitle: 'Parent Attendance Page',
            detailText: 'Review your child’s training attendance.',
          ),
          _DashboardItem(
            title: 'Payments',
            subtitle: 'Fee overview',
            icon: Icons.receipt_long,
            detailTitle: 'Financials & Payment Monitoring',
            detailText: 'Keep track of fees, invoices, and payment updates.',
          ),
        ];
      case UserRole.other:
        return const [
          _DashboardItem(
            title: 'Home',
            subtitle: 'Public dashboard',
            icon: Icons.home,
            detailTitle: 'Public Dashboard / Home',
            detailText:
                'Discover club highlights and the latest look of the academy.',
          ),
          _DashboardItem(
            title: 'News',
            subtitle: 'Updates',
            icon: Icons.newspaper,
            detailTitle: 'News Page',
            detailText: 'Read recent announcements and club updates.',
          ),
          _DashboardItem(
            title: 'Gallery',
            subtitle: 'Moments',
            icon: Icons.photo_library,
            detailTitle: 'Gallery Page',
            detailText: 'Browse photos and video highlights.',
          ),
          _DashboardItem(
            title: 'Events',
            subtitle: 'Upcoming',
            icon: Icons.event_available,
            detailTitle: 'Events Page',
            detailText: 'See training sessions, tournaments, and open events.',
          ),
        ];
    }
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.item,
    required this.accent,
    required this.onTap,
  });

  final _DashboardItem item;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accent.withOpacity(0.12),
                child: Icon(item.icon, color: accent),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceDetailPage extends StatelessWidget {
  const AttendanceDetailPage({
    super.key,
    required this.playerName,
    required this.playerRole,
    required this.accent,
  });

  final String playerName;
  final String playerRole;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    const team = 'JM Hockey U-16 Boys Team A';
    const sessions = [
      _AttendanceSession(
        date: 'Oct 24, 2023',
        title: 'Practice Session',
        detail: 'Drills & tactics • strong defensive work',
        status: 'PRESENT',
        statusColor: Color(0xFF2E7D32),
        icon: Icons.check_circle,
      ),
      _AttendanceSession(
        date: 'Oct 21, 2023',
        title: 'Scrimmage - Inter-Squad',
        detail: 'Strong passing and positioning',
        status: 'PRESENT',
        statusColor: Color(0xFF2E7D32),
        icon: Icons.check_circle,
      ),
      _AttendanceSession(
        date: 'Oct 18, 2023',
        title: 'Conditioning & Strength',
        detail: 'Slightly late, but good effort',
        status: 'LATE (5 mins)',
        statusColor: Color(0xFFFFB300),
        icon: Icons.schedule,
      ),
      _AttendanceSession(
        date: 'Oct 14, 2023',
        title: 'Strategy Meeting',
        detail: 'Excused from training',
        status: 'ABSENT',
        statusColor: Color(0xFFD32F2F),
        icon: Icons.cancel,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(height: 8),
              _MonthHeader(title: 'Month: Oct 2023', accent: accent),
              const SizedBox(height: 12),
              _ProfileCard(
                name: playerName,
                role: playerRole,
                team: team,
                accent: accent,
                avatarIcon: Icons.person,
              ),
              const SizedBox(height: 12),
              _SummaryStrip(
                total: '21',
                present: '18 (G)',
                late: '2 (Y)',
                absent: '1 (R)',
                accent: accent,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                title: 'Attendance trend',
                subtitle: 'Last 5 weeks',
                accent: accent,
                values: const [76, 84, 89, 94, 97],
                labels: const ['W1', 'W2', 'W3', 'W4', 'W5'],
              ),
              const SizedBox(height: 12),
              for (final session in sessions) ...[
                _AttendanceCard(session: session),
                const SizedBox(height: 10),
              ],
              _BottomReportCard(
                buttonText: 'Detailed Performance Report',
                subtitle:
                    'Attendance history is linked to player development data.',
                accent: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.viewerRole,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final UserRole viewerRole;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _groupMessageController = TextEditingController();
  final List<_ChatGroup> _groups = [
    _ChatGroup(
      name: 'Elite Squad',
      members: ['Coach Malik', 'Alicia Tan'],
      canType: [true, false],
    ),
    _ChatGroup(
      name: 'Parents Updates',
      members: ['Sarah Tan', 'Admin User'],
      canType: [true, true],
    ),
  ];

  final Map<UserRole, bool> _typePermissions = {
    UserRole.admin: true,
    UserRole.coach: true,
    UserRole.player: false,
    UserRole.parent: false,
  };

  final Map<UserRole, bool> _createPermissions = {
    UserRole.admin: true,
    UserRole.coach: false,
    UserRole.player: false,
    UserRole.parent: false,
  };

  int _selectedGroup = 0;

  @override
  void dispose() {
    _groupMessageController.dispose();
    super.dispose();
  }

  void _togglePermission(UserRole role, {required bool canType}) {
    setState(() {
      if (canType) {
        _typePermissions[role] = !(_typePermissions[role] ?? false);
      } else {
        _createPermissions[role] = !(_createPermissions[role] ?? false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lower = widget.title.toLowerCase();
    final isAttendance = lower.contains('attendance');
    final isOperations =
        lower.contains('operations') || lower.contains('schedule');
    final isSecurity = lower.contains('security');
    final isCommunication =
        lower.contains('communication') || lower.contains('portal');

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: widget.accent.withOpacity(0.2),
                      child: Icon(widget.icon, color: widget.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (isAttendance) ..._attendanceView(),
              if (isOperations) ..._operationsView(),
              if (isCommunication) ..._communicationView(),
              if (isSecurity) ..._securityView(),
              if (!isAttendance &&
                  !isOperations &&
                  !isCommunication &&
                  !isSecurity)
                ..._defaultView(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _attendanceView() {
    if (widget.viewerRole == UserRole.admin) {
      return _adminAttendanceView();
    }

    final isCoachAttendance = widget.viewerRole == UserRole.coach;
    return _attendanceDetailView(isCoachAttendance: isCoachAttendance);
  }

  List<Widget> _attendanceDetailView({required bool isCoachAttendance}) {
    final name = isCoachAttendance ? 'Coach Malik' : 'Ahmed Khan';
    final role = isCoachAttendance ? 'Head Coach' : 'Player #12';
    final team = 'JM Hockey U-16 Boys Team A';
    final sessions = [
      const _AttendanceSession(
        date: 'Oct 24, 2023',
        title: 'Practice Session',
        detail: 'Drills & tactics • strong defensive work',
        status: 'PRESENT',
        statusColor: Color(0xFF2E7D32),
        icon: Icons.check_circle,
      ),
      const _AttendanceSession(
        date: 'Oct 21, 2023',
        title: 'Scrimmage - Inter-Squad',
        detail: 'Strong passing and positioning',
        status: 'PRESENT',
        statusColor: Color(0xFF2E7D32),
        icon: Icons.check_circle,
      ),
      const _AttendanceSession(
        date: 'Oct 18, 2023',
        title: 'Conditioning & Strength',
        detail: 'Slightly late, but good effort',
        status: 'LATE (5 mins)',
        statusColor: Color(0xFFFFB300),
        icon: Icons.schedule,
      ),
      const _AttendanceSession(
        date: 'Oct 14, 2023',
        title: 'Strategy Meeting',
        detail: 'Excused from training',
        status: 'ABSENT',
        statusColor: Color(0xFFD32F2F),
        icon: Icons.cancel,
      ),
    ];

    return [
      _MonthHeader(title: 'Month: Oct 2023', accent: widget.accent),
      const SizedBox(height: 12),
      _ProfileCard(
        name: name,
        role: role,
        team: team,
        accent: widget.accent,
        avatarIcon: isCoachAttendance ? Icons.co_present : Icons.person,
      ),
      const SizedBox(height: 12),
      _SummaryStrip(
        total: '21',
        present: isCoachAttendance ? '19 (G)' : '18 (G)',
        late: isCoachAttendance ? '1 (Y)' : '2 (Y)',
        absent: '1 (R)',
        accent: widget.accent,
      ),
      const SizedBox(height: 12),
      _ChartCard(
        title: 'Attendance trend',
        subtitle: 'Last 5 weeks',
        accent: widget.accent,
        values: const [76, 84, 89, 94, 97],
        labels: const ['W1', 'W2', 'W3', 'W4', 'W5'],
      ),
      const SizedBox(height: 12),
      for (final session in sessions) ...[
        _AttendanceCard(session: session),
        const SizedBox(height: 10),
      ],
      _BottomReportCard(
        buttonText: 'Detailed Performance Report',
        subtitle: 'Attendance history is linked to player development data.',
        accent: widget.accent,
      ),
    ];
  }

  List<Widget> _adminAttendanceView() {
    const players = [
      _PlayerAttendanceSummary(
        name: 'Ahmed Khan',
        role: 'Player #12',
        present: '18',
        late: '2',
        absent: '1',
        accent: Color(0xFF1E88E5),
      ),
      _PlayerAttendanceSummary(
        name: 'Liam Patel',
        role: 'Player #08',
        present: '20',
        late: '1',
        absent: '0',
        accent: Color(0xFF2E7D32),
      ),
      _PlayerAttendanceSummary(
        name: 'Noah Wilson',
        role: 'Player #15',
        present: '17',
        late: '2',
        absent: '2',
        accent: Color(0xFFFFB300),
      ),
      _PlayerAttendanceSummary(
        name: 'Ethan Brown',
        role: 'Player #04',
        present: '19',
        late: '1',
        absent: '1',
        accent: Color(0xFF0F4C81),
      ),
    ];

    return [
      _MonthHeader(title: 'Month: Oct 2023', accent: widget.accent),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Attendance summary for admin',
        subtitle: 'Tap a player to open their full attendance page',
        accent: widget.accent,
        child: Column(
          children: const [
            _StatChip(label: 'Players', value: '4'),
            SizedBox(height: 10),
            _StatChip(label: 'Average', value: '89%'),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _ChartCard(
        title: 'Team attendance summary',
        subtitle: 'Overall attendance for the squad',
        accent: widget.accent,
        values: const [78, 82, 85, 91, 95],
        labels: const ['W1', 'W2', 'W3', 'W4', 'W5'],
      ),
      const SizedBox(height: 12),
      for (final player in players) ...[
        _PlayerAttendanceSummaryCard(
          player: player,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AttendanceDetailPage(
                  playerName: player.name,
                  playerRole: player.role,
                  accent: player.accent,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    ];
  }

  List<Widget> _operationsView() {
    const week = [
      _OpsDay(
        label: 'Mon',
        title: 'Recovery & review',
        detail: 'Video notes and rehab check-in',
        color: Color(0xFF1E88E5),
      ),
      _OpsDay(
        label: 'Tue',
        title: 'Field training',
        detail: 'Technical drills and unit work',
        color: Color(0xFFFFB300),
      ),
      _OpsDay(
        label: 'Wed',
        title: 'Match prep',
        detail: 'Tactics and set pieces',
        color: Color(0xFF2E7D32),
      ),
      _OpsDay(
        label: 'Thu',
        title: 'Light session',
        detail: 'Agility and finishing',
        color: Color(0xFF0F4C81),
      ),
      _OpsDay(
        label: 'Fri',
        title: 'Game day',
        detail: 'Arrival, kit, and lineup',
        color: Color(0xFFD32F2F),
      ),
    ];

    const tasks = [
      _OpsTask(
        title: 'Confirm bus pickup',
        status: 'Due today',
        icon: Icons.directions_bus,
      ),
      _OpsTask(
        title: 'Check cones and bibs',
        status: 'Ready',
        icon: Icons.inventory_2_outlined,
      ),
      _OpsTask(
        title: 'Send game reminders',
        status: 'Pending',
        icon: Icons.notifications_active,
      ),
      _OpsTask(
        title: 'Approve venue booking',
        status: 'Booked',
        icon: Icons.stadium,
      ),
    ];

    return [
      _PanelCard(
        title: 'Operations control tower',
        subtitle: 'Weekly planning and readiness',
        accent: widget.accent,
        child: Row(
          children: const [
            Expanded(
              child: _StatChip(label: 'Sessions', value: '18'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatChip(label: 'Venue', value: 'Ready'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatChip(label: 'Tasks', value: '4 Open'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'This week',
        subtitle: 'Plan by day and keep the squad aligned',
        accent: widget.accent,
        child: Column(
          children: [
            for (final day in week) ...[
              _DayCard(day: day),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Readiness checklist',
        subtitle: 'Track the items that keep training and matches on time',
        accent: widget.accent,
        child: Column(
          children: [
            _ProgressRow(
              label: 'Venue readiness',
              progress: 0.94,
              accent: widget.accent,
            ),
            const SizedBox(height: 10),
            _ProgressRow(
              label: 'Session planning',
              progress: 0.88,
              accent: widget.accent,
            ),
            const SizedBox(height: 14),
            for (final task in tasks) ...[
              _TaskCard(task: task, accent: widget.accent),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Next event',
        subtitle: 'Game day operations summary',
        accent: widget.accent,
        child: const Column(
          children: [
            _StatusLine(label: 'Arrival window', value: '4:30 PM - 5:00 PM'),
            _StatusLine(label: 'Kit check', value: 'Completed'),
            _StatusLine(label: 'Referee booking', value: 'Confirmed'),
          ],
        ),
      ),
    ];
  }

  List<Widget> _communicationView() {
    final group = _groups[_selectedGroup];
    return [
      _PanelCard(
        title: 'Communication hub',
        subtitle: 'Telegram-style group control',
        accent: widget.accent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatChip(label: 'Groups', value: '2'),
                _StatChip(label: 'Typing access', value: 'Managed'),
                _StatChip(label: 'Alerts', value: '22'),
              ],
            ),
            const SizedBox(height: 14),
            _ChartCard(
              title: 'Message delivery',
              subtitle: 'Last 5 days',
              accent: widget.accent,
              values: const [72, 81, 88, 93, 96],
              labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Group communication',
        subtitle: group.name,
        accent: widget.accent,
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _groups.length; i++)
                  ChoiceChip(
                    label: Text(_groups[i].name),
                    selected: i == _selectedGroup,
                    onSelected: (_) => setState(() => _selectedGroup = i),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groupMessageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message to ${group.name}',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _groupMessageController.clear()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Send'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final member in group.members)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(child: Text(member[0])),
                    const SizedBox(width: 10),
                    Expanded(child: Text(member)),
                    const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _securityView() {
    final roles = const [
      (label: 'Admin', role: UserRole.admin),
      (label: 'Coach', role: UserRole.coach),
      (label: 'Player', role: UserRole.player),
      (label: 'Parent', role: UserRole.parent),
    ];

    return [
      _PanelCard(
        title: 'Security panel',
        subtitle: 'Permissions, access, and audit controls',
        accent: widget.accent,
        child: Column(
          children: [
            _ProgressRow(
              label: 'Access review',
              progress: 0.79,
              accent: widget.accent,
            ),
            const SizedBox(height: 10),
            _ProgressRow(
              label: 'Audit completion',
              progress: 0.85,
              accent: widget.accent,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatChip(label: 'Recent alerts', value: '2'),
                _StatChip(label: '2FA', value: 'On'),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Role access matrix',
        subtitle: 'Admins can change permissions with buttons',
        accent: widget.accent,
        child: Column(
          children: [
            for (final row in roles) ...[
              _SecurityRow(
                role: row.label,
                canType: _typePermissions[row.role] ?? false,
                canCreate: _createPermissions[row.role] ?? false,
                accent: widget.accent,
                onToggleType: () => _togglePermission(row.role, canType: true),
                onToggleCreate: () =>
                    _togglePermission(row.role, canType: false),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Recent security activity',
        subtitle: 'Latest account and access events',
        accent: widget.accent,
        child: Column(
          children: const [
            _ActivityLine(
              title: 'Admin login verified',
              subtitle: '2FA completed successfully',
            ),
            _ActivityLine(
              title: 'New group created',
              subtitle: 'Elite Squad group was added with typing rules',
            ),
            _ActivityLine(
              title: 'Muted typing rights',
              subtitle: 'One player was set to read-only access',
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _defaultView() {
    return const [
      _PanelCard(
        title: 'Overview',
        subtitle: 'This section is ready for future content and backend data.',
        accent: Color(0xFF1E88E5),
        child: Text('Connect this screen to live data or API content.'),
      ),
    ];
  }
}

class _PlayerAttendanceSummary {
  const _PlayerAttendanceSummary({
    required this.name,
    required this.role,
    required this.present,
    required this.late,
    required this.absent,
    required this.accent,
  });

  final String name;
  final String role;
  final String present;
  final String late;
  final String absent;
  final Color accent;
}

class _PlayerAttendanceSummaryCard extends StatelessWidget {
  const _PlayerAttendanceSummaryCard({
    required this.player,
    required this.onTap,
  });

  final _PlayerAttendanceSummary player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: player.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.person, color: player.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      player.role,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _Pill(
                          label: 'Present',
                          value: player.present,
                          color: player.accent,
                        ),
                        _Pill(
                          label: 'Late',
                          value: player.late,
                          color: Color(0xFFFFB300),
                        ),
                        _Pill(
                          label: 'Absent',
                          value: player.absent,
                          color: const Color(0xFFD32F2F),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  const _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.detailTitle,
    required this.detailText,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String detailTitle;
  final String detailText;
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});

  final _OpsDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: day.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: day.color.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: day.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              day.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(day.detail, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.accent});

  final _OpsTask task;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: accent.withOpacity(0.12),
            child: Icon(task.icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  task.status,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Open',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({
    required this.role,
    required this.canType,
    required this.canCreate,
    required this.accent,
    required this.onToggleType,
    required this.onToggleCreate,
  });

  final String role;
  final bool canType;
  final bool canCreate;
  final Color accent;
  final VoidCallback onToggleType;
  final VoidCallback onToggleCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              role,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          _PermissionButton(
            label: 'Type ${canType ? 'On' : 'Off'}',
            enabled: canType,
            accent: accent,
            onPressed: onToggleType,
          ),
          const SizedBox(width: 8),
          _PermissionButton(
            label: 'Create ${canCreate ? 'On' : 'Off'}',
            enabled: canCreate,
            accent: accent,
            onPressed: onToggleCreate,
          ),
        ],
      ),
    );
  }
}

class _PermissionButton extends StatelessWidget {
  const _PermissionButton({
    required this.label,
    required this.enabled,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: enabled ? accent : Colors.grey.shade300),
        backgroundColor: enabled ? accent.withOpacity(0.12) : Colors.white,
        foregroundColor: enabled ? accent : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ActivityLine extends StatelessWidget {
  const _ActivityLine({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            child: Icon(Icons.lock_outline, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.title, required this.accent});

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.chevron_left, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: accent),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.role,
    required this.team,
    required this.accent,
    required this.avatarIcon,
  });

  final String name;
  final String role;
  final String team;
  final Color accent;
  final IconData avatarIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.72)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(avatarIcon, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(role, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                Text(
                  team,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Pill(label: 'Injury', value: 'OK', color: accent),
                    const SizedBox(width: 8),
                    const _Pill(
                      label: 'Status',
                      value: 'Active',
                      color: Color(0xFFFFB300),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.total,
    required this.present,
    required this.late,
    required this.absent,
    required this.accent,
  });

  final String total;
  final String present;
  final String late;
  final String absent;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C81),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCell(
              title: 'Total Sessions',
              value: total,
              valueColor: Colors.white,
            ),
          ),
          Expanded(
            child: _SummaryCell(
              title: 'Present',
              value: present,
              valueColor: const Color(0xFF8BC34A),
            ),
          ),
          Expanded(
            child: _SummaryCell(
              title: 'Late',
              value: late,
              valueColor: const Color(0xFFFFD54F),
            ),
          ),
          Expanded(
            child: _SummaryCell(
              title: 'Absent',
              value: absent,
              valueColor: const Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.session});

  final _AttendanceSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: session.statusColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(session.icon, color: session.statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.detail,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: session.statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              session.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: session.statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomReportCard extends StatelessWidget {
  const _BottomReportCard({
    required this.buttonText,
    required this.subtitle,
    required this.accent,
  });

  final String buttonText;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.values,
    required this.labels,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final List<double> values;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: values[i] / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: i.isEven
                                        ? accent
                                        : const Color(0xFFFFD54F),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.progress,
    required this.accent,
  });

  final String label;
  final double progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            color: accent,
            backgroundColor: accent.withOpacity(0.16),
          ),
        ),
      ],
    );
  }
}

class _OpsDay {
  const _OpsDay({
    required this.label,
    required this.title,
    required this.detail,
    required this.color,
  });

  final String label;
  final String title;
  final String detail;
  final Color color;
}

class _OpsTask {
  const _OpsTask({
    required this.title,
    required this.status,
    required this.icon,
  });

  final String title;
  final String status;
  final IconData icon;
}

class _AttendanceSession {
  const _AttendanceSession({
    required this.date,
    required this.title,
    required this.detail,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  final String date;
  final String title;
  final String detail;
  final String status;
  final Color statusColor;
  final IconData icon;
}

class _ChatGroup {
  _ChatGroup({
    required this.name,
    required this.members,
    required this.canType,
  });

  final String name;
  final List<String> members;
  final List<bool> canType;
}
