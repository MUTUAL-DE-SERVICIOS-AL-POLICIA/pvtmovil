import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/model/evaluation_models.dart';
import 'package:muserpol_pvt/model/loan_pre_evaluation_model.dart';
import 'package:muserpol_pvt/services/evaluation_service.dart';

class EvaluationWidgets {
  // ============================================================================
  // HEADERS Y CONTENEDORES
  // ============================================================================

  /// Header con gradiente común
  static Widget gradientHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff419388) : const Color(0xFFB2DFDB), // Fondo sólido
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: const Color(0xff419388).withValues(alpha: 0.5), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF80CBC4).withValues(alpha: 0.23),
            blurRadius: isDark ? 12 : 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF00695C), size: 24.sp),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF00695C),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF00695C).withValues(alpha: 0.9),
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Container con gradiente y borde común
  static Widget gradientContainer({
    required Widget child,
    EdgeInsets? padding,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    final primary = primaryColor ?? Colors.white;
    final secondary = secondaryColor ?? Colors.grey.shade50;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, secondary]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(
          color: const Color(0xff419388).withValues(alpha: 0.30),
          width: 2,
        ),
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }

  // ============================================================================
  // BOTONES
  // ============================================================================

  /// Botón principal común
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double? width,
    double height = 56,
    bool enabled = true,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff419388),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: const Color(0xff419388).withValues(alpha: 0.4),
          disabledBackgroundColor: Colors.grey.shade400,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // CAMPOS DE ENTRADA
  // ============================================================================

  /// Campo de entrada de dinero común
  static Widget moneyInputField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    String hint = "0,00",
    bool isError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: isError ? Colors.red.shade600 : const Color(0xff2d6b61),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isError ? Colors.red.shade300 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isError ? Colors.red.shade600 : const Color(0xff2d6b61),
              letterSpacing: 0.5,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
              suffixText: 'Bs',
              suffixStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isError ? Colors.red.shade600 : Colors.grey.shade600,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TARJETAS DE INFORMACIÓN
  // ============================================================================

  /// Card de información con icono
  static Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
    Color? backgroundColor,
    Color? textColor,
    bool isHighlighted = false,
  }) {
    final bgColor =
        backgroundColor ?? const Color(0xff419388).withValues(alpha: 0.1);
    final txtColor = textColor ?? const Color(0xff2d6b61);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff419388).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: txtColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: txtColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isHighlighted ? 24.sp : 20.sp,
              color: txtColor,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // ALERTAS Y MENSAJES
  // ============================================================================

  /// Alert de error común
  static Widget errorAlert({
    required String title,
    required String message,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.shade300, width: 3),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 36,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.red.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // INFORMACIÓN DE PAGO Y CÁLCULOS
  // ============================================================================

  /// Widget de cuota mensual destacada (versión completa con card)
  static Widget monthlyPaymentCard({
    required double monthlyPayment,
    required double amount,
    required int term,
    required LoanParameters params,
  }) {
    final termType = EvaluationService.getTermType(params.loanMonthTerm);
    final paymentFrequency =
        EvaluationService.getPaymentFrequency(params.loanMonthTerm);
    EvaluationService.getInterestLabel(params.loanMonthTerm);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff419388), Color(0xff2d6b61)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff419388).withValues(alpha: 0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff419388).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payments, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'CUOTA ${paymentFrequency.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  EvaluationService.formatMoney(monthlyPayment),
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bolivianos',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _detailRowWhite(
                  icon: Icons.attach_money,
                  label: 'Monto',
                  value: '${EvaluationService.formatMoney(amount)} Bs',
                ),
                const SizedBox(height: 12),
                _detailRowWhite(
                  icon: Icons.calendar_today,
                  label: 'Plazo',
                  value: '$term $termType',
                ),
                const SizedBox(height: 12),
                _detailRowWhite(
                  icon: Icons.percent,
                  label: 'Interes Anual',
                  value: '${params.annualInterest.toStringAsFixed(2)}%',
                ),
                const SizedBox(height: 12),
                _detailRowWhite(
                  icon: Icons.people,
                  label: 'Garantes',
                  value: '${params.guarantors}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de información de pago (versión simplificada sin card externa)
  static Widget paymentSummary({
    required BuildContext context,
    required double monthlyPayment,
    required double amount,
    required int term,
    required LoanParameters params,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final termType = EvaluationService.getTermType(params.loanMonthTerm);
    final paymentFrequency =
        EvaluationService.getPaymentFrequency(params.loanMonthTerm);

    return Column(
      children: [
        // Cuota destacada
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.teal.shade900.withValues(alpha: 0.4),
                      Colors.teal.shade800.withValues(alpha: 0.4)
                    ]
                  : [
                      const Color(0xFFE0F2F1),
                      const Color(0xFFB2DFDB)
                    ], // Verde menta claro
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.teal.shade600
                  : const Color(0xFF80CBC4).withValues(alpha: 0.39),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.payments,
                      color: isDark ? Colors.teal.shade200 : const Color(0xFF00695C), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'CUOTA ${paymentFrequency.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.teal.shade200 : const Color(0xFF00695C),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                EvaluationService.formatMoney(monthlyPayment),
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF004D40),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bolivianos',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark
                      ? Colors.teal.shade100
                      : const Color(0xFF00695C).withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Detalles
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              _detailRow(context, Icons.attach_money, 'Monto',
                  '${EvaluationService.formatMoney(amount)} Bs'),
              const SizedBox(height: 12),
              _detailRow(context, Icons.calendar_today, 'Plazo', '$term $termType'),
              const SizedBox(height: 12),
              _detailRow(context, Icons.percent, 'Interés Anual',
                  '${params.annualInterest.toStringAsFixed(2)}%'),
              const SizedBox(height: 12),
              _detailRow(context, Icons.people, 'Garantes', '${params.guarantors}'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _detailRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, color: isDark ? Colors.teal.shade300 : const Color(0xff419388), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: theme.primaryColorDark,
          ),
        ),
      ],
    );
  }

  static Widget _detailRowWhite({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // SELECTOR DE PLAZO
  // ============================================================================

  /// Widget de selector de plazo
  static Widget termSelector({
    required BuildContext context,
    required int currentTerm,
    required int minTerm,
    required int maxTerm,
    required int loanMonthTerm,
    required Function(int) onTermChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final termType = EvaluationService.getTermType(loanMonthTerm);
    final termTypeSingular =
        EvaluationService.getTermTypeSingular(loanMonthTerm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plazo ($termType)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: theme.primaryColorDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _termButton(
              context,
              Icons.remove,
              currentTerm > minTerm,
              () => onTermChanged(currentTerm - 1),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.orange.shade900.withValues(alpha: 0.3), Colors.orange.shade800.withValues(alpha: 0.3)]
                        : [Colors.orange.shade100, Colors.orange.shade50],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.orange.shade800 : Colors.orange.shade200),
                ),
                child: Center(
                  child: Text(
                    '$currentTerm',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _termButton(
              context,
              Icons.add,
              currentTerm < maxTerm,
              () => onTermChanged(currentTerm + 1),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: currentTerm.toDouble(),
          min: minTerm.toDouble(),
          max: maxTerm.toDouble(),
          divisions: maxTerm > minTerm ? maxTerm - minTerm : 1,
          activeColor: isDark ? Colors.orange.shade400 : Colors.orange.shade600,
          inactiveColor: isDark ? Colors.orange.shade900.withValues(alpha: 0.5) : Colors.orange.shade200,
          onChanged: (v) => onTermChanged(v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$minTerm $termTypeSingular',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$maxTerm $termType',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _termButton(
      BuildContext context, IconData icon, bool enabled, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.orange.shade700 : Colors.orange.shade300,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        elevation: 0,
        disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }

  // ============================================================================
  // MODALIDADES
  // ============================================================================

  /// Card de modalidad para grid o lista
  static Widget modalityCard(
    BuildContext context,
    LoanModalityNew modality, {
    required bool isGridView,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isGridView ? 4 : 0,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? null : const Color(0xFFE8F5E8),
        gradient: isDark 
            ? const LinearGradient(
                colors: [Color(0xFF264035), Color(0xFF1A3026)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
        border: isDark 
            ? Border.all(color: const Color(0xff419388).withValues(alpha: 0.6), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.3) 
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: isDark ? 12 : 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(isGridView ? 12 : 20),
            child: isGridView
                ? _buildModalityGridContent(context, modality)
                : _buildModalityListContent(context, modality),
          ),
        ),
      ),
    );
  }

  static Widget _buildModalityGridContent(BuildContext context, LoanModalityNew modality) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D5F4C);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          modality.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: textColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModalityInfoRow(
                context,
                Icons.percent,
                'Interés Anual',
                '${modality.parameters.annualInterest.toStringAsFixed(2)}%',
              ),
              _buildModalityInfoRow(
                context,
                Icons.people,
                'Garantes',
                '${modality.parameters.guarantors}',
              ),
              _buildModalityInfoRow(
                context,
                Icons.calendar_today,
                'Plazo',
                '${modality.parameters.minimumTermModality}-${modality.parameters.maximumTermModality} ${EvaluationService.getTermType(modality.parameters.loanMonthTerm)}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildModalityListContent(BuildContext context, LoanModalityNew modality) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D5F4C);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          modality.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: textColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildModalityInfoCell(
                context,
                Icons.percent,
                'Interés Anual',
                '${modality.parameters.annualInterest.toStringAsFixed(2)}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModalityInfoCell(
                context,
                Icons.people,
                'Garantes',
                '${modality.parameters.guarantors}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildModalityInfoCell(
          context,
          Icons.calendar_today,
          'Plazo',
          '${modality.parameters.minimumTermModality}-${modality.parameters.maximumTermModality} ${EvaluationService.getTermType(modality.parameters.loanMonthTerm)}',
        ),
      ],
    );
  }

  static Widget _buildModalityInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF2D5F4C);
    final iconColor = isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF419388);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildModalityInfoCell(
      BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF2D5F4C);
    final iconColor = isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF419388);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Sección completa de modalidades con toggle de vista
  static Widget modalitiesSection({
    required BuildContext context,
    required List<LoanModalityNew> modalities,
    required bool isGridView,
    required VoidCallback onToggleView,
    required Function(LoanModalityNew) onModalitySelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MODALIDADES DISPONIBLES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xff2d6b61),
                ),
              ),
              IconButton(
                icon: Icon(
                  isGridView ? Icons.view_list : Icons.grid_view,
                  color: isDark ? Colors.white.withValues(alpha: 0.8) : const Color(0xff419388),
                ),
                onPressed: onToggleView,
                tooltip: isGridView ? 'Ver como lista' : 'Ver como cuadrícula',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: isGridView
              ? _buildModalitiesGrid(modalities, onModalitySelected)
              : _buildModalitiesList(modalities, onModalitySelected),
        ),
      ],
    );
  }

  static Widget _buildModalitiesGrid(
    List<LoanModalityNew> modalities,
    Function(LoanModalityNew) onModalitySelected,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: modalities.length,
      itemBuilder: (context, index) => modalityCard(
        context,
        modalities[index],
        isGridView: true,
        onTap: () => onModalitySelected(modalities[index]),
      ),
    );
  }

  static Widget _buildModalitiesList(
    List<LoanModalityNew> modalities,
    Function(LoanModalityNew) onModalitySelected,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modalities.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: modalityCard(
          context,
          modalities[index],
          isGridView: false,
          onTap: () => onModalitySelected(modalities[index]),
        ),
      ),
    );
  }

  // ============================================================================
  // ESTADOS DE CARGA Y ERROR
  // ============================================================================

  /// Loading state común
  static Widget loadingState({
    String? message,
    int? attempt,
    int? maxAttempts,
  }) {
    String text = message ?? 'Cargando...';
    if (attempt != null && maxAttempts != null && attempt > 1) {
      text = 'Reintentando... ($attempt/$maxAttempts)';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xff419388),
          ),
          const SizedBox(height: 16),
          Text(text),
          if (attempt != null && attempt > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Verificando conexión...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Estado de error común
  static Widget errorState({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
