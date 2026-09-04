import 'property.dart';

class ChatUser {
  const ChatUser({required this.name, required this.subtitle});

  final String name;
  final String subtitle;
}

/// Directory of people a tenant can start a chat (or group chat) with —
/// every property's landlord, plus a few other tenants and support, so
/// there's someone to search for beyond just landlords.
final mockChatUsers = [
  for (final property in mockProperties) ChatUser(name: property.landlordName, subtitle: 'Landlord · ${property.title}'),
  const ChatUser(name: 'HomeServant Support', subtitle: 'Support'),
  const ChatUser(name: 'Ada Chukwu', subtitle: 'Tenant'),
  const ChatUser(name: 'Musa Ibrahim', subtitle: 'Tenant'),
  const ChatUser(name: 'Grace Effiong', subtitle: 'Tenant'),
];
