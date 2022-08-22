import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:theme_provider/theme_provider.dart';

class CardEc extends StatefulWidget {
  final Datum? item;
  const CardEc({Key? key, this.item}) : super(key: key);

  @override
  State<CardEc> createState() => _CardEcState();
}

class _CardEcState extends State<CardEc> {
  bool btnAccess = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ContainerComponent(
          color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Row(children: [
                Expanded(
                    child: Column(
                  children: [
                    // Text(widget.item!.title!),
                    Row(
                      mainAxisAlignment: (widget.item!.subtitle! != '')
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.item!.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: widget.item!.subtitle! != ''
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                        ),
                        if (widget.item!.subtitle! != '')
                          Flexible(
                            child: Text(
                              widget.item!.subtitle!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Table(
                        columnWidths: const {
                          0: FlexColumnWidth(5),
                          1: FlexColumnWidth(0.3),
                          2: FlexColumnWidth(5),
                        },
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                            style: BorderStyle.solid,
                          ),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          for (var itemx in widget.item!.display!)
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Text(
                                  itemx.key!,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontFamily: 'Manrope'),
                                ),
                              ),
                              const Text(':'),
                              itemx.value is List
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var itemy in itemx.value)
                                          Text(
                                            '• $itemy',
                                            style: const TextStyle(
                                                fontFamily: 'Manrope'),
                                          )
                                      ],
                                    )
                                  : Text(
                                      '${itemx.value}',
                                      style: const TextStyle(
                                          fontFamily: 'Manrope'),
                                    ),
                            ]),
                          if (widget.item!.printable!)
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Text(
                                  'Comprovante del trámite',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontFamily: 'Manrope'),
                                ),
                              ),
                              const Text(':'),
                              btnAccess
                                  ? Row(
                                      children: [
                                        Center(
                                            child: SvgPicture.asset(
                                          'assets/icons/printer.svg',
                                          height: 30.0,
                                          color: ThemeProvider.themeOf(context)
                                              .data
                                              .hintColor,
                                        )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: ButtonWhiteComponent(
                                            text: 'Documento PDF',
                                            onPressed: () =>
                                                printDocument(context),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Image.asset(
                                      'assets/images/load.gif',
                                      fit: BoxFit.cover,
                                      height: 20,
                                    ))
                            ]),
                        ]),
                  ],
                ))
              ]))),
    );
  }

  printDocument(BuildContext context) async {
    setState(() => btnAccess = false);
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetPDFEC(widget.item!.id!), true, true);
    setState(() => btnAccess = true);
    if (response != null) {
      String pathFile = await saveFile(
          'Documents',
          'eco_com_${widget.item!.title!.replaceAll(' ', '_').replaceAll('/', '_').toLowerCase()}.pdf',
          response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
}
