University Library System - Perpustakaan Ngawi 



Tugas Lab Activity Week 6 - Implementasi Arsitektur MVVM (Model-View-ViewModel) pada aplikasi sistem perpustakaan menggunakan Flutter.



- Tujuan Proyek

Memisahkan data (Model), aturan bisnis dan kalkulasi denda (ViewModel), serta antarmuka pengguna (View) agar tidak ada logika bisnis yang ditulis di dalam UI widget.



- Struktur Arsitektur (MVVM)

\-Models (`/Models`)\*\*: Berisi struktur data murni untuk `Book` dan `Loan` tanpa import UI.

\-ViewModels (`/viewmodels`)\*\*: `LibraryViewModel` (menggunakan `ChangeNotifier`) sebagai pusat logika (Single Source of Truth) untuk mengatur transaksi pinjam, kembali, dan menghitung denda.

\-Views (`/views`)\*\*: Widget UI (`library\_screen`, `book\_card`, `loan\_card`) yang hanya bertugas menampilkan data dan mengirimkan \*action\* ke ViewModel.



- Fitur \& Aturan Bisnis yang Diimplementasikan

1\.Peminjaman \& Ketersediaan: Buku hanya bisa dipinjam jika statusnya `Available`.

2\.Kalkulasi Denda Mingguan: Denda Rp 5.000 hanya dikenakan untuk setiap \*\*1 minggu penuh\*\* (completed week) keterlambatan dari tanggal jatuh tempo (Due Date). Terlambat 0-6 hari = Rp 0.

3\.Status Missing (Hilang): Jika buku terlambat dikembalikan lebih dari 6 bulan, status otomatis berubah menjadi `Missing` dan denda diganti dengan harga penggantian buku (\*Replacement Price\*).

4\.State Management: Menggunakan `ListenableBuilder` dan `ChangeNotifier` agar UI otomatis ter-update tanpa perlu me-refresh layar secara manual.




- Katalog Buku Khusus (Perpustakaan Ngawi)

Aplikasi ini memuat koleksi buku khusus:

\-Pertempuran Sengit Ngawi oleh Amba

\-Hutan Angker Ngawi oleh Imout Anwar

\-Tutorial Unjuk Bakat Ala Mas Rian oleh Mas Rian

\-Mitos Roh Ngawi Dan Pemanpakan Sosok Hytam Asli Ngawi oleh Ambajrun \& Steven Suki



- Cara Menjalankan

1\. Pastikan Flutter SDK sudah ter-install.

2\. Jalankan perintah `flutter pub get` di terminal.

3\. Jalankan aplikasi dengan `flutter run`.



Catatan: Aplikasi ini menggunakan in-memory storage untuk penyederhanaan sesuai instruksi lab, sehingga data akan tereset saat aplikasi ditutup).\*

