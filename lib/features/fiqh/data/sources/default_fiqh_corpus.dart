import '../models/fiqh_article_model.dart';

/// Dataset Awal Korpus Fiqh Darah Wanita (Mazhab Syafi'i)
/// Disediakan sebagai data lokal bawaan (offline-first) dan sumber seed Supabase.
class DefaultFiqhCorpus {
  DefaultFiqhCorpus._();

  static List<FiqhArticleModel> get articles => [
    FiqhArticleModel(
      id: 'art-001',
      title: 'Batas Minimal, Kebiasaan, dan Maksimal Durasi Haid',
      category: 'Haid',
      reference: 'Kitab Safinatun Najah & Fathul Qorib',
      searchKeywords: 'batas durasi haid minimal maksimal hari jam kebiasaan adat',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 1),
      content: '''
Menurut Mazhab Syafi'i, durasi darah haid memiliki tiga batasan penting:
1. Batas Minimal: Satu hari satu malam (24 jam) pendarahan secara akumulatif dalam rentang 15 hari.
2. Batas Kebiasaan (Adat): Umumnya berlangsung selama 6 hingga 7 hari.
3. Batas Maksimal: 15 hari 15 malam.

Jika pendarahan yang keluar belum mencapai akumulasi 24 jam dalam masa 15 hari, maka darah tersebut belum dihukumi sebagai haid melainkan darah rusak (dam fasad). Sebaliknya, apabila darah terus keluar melebihi 15 hari 15 malam, maka darah selebihnya dikategorikan sebagai istihadah.
''',
    ),
    FiqhArticleModel(
      id: 'art-002',
      title: 'Tanda Berakhirnya Haid dan Masuknya Awal Masa Suci',
      category: 'Masa Suci',
      reference: 'Kitab Al-Majmu\' Syarah Al-Muhadzdzab & Nihayatul Muhtaj',
      searchKeywords: 'tanda suci bersih kapas cairan putih naqa qashshah baidha awal masa suci mandi',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 2),
      content: '''
Masa haid dinyatakan selesai dan berganti menjadi Masa Suci apabila telah ditemukan salah satu dari dua tanda berikut:
1. Al-Jufuf / An-Naqa' (Kering Mutlak): Ketika kapas atau pembalut dimasukkan ke bagian dalam kewanitaan, keluar dalam keadaan bersih total tanpa noda darah, flek merah, cokelat, maupun kuning.
2. Al-Qashshah Al-Baidha' (Keluarnya Cairan Putih Bersih): Cairan putih seperti benang atau kapur yang menandakan rahim telah bersih dari peluruhan dinding rahim.

Setelah menemukan tanda ini, seorang muslimah berkewajiban segera melakukan mandi wajib (ghusl) dan melaksanakan ibadah salat serta puasa kembali.
''',
    ),
    FiqhArticleModel(
      id: 'art-003',
      title: 'Ketentuan Minimal Masa Suci 15 Hari Antara Dua Haid',
      category: 'Masa Suci',
      reference: 'Kitab Fathul Mu\'in & Kasyifatus Saja',
      searchKeywords: 'minimal masa suci hari jeda antara dua haid jarak suci',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 3),
      content: '''
Salah satu kaidah paling fundamental dalam Fiqh Syafi'i adalah bahwa jeda Masa Suci yang memisahkan antara dua siklus haid minimal berdurasi 15 hari 15 malam.

Implikasi hukumnya:
- Jika seorang wanita telah suci dari haid pertama, lalu melihat darah lagi sebelum melewati 15 hari masa suci, darah baru tersebut TIDAK BISA langsung dianggap sebagai siklus haid baru.
- Darah tersebut harus dievaluasi keterkaitannya dengan siklus sebelumnya (apakah masih dalam jangkauan 15 hari siklus haid pertama atau termasuk istihadah).
- Tidak ada batasan maksimal untuk lamanya masa suci; seorang perempuan bisa saja suci berbulan-bulan tanpa haid.
''',
    ),
    FiqhArticleModel(
      id: 'art-004',
      title: 'Hukum Darah yang Terputus-putus (Keluar Bersih Lalu Keluar Lagi)',
      category: 'Haid',
      reference: 'Kitab Minhajut Thalibin & Raudhatut Thalibin',
      searchKeywords: 'darah terputus putus keluar bersih lagi jeda talfiq sahb flek berhenti',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 4),
      content: '''
Sering kali seorang wanita mendapati darah keluar selama beberapa hari, kemudian berhenti dan bersih selama 1-2 hari, lalu darah keluar kembali.

Dalam Mazhab Syafi'i terdapat dua pendapat masyhur:
1. Qaul Sahb (Pendapat Menarik/Mencakup - Qaul Mu'tamad): Seluruh rentang waktu tersebut (baik saat keluar darah maupun saat hari-hari bersih di tengahnya) dihukumi sebagai satu kesatuan masa haid, dengan syarat akumulasi total hari sejak awal keluar sampai akhir tidak melebihi 15 hari, dan darah mencapai minimal 24 jam.
2. Qaul Talfiq: Hari-hari saat darah keluar dihukumi haid, sedangkan hari-hari saat bersih dihukumi masa suci (wajib salat dan puasa).

Jika darah keluar lagi setelah melewati 15 hari dari awal haid pertama, maka darah yang keluar di luar batas 15 hari tersebut adalah istihadah.
''',
    ),
    FiqhArticleModel(
      id: 'art-005',
      title: 'Pengertian Darah Istihadah dan Pembagian Golongan Mustahadhah',
      category: 'Istihadah',
      reference: 'Kitab Al-Ibanah wal Ifadhah fi Ahkamil Haidh wan Nifas wal Istihadhah',
      searchKeywords: 'istihadah mustahadhah pendarahan lewat batas hari mutahayyirah mumayyizah',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 5),
      content: '''
Istihadah adalah pendarahan penyakit/disfungsional yang keluar dari urat pembuluh darah di luar kebiasaan haid dan nifas, atau pendarahan yang terus berlanjut melebihi batas maksimal 15 hari 15 malam.

Status hukum wanita beristihadah adalah TETAP SUCI. Artinya, ia tetap berkewajiban mendirikan salat lima waktu dan wajib menjalankan ibadah puasa Ramadan.

Dalam Fiqh, mustahadhah terbagi menjadi 7 kategori, di antaranya:
- Mubtada'ah Mumayyizah (baru pertama kali dan bisa membedakan darah kuat vs lemah).
- Mu'tadah Mumayyizah (sudah punya kebiasaan siklus dan bisa membedakan sifat warna darah).
- Mu'tadah Ghairu Mumayyizah (sudah punya kebiasaan siklus namun darah sewarna, maka hukumnya dikembalikan pada durasi adat bulan sebelumnya).
''',
    ),
    FiqhArticleModel(
      id: 'art-006',
      title: 'Tata Cara Bersuci (Thaharah) dan Salat bagi Wanita Beristihadah',
      category: 'Istihadah',
      reference: 'Kitab Safinatun Najah & Fathul Qarib',
      searchKeywords: 'tata cara salat wudhu istihadah pembersih pembalut darah terus keluar wudhu tiap waktu',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 6),
      content: '''
Karena pendarahan istihadah terjadi terus-menerus, tata cara thaharah bagi wanita yang mengalaminya sama dengan orang yang berstatus daimul hadats (senantiasa berhadats):
1. Bersuci hanya boleh dilakukan SETELAH masuk waktu salat fardhu.
2. Membersihkan kemaluan dari sisa darah, kemudian menyumbat atau menutupnya dengan pembalut bersih agar darah tidak tercecer.
3. Segera berwudhu dengan niat "istibahatus salat" (agar diperbolehkan salat), bukan niat mengangkat hadats besar.
4. Segera melaksanakan salat tanpa menunda-nunda waktu kecuali untuk kepentingan persiapan salat (menutup aurat, menjawab azan).
5. Satu kali wudhu hanya berlaku untuk 1 salat fardhu dan boleh untuk salat sunnah sekehendaknya.
''',
    ),
    FiqhArticleModel(
      id: 'art-007',
      title: 'Tata Cara Mandi Wajib (Ghusl) yang Sah Setelah Haid',
      category: 'Masa Suci',
      reference: 'Kitab Kasyifatus Saja Syarah Safinatun Najah',
      searchKeywords: 'tata cara rukun mandi wajib besar basah junub sah haid niat',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 7),
      content: '''
Rukun mandi wajib setelah masa haid berhenti hanya ada dua hal:
1. Niat dalam hati ketika air pertama kali menyentuh anggota tubuh:
   "Nawaitul ghusla liraf'il hadatsil akbari minal haidhi fardhan lillahi ta'ala" (Saya berniat mandi untuk mengangkat hadats besar dari haid fardhu karena Allah Ta'ala).
2. Meratakan air suci menyucikan ke seluruh permukaan luar tubuh, kulit, dan helai rambut hingga ke pangkal rambut tanpa ada penghalang (seperti cat kuku/kutek kedap air, lilin, atau kotoran tebal).

Sunnah sebelum mandi: berwudhu, membersihkan najis terlebih dahulu, mencuci tangan, dan menyela-nyela rambut.
''',
    ),
    FiqhArticleModel(
      id: 'art-008',
      title: 'Hukum Flek Cokelat (Kudrah) dan Kuning (Shufrah)',
      category: 'Haid',
      reference: 'Kitab Fathul Wahhab & Al-Umm Imam Syafi\'i',
      searchKeywords: 'flek cokelat kuning kudrah shufrah keputihan sebelum sesudah suci',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 8),
      content: '''
Dalam mazhab Syafi'i, cairan berwarna keruh cokelat (kudrah) maupun kekuningan (shufrah) dihukumi berdasarkan waktu keluarnya:
1. Jika keluar dalam rentang kemungkinan haid (sebelum tanda suci sempurna tercapai dan masih dalam batas 15 hari), maka cairan tersebut dihukumi SEBAGAI HAID.
2. Jika cairan keruh atau flek tersebut keluar SETELAH tercapainya masa suci secara sempurna (kapas sudah bersih atau keluar cairan putih), maka flek tersebut TIDAK DIANGGAP HAID, melainkan najis biasa yang cukup dibersihkan dan berwudhu kembali untuk salat.
''',
    ),
    FiqhArticleModel(
      id: 'art-009',
      title: 'Ketentuan Meng-qadha Puasa Ramadan dan Salat yang Ditinggalkan',
      category: 'Ibadah',
      reference: 'Hadits Shahih Muslim dari Aisyah radhiyallahu \'anha',
      searchKeywords: 'qadha ganti hutang puasa ramadan salat waktu tinggal haid',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 9),
      content: '''
Dari Aisyah RA: "Kami dahulu mengalami haid pada masa Rasulullah SAW, lalu kami diperintahkan untuk mengqadha puasa dan tidak diperintahkan untuk mengqadha salat." (HR. Muslim).

Ketentuan Fiqh:
- Puasa Ramadan yang ditinggalkan selama masa haid WAJIB di-qadha di luar bulan Ramadan sebelum tiba Ramadan berikutnya.
- Salat lima waktu yang ditinggalkan selama haid TIDAK WAJIB di-qadha.
- Pengecualian Salat: Jika seorang wanita mendapati dirinya suci sebelum waktu salat berakhir sekadar ukuran satu rakaat (atau takbiratul ihram), maka ia wajib mengqadha salat waktu tersebut dan salat sebelumnya yang bisa dijamak (misal suci di waktu Ashar sebelum Maghrib, maka wajib salat Ashar dan Zhuhur).
''',
    ),
    FiqhArticleModel(
      id: 'art-010',
      title: 'Darah Nifas: Batas Minimal, Kebiasaan, dan Maksimal',
      category: 'Nifas',
      reference: 'Kitab Safinatun Najah & Tausyih \'ala Ibni Qasim',
      searchKeywords: 'nifas melahirkan batas waktu nifas hari darah persalinan',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 10),
      content: '''
Nifas adalah darah yang keluar dari rahim wanita sesudah selesainya proses persalinan / melahirkan (walad).

Batasan durasi nifas dalam Mazhab Syafi'i:
- Minimal: Lahzhah (sekejap/setetes darah saja).
- Kebiasaan (Adat): 40 hari.
- Maksimal: 60 hari 60 malam.

Jika pendarahan pasca melahirkan berlanjut melewati 60 hari, maka darah setelah hari ke-60 dikategorikan sebagai istihadah. Wanita tersebut wajib mandi wajib pada hari ke-60 dan mulai melaksanakan salat serta puasa dengan tata cara thaharah istihadah.
''',
    ),
    FiqhArticleModel(
      id: 'art-011',
      title: 'Darah Keluar Kurang dari 24 Jam (Darah Fasad)',
      category: 'Haid',
      reference: 'Kitab Al-Fiqh Al-Manhaji Mazhab Syafi\'i',
      searchKeywords: 'darah rusak fasad kurang jam keluar sedikit lalu berhenti',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 11),
      content: '''
Jika seorang wanita mengeluarkan darah hanya beberapa tetes atau selama beberapa jam, kemudian berhenti total dan hingga hari ke-15 akumulasi darah tidak mencapai 24 jam penuh:
- Darah tersebut dihukumi secara hukum fiqh sebagai "Dam Fasad" (darah rusak/penyakit), bukan darah haid.
- Konsekuensinya: Seluruh salat yang sempat ditinggalkan selama waktu tersebut wajib di-qadha karena wanita tersebut sejatinya tidak sedang dalam kondisi haid yang sah menurut batasan syariat.
''',
    ),
    FiqhArticleModel(
      id: 'art-012',
      title: 'Aktivitas Ibadah yang Dilarang dan Diperbolehkan Saat Haid',
      category: 'Ibadah',
      reference: 'Kitab Kasyifatus Saja & Fathul Qarib',
      searchKeywords: 'larangan boleh ibadah zikir doa baca quran salat puasa thawaf haid',
      authorReviewer: 'Kajian Fiqh Syafi\'i Terverifikasi',
      createdAt: DateTime(2026, 1, 12),
      content: '''
Perkara yang dilarang bagi wanita yang sedang haid:
1. Melaksanakan salat fardhu maupun sunnah.
2. Melaksanakan ibadah puasa.
3. Melakukan Thawaf di Ka'bah.
4. Menyentuh dan membawa mushaf Al-Qur'an.
5. Membaca Al-Qur'an dengan niat tilawah (membaca Al-Qur'an secara sengaja).
6. Berdiam diri (i'tikaf) di dalam masjid.

Perkara yang DIPERBOLEHKAN dan bernilai pahala:
1. Berdzikir kepada Allah (tasbih, tahmid, tahlil, istighfar).
2. Membaca doa-doa ma'tsur, shalawat Nabi SAW, dan mendengarkan kajian keilmuan.
3. Membaca ayat Al-Qur'an dengan niat murni dzikir atau perlindungan diri (misal membaca ayat kursi untuk dzikir petang/tidur atau bismillah saat hendak makan).
4. Menuntut ilmu agama dan bersedekah.
''',
    ),
  ];
}
