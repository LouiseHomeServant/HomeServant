class Property {
  const Property({
    required this.title,
    required this.location,
    required this.rating,
    required this.imageAsset,
    required this.category,
  });

  final String title;
  final String location;
  final double rating;
  final String imageAsset;

  /// One of the dashboard's category tabs — House, Shortlet, Self-Con,
  /// Apartment — used to filter the feed.
  final String category;
}

const mockProperties = [
  // House
  Property(
    title: '2 Bedroom Flat',
    location: 'Agege, Lagos',
    rating: 4.2,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'House',
  ),
  Property(
    title: '3 Bedroom Duplex',
    location: 'Magodo, Lagos',
    rating: 4.7,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'House',
  ),
  // Shortlet
  Property(
    title: 'Cozy Shortlet Studio',
    location: 'Lekki, Lagos',
    rating: 4.6,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Shortlet',
  ),
  Property(
    title: 'Luxury Shortlet Apartment',
    location: 'Victoria Island, Lagos',
    rating: 4.9,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Shortlet',
  ),
  // Self-Con
  Property(
    title: 'Studio Self-Con',
    location: 'Yaba, Lagos',
    rating: 4.8,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Self-Con',
  ),
  Property(
    title: 'Mini Self-Con Flat',
    location: 'Surulere, Lagos',
    rating: 4.0,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Self-Con',
  ),
  // Apartment
  Property(
    title: '4 Bedroom Apartment',
    location: 'Opebi, Ikeja, Lagos',
    rating: 4.5,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Apartment',
  ),
  Property(
    title: '1 Bedroom Apartment',
    location: 'Ikeja GRA, Lagos',
    rating: 4.3,
    imageAsset: 'assets/images/homepage.jpg',
    category: 'Apartment',
  ),
];
