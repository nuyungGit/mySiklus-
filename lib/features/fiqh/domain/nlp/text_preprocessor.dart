/// Modul Pemrosesan Bahasa Alami (NLP Preprocessing) Bahasa Indonesia
/// Meliputi: Case Folding, Punctuation Filtering, Tokenisasi, Stopword Removal, dan Stemming Sederhana.
class TextPreprocessor {
  TextPreprocessor._();

  /// Daftar Stopwords Bahasa Indonesia Umum
  static const Set<String> indonesianStopwords = {
    'ada', 'adalah', 'adanya', 'adapun', 'agak', 'agar', 'akan', 'akankah',
    'akhir', 'akhiri', 'akhirnya', 'aku', 'akulah', 'amat', 'amatlah', 'anda',
    'andalah', 'antar', 'antara', 'antaranya', 'apa', 'apaan', 'apabila',
    'apakah', 'apalagi', 'apatah', 'artinya', 'asal', 'asalkan', 'atas',
    'atau', 'ataukah', 'ataupun', 'awal', 'awalnya', 'bagai', 'bagaikan',
    'bagaimana', 'bagaimanakah', 'bagaimanapun', 'bagi', 'bagian', 'bahkan',
    'bahwa', 'bahwasanya', 'baik', 'bakal', 'bakalan', 'balik', 'banyak',
    'bapak', 'baru', 'bawah', 'beberapa', 'begini', 'beginian', 'beginikah',
    'beginilah', 'begitu', 'begitukah', 'begitulah', 'begitupun', 'bekerja',
    'belakang', 'belakangan', 'belum', 'belumlah', 'benar', 'benarkah',
    'benarlah', 'berada', 'berakhir', 'berakhirlah', 'berakhirnya', 'berapa',
    'berapakah', 'berapalah', 'berapapun', 'berarti', 'berawal', 'berbagai',
    'berdatangan', 'beri', 'berikan', 'berikut', 'berikutnya', 'berjumlah',
    'berkali-kali', 'berkata', 'berkehendak', 'berkeinginan', 'berkenaan',
    'berlainan', 'berlalu', 'berlangsung', 'berlebihan', 'bermacam',
    'bermacam-macam', 'bermaksud', 'bermula', 'bersama', 'bersama-sama',
    'bersiap', 'bersiap-siap', 'bertanya', 'bertanya-tanya', 'berturut',
    'berturut-turut', 'bertutur', 'berujar', 'berupa', 'besar', 'betul',
    'betulkah', 'biasa', 'biasanya', 'bila', 'bilakah', 'bisa', 'bisakah',
    'boleh', 'bolehkah', 'bolehlah', 'buat', 'bukan', 'bukankah', 'bukanlah',
    'bukannya', 'cuma', 'dan', 'dapat', 'dari', 'daripada', 'dekat', 'demi',
    'demikian', 'demikianlah', 'dengan', 'depan', 'di', 'dia', 'diakhiri',
    'diakhirinya', 'dialah', 'diantara', 'diantaranya', 'diberi', 'diberikan',
    'diberikannya', 'dibuat', 'dibuatnya', 'didapat', 'didatangkan',
    'digunakan', 'diibaratkan', 'diibaratkannya', 'diingat', 'diingatkan',
    'diinginkan', 'dijawab', 'dijelaskan', 'dijelaskannya', 'dikarenakan',
    'dikatakan', 'dikatakannya', 'dikerjakan', 'diketahui', 'diketahuinya',
    'dikira', 'dilakukan', 'dilalui', 'dilihat', 'dimaksud', 'dimaksudkan',
    'dimaksudkannya', 'dimaksudnya', 'diminta', 'dimintai', 'dimisalkan',
    'dimulai', 'dimulailah', 'dimulainya', 'dimungkinkan', 'dini', 'dipastikan',
    'diperbuat', 'diperbuatnya', 'dipergunakan', 'diperkirakan', 'diperlihatkan',
    'diperlukan', 'diperlukannya', 'dipersoalkan', 'dipertanyakan', 'dipunyai',
    'diri', 'dirinya', 'disampaikan', 'disebut', 'disebutkan', 'disebutkannya',
    'disini', 'disinilah', 'disitu', 'disitulah', 'ditandai', 'ditandainya',
    'ditanya', 'ditanyai', 'ditanyakan', 'ditegaskan', 'ditemukan', 'ditentukan',
    'dituturkan', 'dituturkannya', 'diucapkan', 'diucapkannya', 'diungkapkan',
    'dong', 'dulu', 'empat', 'enggak', 'enggaknya', 'entah', 'entahlah',
    'guna', 'gunakan', 'hal', 'hampir', 'hanya', 'hanyalah', 'hari', 'harus',
    'haruslah', 'harusnya', 'hendak', 'hendaklah', 'hendaknya', 'hingga',
    'ia', 'ialah', 'ibarat', 'ibaratkan', 'ibaratnya', 'ibu', 'ikut', 'ingat',
    'ingat-ingat', 'ingin', 'inginkah', 'inginkan', 'ini', 'inikah', 'inilah',
    'itu', 'itukah', 'itulah', 'jadi', 'jadilah', 'jadinya', 'jangan',
    'jangankan', 'janganlah', 'jauh', 'jawab', 'jawaban', 'jawabnya', 'jelas',
    'jelaskan', 'jelaslah', 'jelasnya', 'jika', 'jikalau', 'juga', 'jumlah',
    'jumlahnya', 'justru', 'kala', 'kalau', 'kalaulah', 'kalaupun', 'kalian',
    'kami', 'kamilah', 'kamu', 'kamulah', 'kan', 'kapan', 'kapankah',
    'kapanpun', 'karena', 'karenanya', 'kasus', 'kata', 'katakan', 'katakanlah',
    'katanya', 'ke', 'keadaan', 'kebetulan', 'kecil', 'kedua', 'keduanya',
    'keinginan', 'kelamaan', 'kelihatan', 'kelihatannya', 'kelima', 'keluar',
    'kembali', 'kemudian', 'kemungkinan', 'kemungkinannya', 'kenapa', 'kepada',
    'kepadanya', 'kesampaian', 'keseluruhan', 'keseluruhannya', 'keterlaluan',
    'ketika', 'khususnya', 'kini', 'kinilah', 'kira', 'kira-kira', 'kiranya',
    'kita', 'kitalah', 'kok', 'kurang', 'lagi', 'lagian', 'lah', 'lain',
    'lainnya', 'lalu', 'lama', 'lamanya', 'lanjut', 'lanjutnya', 'lebih',
    'lewat', 'macam', 'maka', 'makanya', 'makin', 'malah', 'malahan', 'mampu',
    'mampukah', 'mana', 'manakala', 'manalagi', 'masing', 'masing-masing',
    'masuk', 'mata', 'mau', 'maupun', 'melainkan', 'melakukan', 'melalui',
    'melihat', 'melihatnya', 'memang', 'memastikan', 'memberi', 'memberikan',
    'membuat', 'memerlukan', 'memihak', 'meminta', 'memintakan', 'memisalkan',
    'memperbuat', 'mempergunakan', 'memperkirakan', 'memperlihatkan',
    'mempersiapkan', 'mempersoalkan', 'mempertanyakan', 'mempunyai', 'memulai',
    'memungkinkan', 'menaiki', 'menandai', 'menandaskan', 'menanti', 'menantikan',
    'menanya', 'menanyai', 'menanyakan', 'mendapat', 'mendapatkan', 'mendatang',
    'mendatangi', 'mendatangkan', 'menegaskan', 'mengakhiri', 'mengapa',
    'mengatakan', 'mengatakannya', 'mengenai', 'mengerjakan', 'mengetahui',
    'menggunakan', 'menghendaki', 'mengibaratkan', 'mengibaratkannya',
    'mengingat', 'mengingatkan', 'menginginkan', 'mengira', 'mengucapkan',
    'mengucapkannya', 'mengungkapkan', 'menjadi', 'menjadikan', 'menjawa',
    'menjawab', 'menuju', 'menunjuk', 'menunjuki', 'menunjukkan', 'menunjuknya',
    'menurut', 'menurutnya', 'menuturkan', 'menuturkannya', 'menyampaikan',
    'menyangkut', 'menyatakan', 'menyebutkan', 'menyeluruh', 'menyiapkan',
    'merasa', 'mereka', 'merekalah', 'merupakan', 'meski', 'meskipun',
    'meyakini', 'meyakinkan', 'minta', 'mirip', 'misal', 'misalkan', 'misalnya',
    'mula', 'mulai', 'mulailah', 'mulanya', 'mungkin', 'mungkinkah', 'nah',
    'naik', 'namun', 'nanti', 'nantinya', 'nyaris', 'nyatanya', 'oleh',
    'olehnya', 'pada', 'padahal', 'padanya', 'pak', 'paling', 'panjang',
    'pantas', 'pantaskah', 'pantaslah', 'para', 'pasti', 'pastilah', 'penting',
    'pentingnya', 'per', 'percuma', 'perlu', 'perlukah', 'perlunya', 'pernah',
    'persoalan', 'pertama', 'pertama-tama', 'pertanyaan', 'pertanyakan', 'pihak',
    'pihaknya', 'pukul', 'pula', 'pun', 'punya', 'rasa', 'rasanya', 'rata',
    'rupanya', 'saat', 'saatnya', 'saja', 'sajalah', 'saling', 'sama',
    'sama-sama', 'sambil', 'sampai', 'sampai-sampai', 'sampaikan', 'sana',
    'sangat', 'sangatlah', 'satu', 'saya', 'sayalah', 'se', 'sebab', 'sebabnya',
    'sebagai', 'sebagaimana', 'sebagainya', 'sebagian', 'sebaik', 'sebaik-baiknya',
    'sebaiknya', 'sebaliknya', 'sebanyak', 'sebegini', 'sebegitu', 'sebelum',
    'sebelumnya', 'sebenarnya', 'seberapa', 'sebesar', 'sebetulnya', 'sebisanya',
    'sebuah', 'sebut', 'sebutlah', 'sebutnya', 'secara', 'secukupnya', 'sedang',
    'sedangkan', 'sedemikian', 'sedikit', 'sedikitnya', 'seenaknya', 'segala',
    'segalanya', 'segera', 'seharusnya', 'sehingga', 'seingat', 'sejak',
    'sejauh', 'sejenak', 'sejumlah', 'sekadar', 'sekadarnya', 'sekali',
    'sekalian', 'sekaligus', 'sekalipun', 'sekarang', 'sekaranglah', 'sekecil',
    'seketika', 'sekiranya', 'sekitar', 'sekitarnya', 'sekurang-kurangnya',
    'sekurangnya', 'sela', 'selain', 'selaku', 'selalu', 'selama', 'selama-lamanya',
    'selamanya', 'selanjutnya', 'seluruh', 'seluruhnya', 'semacam', 'semakin',
    'semampu', 'semampunya', 'semasa', 'semasih', 'semata', 'semata-mata',
    'semaunya', 'sementara', 'semisal', 'semisalnya', 'sempat', 'semua',
    'semuanya', 'semula', 'sendiri', 'sendirian', 'sendirinya', 'seolah',
    'seolah-olah', 'seorang', 'sepanjang', 'sepantasnya', 'sepantasnyalah',
    'seperlunya', 'seperti', 'sepertinya', 'sepihak', 'sering', 'seringnya',
    'serta', 'serupa', 'sesaat', 'sesama', 'sesampai', 'sesegera', 'sesekali',
    'seseorang', 'sesuatu', 'sesuatunya', 'sesudah', 'sesudahnya', 'setelah',
    'setempat', 'setengah', 'seterusnya', 'setiap', 'setiba', 'setibanya',
    'setidak-tidaknya', 'setidaknya', 'setinggi', 'seusai', 'sewaktu', 'siap',
    'siapa', 'siapakah', 'siapapun', 'sini', 'sinilah', 'sinipun', 'situ',
    'situlah', 'suatu', 'sudah', 'sudahkah', 'sudahlah', 'supaya', 'tadi',
    'tadinya', 'tahu', 'tahun', 'tak', 'tambah', 'tambahnya', 'tampak',
    'tampaknya', 'tandas', 'tandasnya', 'tanpa', 'tanya', 'tanyakan', 'tanyanya',
    'tapi', 'tegas', 'tegasnya', 'telah', 'tempat', 'tengah', 'tentang',
    'tentu', 'tentulah', 'tentunya', 'tepat', 'terakhir', 'terasa', 'terbanyak',
    'terdahulu', 'terdapat', 'terdiri', 'terhadap', 'terhadapnya', 'teringat',
    'teringat-ingat', 'terjadi', 'terjadilah', 'terjadinya', 'terkira',
    'terlalu', 'terlebih', 'terlihat', 'termasuk', 'ternyata', 'tersampaikan',
    'tersebut', 'tersebutlah', 'tertentu', 'tertuju', 'terus', 'terutama',
    'tetap', 'tetapi', 'tiap', 'tiba', 'tiba-tiba', 'tidak', 'tidakkah',
    'tidaklah', 'tidaknya', 'tiga', 'toh', 'tunjuk', 'turut', 'tutur',
    'tuturnya', 'ucap', 'ucapnya', 'ujar', 'ujarnya', 'umum', 'umumnya',
    'ungkap', 'ungkapnya', 'untuk', 'usah', 'usai', 'waduh', 'wah', 'wahai',
    'waktu', 'waktunya', 'walau', 'walaupun', 'wong', 'yaitu', 'yakin',
    'yakni', 'yang',
  };

  /// Preprocessing lengkap: Lowercase -> Clean Punctuation -> Tokenize -> Filter Stopwords -> Stemming
  static List<String> preprocess(String text) {
    if (text.trim().isEmpty) return [];

    // 1. Case Folding
    String cleaned = text.toLowerCase();

    // 2. Cleaning tanda baca & angka, pertahankan hanya huruf a-z dan spasi
    cleaned = cleaned.replaceAll(RegExp(r'[^a-z\s]'), ' ');

    // 3. Tokenisasi
    final rawTokens = cleaned
        .split(RegExp(r'\s+'))
        .where((t) => t.trim().isNotEmpty)
        .toList();

    // 4. Stopwords Removal & Stemming Ringan
    final processedTokens = <String>[];
    for (final token in rawTokens) {
      if (!indonesianStopwords.contains(token) && token.length > 2) {
        final stemmed = simpleStem(token);
        if (stemmed.isNotEmpty && !indonesianStopwords.contains(stemmed)) {
          processedTokens.add(stemmed);
        }
      }
    }

    return processedTokens;
  }

  /// Algoritma pemotong imbuhan (stemming) dasar untuk kata bahasa Indonesia
  static String simpleStem(String word) {
    var result = word;

    // Hilangkan partikel/infleksi di belakang: -lah, -kah, -pun, -nya, -ku, -mu
    if (result.endsWith('nya') && result.length > 5) {
      result = result.substring(0, result.length - 3);
    } else if ((result.endsWith('lah') || result.endsWith('kah') || result.endsWith('pun')) && result.length > 5) {
      result = result.substring(0, result.length - 3);
    } else if ((result.endsWith('ku') || result.endsWith('mu')) && result.length > 4) {
      result = result.substring(0, result.length - 2);
    }

    // Hilangkan akhiran: -kan, -an, -i
    if (result.endsWith('kan') && result.length > 5) {
      result = result.substring(0, result.length - 3);
    } else if (result.endsWith('an') && result.length > 4) {
      result = result.substring(0, result.length - 2);
    } else if (result.endsWith('i') && result.length > 3) {
      result = result.substring(0, result.length - 1);
    }

    // Hilangkan awalan: meng-, meny-, men-, mem-, me-, peng-, peny-, pen-, pem-, pe-, ber-, ter-, di-, ke-, se-
    if (result.startsWith('meng') && result.length > 6) {
      result = result.substring(4);
    } else if (result.startsWith('meny') && result.length > 6) {
      result = 's${result.substring(4)}';
    } else if (result.startsWith('men') && result.length > 5) {
      result = result.substring(3);
    } else if (result.startsWith('mem') && result.length > 5) {
      result = result.substring(3);
    } else if (result.startsWith('me') && result.length > 4) {
      result = result.substring(2);
    } else if (result.startsWith('ber') && result.length > 5) {
      result = result.substring(3);
    } else if (result.startsWith('ter') && result.length > 5) {
      result = result.substring(3);
    } else if (result.startsWith('di') && result.length > 4) {
      result = result.substring(2);
    } else if (result.startsWith('ke') && result.length > 4) {
      result = result.substring(2);
    } else if (result.startsWith('se') && result.length > 4) {
      result = result.substring(2);
    }

    return result;
  }
}
