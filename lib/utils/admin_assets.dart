import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';

List<TahunAjaran> thn_ajaran_list = [
  TahunAjaran(id_thn_ajaran: 1, thnAjaran: "2022/2023", semester: "Genap", active: true),
  TahunAjaran(id_thn_ajaran: 2, thnAjaran: "2022/2023", semester: "Ganjil", active: false),
  TahunAjaran(id_thn_ajaran: 3, thnAjaran: "2021/2022", semester: "Genap", active: false),
  TahunAjaran(id_thn_ajaran: 4, thnAjaran: "2021/2022", semester: "Ganjil", active: false),
  TahunAjaran(id_thn_ajaran: 5, thnAjaran: "2020/2021", semester: "Genap", active: false),
];

List<RombelSekolah> rombel_list = [
  RombelSekolah(id_rombel: "1", id_sekolah: "2", tingkat: 7, rombel: "7A"),
  RombelSekolah(id_rombel: "2", id_sekolah: "2", tingkat: 7, rombel: "7B"),
  RombelSekolah(id_rombel: "3", id_sekolah: "2", tingkat: 7, rombel: "7C"),
  RombelSekolah(id_rombel: "4", id_sekolah: "2", tingkat: 8, rombel: "8A"),
  RombelSekolah(id_rombel: "5", id_sekolah: "2", tingkat: 9, rombel: "9A"),
];