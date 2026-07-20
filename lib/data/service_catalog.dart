import '../domain/booking_models.dart';

const List<ServiceMode> _standardModes = <ServiceMode>[
  ServiceMode.inOffice,
  ServiceMode.houseCall,
];

const List<BookingService> serviceCatalog = <BookingService>[
  BookingService(
    id: 'computer-repair',
    name: 'Computer & laptop repair',
    shortDescription:
        'Diagnostics and repair intake for hardware, software, performance, and startup problems.',
    category: ServiceCategory.computers,
    durationOptions: <int>[30, 60],
    supportedModes: <ServiceMode>[
      ServiceMode.inOffice,
      ServiceMode.houseCall,
      ServiceMode.remote,
    ],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'Parts and extended labor are quoted separately.',
  ),
  BookingService(
    id: 'custom-computer',
    name: 'Custom computer build',
    shortDescription:
        'Plan a gaming, workstation, home, or business PC around your goals and budget.',
    category: ServiceCategory.computers,
    durationOptions: <int>[30, 60],
    supportedModes: <ServiceMode>[
      ServiceMode.inOffice,
      ServiceMode.remote,
    ],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'Components and assembly are quoted after the consultation.',
  ),
  BookingService(
    id: 'computer-dropoff',
    name: 'Computer drop-off',
    shortDescription:
        'A quick in-office intake to document the device, symptoms, and next steps.',
    category: ServiceCategory.computers,
    durationOptions: <int>[15],
    supportedModes: <ServiceMode>[ServiceMode.inOffice],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'The residential office address is shared after confirmation.',
  ),
  BookingService(
    id: 'network-setup',
    name: 'Network setup & segmentation',
    shortDescription:
        'Wi-Fi, routers, VLANs, guest networks, device isolation, and secure configuration.',
    category: ServiceCategory.networks,
    durationOptions: <int>[60],
    supportedModes: _standardModes,
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'Equipment and work beyond the first visit are quoted separately.',
  ),
  BookingService(
    id: 'security-assessment',
    name: 'Security consultation',
    shortDescription:
        'A practical review of account, computer, server, or network security concerns.',
    category: ServiceCategory.security,
    durationOptions: <int>[30, 60],
    supportedModes: <ServiceMode>[
      ServiceMode.remote,
      ServiceMode.houseCall,
      ServiceMode.inOffice,
    ],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'Testing is performed only with documented authorization.',
  ),
  BookingService(
    id: 'data-recovery',
    name: 'Data recovery intake',
    shortDescription:
        'Evaluate an inaccessible or failing drive, phone, computer, or storage device.',
    category: ServiceCategory.computers,
    durationOptions: <int>[30],
    supportedModes: <ServiceMode>[ServiceMode.inOffice],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'Recovery work and replacement media are quoted after evaluation.',
  ),
  BookingService(
    id: 'general-it',
    name: 'General IT consultation',
    shortDescription:
        'Start here for technical work that does not fit another category.',
    category: ServiceCategory.support,
    durationOptions: <int>[15, 30, 60],
    supportedModes: <ServiceMode>[
      ServiceMode.remote,
      ServiceMode.houseCall,
      ServiceMode.inOffice,
    ],
    upfrontCents: 3000,
    dueAtAppointmentCents: 7000,
    pricingNote: 'We will confirm scope before any additional work or expense.',
  ),
  BookingService(
    id: 'phone-support',
    name: 'Extended phone technical support',
    shortDescription:
        'Dedicated phone or remote troubleshooting, with sessions available up to six hours.',
    category: ServiceCategory.support,
    durationOptions: <int>[60, 120, 180, 360],
    supportedModes: <ServiceMode>[ServiceMode.remote],
    upfrontCents: 5000,
    dueAtAppointmentCents: 0,
    pricingNote: 'The full $50 support charge is paid when booking.',
  ),
];

BookingService serviceById(String id) =>
    serviceCatalog.firstWhere((service) => service.id == id);
