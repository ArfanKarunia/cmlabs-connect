class StringUtils {
  // Static method to convert a hyphenated string to camel case
  static String toCamelCase(String? input) {
    if (input == null || input.isEmpty) {
      return '-'; // Return placeholder for null or empty input
    }

    return input
        .split(RegExp(r'[-_]')) // Split by hyphen or underscore
        .map((word) {
      if (word.isEmpty) return ''; // Skip empty parts
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' '); // Join words with spaces
  }

  static String setPitchDuration(int? value) {
    if (value == null) return '-'; // Return '-' if value is null
    if (value == 0) return "today"; // Return 'today' if value is 0

    // For positive values, return days ago
    if (value > 0) {
      return "$value day${value > 1 ? 's' : ''} ago";
    } else {
      // For negative values, return remaining days
      return "${-value} day${-value > 1 ? 's' : ''} remaining";
    }
  }
}
