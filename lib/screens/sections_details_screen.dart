import 'package:flutter/material.dart';

class SectionDetailsScreen extends StatelessWidget {
  final String title;

  const SectionDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final content = _getSectionContent(title);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }

  /// 🧩 Контент під кожен розділ
  Widget _getSectionContent(String title) {
    switch (title) {
      case 'Розділ 1. Загальні положення':
        return _buildChapter1();
      case 'Розділ 2. Обов’язки і права водіїв механічних транспортних засобів':
        return _buildPlaceholder('Розділ 2. Обов’язки і права водіїв механічних транспортних засобів');
      case 'Розділ 3. Рух транспортних засобів із спеціальними сигналами':
        return _buildPlaceholder('Розділ 3. Рух транспортних засобів із спеціальними сигналами');
      case 'Розділ 4. Рух транспортних засобів':
        return _buildPlaceholder('Розділ 4. Рух транспортних засобів');
      case 'Розділ 5. Обов’язки і права пішоходів':
        return _buildPlac￼Change your avatar
￼
eholder('Розділ 5. Обов’язки і права пішоходів');
      default:
        return _buildPlaceholder(title);
    }
  }

  Widget _buildChapter1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderBlock(
          title: 'Розділ 1. Загальні положення',
          subtitle:
          'Основні принципи, терміни та вимоги для всіх учасників дорожнього руху.',
        ),
        const SizedBox(height: 16),
        _buildSubsection(
          number: '1.1',
          title:
          'Ці Правила відповідно до Закону України «Про дорожній рух» встановлюють єдиний порядок дорожнього руху.',
          text:
          'Інші нормативні акти, що стосуються особливостей дорожнього руху, повинні ґрунтуватися на цих Правилах.',
        ),
        _buildSubsection(
          number: '1.2',
          title: 'В Україні установлено правосторонній рух транспортних засобів.',
          text:
          'Правосторонній рух є загальноприйнятим у більшості країн світу. Водії повинні триматися правої сторони проїзної частини.',
          imagePath: 'assets/images/right_drive.jpg',
        ),
        _buildSubsection(
          number: '1.3',
          title:
          'Учасники дорожнього руху зобов’язані знати і неухильно виконувати вимоги цих Правил.',
          text:
          'Кожен учасник повинен знати дорожні знаки, сигнали світлофора і регулювальника. Незнання не звільняє від відповідальності.',
        ),
        _buildSubsection(
          number: '1.4',
          title:
          'Кожен учасник дорожнього руху має право розраховувати на дотримання цих Правил іншими.',
          text:
          'Поведінка учасників повинна бути передбачуваною і безпечною. Порушення може призвести до аварійної ситуації.',
        ),
        const SizedBox(height: 24),
        _buildDefinitionBlock(),
      ],
    );
  }


  Widget _buildPlaceholder(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.book_outlined, color: Colors.blue, size: 100),
            const SizedBox(height: 16),
            Text(
              'Матеріал для "$title" ще не додано 📘',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Цей розділ з’явиться найближчим часом.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHeaderBlock({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade800, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsection({
    required String number,
    required String title,
    required String text,
    String? imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(
          left: BorderSide(color: Colors.redAccent.shade400, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number ',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          if (imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefinitionBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300, width: 1.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Основні поняття:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Дорога — частина території, призначена для руху транспортних засобів і пішоходів.\n'
                '• Тротуар — частина дороги, призначена для руху пішоходів.\n'
                '• Проїзна частина — частина дороги, призначена безпосередньо для руху транспортних засобів.\n'
                '• Водій — особа, яка керує транспортним засобом.\n'
                '• Пішохід — особа, що бере участь у дорожньому русі поза транспортним засобом.\n'
                '• Регулювальник — особа, яка за допомогою сигналів регулює дорожній рух.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
