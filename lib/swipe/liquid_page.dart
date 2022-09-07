import 'package:flutter/material.dart';

const greyStyle = TextStyle(fontSize: 40.0, color: Colors.white);
const descriptionGreyStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300);
const title = TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400);
const subtitle = TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);

final liquidPages = [
  const LiquidPage(
    imageBackground: 'assets/images/001.jpg',
    imageFront: "assets/icons/6.png",
    titleText: "BIENVENIDO",
    subtitleText: "MUTUAL DE SERVICIOS AL POLICÍA",
    text: "",
  ),
  const LiquidPage(
    imageBackground: 'assets/images/002.jpg',
    imageFront: "assets/icons/7.png",
    titleText: "EVITA HACER FILAS",
    subtitleText: "COMPLEMENTO ECONÓMICO",
    text: "Podras realizar la solicitud y seguimiento del pago del Beneficio del Complemento Económico",
  ),
  const LiquidPage(
      imageBackground: 'assets/images/003.jpg',
      imageFront: "assets/icons/003.png",
      titleText: "SEGUIMIENTO\nDE",
      subtitleText: "APORTES",
      text: "Realiza seguimiento de tus aportes"),
  const LiquidPage(
      imageBackground: 'assets/images/004.jpg',
      imageFront: "assets/icons/9.png",
      titleText: "SEGUIMIENTO\nDE",
      subtitleText: "PRESTAMOS",
      text: "Realiza seguimiento de tus prestamos"),
];

class LiquidPage extends StatelessWidget {
  final String imageBackground;
  final String imageFront;
  final String titleText;
  final String subtitleText;
  final String text;
  const LiquidPage(
      {Key? key, required this.imageBackground, required this.imageFront, required this.titleText, required this.subtitleText, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(imageBackground),
        fit: BoxFit.fitHeight,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Image.asset(
          //   imageFront,
          //   height: 150,
          //   width: 150,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(titleText, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400)),
                Text(subtitleText,
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: descriptionGreyStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
