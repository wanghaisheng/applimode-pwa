class MultiImages {
  const MultiImages({
    required this.imageUrl,
    this.imageUrlsList,
    this.currentIndex,
  });

  final String imageUrl;
  final List<String>? imageUrlsList;
  final int? currentIndex;
}
