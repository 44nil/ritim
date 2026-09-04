import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';

enum _LoginStep { emailInput, linkSent }

/// Ebeveyn paneli giriş ekranı — Clerk tarzı magic link akışı.
/// Tek ekranda akıcı geçiş: e-posta girişi → link gönderildi durumu.
/// TODO: Supabase Auth magic link entegrasyonu (Eray ile koordine)
class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _LoginStep _step = _LoginStep.emailInput;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendMagicLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // TODO: Supabase Auth magic link entegrasyonu (Eray ile koordine)
    // Gerçek implementasyonda: supabase.auth.signInWithOtp(email: _emailController.text)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // Placeholder: başarılı varsayıyoruz
    // Gerçek implementasyonda hata durumunu da handle et
    setState(() {
      _isLoading = false;
      _step = _LoginStep.linkSent;
    });
  }

  void _resetToEmailInput() {
    setState(() {
      _step = _LoginStep.emailInput;
      _errorMessage = null;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen e-posta adresinizi girin';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi girebilir misiniz?';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebeveyn Girişi'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: AnimatedSwitcher(
            duration: AppConstants.animDurationNormal,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _step == _LoginStep.emailInput
                ? _EmailInputView(
                    key: const ValueKey('email-input'),
                    theme: theme,
                    formKey: _formKey,
                    emailController: _emailController,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onSendLink: _sendMagicLink,
                    validateEmail: _validateEmail,
                  )
                : _LinkSentView(
                    key: const ValueKey('link-sent'),
                    theme: theme,
                    email: _emailController.text.trim(),
                    onResend: _sendMagicLink,
                    onChangeEmail: _resetToEmailInput,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── E-posta giriş görünümü ──────────────────────────────────────────────────

class _EmailInputView extends StatelessWidget {
  const _EmailInputView({
    super.key,
    required this.theme,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.errorMessage,
    required this.onSendLink,
    required this.validateEmail,
  });

  final ThemeData theme;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSendLink;
  final String? Function(String?) validateEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),

        // Kalkan ikonu
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            size: 40,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 28),

        Text(
          'Ebeveyn Paneli',
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Çocuğunuzun döngü takibini ve içerik ayarlarını yönetmek için e-posta adresinizle giriş yapın.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 36),

        // E-posta formu
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-posta adresi',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                autofillHints: const [AutofillHints.email],
                onFieldSubmitted: (_) => onSendLink(),
                decoration: const InputDecoration(
                  hintText: 'ebeveyn@email.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: validateEmail,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Hata mesajı
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // Giriş bağlantısı gönder butonu
        SizedBox(
          width: double.infinity,
          child: AnimatedSwitcher(
            duration: AppConstants.animDurationFast,
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    key: const ValueKey('idle'),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSendLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                      child: const Text('Giriş Bağlantısı Gönder'),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Ayırıcı
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'veya',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Google ile giriş — placeholder, ileride aktif edilecek
        // TODO: Supabase Auth sosyal giriş entegrasyonu (Google OAuth)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: null, // Henüz aktif değil
            icon: Icon(
              Icons.g_mobiledata_rounded,
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            label: Text(
              'Google ile Giriş Yap',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Yakında',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}

// ─── Link gönderildi görünümü ────────────────────────────────────────────────

class _LinkSentView extends StatelessWidget {
  const _LinkSentView({
    super.key,
    required this.theme,
    required this.email,
    required this.onResend,
    required this.onChangeEmail,
  });

  final ThemeData theme;
  final String email;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),

        // Başarı ikonu
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 44,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 28),

        Text(
          'E-postanızı kontrol edin',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.6,
            ),
            children: [
              const TextSpan(text: 'Giriş bağlantınızı '),
              TextSpan(
                text: email,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const TextSpan(
                text: ' adresine gönderdik. E-postadaki bağlantıya tıklayarak giriş yapabilirsiniz.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // İpucu kartı
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'E-posta gelmediyse spam klasörünü kontrol etmeyi deneyin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Tekrar gönder butonu
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onResend,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.secondary,
              side: BorderSide(color: theme.colorScheme.secondary),
            ),
            child: const Text('Bağlantıyı Tekrar Gönder'),
          ),
        ),
        const SizedBox(height: 12),

        // E-posta değiştir
        TextButton(
          onPressed: onChangeEmail,
          child: Text(
            'Farklı bir e-posta kullan',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // TODO: Backend entegrasyonu — gerçek magic link akışında bu buton
        // kalkacak, kullanıcı e-postadaki bağlantıya tıklayınca panele girecek.
        // Backend olmadığı için şimdilik demo amaçlı doğrudan geçiş.
        // kDebugMode'a alındı: gerçek doğrulama yapmadan ebeveyn paneline
        // giren bu buton release build'e gitmemeli.
        if (kDebugMode)
          TextButton(
            onPressed: () => context.goNamed(RouteNames.parentPanel),
            child: const Text('Girişi tamamla (demo)'),
          ),
      ],
    );
  }
}
