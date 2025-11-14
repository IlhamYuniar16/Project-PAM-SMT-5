class AnswerOptionMental {
  final String label;
  final int score;
  const AnswerOptionMental({required this.label, required this.score});
}

class QuestionMental {
  final String id;
  final String text;
  final List<AnswerOptionMental> options;

  const QuestionMental({required this.id, required this.text, required this.options});
}

const defaultQuestionsMental = <QuestionMental>[
  QuestionMental(
    id: '1',
    text: 'Apakah Anda merasa mampu mengendalikan emosi ketika menghadapi situasi sulit?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '2',
    text: 'Apakah Anda merasa tenang saat menghadapi tekanan atau masalah?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '3',
    text: 'Apakah Anda mampu berpikir positif terhadap diri sendiri?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '4',
    text: 'Apakah Anda merasa mudah tersinggung atau marah terhadap hal kecil?',
    options: [
      AnswerOptionMental(label: 'Tidak Pernah', score: 3),
      AnswerOptionMental(label: 'Kadang-kadang', score: 2),
      AnswerOptionMental(label: 'Sering', score: 1),
      AnswerOptionMental(label: 'Hampir Selalu', score: 0),
    ],
  ),
  QuestionMental(
    id: '5',
    text: 'Apakah Anda mampu tetap fokus saat menghadapi tekanan?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '6',
    text: 'Apakah Anda merasa memiliki tujuan hidup yang jelas?',
    options: [
      AnswerOptionMental(label: 'Sangat Jelas', score: 3),
      AnswerOptionMental(label: 'Cukup Jelas', score: 2),
      AnswerOptionMental(label: 'Kurang Jelas', score: 1),
      AnswerOptionMental(label: 'Tidak Jelas', score: 0),
    ],
  ),
  QuestionMental(
    id: '7',
    text: 'Apakah Anda merasa bahagia dengan kehidupan Anda saat ini?',
    options: [
      AnswerOptionMental(label: 'Sangat Bahagia', score: 3),
      AnswerOptionMental(label: 'Cukup Bahagia', score: 2),
      AnswerOptionMental(label: 'Kurang Bahagia', score: 1),
      AnswerOptionMental(label: 'Tidak Bahagia', score: 0),
    ],
  ),
  QuestionMental(
    id: '8',
    text: 'Apakah Anda merasa mudah untuk menenangkan diri ketika stres?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '9',
    text: 'Apakah Anda merasa percaya diri menghadapi tantangan baru?',
    options: [
      AnswerOptionMental(label: 'Sangat Percaya Diri', score: 3),
      AnswerOptionMental(label: 'Cukup Percaya Diri', score: 2),
      AnswerOptionMental(label: 'Sedikit Ragu', score: 1),
      AnswerOptionMental(label: 'Tidak Percaya Diri', score: 0),
    ],
  ),
  QuestionMental(
    id: '10',
    text: 'Apakah Anda sering merasa kewalahan oleh masalah hidup?',
    options: [
      AnswerOptionMental(label: 'Tidak Pernah', score: 3),
      AnswerOptionMental(label: 'Kadang-kadang', score: 2),
      AnswerOptionMental(label: 'Sering', score: 1),
      AnswerOptionMental(label: 'Hampir Selalu', score: 0),
    ],
  ),
  QuestionMental(
    id: '11',
    text: 'Apakah Anda merasa mampu menyesuaikan diri dengan perubahan dalam hidup?',
    options: [
      AnswerOptionMental(label: 'Sangat Mampu', score: 3),
      AnswerOptionMental(label: 'Cukup Mampu', score: 2),
      AnswerOptionMental(label: 'Kurang Mampu', score: 1),
      AnswerOptionMental(label: 'Tidak Mampu', score: 0),
    ],
  ),
  QuestionMental(
    id: '12',
    text: 'Apakah Anda merasa memiliki dukungan sosial dari teman atau keluarga?',
    options: [
      AnswerOptionMental(label: 'Sangat Mendukung', score: 3),
      AnswerOptionMental(label: 'Cukup Mendukung', score: 2),
      AnswerOptionMental(label: 'Kurang Mendukung', score: 1),
      AnswerOptionMental(label: 'Tidak Ada Dukungan', score: 0),
    ],
  ),
  QuestionMental(
    id: '13',
    text: 'Apakah Anda sering merasa cemas tanpa alasan yang jelas?',
    options: [
      AnswerOptionMental(label: 'Tidak Pernah', score: 3),
      AnswerOptionMental(label: 'Kadang-kadang', score: 2),
      AnswerOptionMental(label: 'Sering', score: 1),
      AnswerOptionMental(label: 'Hampir Selalu', score: 0),
    ],
  ),
  QuestionMental(
    id: '14',
    text: 'Apakah Anda merasa mudah memaafkan kesalahan orang lain?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '15',
    text: 'Apakah Anda mampu mengatur waktu dan tanggung jawab dengan baik?',
    options: [
      AnswerOptionMental(label: 'Sangat Baik', score: 3),
      AnswerOptionMental(label: 'Cukup Baik', score: 2),
      AnswerOptionMental(label: 'Kurang Baik', score: 1),
      AnswerOptionMental(label: 'Tidak Baik', score: 0),
    ],
  ),
  QuestionMental(
    id: '16',
    text: 'Apakah Anda merasa puas dengan diri sendiri dan pencapaian Anda?',
    options: [
      AnswerOptionMental(label: 'Sangat Puas', score: 3),
      AnswerOptionMental(label: 'Cukup Puas', score: 2),
      AnswerOptionMental(label: 'Kurang Puas', score: 1),
      AnswerOptionMental(label: 'Tidak Puas', score: 0),
    ],
  ),
  QuestionMental(
    id: '17',
    text: 'Apakah Anda sering merasa kesepian atau terisolasi?',
    options: [
      AnswerOptionMental(label: 'Tidak Pernah', score: 3),
      AnswerOptionMental(label: 'Kadang-kadang', score: 2),
      AnswerOptionMental(label: 'Sering', score: 1),
      AnswerOptionMental(label: 'Hampir Selalu', score: 0),
    ],
  ),
  QuestionMental(
    id: '18',
    text: 'Apakah Anda mampu menerima kegagalan tanpa menyalahkan diri sendiri?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
  QuestionMental(
    id: '19',
    text: 'Apakah Anda merasa hidup Anda memiliki makna dan arah yang jelas?',
    options: [
      AnswerOptionMental(label: 'Sangat Bermakna', score: 3),
      AnswerOptionMental(label: 'Cukup Bermakna', score: 2),
      AnswerOptionMental(label: 'Kurang Bermakna', score: 1),
      AnswerOptionMental(label: 'Tidak Bermakna', score: 0),
    ],
  ),
  QuestionMental(
    id: '20',
    text: 'Apakah Anda merasa mampu mengatasi stres dengan cara yang sehat?',
    options: [
      AnswerOptionMental(label: 'Selalu', score: 3),
      AnswerOptionMental(label: 'Sering', score: 2),
      AnswerOptionMental(label: 'Kadang-kadang', score: 1),
      AnswerOptionMental(label: 'Tidak Pernah', score: 0),
    ],
  ),
];
