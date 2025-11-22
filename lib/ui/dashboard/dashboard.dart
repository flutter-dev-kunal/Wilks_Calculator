import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WilksCalculatorScreen extends StatefulWidget {
  const WilksCalculatorScreen({super.key});

  @override
  State<WilksCalculatorScreen> createState() => _WilksCalculatorScreenState();
}

class _WilksCalculatorScreenState extends State<WilksCalculatorScreen> {
  final _bodyWeightController = TextEditingController();
  final _liftedWeightController = TextEditingController();
  final bgColor = Color(0xFF0f0E47);

  String _selectedGender = 'Male';
  double? _wilksScore;

  @override
  void dispose() {
    _bodyWeightController.dispose();
    _liftedWeightController.dispose();
    super.dispose();
  }

  void _calculateWilks() {
    final bodyWeight = double.tryParse(_bodyWeightController.text);
    final liftedWeight = double.tryParse(_liftedWeightController.text);

    if (bodyWeight == null || liftedWeight == null) {
      setState(() {
        _wilksScore = null;
      });
      return;
    }

    double wilks = calculateWilks(
      bodyWeightKg: bodyWeight,
      totalLiftKg: liftedWeight,
      isMale: _selectedGender == 'Male'
    );

    setState(() {
      _wilksScore = wilks;
    });
  }

  double _calculateLiftProgress() {
    final bodyWeight = double.tryParse(_bodyWeightController.text);
    final liftedWeight = double.tryParse(_liftedWeightController.text);

    final liftedWeightByBodyWeight = (liftedWeight! / bodyWeight!).toStringAsFixed(2);

    return double.parse(liftedWeightByBodyWeight);
  }

  double calculateWilks({
    required double bodyWeightKg,
    required double totalLiftKg,
    required bool isMale,
  }) {
    // Constants for men and women
    final List<double> constants = isMale
        ? [-216.0475144, 16.2606339, -0.002388645, -0.00113732, 7.01863E-06, -1.291E-08]
        : [594.31747775582, -27.23842536447, 0.82112226871, -0.00930733913, 4.731582E-05, -9.054E-08];

    final double a = constants[0];
    final double b = constants[1];
    final double c = constants[2];
    final double d = constants[3];
    final double e = constants[4];
    final double f = constants[5];

    // Denominator of the Wilks coefficient
    double denominator = a +
        (b * bodyWeightKg) +
        (c * bodyWeightKg * bodyWeightKg) +
        (d * bodyWeightKg * bodyWeightKg * bodyWeightKg) +
        (e * bodyWeightKg * bodyWeightKg * bodyWeightKg * bodyWeightKg) +
        (f * bodyWeightKg * bodyWeightKg * bodyWeightKg * bodyWeightKg * bodyWeightKg);

    double coefficient = 500 / denominator;

    return coefficient * totalLiftKg;
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: bgColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                inputFormatters: [DecimalTextInputFormatter()],
                controller: controller,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (_) => onChanged(),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: _calculatorView(),
    );
  }

  Widget _calculatorView() {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15,top: 10),
      padding: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gender dropdown
            Text('Gender',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGender = value;
                    _calculateWilks();
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: GoogleFonts.poppins(fontSize: 16, color: bgColor),
              dropdownColor: Colors.white,
            ),
            const SizedBox(height: 24),
            // BodyWeight input
            _buildTextField(
              label: 'Body Weight (Kgs)',
              controller: _bodyWeightController,
              onChanged: _calculateWilks,
            ),
            const SizedBox(height: 24),
            // Lifted weight input
            _buildTextField(
              label: 'Lifted Weight (Kgs)',
              controller: _liftedWeightController,
              onChanged: _calculateWilks,
            ),
            const SizedBox(height: 36),
            // Wilks Score display
            Center(
              child: Text(
                _wilksScore == null
                    ? 'Enter values to calculate Wilks Score'
                    : 'Wilks Score: ${_wilksScore!.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  color: bgColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Lift x body weight
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  _wilksScore != null
                      ? 'You lift: ${_calculateLiftProgress()} x your body weight'
                      : '',
                  style: GoogleFonts.poppins(
                    color: bgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 75,
      centerTitle: true,
      backgroundColor: bgColor,
      title: Center(
        child: Text(
          'Wilks Calculator',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Reject empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Only allow digits and one dot
    final regExp = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');

    if (regExp.hasMatch(text)) {
      return newValue;
    }

    // If not matching pattern, keep old value (reject input)
    return oldValue;
  }
}
