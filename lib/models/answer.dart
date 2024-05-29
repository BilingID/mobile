class Answer {
  final int E;
  final int I;
  final int S;
  final int N;
  final int T;
  final int F;
  final int J;
  final int P;

  Answer({
    required this.E,
    required this.I,
    required this.S,
    required this.N,
    required this.T,
    required this.F,
    required this.J,
    required this.P,
  });

  Answer copyWith({
    int? E,
    int? I,
    int? S,
    int? N,
    int? T,
    int? F,
    int? J,
    int? P,
  }) {
    return Answer(
      E: E ?? this.E,
      I: I ?? this.I,
      S: S ?? this.S,
      N: N ?? this.N,
      T: T ?? this.T,
      F: F ?? this.F,
      J: J ?? this.J,
      P: P ?? this.P,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'E': E,
      'I': I,
      'S': S,
      'N': N,
      'T': T,
      'F': F,
      'J': J,
      'P': P,
    };
  }
}
