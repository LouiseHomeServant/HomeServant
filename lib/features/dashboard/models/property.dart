class Property {
  const Property({
    required this.title,
    required this.location,
    required this.rating,
    required this.imageAsset,
  });

  final String title;
  final String location;
  final double rating;
  final String imageAsset;
}

const mockProperties = [
  Property(
    title: '4 Bedroom Apartment',
    location: 'Opebi, Ikeja, Lagos',
    rating: 4.5,
    imageAsset: 'assets/images/homepage.jpg',
  ),
  Property(
    title: '2 Bedroom Flat',
    location: 'Agege, Lagos',
    rating: 4.2,
    imageAsset: 'assets/images/homepage.jpg',
  ),
  Property(
    title: 'Studio Self-Con',
    location: 'Yaba, Lagos',
    rating: 4.8,
    imageAsset: 'assets/images/homepage.jpg',
  ),
];
