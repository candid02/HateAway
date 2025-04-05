import 'package:flutter/material.dart';

class EducationalScreen extends StatelessWidget {
  const EducationalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Hate Speech'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Understanding Hate Speech',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'What is Hate Speech?',
              content:
                  'Hate speech is any communication that disparages a person or a group based on some characteristic such as race, color, ethnicity, gender, disability, sexual orientation, nationality, religion, or other characteristic.',
              icon: Icons.info_outline,
            ),
            _buildInfoCard(
              title: 'Impact of Hate Speech',
              content:
                  'Hate speech can cause emotional distress, fear, and can lead to discrimination and violence against targeted groups. It creates hostile environments and undermines principles of equality and dignity.',
              icon: Icons.warning_amber_rounded,
            ),
            _buildInfoCard(
              title: 'Why Detection Matters',
              content:
                  'Automated detection of hate speech helps in creating safer online spaces, protecting vulnerable communities, and enforcing community guidelines on digital platforms.',
              icon: Icons.search,
            ),
            const SizedBox(height: 24),
            const Text(
              'Types of Harmful Content',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTypesList(),
            const SizedBox(height: 24),
            _buildResourcesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypesList() {
    final types = [
      {
        'title': 'Direct Attacks',
        'description': 'Explicitly targeting individuals or groups with derogatory language.'
      },
      {
        'title': 'Dehumanization',
        'description': 'Comparing groups to animals, insects, or diseases.'
      },
      {
        'title': 'Incitement to Violence',
        'description': 'Encouraging harmful actions against specific groups.'
      },
      {
        'title': 'Offensive Stereotyping',
        'description': 'Perpetuating harmful stereotypes about groups.'
      },
      {
        'title': 'Exclusion & Discrimination',
        'description': 'Promoting the exclusion of certain groups from society.'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text('${index + 1}'),
          ),
          title: Text(types[index]['title']!),
          subtitle: Text(types[index]['description']!),
        );
      },
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resources & Further Learning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildResourceItem(
                  title: 'UNESCO: Countering Online Hate Speech',
                  subtitle: 'Guidelines and resources for addressing hate speech',
                ),
                const Divider(),
                _buildResourceItem(
                  title: 'Council of Europe: Hate Speech Fact Sheet',
                  subtitle: 'Information on legal frameworks and prevention',
                ),
                const Divider(),
                _buildResourceItem(
                  title: 'Media Literacy Resources',
                  subtitle: 'Tools for critical evaluation of online content',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem({required String title, required String subtitle}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      contentPadding: EdgeInsets.zero,
    );
  }
}