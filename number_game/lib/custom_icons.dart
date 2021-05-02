import 'package:flutter/material.dart';

const double iconSize = 48;

CustomIcons myIcons = CustomIcons();

class CustomIcons {
  Widget getIcon(String name, double size, Color color){
    if(name.toLowerCase() == "mitomi" || name.toLowerCase() == "hayato") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/mitomi.jpeg'),
          )
        )
      );
    }
    if(name.toLowerCase() == "akisawa" || name.toLowerCase() == "taketo") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/akisawa.jpg'),
          )
        )
      );
    }
    if(name.toLowerCase() == "takeda" || name.toLowerCase() == "riku") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/takeda.JPG'),
          )
        )
      );
    }
    if(name.toLowerCase() == "fujitani" || name.toLowerCase() == "yuuki" || name.toLowerCase() == "yuki") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/fujitani.jpg'),
          )
        )
      );
    }
    if(name.toLowerCase() == "ishii" || name.toLowerCase() == "toshiki") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/ishii.JPG'),
          )
        )
      );
    }
    if(name.toLowerCase() == "tanuma" || name.toLowerCase() == "tomo") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/tanuma.JPG'),
          )
        )
      );
    }
    if(name.toLowerCase() == "takahashi" || name.toLowerCase() == "keisuke" || name.toLowerCase() == "kesuke") {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage('images/takahashi.JPG'),
          )
        )
      );
    }
    if(color == Colors.transparent) color = null;
    return Icon(Icons.person, size: size, color: color);
  }
}