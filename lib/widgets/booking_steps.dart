import 'package:flutter/material.dart';

import '../data/service_catalog.dart';
import '../domain/booking_models.dart';
import '../domain/business_rules.dart';
import '../theme/app_theme.dart';

class ServiceStep extends StatelessWidget {
  const ServiceStep({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final BookingService? selected;
  final ValueChanged<BookingService> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const StepHeading(
          title: 'Choose a service',
          subtitle: 'Pick the closest match. We can refine the scope together.',
        ),
        const SizedBox(height: 16),
        ...serviceCatalog.map(
          (service) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OptionTile(
              selected: selected?.id == service.id,
              onTap: () => onSelected(service),
              leading: Icon(
                _categoryIcon(service.category),
                color: selected?.id == service.id ? AppTheme.ink : AppTheme.mint,
              ),
              title: service.name,
              subtitle: service.shortDescription,
              trailing: Text(
                '${service.upfrontPrice}\nupfront',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: selected?.id == service.id
                      ? AppTheme.ink
                      : AppTheme.mint,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentStep extends StatelessWidget {
  const AppointmentStep({
    super.key,
    required this.service,
    required this.durationMinutes,
    required this.mode,
    required this.serviceArea,
    required this.onDurationChanged,
    required this.onModeChanged,
    required this.onAreaChanged,
  });

  final BookingService service;
  final int? durationMinutes;
  final ServiceMode? mode;
  final String? serviceArea;
  final ValueChanged<int?> onDurationChanged;
  final ValueChanged<ServiceMode> onModeChanged;
  final ValueChanged<String?> onAreaChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const StepHeading(
          title: 'Appointment details',
          subtitle: 'Choose the length and the easiest way to get help.',
        ),
        const SizedBox(height: 18),
        DropdownButtonFormField<int>(
          initialValue: durationMinutes,
          decoration: const InputDecoration(
            labelText: 'Appointment length',
            prefixIcon: Icon(Icons.timer_outlined),
          ),
          items: service.durationOptions
              .map(
                (duration) => DropdownMenuItem<int>(
                  value: duration,
                  child: Text(formatDuration(duration)),
                ),
              )
              .toList(),
          onChanged: onDurationChanged,
        ),
        const SizedBox(height: 18),
        Text('How should we meet?', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...service.supportedModes.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OptionTile(
              selected: mode == option,
              onTap: () => onModeChanged(option),
              leading: Icon(
                _modeIcon(option),
                color: mode == option ? AppTheme.ink : AppTheme.cyan,
              ),
              title: option.label,
              subtitle: option.description,
            ),
          ),
        ),
        if (mode == ServiceMode.houseCall) ...<Widget>[
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: serviceArea,
            decoration: const InputDecoration(
              labelText: 'Service area',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: BusinessRules.serviceAreas
                .map(
                  (area) => DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  ),
                )
                .toList(),
            onChanged: onAreaChanged,
          ),
        ],
        if (mode == ServiceMode.inOffice) ...<Widget>[
          const SizedBox(height: 8),
          const InfoBox(
            icon: Icons.home_work_outlined,
            text:
                'In-office appointments are lower cost. Because the office is a residence, the exact address is provided after confirmation.',
          ),
        ],
        const SizedBox(height: 14),
        _PriceSummary(service: service),
      ],
    );
  }
}

class ScheduleStep extends StatelessWidget {
  const ScheduleStep({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.slots,
    required this.onPickDate,
    required this.onSlotChanged,
  });

  final DateTime? selectedDate;
  final int? selectedSlot;
  final List<TimeSlot> slots;
  final VoidCallback onPickDate;
  final ValueChanged<int?> onSlotChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const StepHeading(
          title: 'Pick a time',
          subtitle:
              'Appointments require three days’ notice. All times are shown in Eastern Time.',
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: onPickDate,
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(
            selectedDate == null ? 'Choose a date' : formatDate(selectedDate!),
          ),
        ),
        if (selectedDate != null) ...<Widget>[
          const SizedBox(height: 12),
          InfoBox(
            icon: Icons.schedule_rounded,
            text: BusinessRules.hoursSummaryFor(selectedDate!),
          ),
          const SizedBox(height: 16),
          if (slots.isEmpty)
            const InfoBox(
              icon: Icons.event_busy_outlined,
              text:
                  'No openings fit this appointment length on that date. Try another date or a shorter session.',
              warning: true,
            )
          else
            DropdownButtonFormField<int>(
              initialValue: selectedSlot,
              decoration: const InputDecoration(
                labelText: 'Available time',
                prefixIcon: Icon(Icons.access_time_rounded),
              ),
              items: slots
                  .map(
                    (slot) => DropdownMenuItem<int>(
                      value: slot.startMinute,
                      child: Text(slot.label),
                    ),
                  )
                  .toList(),
              onChanged: onSlotChanged,
            ),
        ],
      ],
    );
  }
}

class ContactStep extends StatelessWidget {
  const ContactStep({
    super.key,
    required this.formKey,
    required this.service,
    required this.date,
    required this.startMinute,
    required this.durationMinutes,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.detailsController,
    required this.policyAccepted,
    required this.onPolicyChanged,
  });

  final GlobalKey<FormState> formKey;
  final BookingService service;
  final DateTime date;
  final int startMinute;
  final int durationMinutes;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController detailsController;
  final bool policyAccepted;
  final ValueChanged<bool> onPolicyChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const StepHeading(
            title: 'Contact & review',
            subtitle: 'Tell us who to contact and what is happening.',
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.name],
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Enter an email address.';
              if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email address.';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.telephoneNumber],
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: detailsController,
            minLines: 4,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'What do you need help with?',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().length < 10) {
                return 'Please add at least a short description.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Booking summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  SummaryRow(label: 'Service', value: service.name),
                  SummaryRow(label: 'Date', value: formatDate(date)),
                  SummaryRow(
                    label: 'Time',
                    value: TimeSlot(
                      startMinute: startMinute,
                      durationMinutes: durationMinutes,
                    ).label,
                  ),
                  SummaryRow(label: 'Pay now', value: service.upfrontPrice),
                  if (service.dueAtAppointmentCents > 0)
                    SummaryRow(label: 'Due at appointment', value: service.duePrice),
                  const Divider(height: 24),
                  Text(service.pricingNote, style: const TextStyle(color: Colors.white60)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: policyAccepted,
            onChanged: (value) => onPolicyChanged(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('I understand the cancellation policy.'),
            subtitle: Text(
              service.id == 'phone-support'
                  ? 'The $50 phone-support payment is collected in full at booking. Refund terms will be finalized before launch.'
                  : 'The $30 booking deposit is kept if I cancel. The $70 appointment charge is not collected for a canceled appointment.',
            ),
          ),
          const InfoBox(
            icon: Icons.science_outlined,
            text:
                'Preview mode: submitting this form creates only an in-memory test booking. No payment or email is sent.',
          ),
        ],
      ),
    );
  }

  static String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}

class StepHeading extends StatelessWidget {
  const StepHeading({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text(subtitle, style: const TextStyle(color: Colors.white60, height: 1.4)),
      ],
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.selected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.mint : Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: selected ? AppTheme.ink : Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: selected ? AppTheme.ink.withValues(alpha: 0.72) : Colors.white60,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.icon, required this.text, this.warning = false});

  final IconData icon;
  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? Colors.orangeAccent : AppTheme.cyan;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 130, child: Text(label, style: const TextStyle(color: Colors.white54))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({required this.service});

  final BookingService service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SummaryRow(label: 'Paid when booking', value: service.upfrontPrice),
            if (service.dueAtAppointmentCents > 0)
              SummaryRow(label: 'Due at appointment', value: service.duePrice),
            const Divider(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(service.pricingNote, style: const TextStyle(color: Colors.white60)),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _categoryIcon(ServiceCategory category) => switch (category) {
  ServiceCategory.computers => Icons.computer_rounded,
  ServiceCategory.networks => Icons.lan_rounded,
  ServiceCategory.security => Icons.shield_outlined,
  ServiceCategory.support => Icons.support_agent_rounded,
};

IconData _modeIcon(ServiceMode mode) => switch (mode) {
  ServiceMode.remote => Icons.phone_in_talk_outlined,
  ServiceMode.houseCall => Icons.directions_car_outlined,
  ServiceMode.inOffice => Icons.home_work_outlined,
};
