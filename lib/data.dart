class Seg {
  const Seg(this.text, {this.bold = false});
  final String text;
  final bool bold;
}

class ChipItem {
  const ChipItem(this.segs, {this.off = false});
  final List<Seg> segs;
  final bool off;
}

class SkillGroup {
  const SkillGroup(this.titleKey, this.items);
  final String titleKey;
  final List<ChipItem> items;
}

const List<SkillGroup> kSkillGroups = [
  SkillGroup('skills.g1', [
    ChipItem([Seg('Flutter', bold: true)]),
    ChipItem([Seg('GetX')]),
    ChipItem([Seg('Dio')]),
    ChipItem([Seg('Firebase FCM')]),
    ChipItem([Seg('WebSocket')]),
    ChipItem([Seg('Geolocator')]),
    ChipItem([Seg('FastAPI')]),
    ChipItem([Seg('SQLAlchemy')]),
    ChipItem([Seg('Pydantic')]),
  ]),
  SkillGroup('skills.g2', [
    ChipItem([Seg('Dart', bold: true)]),
    ChipItem([Seg('Python', bold: true)]),
    ChipItem([Seg('JavaScript')]),
    ChipItem([Seg('HTML · CSS · PHP')], off: true),
    ChipItem([Seg('C# · C++ · Java · SQL')], off: true),
  ]),
  SkillGroup('skills.g3', [
    ChipItem([Seg('MongoDB', bold: true)]),
    ChipItem([Seg('SQLite')]),
    ChipItem([Seg('PostgreSQL')]),
    ChipItem([Seg('REST API')]),
    ChipItem([Seg('JWT / OTP Auth')]),
    ChipItem([Seg('Social Login')]),
    ChipItem([Seg('Gemini AI')]),
    ChipItem([Seg('Cloudinary')]),
  ]),
  SkillGroup('skills.g4', [
    ChipItem([Seg('Git'), Seg(' / '), Seg('GitHub', bold: true)]),
    ChipItem([Seg('Postman')]),
    ChipItem([Seg('Docker')]),
    ChipItem([Seg('Render')]),
    ChipItem([Seg('Firebase Console')]),
    ChipItem([Seg('Android Studio')]),
    ChipItem([Seg('VS Code')]),
  ]),
];

class Project {
  const Project({
    required this.titleKey,
    required this.taglineKey,
    required this.roleKey,
    required this.bodyKeys,
    required this.tags,
    required this.link,
  });
  final String titleKey;
  final String taglineKey;
  final String roleKey;
  final List<String> bodyKeys;
  final List<String> tags;
  final String link;
}

const _gh = 'https://github.com/panhahoun';

const List<Project> kProjects = [
  Project(
    titleKey: 'p1.name',
    taglineKey: 'p1.tagline',
    roleKey: 'p1.role',
    bodyKeys: ['p1.b1', 'p1.b2', 'p1.b3'],
    tags: ['Flutter', 'GetX', 'Dio', 'Firebase FCM', 'Geolocator', 'i18n'],
    link: _gh,
  ),
  Project(
    titleKey: 'p2.name',
    taglineKey: 'p2.tagline',
    roleKey: 'p2.role',
    bodyKeys: ['p2.b1', 'p2.b2', 'p2.b3'],
    tags: [
      'FastAPI',
      'MongoDB',
      'JWT',
      'OTP',
      'WebSocket',
      'Gemini AI',
      'Flutter Web',
      'Render',
    ],
    link: _gh,
  ),
  Project(
    titleKey: 'p3.name',
    taglineKey: 'p3.tagline',
    roleKey: 'p3.role',
    bodyKeys: ['p3.b1', 'p3.b2', 'p3.b3'],
    tags: ['Flutter', 'FastAPI', 'SQLite', 'JWT', 'Chart.js'],
    link: _gh,
  ),
  Project(
    titleKey: 'p8.name',
    taglineKey: 'p8.tagline',
    roleKey: 'p8.role',
    bodyKeys: ['p8.b1', 'p8.b2', 'p8.b3'],
    tags: ['Flutter', 'GetX', 'FastAPI', 'Dio', 'JWT', 'i18n'],
    link: _gh,
  ),
  Project(
    titleKey: 'p9.name',
    taglineKey: 'p9.tagline',
    roleKey: 'p9.role',
    bodyKeys: ['p9.b1', 'p9.b2', 'p9.b3'],
    tags: ['Flutter', 'GetX', 'FastAPI', 'SQLAlchemy', 'PostgreSQL', 'JWT'],
    link: _gh,
  ),
  Project(
    titleKey: 'p4.name',
    taglineKey: 'p4.tagline',
    roleKey: 'p4.role',
    bodyKeys: ['p4.b1', 'p4.b2', 'p4.b3'],
    tags: ['C#', 'WinForms', 'OOP', 'LINQ', '.NET 4.8'],
    link: _gh,
  ),
  Project(
    titleKey: 'p5.name',
    taglineKey: 'p5.tagline',
    roleKey: 'p5.role',
    bodyKeys: ['p5.b1', 'p5.b2'],
    tags: ['HTML', 'CSS', 'JavaScript', 'i18n'],
    link: _gh,
  ),
  Project(
    titleKey: 'p6.name',
    taglineKey: 'p6.tagline',
    roleKey: 'p6.role',
    bodyKeys: ['p6.b1', 'p6.b2'],
    tags: ['Java', 'Python', 'C#', 'JavaScript'],
    link: _gh,
  ),
  Project(
    titleKey: 'p7.name',
    taglineKey: 'p7.tagline',
    roleKey: 'p7.role',
    bodyKeys: ['p7.b1', 'p7.b2'],
    tags: ['C++', 'OOP', 'Binary Storage'],
    link: _gh,
  ),
];

class StatItem {
  const StatItem(this.value, this.labelKey);
  final String value;
  final String labelKey;
}

const List<StatItem> kStats = [
  StatItem('9+', 'stat.projects'),
  StatItem('4', 'stat.fullstack'),
  StatItem('100%', 'stat.scholarship'),
];

class EduItem {
  const EduItem({
    required this.degreeKey,
    required this.schoolKey,
    required this.dateKey,
  });
  final String degreeKey;
  final String schoolKey;
  final String dateKey;
}

const List<EduItem> kEduItems = [
  EduItem(degreeKey: 'edu.deg', schoolKey: 'edu.univ', dateKey: 'edu.date1'),
  EduItem(degreeKey: 'edu.prog', schoolKey: 'edu.cent', dateKey: 'edu.date2'),
];

const List<String> kEduTags = ['edu.t1', 'edu.t2', 'edu.t3'];
