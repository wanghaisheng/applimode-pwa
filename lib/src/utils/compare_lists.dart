List<String> compareLists(
  List<String> firstList,
  List<String> secondList,
) {
  List<String> popItems = [];
  for (final item in firstList) {
    if (!secondList.contains(item)) {
      popItems.add(item);
    }
  }
  return popItems;
}
