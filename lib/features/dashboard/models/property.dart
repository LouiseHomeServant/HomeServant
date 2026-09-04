class Property {
  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.rating,
    required this.image,
    required this.category,
    required this.price,
    required this.priceUnit,
    required this.bedrooms,
    required this.bathrooms,
    required this.description,
    this.galleryImages = const [],
  });

  /// Stable key used to track this listing in the wishlist — titles alone
  /// aren't guaranteed unique once real listings replace the mock data.
  final String id;

  final String title;
  final String location;
  final double rating;

  /// Local asset path for the card and the hero image on the detail screen.
  final String image;

  /// One of the dashboard's category tabs — House, Shortlet, Self-Con,
  /// Apartment — used to filter the feed.
  final String category;

  final int price;

  /// 'year' or 'night' — shortlets are priced per night, everything else
  /// per year.
  final String priceUnit;

  final int bedrooms;
  final int bathrooms;
  final String description;

  /// Extra interior shots shown in the detail screen's preview strip.
  final List<String> galleryImages;

  String get priceLabel => '₦${_withThousandsSeparators(price)}/$priceUnit';
}

String _withThousandsSeparators(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

// Shared interior shots used in every property's "Details Preview" strip.
const _kitchenPhoto = 'assets/images/gallery_kitchen.jpg';
const _bathroomPhoto = 'assets/images/gallery_bathroom.jpg';
const _bedroomPhoto = 'assets/images/gallery_bedroom.jpg';
const _detailPreview = [_kitchenPhoto, _bathroomPhoto, _bedroomPhoto];

const mockProperties = [
  // House
  Property(
    id: 'house-agege-2br',
    title: '2 Bedroom Flat',
    location: 'Agege, Lagos',
    rating: 4.2,
    image: 'assets/images/2 bedroom.jpeg',
    category: 'House',
    price: 350000,
    priceUnit: 'year',
    bedrooms: 2,
    bathrooms: 2,
    description:
        'A comfortable 2-bedroom flat in a friendly Agege neighborhood, close to major roads and markets. '
        'Features tiled floors, good natural lighting, and a shared compound with parking space. '
        'Ideal for small families or young professionals looking for an affordable, well-located home.',
    galleryImages: _detailPreview,
  ),
  Property(
    id: 'house-magodo-3br',
    title: '3 Bedroom Duplex',
    location: 'Magodo, Lagos',
    rating: 4.7,
    image: 'assets/images/3bedroom.jpeg',
    category: 'House',
    price: 1200000,
    priceUnit: 'year',
    bedrooms: 3,
    bathrooms: 3,
    description:
        'An elegant 3-bedroom duplex in the serene, gated Magodo Estate. Boasts spacious rooms, a '
        'private balcony, ample parking, and round-the-clock estate security — perfect for families '
        'seeking comfort and privacy.',
    galleryImages: _detailPreview,
  ),
  // Shortlet
  Property(
    id: 'shortlet-lekki-studio',
    title: 'Cozy Shortlet Studio',
    location: 'Lekki, Lagos',
    rating: 4.6,
    image: 'assets/images/shortlet_lekki_studio.jpg',
    category: 'Shortlet',
    price: 45000,
    priceUnit: 'night',
    bedrooms: 1,
    bathrooms: 1,
    description:
        'A cozy, fully furnished studio in the heart of Lekki, perfect for short stays. Comes with '
        'fast WiFi, a smart TV, air conditioning, and 24/7 power supply — walking distance to '
        'restaurants and the beach.',
    galleryImages: _detailPreview,
  ),
  Property(
    id: 'shortlet-vi-luxury',
    title: 'Luxury Shortlet Apartment',
    location: 'Victoria Island, Lagos',
    rating: 4.9,
    image: 'assets/images/shortlet_vi_luxury.jpg',
    category: 'Shortlet',
    price: 120000,
    priceUnit: 'night',
    bedrooms: 2,
    bathrooms: 2,
    description:
        'A premium shortlet apartment in Victoria Island offering hotel-style luxury: a fitted '
        'kitchen, elegant furnishing, gym and pool access, and round-the-clock concierge — ideal for '
        'business trips or a weekend getaway.',
    galleryImages: _detailPreview,
  ),
  // Self-Con
  Property(
    id: 'selfcon-yaba-studio',
    title: 'Studio Self-Con',
    location: 'Yaba, Lagos',
    rating: 4.8,
    image: 'assets/images/selfcon_yaba_studio.jpg',
    category: 'Self-Con',
    price: 400000,
    priceUnit: 'year',
    bedrooms: 1,
    bathrooms: 1,
    description:
        'A neat, self-contained studio close to Yaba\'s tech hub and university campuses. Includes a '
        'private kitchenette, prepaid meter, and constant water supply — great for students and young '
        'professionals.',
    galleryImages: _detailPreview,
  ),
  Property(
    id: 'selfcon-surulere-mini',
    title: 'Mini Self-Con Flat',
    location: 'Surulere, Lagos',
    rating: 4.0,
    image: 'assets/images/selfcon_surulere_mini.jpg',
    category: 'Self-Con',
    price: 320000,
    priceUnit: 'year',
    bedrooms: 1,
    bathrooms: 1,
    description:
        'An affordable mini self-con tucked away in a quiet Surulere close, minutes from the Stadium '
        'and major bus stops. Simple, secure, and low-maintenance living for singles.',
    galleryImages: _detailPreview,
  ),
  // Apartment
  Property(
    id: 'apartment-opebi-4br',
    title: '4 Bedroom Apartment',
    location: 'Opebi, Ikeja, Lagos',
    rating: 4.5,
    image: 'assets/images/apartment_opebi_4br.jpg',
    category: 'Apartment',
    price: 500000,
    priceUnit: 'year',
    bedrooms: 4,
    bathrooms: 3,
    description:
        'Spacious 4-bedroom apartment available for rent in a quiet, secure neighborhood. The '
        'property features well-sized rooms, enough yard for recreational activity for the children '
        'with good natural lighting, a comfortable living area, and a functional kitchen. Both '
        'bedrooms are neatly finished and suitable for individuals, couples, or small families.',
    galleryImages: _detailPreview,
  ),
  Property(
    id: 'apartment-ikeja-gra-1br',
    title: '1 Bedroom Apartment',
    location: 'Ikeja GRA, Lagos',
    rating: 4.3,
    image: 'assets/images/apartment_ikeja_gra_1br.jpg',
    category: 'Apartment',
    price: 600000,
    priceUnit: 'year',
    bedrooms: 1,
    bathrooms: 1,
    description:
        'A modern 1-bedroom apartment in the leafy, upscale Ikeja GRA. Features a fitted kitchen, '
        'walk-in wardrobe, backup power, and access to a shared gym — a smart choice for professionals '
        'who want comfort close to the airport and business district.',
    galleryImages: _detailPreview,
  ),
];
