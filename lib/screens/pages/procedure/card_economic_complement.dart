import 'package:flutter/material.dart';
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
    return ContainerComponent(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Row(children: [
              Expanded(
                  child: Column(
                children: [
                  Text(widget.item!.title!),
                  const SizedBox(height: 20),
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          const Text('Estado  :', textAlign: TextAlign.right),
                          Text(widget.item!.subtitle!)
                        ]),
                        for (var itemx in widget.item!.display!)
                          TableRow(children: [
                            Text('${itemx.key!}  :',
                                textAlign: TextAlign.right),
                            itemx.value is List
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        for (var itemy in itemx.value)
                                          Text('*$itemy')
                                      ])
                                : Text('${itemx.value}')
                          ]),
                        if (widget.item!.printable!)
                          TableRow(children: [
                            const Text(''),
                            btnAccess
                                ? ButtonWhiteComponent(
                                    text: 'Documento PDF',
                                    onPressed: () => printDocument(context),
                                  )
                                : Center(
                                    child: Image.asset(
                                    'assets/images/load.gif',
                                    fit: BoxFit.cover,
                                    height: 20,
                                  ))
                          ])
                      ])
                ],
              ))
            ])));
  }

  printDocument(BuildContext context) async {
    setState(() => btnAccess = false);
    var response = await serviceMethod(
        context, 'get', null, serviceGetPDFEC(widget.item!.id!), true, true);
    setState(() => btnAccess = true);
    if (response != null) {
      String pathFile = await saveFile(
          context,
          'Trámites',
          'eco_com_${widget.item!.title!.replaceAll(' ', '_').replaceAll('/', '_').toLowerCase()}.pdf',
          response);
      await OpenFile.open(pathFile);
    }
  }
}
