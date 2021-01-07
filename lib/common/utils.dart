// class Utils {
//   String capitalize(String s) => (s != null && s.length > 1)
//       ? s[0].toUpperCase() + s.substring(1)
//       : s != null ? s.toUpperCase() : null;
// }


extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.inCaps).join(" ");
}