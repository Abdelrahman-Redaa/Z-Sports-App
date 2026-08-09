import 'package:z_sports_booking/data/models/booking_model.dart';
import 'package:z_sports_booking/data/models/chat_model.dart';
import 'package:z_sports_booking/data/models/notification_model.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/data/models/user_model.dart';

abstract final class MockData {
  static const currentUser = UserModel(
    id: '1',
    name: 'أحمد',
    email: 'abdelrahman@example.com',
    phone: '+20 100 123 4567',
    avatarUrl: 'https://i.pravatar.cc/150?u=abdelrahman',
  );

  static const categories = [
    '5 ضد 5',
    '7 ضد 7',
    '11 ضد 11',
    'صالة مغلقة',
    'عشب طبيعي',
  ];

  static const pitches = [
    PitchModel(
      id: '1',
      name: 'ملعب الأساطير',
      imageUrl:
          'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=800',
      rating: 4.9,
      reviewCount: 120,
      pricePerHour: 300,
      location: 'التجمع الخامس، القاهرة',
      distance: '2.5 كم',
      category: '5 ضد 5',
      amenities: ['إضاءة', 'غرف تغيير', 'مواقف', 'مياه'],
      description:
          'ملعب بمواصفات عالمية، عشب صناعي من الجيل الخامس، إضاءة ليد احترافية. بمساحة واسعة تناسب المباريات التنافسية.',
      isPopular: true,
    ),
    PitchModel(
      id: '2',
      name: 'ملعب الملوك',
      imageUrl:
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800',
      rating: 4.8,
      reviewCount: 100,
      pricePerHour: 250,
      location: 'مدينة نصر، القاهرة',
      distance: '4.1 كم',
      category: '7 ضد 7',
      amenities: ['إضاءة', 'كافتيريا', 'مواقف'],
      description:
          'ملعب بمواصفات عالمية، عشب صناعي من الجيل الخامس، إضاءة ليد احترافية. بمساحة واسعة تناسب المباريات التنافسية.',
      isPopular: true,
    ),
    PitchModel(
      id: '3',
      name: 'ملعب المدينة',
      imageUrl:
          'https://images.unsplash.com/photo-1459865269687-92ea836bad04?w=800',
      rating: 4.4,
      reviewCount: 85,
      pricePerHour: 200,
      location: 'المعادي، القاهرة',
      distance: '6.3 كم',
      category: '5 ضد 5',
      amenities: ['إضاءة', 'غرف تغيير'],
      description: 'ملعب مميز بأسعار مناسبة في موقع هادئ.',
    ),
    PitchModel(
      id: '4',
      name: 'ملعب الصقر',
      imageUrl:
          'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=800',
      rating: 4.9,
      reviewCount: 200,
      pricePerHour: 350,
      location: '6 أكتوبر، الجiza',
      distance: '8.0 كم',
      category: '11 ضد 11',
      amenities: ['إضاءة', 'غرف تغيير', 'مواقف', 'مياه', 'كافتيريا'],
      description: 'أفضل ملعب بمساحة كاملة ومرافق فاخرة.',
      isPopular: true,
    ),
    PitchModel(
      id: '5',
      name: 'ملعب الشمس',
      imageUrl:
          'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=800',
      rating: 4.2,
      reviewCount: 45,
      pricePerHour: 180,
      location: 'حلوان، القاهرة',
      distance: '10.2 كم',
      category: 'كرة قدم (7 ضد 7)',
      amenities: ['إضاءة', 'مواقف'],
      description: 'ملعب اقتصادي مناسب للتدريبات اليومية.',
    ),
    PitchModel(
      id: '6',
      name: 'سلة الحريف',
      imageUrl:
          'https://images.unsplash.com/photo-1546519638405-a9d1b29d3df3?w=800',
      rating: 4.5,
      reviewCount: 120,
      pricePerHour: 280,
      location: 'مدينة نصر، القاهرة',
      distance: '3.2 كم',
      category: 'كرة سلة (5 ضد 5)',
      amenities: ['إضاءة', 'غرف تغيير', 'مواقف', 'مياه'],
      description:
          'استمتع بتجربة لعب لا مثيل لها في أفضل ملاعب كرة سلة بالمنطقة. تم تجهيز الملعب بأرضيات تمنحك الثبات والراحة أثناء الحركة.',
      isPopular: true,
    ),
    PitchModel(
      id: '7',
      name: 'سلة الاهرامات',
      imageUrl:
          'https://images.unsplash.com/photo-1504450758481-7338eba7524a?w=800',
      rating: 4.7,
      reviewCount: 120,
      pricePerHour: 350,
      location: '6 أكتوبر، الجيزة',
      distance: '7.5 كم',
      category: 'كرة سلة (5 ضد 5)',
      amenities: ['إضاءة', 'غرف تغيير', 'مواقف', 'كافتيريا'],
      description:
          'استمتع بتجربة لعب لا مثيل لها في أفضل ملاعب كرة سلة بالمنطقة. تم تجهيز الملعب بأرضيات تمنحك الثبات والراحة أثناء الحركة.',
      isPopular: true,
    ),
    PitchModel(
      id: '8',
      name: 'ملعب تنس النيل',
      imageUrl:
          'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=800',
      rating: 4.6,
      reviewCount: 90,
      pricePerHour: 320,
      location: 'المعادي، القاهرة',
      distance: '5.0 كم',
      category: 'تنس',
      amenities: ['إضاءة', 'غرف تغيير', 'مواقف', 'مياه'],
      description:
          'ملعب تنس باحترافية عالية بأرضيات هارد كورت عالمية المواصفات، مجهز بإضاءة ليلية قوية لتجربة لعب مثالية.',
      isPopular: true,
    ),
    PitchModel(
      id: '9',
      name: 'تنس الملوك',
      imageUrl:
          'https://images.unsplash.com/photo-1545809074-59472b3f5ecc?w=800',
      rating: 4.3,
      reviewCount: 65,
      pricePerHour: 250,
      location: 'التجمع الخامس، القاهرة',
      distance: '4.8 كم',
      category: 'تنس',
      amenities: ['إضاءة', 'مواقف'],
      description: 'ملعب تنس مميز بموقع استراتيجي في التجمع الخامس.',
    ),
  ];

  static final bookings = [
    BookingModel(
      id: 'b1',
      pitch: pitches[0],
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: '6:00 م',
      endTime: '7:00 م',
      totalPrice: 250,
      status: BookingStatus.upcoming,
    ),
    BookingModel(
      id: 'b2',
      pitch: pitches[1],
      date: DateTime.now().add(const Duration(days: 5)),
      startTime: '8:00 م',
      endTime: '9:00 م',
      totalPrice: 300,
      status: BookingStatus.upcoming,
    ),
    BookingModel(
      id: 'b3',
      pitch: pitches[2],
      date: DateTime.now().subtract(const Duration(days: 3)),
      startTime: '5:00 م',
      endTime: '6:00 م',
      totalPrice: 200,
      status: BookingStatus.completed,
    ),
  ];

  static const notifications = [
    NotificationModel(
      id: 'n1',
      title: 'تم تأكيد حجزك',
      body: 'تم تأكيد حجزك في ملعب النجوم يوم الجمعة 6:00 م',
      time: 'منذ 5 دقائق',
      isRead: false,
    ),
    NotificationModel(
      id: 'n2',
      title: 'عرض خاص',
      body: 'خصم 20% على جميع الملاعب هذا الأسبوع!',
      time: 'منذ ساعتين',
      isRead: false,
    ),
    NotificationModel(
      id: 'n3',
      title: 'تذكير بالحجز',
      body: 'حجزك في ملعب الأبطال غداً الساعة 8:00 م',
      time: 'أمس',
      isRead: true,
    ),
  ];

  static const conversations = [
    ChatConversation(
      id: 'c1',
      name: 'إدارة ملعب النجوم',
      avatarUrl: 'https://i.pravatar.cc/150?u=pitch1',
      lastMessage: 'تم تأكيد حجزك، نراك قريباً!',
      time: '10:30 ص',
      unreadCount: 2,
      messages: [
        ChatMessage(
          id: 'm1',
          text: 'مرحباً، أريد حجز الملعب',
          isSent: true,
          time: '10:00 ص',
        ),
        ChatMessage(
          id: 'm2',
          text: 'أهلاً بك! متى تريد الحجز؟',
          isSent: false,
          time: '10:05 ص',
        ),
        ChatMessage(
          id: 'm3',
          text: 'يوم الجمعة 6 مساءً',
          isSent: true,
          time: '10:10 ص',
        ),
        ChatMessage(
          id: 'm4',
          text: 'تم تأكيد حجزك، نراك قريباً!',
          isSent: false,
          time: '10:30 ص',
        ),
      ],
    ),
    ChatConversation(
      id: 'c2',
      name: 'ملعب الأبطال',
      avatarUrl: 'https://i.pravatar.cc/150?u=pitch2',
      lastMessage: 'الملعب متاح في الموعد المطلوب',
      time: 'أمس',
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'm5',
          text: 'هل الملعب متاح غداً؟',
          isSent: true,
          time: '3:00 م',
        ),
        ChatMessage(
          id: 'm6',
          text: 'الملعب متاح في الموعد المطلوب',
          isSent: false,
          time: '3:15 م',
        ),
      ],
    ),
  ];

  static const timeSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '01:00',
    '02:00',
    '03:00',
  ];

  static PitchModel pitchById(String id) =>
      pitches.firstWhere((p) => p.id == id, orElse: () => pitches.first);

  static ChatConversation conversationById(String id) => conversations
      .firstWhere((c) => c.id == id, orElse: () => conversations.first);
}
