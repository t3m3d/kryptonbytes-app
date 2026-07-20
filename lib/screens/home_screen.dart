import 'package:flutter/material.dart';

import '../data/booking_repository.dart';
import '../data/service_catalog.dart';
import '../domain/booking_models.dart';
import '../domain/business_rules.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final BookingRepository repository;

  void _openBooking(BuildContext context, [BookingService? service]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BookingScreen(
          repository: repository,
          initialService: service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: const BrandMark(compact: true),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton.tonalIcon(
                  onPressed: () => _openBooking(context),
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: const Text('Book'),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _MaxWidth(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 22),
                child: _Hero(onBook: () => _openBooking(context)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _MaxWidth(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                child: _SectionHeading(
                  eyebrow: 'START WITH THE BASICS',
                  title: 'What can we help with?',
                  subtitle:
                      'Choose the closest match. Complex work begins with an intake or consultation so scope and costs stay clear.',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _MaxWidth(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 900
                        ? 3
                        : constraints.maxWidth >= 580
                        ? 2
                        : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: serviceCatalog.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: columns == 1 ? 2.05 : 1.32,
                      ),
                      itemBuilder: (context, index) {
                        final service = serviceCatalog[index];
                        return _ServiceCard(
                          service: service,
                          onTap: () => _openBooking(context, service),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _MaxWidth(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                child: const _DetailsPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onBook});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.panel,
            AppTheme.mint.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.mint.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.mint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'LOUISVILLE-AREA TECHNOLOGY SERVICES',
              style: TextStyle(
                color: AppTheme.mint,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Tech work, scheduled\nwithout the runaround.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.02,
              letterSpacing: -1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Computer builds and repairs, secure networks, data recovery, cybersecurity, and practical IT help.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 26),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Book tech support'),
              ),
              const _PreviewBadge(),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.science_outlined, size: 18, color: AppTheme.cyan),
          SizedBox(width: 8),
          Text('Preview — no live charges'),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onTap});

  final BookingService service;
  final VoidCallback onTap;

  IconData get icon => switch (service.category) {
    ServiceCategory.computers => Icons.computer_rounded,
    ServiceCategory.networks => Icons.lan_rounded,
    ServiceCategory.security => Icons.shield_outlined,
    ServiceCategory.support => Icons.support_agent_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, color: AppTheme.mint),
                  const Spacer(),
                  Text(
                    service.category.label.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                service.shortDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, height: 1.35),
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  Text(
                    '${service.upfrontPrice} upfront',
                    style: const TextStyle(
                      color: AppTheme.mint,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Wrap(
          spacing: 30,
          runSpacing: 22,
          children: const <Widget>[
            _Detail(
              icon: Icons.schedule_rounded,
              title: 'Flexible hours',
              text: 'Weekday mornings and evenings, with 24-hour weekend availability.',
            ),
            _Detail(
              icon: Icons.location_on_outlined,
              title: 'Local service',
              text: 'Louisville, New Albany, and Jeffersonville.',
            ),
            _Detail(
              icon: Icons.payments_outlined,
              title: 'Clear booking policy',
              text: '\$30 deposit and \$70 at the appointment for standard services.',
            ),
            _Detail(
              icon: Icons.event_available_rounded,
              title: 'Three-day notice',
              text: 'Appointments open up to 60 days ahead in Eastern Time.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppTheme.cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(color: Colors.white60, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow,
          style: const TextStyle(
            color: AppTheme.mint,
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white60, height: 1.45)),
      ],
    );
  }
}

class _MaxWidth extends StatelessWidget {
  const _MaxWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1120), child: child));
  }
}
