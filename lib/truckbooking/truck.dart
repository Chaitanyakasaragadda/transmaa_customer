class Truck {
  final String imagePath;
  final String name;
  final double price;
  final String weightCapacity;
  final String selectedImageColor;
  bool isSelected; // Add isSelected property

  Truck({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.weightCapacity,
    required this.selectedImageColor,
    this.isSelected = false, // Provide a default value for isSelected
  });
}

