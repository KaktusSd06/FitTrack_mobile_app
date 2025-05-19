import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Умови використання',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              const SizedBox(height: 24),
              _buildSocialResponsibilitySection(context),
              const SizedBox(height: 24),
              _buildSupportSection(context),
              const SizedBox(height: 32),
              _buildTermsSection(context),
              const SizedBox(height: 32),
              _buildPrivacySection(context),
              const SizedBox(height: 24),
              _buildAcceptanceSection(context),
              const SizedBox(height: 24),
              _buildInfo(context),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FitTrack — це сучасний мобільний додаток для відстеження прогресу у спорті, '
              'пошуку тренувань та взаємодії з тренажерними залами. Ми поєднуємо зручність, '
              'мотивацію та соціальну відповідальність, щоб зробити фітнес частиною твого життя.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSocialResponsibilitySection(BuildContext context) {
    return _buildInfoCard(
      context,
      icon: Icons.favorite,
      iconColor: Colors.blue,
      title: 'Соціальна відповідальність',
      content: 'З кожної покупки в додатку 5% спрямовується на підтримку проєкту. Обираючи FitTrack — ти не лише дбаєш про себе, а й допомагаєш іншим.',
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildInfoCard(
      context,
      icon: Icons.support_agent,
      iconColor: Colors.orange,
      title: 'Підтримка',
      content: 'Якщо у тебе виникли запитання або технічні проблеми — ми завжди поруч. '
          'Зв\'яжися з нами:',
      extraWidget: InkWell(
        onTap: () => _launchEmail('stepanukdima524@gmail.com'),
        child: Text(
          'stepanukdima524@gmail.com',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Загальні умови використання',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTermItem(context, 'Реєстрація облікового запису',
            'Для використання всіх функцій додатку необхідно створити обліковий запис. '
                'Користувач несе відповідальність за збереження конфіденційності свого облікового запису. '),
        _buildTermItem(context, 'Оплата та повернення коштів',
            'Всі покупки в додатку є остаточними. Повернення коштів можливе лише у випадках, '
                'передбачених законодавством України.'),
        _buildTermItem(context, 'Використання контенту',
            'Весь контент, розміщений у додатку, є власністю FitTrack або ліцензованим контентом. '
                'Заборонено копіювати, розповсюджувати або комерційно використовувати без дозволу.'),
        _buildTermItem(context, 'Обмеження відповідальності',
            'FitTrack не несе відповідальності за будь-які травми, пошкодження або збитки, '
                'пов\'язані з використанням додатку або виконанням тренувань.'),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Конфіденційність та дані',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTermItem(context, 'Збір даних',
            'Ми збираємо дані про ваші тренування, фізичні показники та використання додатку для '
                'покращення вашого досвіду та вдосконалення сервісу.'),
        _buildTermItem(context, 'Захист даних',
            'Ми використовуємо сучасні технології для захисту ваших персональних даних та '
                'дотримуємось вимог законодавства щодо захисту персональних даних.'),
        _buildTermItem(context, 'Обмін даними',
            'Ваші персональні дані не будуть передані третім сторонам без вашої згоди, окрім '
                'випадків, передбачених законодавством.'),
      ],
    );
  }

  Widget _buildAcceptanceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Використовуючи додаток FitTrack, ви погоджуєтеся з усіма умовами, викладеними на цій сторінці. '
            'Ми зберігаємо за собою право змінювати ці умови в будь-який час, повідомляючи користувачів '
            'через додаток або електронну пошту.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Дякуюємо що обираєте FitTrack 🧡',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String content,
        Widget? extraWidget,
      }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (extraWidget != null) ...[
                  const SizedBox(height: 8),
                  extraWidget,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}