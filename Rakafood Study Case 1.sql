-- CASE 1 ---------------------------------------------------------------------------------------------------------------------
--- Managerial ingin mengetahui sejauh mana perkembangan /ekspansi RakaFood sejauh ini.
--- Tampilkan semua kota-kota unik di mana pelanggan customer berasal!

SELECT DISTINCT
	kota
FROM
	rakamin_customer_address;

--- Penjelasan:
--- untuk menampilkan nilai kolom yang unik (tidak ada duplikat) dapat menggunakan keyword SELECT DISTINCT
--- diikuti dengan nama kolom yang ingin ditampilkan.


-- CASE 2 ---------------------------------------------------------------------------------------------------------------------
--- Tim Engineering baru saja melakukan update skema tabel order.
--- Tampilkan 10 baris transaksi terbaru (most recent) dari tabel rakamin_order untuk melihat format dari tabel ini!

SELECT
	*
FROM
	rakamin_order
ORDER BY
	tanggal_pembelian DESC
LIMIT 10;

--- Penjelasan:
--- Kolom tanggal_pembelian menunjukkan kapan baris data tersebut terekam dalam database.
--- Oleh karena itu untuk mengurutkan kolom tersebut dari yang terbaru bisa menggunakan ORDER BY … DESC.
--- Kemudian, untuk mendapatkan 10 baris teratas saja, digunakan LIMIT 10.


-- CASE 3 ---------------------------------------------------------------------------------------------------------------------
--- Tim Risk ingin mengetahui bagaimana performa sistem fraud detection
--- yang telah berjalan selama ini, karena itu mereka ingin mengetahui berapa
--- banyak customer kita yang terdeteksi sebagai penipu sejauh ini? Tunjukkan
--- angka customer penipu yang terdapat di RakaFood! 

SELECT COUNT(1)
	AS jumlah_penipu
FROM rakamin_customer
WHERE penipu = 1;

--- Penjelasan:
--- Untuk mendapatkan baris data yang terdiri dari penipu saja, dapat menggunakan filter WHERE penipu = 1.
--- Kemudian, untuk menghitung ada berapa baris dari tabel yang difilter tersebut, bisa menggunakan fungsi
--- agregasi COUNT(1) atau COUNT(*). Dengan begitu, query ini akan menghitung ada berapa banyak baris data
--- yang diberi label penipu = 1. 


-- CASE 4 ---------------------------------------------------------------------------------------------------------------------
--- Buatlah satu kolom baru pada tabel customer yang berisi informasi platform email
--- (Google, Yahoo, Outlook, Others) yang digunakan customer. Kemudian, tampilkan semua kolom yang ada
--- dengan catatan hanya untuk customer yang melakukan registasi pada semester pertama (Januari hingga Juni)
--- tahun 2013 dan berumur minimal 17 tahun! Urutkan berdasarkan kolom baru platform email

SELECT
	* ,
	CASE WHEN email LIKE '%gmail.com' THEN 'Gmail'
		 WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
		 WHEN email LIKE '%outlook.com' THEN 'Outlook'
		 ELSE 'Others'
	END AS email_platform
FROM
	rakamin_customer
WHERE 
	tanggal_registrasi BETWEEN '2013-01-01' AND '2013-06-30'
	AND umur >= 17
ORDER BY 1;

--- Penjelasan:
--- Untuk membuat kolom email_platform dapat digunakan keyword CASE WHEN diikuti dengan keyword LIKE
--- untuk mendapatkan platform email yang digunakan masing-masing customer.
--- Tidak lupa untuk menerapkan filter yang diminta, yaitu pembatasan tanggal_registrasi
--- (bisa menggunakan --- BETWEEN) dan juga umur. Terakhir, untuk mengurutkan bisa dengan menggunakan ORDER BY.


-- CASE 5 ---------------------------------------------------------------------------------------------------------------------
--- Tampilkan perbandingan antara metode bayar OVO dan GOPAY dalam hal: jumlah transaksi,
--- spending (harga) terendah, rata-rata spending (harga), spending (harga) tertinggi,
--- dan total spending (harga) khusus untuk transaksi yang dilakukan di merchant
--- CHICKEN WING (id_merchant = 3), KFC (id_merchant = 5) dan MCD (id_merchant = 6)

SELECT
	metode_bayar,
	COUNT (1) AS jumlah_transaksi,
	MIN(harga) AS spending_terendah,
	AVG(harga) AS rata2_spending,
	MAX(harga) AS spending_tertinggi,
	SUM(harga) AS total_spending
FROM
	rakamin_order
WHERE
	metode_bayar IN ('ovo','gopay')
	AND id_merchant IN (3, 5, 6)
GROUP BY 1;

--- Penjelasan:
--- Karena permintaan analisis hanya difokuskan kepada metode bayar OVO dan GOPAY serta merchant tertentu,
--- maka perlu dilakukan filter agar data yang terambil hanya mencakup metode bayar dan merchant yang diminta.
--- Kemudian, untuk menampilkan beberapa stats bisa dengan mudah menggunakan fungsi-fungsi agregasi sesuai kebutuhan.
--- Tidak lupa untuk melakukan GROUP BY metode_bayar pada akhirnya. 


-- CASE 6 ---------------------------------------------------------------------------------------------------------------------
--- Buatlah tabel yang menunjukkan jumlah customer unik yang dikelompokkan berdasarkan
--- metode bayar (selain cash) dan juga spending group, di mana spending group yang
--- dimaksud adalah sebagai berikut:
----- ● Total transaksi (termasuk PPN) di bawah 30.000 : low spending,
----- ● 30.000 - 50.000 disebut medium spending
----- ● Di atas 50.000 disebut high spending. 

-- cara 1
SELECT
	metode_bayar,
	CASE WHEN harga + (harga*"PPN") < 30000 THEN 'low_spending'
		 WHEN harga + (harga*"PPN") BETWEEN 30000 AND 50000 THEN 'medium_spending'
	WHEN harga + (harga*"PPN") > 50000 THEN 'high_spending'
	END AS spending_group,
	COUNT(DISTINCT id_pelanggan) AS jumlah_customer_unik
FROM
	rakamin_order
WHERE
	bayar_cash = 0
GROUP BY
	metode_bayar, spending_group;

-- cara 2
SELECT
	metode_bayar,
	CASE WHEN harga + (harga * "PPN") < 30000 THEN 'low_spending'
		 WHEN harga + (harga * "PPN") BETWEEN 30000 AND 50000 THEN 'medium_spending'
		 ELSE 'high_spending'
	END AS spending_group,
	COUNT(DISTINCT id_pelanggan) AS jumlah_customer_unik
FROM
	rakamin_order
WHERE
	metode_bayar != 'cash'
GROUP BY
	1, 2
ORDER BY
	1;

--- Penjelasan:
--- Untuk membuat kolom baru yaitu spending_group, bisa digunakan CASE WHEN yang diikuti oleh
--- kondisi masing-masing group terhadap total transaksi. Perhatikan perhitungan total transaksi dalam
--- keyword CASE WHEN adalah harga + (harga * "PPN') supaya mendapatkan harga setelah ppn sesuai permintaan.
--- Untuk menghitung jumlah customer unik dari masing-masing group, maka digunakan COUNT(DISTINCT id_pelanggan)
--- supaya memastikan tidak ada customer sama yang dihitung lebih dari satu kali. 
--- Dilakukan filter metode bayar dan ditutup dengan GROUP BY sesuai banyak kolom yang di SELECT.