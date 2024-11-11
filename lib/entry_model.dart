class Entry {
  final String migraine;
  final String alcohol;
  final String stressLevel;
  final String shortNote;
  final String longNote;

  Entry({
    required this.migraine,
    required this.alcohol,
    required this.stressLevel,
    required this.shortNote,
    required this.longNote,
  });

  Entry.fromJson(Map<String, dynamic> json) :
    migraine = json['migraine'],
    alcohol = json['alcohol'],
    stressLevel = json['stressLevel'],
    shortNote = json['shortNote'],
    longNote = json['longNote'];

  Map<String, dynamic> toJson() => {
    'migraine': migraine,
    'alcohol': alcohol,
    'stressLevel': stressLevel,
    'shortNote': shortNote,
    'longNote': longNote,
  };
}