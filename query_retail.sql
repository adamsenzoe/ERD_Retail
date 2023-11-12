-- Active: 1699372637116@@127.0.0.1@3306@erd_retail

-- conection : localhost

-- membuat DATABASE
CREATE DATABASE erd_retail;

-- menggunakan DATABASE
USE erd_retail;

-- membuat TABLE
CREATE TABLE `pelanggan` (
    `id_pelanggan` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `alamat` VARCHAR(255) NOT NULL,
    `nama` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `no_telepon` VARCHAR(255) NOT NULL
);
/* 2023-11-11 10:47:45 [42 ms] */ 
CREATE TABLE `pesanan` (
    `id_pesanan` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_pelanggan` INT UNSIGNED NOT NULL,
    `status_pesanan` VARCHAR(255) NOT NULL,
    `tanggal_pemesanan` DATE NOT NULL,
    FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`)
);
/* 2023-11-11 10:48:11 [36 ms] */ 
CREATE TABLE `produk` (
    `id_produk` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nama_produk` VARCHAR(255) NOT NULL,
    `harga` DECIMAL(8, 2) NOT NULL,
    `stock` INT NOT NULL
);
/* 2023-11-11 10:48:15 [63 ms] */ 
CREATE TABLE `detail_pesanan` (
    `id_detail_pesanan` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_pesanan` INT UNSIGNED NOT NULL,
    `id_produk` INT UNSIGNED NOT NULL,
    `jumlah` INT NOT NULL,
    `subtotal` DECIMAL(8, 2) NOT NULL,
    FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
    FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`)
);
/* 2023-11-11 10:48:22 [47 ms] */ 
CREATE TABLE `kategori_produk` (
    `id_kategori` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nama_kategori` VARCHAR(255) NOT NULL
);
/* 2023-11-11 10:48:27 [71 ms] */ 
CREATE TABLE `produk_kategori` (
    `id_produk_kategori` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_produk` INT UNSIGNED NOT NULL,
    `id_kategori` INT UNSIGNED NOT NULL,
    FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`),
    FOREIGN KEY (`id_kategori`) REFERENCES `kategori_produk` (`id_kategori`)
);
/* 2023-11-11 10:48:30 [61 ms] */ 
CREATE TABLE `pembayaran` (
    `id_pembayaran` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_pesanan` INT UNSIGNED NOT NULL,
    `metode_pembayaran` VARCHAR(255) NOT NULL,
    `total_pembayaran` DECIMAL(8, 2) NOT NULL,
    `tanggal_pembayaran` DATE NOT NULL,
    FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`)
);
/* 2023-11-11 10:48:34 [49 ms] */ 
CREATE TABLE `pengiriman` (
    `id_pengiriman` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_pesanan` INT UNSIGNED NOT NULL,
    `alamat_pengiriman` VARCHAR(255) NOT NULL,
    `metode_pengiriman` VARCHAR(255) NOT NULL,
    `status_pengiriman` VARCHAR(255) NOT NULL,
    FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`)
);
-- ----------------------------------------------------------------

-- membuat / mengisi data pada tabel
INSERT INTO pelanggan (nama, alamat, email, no_telepon) VALUES
('bedul', 'jl.gading','rohim@gmail.com', '1234567890');

INSERT INTO pesanan (id_pelanggan, status_pesanan, tanggal_pemesanan) VALUES
(17, 'Dalam Proses', '2023-11-11');

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, subtotal) VALUES
(38, 1, 23, 303000);  -- Mengacu pada id_pesanan=1 (contoh) dan id_produk=1, jumlah 3, subtotal 300


-- mengambil / melihat semua data pada TABLE
SELECT * FROM pelanggan;
SELECT * FROM pesanan;
SELECT * FROM detail_pesanan;
SELECT * FROM produk;
SELECT * FROM pembayaran;
SELECT * FROM pengiriman;

-- mengambil 1 data pada tabel
SELECT * FROM pelanggan WHERE id_pelanggan=1;

-- mengubah data dari TABLE
UPDATE pelanggan SET nama = 'Madara'
                WHERE id_pelanggan = 15;

-- menghapus data tabel
DELETE FROM pelanggan WHERE id_pelanggan = 15;

-- menghapus database (jangan asal eksekusi)
DROP DATABASE nama_database;


-- ubah tipe DATA 
ALTER TABLE pembayaran
MODIFY COLUMN total_pembayaran INT;

-- ubah data TABLE 
UPDATE pembayaran
SET total_pembayaran = 500000
WHERE id_pembayaran = 1;



-- -------------------------------------------------
SELECT * FROM pelanggan;
-- pelanggan (done)
SELECT * FROM pesanan;
-- pesanan (done)
SELECT * FROM detail_pesanan
-- detail pesanan (done)

SELECT * FROM produk;
-- produk (done)

SELECT * FROM kategori_produk;
-- kategori produk (done)

SELECT * FROM produk_kategori;
-- prduk kategori c (done)

SELECT * FROM pembayaran;
-- pembayaran (done)

SELECT * FROM pengiriman;
-- pengiriman (done)

-- ----------------------------------------------------------------------



INSERT INTO produk_kategori (id_produk, id_kategori) VALUES
(1, 1),  -- Mengacu pada produk dengan id_produk=1 dan kategori_produk dengan id_kategori=1
(2, 2),
(3, 1);

INSERT INTO pembayaran (id_pesanan, metode_pembayaran, total_pembayaran, tanggal_pembayaran) VALUES
(41, 'Kartu Kredit', 150.00, '2023-11-10'),  -- Mengacu pada pesanan dengan id_pesanan=41
(42, 'Transfer Bank', 200.50, '2023-11-12'),
(43, 'Cash/Tunai', 50.00, '2023-11-12');

INSERT INTO pengiriman (id_pesanan, alamat_pengiriman, metode_pengiriman, status_pengiriman) VALUES
(38, 'Jl. Pengiriman 123', 'Paket Kilat', 'Dikirim'),
(39, 'Jl. Pengiriman 456', 'Paket Reguler', 'Diproses'),
(40, 'Jl. Pengiriman 789', 'Paket Express', 'Menunggu Pengemasan'),
(41, 'Jl. Pengiriman 123', 'Paket Kilat', 'Dikirim'),
(42, 'Jl. Pengiriman 456', 'Paket Reguler', 'Diproses'),
(43, 'Jl. Pengiriman 789', 'Paket Express', 'Menunggu Pengemasan');


-- ----------------------------------------------------
-- 1 pelanggan membeli 3 barang yang berbeda.

SELECT
    p.id_pelanggan,
    p.nama AS nama_pelanggan,
    COUNT(DISTINCT dp.id_produk) AS jumlah_produk_dibeli
FROM
    pelanggan p
JOIN
    pesanan ps ON p.id_pelanggan = ps.id_pelanggan
JOIN
    detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY
    p.id_pelanggan, p.nama
HAVING
    COUNT(DISTINCT dp.id_produk) = 3;



-- Melihat 3 produk yang paling sering dibeli oleh pelanggan.
SELECT
    p.id_produk,
    p.nama_produk,
    COUNT(dp.id_produk) AS jumlah_pembelian
FROM
    produk p
JOIN
    detail_pesanan dp ON p.id_produk = dp.id_produk
GROUP BY
    p.id_produk, p.nama_produk
ORDER BY
    jumlah_pembelian DESC
LIMIT 3;

-- Melihat Kategori barang yang paling banyak barangnya.
SELECT
    kp.id_kategori,
    kp.nama_kategori,
    COUNT(pk.id_produk) AS jumlah_barang
FROM
    kategori_produk kp
JOIN
    produk_kategori pk ON kp.id_kategori = pk.id_kategori
JOIN
    produk p ON pk.id_produk = p.id_produk
GROUP BY
    kp.id_kategori, kp.nama_kategori
ORDER BY
    jumlah_barang DESC
LIMIT 1;

-- Nominal rata-rata transaksi yang dilakukan oleh pelanggan dalam 1 bulan terakhir.
SELECT
    AVG(total_pembayaran) AS rata_rata_transaksi
FROM
    pembayaran
WHERE
    tanggal_pembayaran >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
