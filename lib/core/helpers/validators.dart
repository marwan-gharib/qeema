class Validators {
  const Validators._();

  static String? amount(
    String? value, {
    required String requiredMsg,
    required String invalidMsg,
  }) {
    if (value == null || value.isEmpty) return requiredMsg;
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return invalidMsg;
    }
    return null;
  }
}
