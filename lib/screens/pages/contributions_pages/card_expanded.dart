import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardExpanded extends StatelessWidget {
  final String index;
  final Contribution contribution;
  final Color colorRefund;
  const CardExpanded({
    super.key,
    required this.colorRefund,
    required this.index,
    required this.contribution,
  });

  bool get _isActive => contribution.state == 'ACTIVO';

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent.withValues(alpha: 0.5),
        body: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Hero(
              tag: index,
              child: Material(
                type: MaterialType.transparency,
                child: GestureDetector(
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: ContainerComponent(
                      width: MediaQuery.of(context).size.width / 1.1,
                      color: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HedersComponent(
                            titleHeader: contribution.state,
                            title: DateFormat(' dd, MMMM yyyy ', "es_ES")
                                .format(contribution.monthYear!),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 14.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Grupo 1: Cotizable (ambos estados)
                                  _row('Cotizable', '${contribution.quotable!} Bs', textColor),

                                  if (!_isActive) ...[
                                    // PASIVO: Cotizable + Total Aporte
                                    // En PASIVO el dato real viene en "total", no en "contribution_total"
                                    _divider(),
                                    _row('Total Aporte',
                                        '${contribution.total ?? '0,00'} Bs', textColor),
                                  ],

                                  if (_isActive) ...[
                                    _divider(),

                                    // Grupo 2: Fondo de retiro + Cuota mortuoria
                                    if (contribution.retirementFund != null &&
                                        contribution.retirementFund != '0,00')
                                      _row('Fondo de retiro', contribution.retirementFund!, textColor),
                                    if (contribution.mortuaryQuota != null &&
                                        contribution.mortuaryQuota != '0,00')
                                      _row('Cuota mortuoria', contribution.mortuaryQuota!, textColor),

                                    _divider(),

                                    // Grupo 3: Total Aporte
                                    _row('Total Aporte',
                                        '${contribution.contributionTotal ?? '0,00'} Bs', textColor),

                                    _divider(),

                                    // Grupo 4: Aporte + Reintegro/Regularización
                                    _row('Aporte',
                                        '${contribution.contributionTotal ?? '0,00'} Bs', textColor),
                                    _row(
                                      contribution.typePayroll == 'regularizacion'
                                          ? 'Regularización'
                                          : 'Reintegro',
                                      '${contribution.reimbursementTotal ?? '0,00'} Bs',
                                      textColor,
                                      dotColor: colorRefund != Colors.transparent
                                      ? (Theme.of(context).brightness == Brightness.dark
                                          ? colorRefund  // dark: mantiene el color original
                                          : (contribution.typePayroll == 'regularizacion'
                                              ? const Color(0xffE8837C)   // light: rojo suave
                                              : const Color(0xffE0A44C))) // light: dorado (sin cambio)
                                      : null,
                                    ),

                                    _divider(),

                                    // Grupo 5: TOTAL
                                    _totalRow('${contribution.total ?? '0,00'} Bs', textColor),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Container(height: 1, color: Colors.grey.shade300),
    );
  }

  Widget _row(String label, String value, Color textColor, {Color? dotColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                ),
                SizedBox(width: 8.sp),
              ],
              Text(
                label,
                style: TextStyle(fontSize: 18.sp, color: textColor.withValues(alpha: 0.75)),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String value, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('TOTAL',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: textColor)),
          Text(value,
              style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}