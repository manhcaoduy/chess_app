class Validator {
  // alphanum contains only the character that can appear in roomID
  final String alphanum = '0123456789';

  // validator for name
  String nameValidator(String value) {
    if (value.isEmpty) {
      return "Name must not be empty";
    }
    if (value.length > 10) {
      return "Name must not contain more than 10 characters";
    }
    return null;
  }

  // validator for roomId
  String roomIdValidator(String value) {
    if (value.isEmpty) {
      return "Room ID must not be empty";
    }
    if (value.length != 6) {
      return "Room ID must contain 6 characters";
    }
    for (var i = 0; i < value.length; i++) {
      if (!this.alphanum.contains(value[i])) {
        return "Invalid Room ID";
      }
    }
    return null;
  }
}
