import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../legal/screens/consent_gate_screen.dart';
import '../../legal/screens/guardian_assist_gate_screen.dart';
import '../../legal/state/onboarding_consent_provider.dart';

/// Kurulum sırasının adımları. Yaş ve rıza durumuna göre `guardian` adımı
/// listeye dahil edilir ya da edilmez — bkz. `_SetupScreenState._stepKinds`.
enum _StepKind { age, guardian, privacyNotice, consent, periodStarted, lastPeriodDate, cycleLength, name }

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Kullanıcı verileri
  int _age = 14;
  bool? _hasStarted;
  DateTime _lastPeriod = DateTime.now().subtract(const Duration(days: 14));
  int _cycleLength = 28;
  final _nameController = TextEditingController();

  // Yasal/rıza durumu
  // 13 yaş altı için gösterilen ebeveyn kapısı adımının bu akışa dahil olup
  // olmadığı — yalnızca Yaş adımından ayrılırken güncellenir, bu yüzden
  // kullanıcı ileriki bir adımdayken PageView'in çocuk listesi altından
  // değişmez (bkz. docs/legal-compliance-notes.md bölüm 7).
  bool _includeGuardianStep = false;
  bool? _guardianChoice;
  bool _consentChecked = false;

  List<_StepKind> get _stepKinds => [
        _StepKind.age,
        if (_includeGuardianStep) _StepKind.guardian,
        _StepKind.privacyNotice,
        _StepKind.consent,
        _StepKind.periodStarted,
        _StepKind.lastPeriodDate,
        _StepKind.cycleLength,
        _StepKind.name,
      ];

  int get _totalSteps => _stepKinds.length;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    final kind = _stepKinds[_currentStep];
    if (kind == _StepKind.age) {
      ref.read(onboardingConsentProvider.notifier).recordAge(_age);
      setState(() => _includeGuardianStep = _age < 13);
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      // "İlk reglin oldu mu?" -> evetse, "ne zaman başladı"/"kaç gün sürüyor"
      // cevaplarını gerçek bir kayda çeviriyoruz — yoksa bu sorulara verilen
      // cevaplar hiçbir yere yazılmadan kayboluyordu.
      if (_hasStarted == true) {
        ref.read(cycleProvider.notifier).seedFromOnboarding(
          lastPeriodStart: _lastPeriod,
          reportedCycleLength: _cycleLength,
        );
      }
      ref.read(cycleProvider.notifier).setUserName(_nameController.text.trim());
      ref.read(cycleProvider.notifier).markOnboardingComplete();
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
    switch (_stepKinds[_currentStep]) {
      case _StepKind.age: return true;
      case _StepKind.guardian: return _guardianChoice != null;
      case _StepKind.privacyNotice: return true;
      case _StepKind.consent: return _consentChecked;
      case _StepKind.periodStarted: return _hasStarted != null;
      case _StepKind.lastPeriodDate: return _hasStarted == true;
      case _StepKind.cycleLength: return true;
      case _StepKind.name: return _nameController.text.trim().isNotEmpty;
    }
  }

  // Aydınlatma/rıza adımlarında üstteki "Atla" gizlenir — bu adımlar
  // hassas veri toplanmadan önceki bilgilendirme/onay adımları olduğu için
  // tek tıkla atlanabilir olmamalı.
  bool get _canSkip {
    switch (_stepKinds[_currentStep]) {
      case _StepKind.guardian:
      case _StepKind.privacyNotice:
      case _StepKind.consent:
        return false;
      default:
        return true;
    }
  }

  List<Widget> _buildPages() {
    return _stepKinds.map<Widget>((kind) {
      switch (kind) {
        case _StepKind.age:
          return _AgePage(age: _age, onChanged: (v) => setState(() => _age = v));
        case _StepKind.guardian:
          return GuardianAssistGateStep(
            choice: _guardianChoice,
            onChanged: (v) {
              setState(() => _guardianChoice = v);
              ref.read(onboardingConsentProvider.notifier).recordGuardianChoice(v);
            },
          );
        case _StepKind.privacyNotice:
          return const _PrivacyNoticePage();
        case _StepKind.consent:
          return ConsentGateStep(
            checked: _consentChecked,
            onChanged: (v) {
              setState(() => _consentChecked = v);
              final notifier = ref.read(onboardingConsentProvider.notifier);
              if (v) { notifier.giveConsent(); } else { notifier.revokeConsent(); }
            },
            onOpenPrivacyPolicy: () => context.pushNamed(RouteNames.privacyPolicy),
            onOpenTerms: () => context.pushNamed(RouteNames.terms),
          );
        case _StepKind.periodStarted:
          return _PeriodStartedPage(value: _hasStarted, onChanged: (v) => setState(() => _hasStarted = v));
        case _StepKind.lastPeriodDate:
          return _LastPeriodPage(date: _lastPeriod, onChanged: (v) => setState(() => _lastPeriod = v));
        case _StepKind.cycleLength:
          return _CycleLengthPage(length: _cycleLength, onChanged: (v) => setState(() => _cycleLength = v));
        case _StepKind.name:
          return _NamePage(controller: _nameController, onChanged: () => setState(() {}));
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      body: Stack(
        children: [
          // Aura arka plan
          _SetupAura(step: _currentStep),
          SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Üst bar: geri + progress + atla
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Semantics(button: true, label: 'Geri', child: GestureDetector(
                      onTap: _back,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        child: Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.inkOn(context)),
                      ),
                    ))
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
                  if (_canSkip)
                    GestureDetector(
                      onTap: () => context.go('/cycle-tracking'),
                      child: Text('Atla', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      )),
                    )
                  else
                    const SizedBox(width: 36),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Sayfalar
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) {
                  setState(() => _currentStep = i);
                  if (_stepKinds[i] == _StepKind.privacyNotice) {
                    ref.read(onboardingConsentProvider.notifier).markPrivacyNoticeSeen();
                  }
                },
                children: _buildPages(),
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
                  Semantics(
                    button: true,
                    label: _currentStep == _totalSteps - 1 ? 'Tamamla' : 'İleri',
                    child: GestureDetector(
                      onTap: _canProceed ? _next : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _canProceed
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _currentStep == _totalSteps - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                          color: Colors.white, size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ],
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
          Text('Kaç\nyaşındasın?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
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
                            ? AppColors.inkOn(context)
                            : AppColors.inkOn(context).withValues(alpha: 0.2),
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

// ─── Sayfa 2: İlk regl oldu mu? ────────────────────────────────────────────

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
          Text('İlk reglin\noldu mu?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Endişelenme, henüz olmadıysa da tamamen normal.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
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
              color: AppColors.inkOn(context),
            ))),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.inkOn(context).withValues(alpha: 0.2),
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

// ─── Sayfa 3: Son regl tarihi ───────────────────────────────────────────────

class _LastPeriodPage extends StatefulWidget {
  const _LastPeriodPage({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  State<_LastPeriodPage> createState() => _LastPeriodPageState();
}

class _LastPeriodPageState extends State<_LastPeriodPage> {
  static const _months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];

  late int _day;
  late int _month;
  late int _year;

  @override
  void initState() {
    super.initState();
    _day = widget.date.day;
    _month = widget.date.month;
    _year = widget.date.year;
  }

  void _update() {
    final maxDay = DateTime(_year, _month + 1, 0).day;
    if (_day > maxDay) _day = maxDay;
    widget.onChanged(DateTime(_year, _month, _day));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

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
          Text('Son reglin\nne zaman\nbaşladı?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Tam tarihi bilmiyorsan yaklaşık seç.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
          ),
          const Spacer(),
          // 3 scroll picker yan yana: Gün — Ay — Yıl
          SizedBox(
            height: 180,
            child: Row(
              children: [
                // Gün
                Expanded(
                  flex: 2,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: _day - 1),
                    itemExtent: 50,
                    magnification: 1.15,
                    squeeze: 0.9,
                    useMagnifier: true,
                    onSelectedItemChanged: (i) { _day = i + 1; _update(); },
                    children: List.generate(31, (i) {
                      final val = i + 1;
                      return Center(child: Text('$val', style: TextStyle(
                        fontSize: val == _day ? 32 : 20, fontWeight: FontWeight.w700,
                        color: val == _day ? AppColors.inkOn(context) : AppColors.inkOn(context).withValues(alpha: 0.2),
                      )));
                    }),
                  ),
                ),
                // Ay
                Expanded(
                  flex: 3,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: _month - 1),
                    itemExtent: 50,
                    magnification: 1.15,
                    squeeze: 0.9,
                    useMagnifier: true,
                    onSelectedItemChanged: (i) { _month = i + 1; _update(); },
                    children: _months.asMap().entries.map((e) {
                      final isSelected = e.key + 1 == _month;
                      return Center(child: Text(e.value, style: TextStyle(
                        fontSize: isSelected ? 22 : 16, fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.inkOn(context) : AppColors.inkOn(context).withValues(alpha: 0.2),
                      )));
                    }).toList(),
                  ),
                ),
                // Yıl
                Expanded(
                  flex: 2,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: now.year - _year),
                    itemExtent: 50,
                    magnification: 1.15,
                    squeeze: 0.9,
                    useMagnifier: true,
                    onSelectedItemChanged: (i) { _year = now.year - i; _update(); },
                    children: List.generate(2, (i) {
                      final val = now.year - i;
                      return Center(child: Text('$val', style: TextStyle(
                        fontSize: val == _year ? 28 : 20, fontWeight: FontWeight.w700,
                        color: val == _year ? AppColors.inkOn(context) : AppColors.inkOn(context).withValues(alpha: 0.2),
                      )));
                    }),
                  ),
                ),
              ],
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
          Text('Döngün\ngenelde kaç\ngün sürüyor?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Bilmiyorsan 28 gün varsayılan — sonra güncelleyebilirsin.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
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
                                ? AppColors.inkOn(context)
                                : AppColors.inkOn(context).withValues(alpha: 0.2),
                          ),
                        ),
                        if (val == length)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 4),
                            child: Text('gün', style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,
                              color: AppColors.inkOn(context).withValues(alpha: 0.4),
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
          Text('Sana nasıl\nhitap\nedelim?', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Takma ad da olur, gerçek ismin de — seni temsil eden ne varsa.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w700,
              color: AppColors.inkOn(context),
            ),
            decoration: InputDecoration(
              hintText: 'Adın...',
              hintStyle: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700,
                color: AppColors.inkOn(context).withValues(alpha: 0.15),
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

// ─── Sayfa: Aydınlatma Metni ────────────────────────────────────────────────

/// Onboarding'e gömülü KVKK aydınlatma adımı. Rıza adımından önce gösterilir
/// — hangi verinin, neden toplandığının açıklandığı, saf bilgilendirme
/// adımıdır (KVKK Madde 10 aydınlatma yükümlülüğü, rızadan bağımsızdır).
class _PrivacyNoticePage extends StatelessWidget {
  const _PrivacyNoticePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Text('Önce seni\nbilgilendirelim', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 20),
          // Kurulum ekranında tüm KVKK metnini (şirket adresi dahil) doğrudan
          // basmak yerine kısa bir özet + tam metne link gösteriyoruz — bu,
          // Gizlilik Politikası/Kullanım Şartları'nın consent adımında zaten
          // kullandığı link deseniyle tutarlı, ayrıca adres bilgisini her
          // kurulumda zorunlu görünür kılmıyor.
          Text(
            'Yaşını, döngü bilgilerini ve istersen ruh hali/belirti notlarını, '
            'döngünü takip edebilmen ve yaşına uygun genel bilgi sunabilmemiz '
            'için kullanıyoruz. Hiçbir bilgi cihazından dışarı çıkmıyor, '
            'satılmıyor ya da paylaşılmıyor.',
            style: TextStyle(fontSize: 13.5, height: 1.6, color: AppColors.inkOn(context).withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.privacyNotice),
            child: Text(
              'Tam KVKK Aydınlatma Metnini Oku',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Aura Arka Plan ─────────────────────────────────────────────────────────

class _SetupAura extends StatelessWidget {
  const _SetupAura({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final configs = [
      [_ABlob(-80, -100, 500, const Color(0xFFE8856E)), _ABlob(150, 400, 450, const Color(0xFFF098B8)), _ABlob(-120, 650, 420, const Color(0xFFE89870))],
      [_ABlob(60, -120, 480, const Color(0xFFF07898)), _ABlob(-100, 350, 500, const Color(0xFFD898B0)), _ABlob(100, 600, 400, const Color(0xFFE8A890))],
      [_ABlob(-90, 50, 450, const Color(0xFFD098D0)), _ABlob(80, 380, 480, const Color(0xFFE88898)), _ABlob(-60, 700, 420, const Color(0xFFC8A8D8))],
      [_ABlob(120, -80, 470, const Color(0xFFE89870)), _ABlob(-120, 300, 500, const Color(0xFFF098A8)), _ABlob(60, 650, 430, const Color(0xFFD89870))],
      [_ABlob(20, -90, 490, const Color(0xFFF09898)), _ABlob(-100, 250, 440, const Color(0xFFD888B8)), _ABlob(80, 550, 500, const Color(0xFFE8B098))],
    ];

    final blobs = configs[step.clamp(0, configs.length - 1)];

    return Stack(
      children: blobs.map((b) => AnimatedPositioned(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        left: b.x,
        top: b.y,
        child: Container(
          width: b.size,
          height: b.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [b.color.withValues(alpha: 0.7), b.color.withValues(alpha: 0)],
            ),
          ),
        ),
      )).toList(),
    );
  }
}

class _ABlob {
  const _ABlob(this.x, this.y, this.size, this.color);
  final double x, y, size;
  final Color color;
}
