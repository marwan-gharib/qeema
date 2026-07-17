class Validators {
  const Validators._();

  static String? email(
    String? value, {
    required String requiredMsg,
    required String invalidMsg,
  }) {
    if (value == null || value.isEmpty) return requiredMsg;
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return invalidMsg;
    return null;
  }

  static String? password(
    String? value, {
    required String requiredMsg,
    String? minLengthMsg,
  }) {
    if (value == null || value.isEmpty) return requiredMsg;
    if (value.length < 8) return minLengthMsg;
    return null;
  }

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
