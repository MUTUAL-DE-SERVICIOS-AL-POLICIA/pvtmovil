import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/model/contacts_model.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CardContact extends StatefulWidget {
  final City city;
  const CardContact({Key? key, required this.city}) : super(key: key);

  @override
  State<CardContact> createState() => _CardContactState();
}

class _CardContactState extends State<CardContact> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  AvailableMap? itemSelect;
  @override
  Widget build(BuildContext context) {
    return ContainerComponent(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Row(children: [
              Expanded(
                  child: Column(
                children: [
                  Text(widget.city.name!),
                  const SizedBox(height: 20),
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          const Text('Dirección:'),
                          GestureDetector(
                            onTap: () => openMapsSheet(
                                context,
                                Coords(widget.city.latitude!,
                                    widget.city.longitude!),
                                widget.city.companyAddress!),
                            child: Row(
                              children: [
                                Icon(Icons.location_on),
                                Flexible(
                                    child: Text(
                                  widget.city.companyAddress!,
                                  style: TextStyle(color: Color(0xff439CAB)),
                                ))
                              ],
                            ),
                          ),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                        ]),
                        if (json.decode(widget.city.companyPhones!).length > 0)
                          TableRow(children: [
                            const Text('Teléfonos:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var item
                                    in json.decode(widget.city.companyPhones!))
                                  GestureDetector(
                                    onTap: () => UrlLauncher.launchUrl(
                                        Uri(scheme: 'tel', path: '$item')),
                                    child: Text('$item',
                                        style: TextStyle(
                                            color: Color(0xff439CAB))),
                                  )
                              ],
                            )
                          ]),
                        const TableRow(children: [
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                        ]),
                        if (json.decode(widget.city.companyCellphones!).length >
                            0)
                          TableRow(children: [
                            const Text('Celulares:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var item in json
                                    .decode(widget.city.companyCellphones!))
                                  GestureDetector(
                                    onTap: () => UrlLauncher.launchUrl(
                                        Uri(scheme: 'tel', path: '$item')),
                                    child: Text('$item',
                                        style: TextStyle(
                                            color: Color(0xff439CAB))),
                                  )
                              ],
                            )
                          ])
                      ])
                ],
              ))
            ])));
  }

  openMapsSheet(context, Coords coords, String title) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                          onTap: () => map.showMarker(
                                coords: coords,
                                title: title,
                              ),
                          title: Text('Abrir: ${map.mapName}'),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          )),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
