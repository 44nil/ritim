import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const _totalSteps = 5;

  // Kullanıcı verileri
  int _age = 14;
  bool? _hasStarted;
  DateTime _lastPeriod = DateTime.now().subtract(const Duration(days: 14));
  int _cycleLength = 28;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      // TODO: Backend entegrasyonu — kullanıcı verilerini Supabase'e kaydet
      context.go('/cycle-tracking');
    }
  }

  void _back() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0: return true;
      case 1: return _hasStarted != null;
      case 2: return _hasStarted == true;
      case 3: return true;
      case 4: return _nameController.text.trim().isNotEmpty;
      default: return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Üst bar: geri + progress + atla
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    GestureDetector(
                      onTap: _back,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF2D2028)),
                      ),
                    )
                  else
                    const SizedBox(width: 36),
                  const SizedBox(width: 12),
                  // Progress bar
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / _totalSteps,
                        backgroundColor: Colors.black.withValues(alpha: 0.06),
                        color: AppColors.primary,
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.go('/cycle-tracking'),
                    child: Text('Atla', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Sayfalar
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _AgePage(age: _age, onChanged: (v) => setState(() => _age = v)),
                  _PeriodStartedPage(value: _hasStarted, onChanged: (v) => setState(() => _hasStarted = v)),
                  _LastPeriodPage(date: _lastPeriod, onChanged: (v) => setState(() => _lastPeriod = v)),
                  _CycleLengthPage(length: _cycleLength, onChanged: (v) => setState(() => _cycleLength = v)),
                  _NamePage(controller: _nameController, onChanged: () => setState(() {})),
                ],
              ),
            ),

            // Alt buton
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  // Adım göstergesi
                  Text(
                    '${_currentStep + 1}/$_totalSteps',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                  ),
                  const Spacer(),
                  // İleri butonu
                  GestureDetector(
                    onTap: _canProceed ? _next : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _canProceed
                            ? const Color(0xFF2D2028)
                            : const Color(0xFF2D2028).withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        _currentStep == _totalSteps - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                        color: Colors.white, size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sayfa 1: Yaş ──────────────────────────────────────────────────────────

class _AgePage extends StatelessWidget {
  const _AgePage({required this.age, required this.onChanged});
  final int age;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          const Text('Kaç\nyaşındasın?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: Color(0xFF2D2028),
          )),
          const Spacer(),
          // Büyük sayı göstergesi
          Center(
            child: SizedBox(
              height: 180,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: age - 10),
                itemExtent: 60,
                magnification: 1.2,
                squeeze: 0.8,
                useMagnifier: true,
                onSelectedItemChanged: (i) => onChanged(i + 10),
                children: List.generate(9, (i) {
                  final val = i + 10;
                  return Center(
                    child: Text(
                      '$val',
                      style: TextStyle(
                        fontSize: val == age ? 48 : 28,
                        fontWeight: FontWeight.w800,
                        color: val == age
                            ? const Color(0xFF2D2028)
                            : const Color(0xFF2D2028).withValues(alpha: 0.2),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Sayfa 2: İlk adet oldu mu? ────────────────────────────────────────────

class _PeriodStartedPage extends StatelessWidget {
  const _PeriodStartedPage({required this.value, required this.onChanged});
  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          const Text('İlk adetin\noldu mu?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: Color(0xFF2D2028),
          )),
          const SizedBox(height: 12),
          Text(
            'Endişelenme, henüz olmadıysa da tamamen normal.',
            style: TextStyle(fontSize: 14, color: const Color(0xFF2D2028).withValues(alpha: 0.5), height: 1.4),
          ),
          const SizedBox(height: 40),
          _OptionCard(
            label: 'Evet, oldu',
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
          const SizedBox(height: 12),
          _OptionCard(
            label: 'Hayır, henüz olmadı',
            isSelected: value == false,
            onTap: () => onChanged(false),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,
              color: const Color(0xFF2D2028),
            ))),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFF2D2028).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sayfa 3: Son adet tarihi ───────────────────────────────────────────────

class _LastPeriodPage extends StatelessWidget {
  const _LastPeriodPage({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          const Text('Son adetin\nne zaman\nbaşladı?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: Color(0xFF2D2028),
          )),
          const SizedBox(height: 12),
          Text(
            'Tam tarihi bilmiyorsan yaklaşık bir tarih seç.',
            style: TextStyle(fontSize: 14, color: const Color(0xFF2D2028).withValues(alpha: 0.5), height: 1.4),
          ),
          const Spacer(),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: date,
              maximumDate: DateTime.now(),
              minimumDate: DateTime.now().subtract(const Duration(days: 90)),
              onDateTimeChanged: onChanged,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Sayfa 4: Döngü süresi ─────────────────────────────────────────────────

class _CycleLengthPage extends StatelessWidget {
  const _CycleLengthPage({required this.length, required this.onChanged});
  final int length;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          const Text('Döngün\ngenelde kaç\ngün sürüyor?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: Color(0xFF2D2028),
          )),
          const SizedBox(height: 12),
          Text(
            'Bilmiyorsan 28 gün varsayılan — sonra güncelleyebilirsin.',
            style: TextStyle(fontSize: 14, color: const Color(0xFF2D2028).withValues(alpha: 0.5), height: 1.4),
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 180,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: length - 21),
                itemExtent: 60,
                magnification: 1.2,
                squeeze: 0.8,
                useMagnifier: true,
                onSelectedItemChanged: (i) => onChanged(i + 21),
                children: List.generate(15, (i) {
                  final val = i + 21;
                  return Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$val',
                          style: TextStyle(
                            fontSize: val == length ? 48 : 28,
                            fontWeight: FontWeight.w800,
                            color: val == length
                                ? const Color(0xFF2D2028)
                                : const Color(0xFF2D2028).withValues(alpha: 0.2),
                          ),
                        ),
                        if (val == length)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 4),
                            child: Text('gün', style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2028).withValues(alpha: 0.4),
                            )),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Sayfa 5: İsim ─────────────────────────────────────────────────────────

class _NamePage extends StatelessWidget {
  const _NamePage({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          const Text('Sana nasıl\nhitap\nedelim?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: Color(0xFF2D2028),
          )),
          const SizedBox(height: 12),
          Text(
            'Takma ad da olur, gerçek ismin de — seni temsil eden ne varsa.',
            style: TextStyle(fontSize: 14, color: const Color(0xFF2D2028).withValues(alpha: 0.5), height: 1.4),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.w700,
              color: Color(0xFF2D2028),
            ),
            decoration: InputDecoration(
              hintText: 'Adın...',
              hintStyle: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700,
                color: const Color(0xFF2D2028).withValues(alpha: 0.15),
              ),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
