import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:theme_provider/theme_provider.dart';

class CardExpanded extends StatefulWidget {
  final String id;
  const CardExpanded({Key? key, required this.id}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: widget.id,
                child: Material(
                    type: MaterialType.transparency, // likely needed
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                          height: 200,
                          width: 300,
                          color: ThemeProvider.themeOf(context)
                              .data
                              .scaffoldBackgroundColor,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [Text('data')],
                          ))),
                    ))),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
