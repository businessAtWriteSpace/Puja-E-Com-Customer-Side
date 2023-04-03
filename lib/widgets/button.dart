import '../../consts/consts.dart';

Widget ourButton({onPress, color, textColor, title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: Text(title,
        style: TextStyle(
          color: textColor,
          fontFamily: bold,
        ),));
}