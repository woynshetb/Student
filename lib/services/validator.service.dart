
class FormValidator {
  static String? validateFirstName(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'First Name Can not be Empty';
    }
    return null;
  }
   static String? validateLastName(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Last Name Can not be Empty';
    }
    return null;
  }

 



}
