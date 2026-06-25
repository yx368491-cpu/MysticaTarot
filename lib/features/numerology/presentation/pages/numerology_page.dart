import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../../providers/numerology_provider.dart';

/// Numerology page - calculate life path and destiny numbers
class NumerologyPage extends StatefulWidget {
  const NumerologyPage({super.key});

  @override
  State<NumerologyPage> createState() => _NumerologyPageState();
}

class _NumerologyPageState extends State<NumerologyPage> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _showBirthdayForm = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NumerologyProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('numerologyTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle between birthday and name input
                Row(
                  children: [
                    _InputTab(
                      label: 'Birthday',
                      isSelected: _showBirthdayForm,
                      onTap: () => setState(() => _showBirthdayForm = true),
                    ),
                    const SizedBox(width: 8),
                    _InputTab(
                      label: 'Name',
                      isSelected: !_showBirthdayForm,
                      onTap: () => setState(() => _showBirthdayForm = false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Input form
                if (_showBirthdayForm)
                  _BirthdayForm(
                    selectedDate: _selectedDate,
                    onDateChanged: (d) => _selectedDate = d,
                    onCalculate: () {
                      provider.calculateByBirthday(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      );
                    },
                  )
                else
                  _NameForm(
                    controller: _nameController,
                    onCalculate: () => provider.calculateDestiny(_nameController.text),
                  ),

                const SizedBox(height: 24),

                // Results
                if (provider.hasResults) ...[
                  _LifePathResult(provider: provider),
                  if (provider.destinyNumber != null) ...[
                    const SizedBox(height: 16),
                    _DestinyResult(provider: provider),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InputTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rosePink : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.rosePink : AppColors.softPurpleLight),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.softPurpleDark,
        )),
      ),
    );
  }
}

class _BirthdayForm extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onCalculate;

  const _BirthdayForm({
    required this.selectedDate,
    required this.onDateChanged,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return MysticalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select your birth date', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText(context))),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppColors.rosePink,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (date != null) onDateChanged(date);
              },
              icon: const Icon(Icons.calendar_month),
              label: Text(
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softPurpleLight.withValues(alpha: 0.3),
                foregroundColor: AppColors.primaryText(context),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          MysticalButton(
            text: 'Calculate',
            icon: Icons.calculate,
            onPressed: onCalculate,
          ),
        ],
      ),
    );
  }
}

class _NameForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCalculate;

  const _NameForm({required this.controller, required this.onCalculate});

  @override
  Widget build(BuildContext context) {
    return MysticalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter your full name', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText(context))),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'e.g. John Doe',
              filled: true,
              fillColor: AppColors.softPurpleLight.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.person, color: AppColors.softPurple),
            ),
          ),
          const SizedBox(height: 16),
          MysticalButton(
            text: 'Calculate',
            icon: Icons.calculate,
            onPressed: onCalculate,
          ),
        ],
      ),
    );
  }
}

class _LifePathResult extends StatelessWidget {
  final NumerologyProvider provider;

  const _LifePathResult({required this.provider});

  @override
  Widget build(BuildContext context) {
    final data = provider.lifePathData;
    if (data == null) return const SizedBox();

    return MysticalCard(
      child: Column(
        children: [
          // Number display
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.rosePink, AppColors.softPurple],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${provider.lifePathNumber}',
                style: const TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Life Path Number',
            style: TextStyle(
              fontSize: 14, color: AppColors.softPurpleDark,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.localizedName('en'),
            style: AppTextStyles.headingMedium,
          ),
          if (data.isMasterNumber)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('MASTER NUMBER', style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold,
                color: AppColors.goldDark, letterSpacing: 2)),
            ),
          const SizedBox(height: 16),
          // Meaning
          _section(context, 'Meaning', data.meaningEn),
          const SizedBox(height: 10),
          // Strengths
          _section(context, 'Strengths', data.strengthEn),
          const SizedBox(height: 10),
          // Challenges
          _section(context, 'Challenges', data.challengeEn),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.rosePink)),
        const SizedBox(height: 4),
        Text(content, style: TextStyle(
          fontSize: 14, color: AppColors.primaryText(context), height: 1.5)),
      ],
    );
  }
}

class _DestinyResult extends StatelessWidget {
  final NumerologyProvider provider;

  const _DestinyResult({required this.provider});

  @override
  Widget build(BuildContext context) {
    return MysticalCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${provider.destinyNumber}',
                style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold,
                  color: AppColors.goldDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destiny Number', style: TextStyle(
                  fontSize: 12, color: AppColors.secondaryText(context), letterSpacing: 2)),
                const SizedBox(height: 4),
                Text(
                  'Your destiny number reveals your life purpose.',
                  style: TextStyle(
                    fontSize: 13, color: AppColors.primaryText(context), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
