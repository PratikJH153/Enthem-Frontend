String displayUserPicture(String username) {
  return "${username.toString()[0].toUpperCase()}${username.toString()[username.length - 1].toUpperCase()}";
}
