import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../content/legal_content.dart';

/// Onboarding sırasında verilen aydınlatma/rıza kaydı.
///
/// Şu an in-memory (uygulamanın geri kalanıyla tutarlı — henüz backend yok).
/// Supabase entegrasyonunda bu alanların kalıcı hale gelmesi gerekiyor,
/// bkz. docs/legal-compliance-notes.md bölüm 6.
class ConsentState {
  const ConsentState({
    this.ageAtOnboarding,
    this.privacyNoticeSeenAt,
    this.consentGivenAt,
    this.contentVersion,
    this.guardianAssisted,
  });

  final int? ageAtOnboarding;
  final DateTime? privacyNoticeSeenAt;
  final DateTime? consentGivenAt;
  final String? contentVersion;
  final bool? guardianAssisted;

  bool get hasConsented => consentGivenAt != null;

  ConsentState copyWith({
    int? ageAtOnboarding,
    DateTime? privacyNoticeSeenAt,
    DateTime? consentGivenAt,
    String? contentVersion,
    bool? guardianAssisted,
  }) {
    return ConsentState(
      ageAtOnboarding: ageAtOnboarding ?? this.ageAtOnboarding,
      privacyNoticeSeenAt: privacyNoticeSeenAt ?? this.privacyNoticeSeenAt,
      consentGivenAt: consentGivenAt ?? this.consentGivenAt,
      contentVersion: contentVersion ?? this.contentVersion,
      guardianAssisted: guardianAssisted ?? this.guardianAssisted,
    );
  }
}

final onboardingConsentProvider = StateNotifierProvider<OnboardingConsentNotifier, ConsentState>((ref) {
  return OnboardingConsentNotifier();
});

class OnboardingConsentNotifier extends StateNotifier<ConsentState> {
  OnboardingConsentNotifier() : super(const ConsentState());

  void recordAge(int age) {
    state = state.copyWith(ageAtOnboarding: age);
  }

  void recordGuardianChoice(bool guardianAssisted) {
    state = state.copyWith(guardianAssisted: guardianAssisted);
  }

  void markPrivacyNoticeSeen() {
    if (state.privacyNoticeSeenAt != null) return;
    state = state.copyWith(privacyNoticeSeenAt: DateTime.now());
  }

  void giveConsent() {
    state = state.copyWith(
      consentGivenAt: DateTime.now(),
      contentVersion: kLegalContentVersion,
    );
  }

  void revokeConsent() {
    state = ConsentState(
      ageAtOnboarding: state.ageAtOnboarding,
      privacyNoticeSeenAt: state.privacyNoticeSeenAt,
      guardianAssisted: state.guardianAssisted,
    );
  }
}
