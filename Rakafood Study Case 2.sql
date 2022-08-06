-- case 1 ---------------------------------------------------------------------------------------------------------------------
--- Salah satu merchant kita, yaitu KFC Depok, ingin membuka cabang baru.
--- Karena itu mereka meminta insight dari kita untuk melihat daerah mana yang paling berpotensi
--- di luar kota Depok. Kami membutuhkan data kota (selain Depok) dan alamat (kolom address)
--- tempat customer berada (filter untuk alamat utama saja) beserta total order
--- dari masing-masing alamat tersebut. Urutkan juga dari total order paling banyak.

--query
SELECT
	rca.kota,
	rca.alamat,
	SUM(harga) AS total_penjualan
FROM
	rakamin_customer_address rca
JOIN
	rakamin_order ro ON rca.id_pelanggan = ro.id_pelanggan
WHERE
 rca.kota != 'Depok'
GROUP BY
	1, 2
ORDER BY
	3 DESC;

-- case 2 ---------------------------------------------------------------------------------------------------------------------
--- Dari customer yang pernah melakukan order, kami ingin memberikan cashback untuk customer
--- yang sudah menggunakan email ‘@yahoo.com'. Karena itu, kami butuh informasi customer ID,
--- nomor telepon, metode bayar, dan TPV (Total Payment Value). Pastikan bahwa mereka bukan penipu. 

--query
SELECT
	rc.id_pelanggan,
	rc.telepon,
	rc.email,
	ro.metode_bayar,
	SUM(ro.kuantitas * ro.harga) AS Total_Payment_Value
FROM rakamin_customer AS rc
LEFT JOIN rakamin_order AS ro ON rc.id_pelanggan = ro.id_pelanggan
WHERE
	rc.email LIKE '%yahoo.com' AND rc.penipu = 0
GROUP BY
	1,2,3,4
ORDER BY
	5 DESC;


-- case 3 ---------------------------------------------------------------------------------------------------------------------
--- Tim UX researcher ingin mengetahui alasan dari user yang belum menggunakan digital payment method
--- dalam pembayaran transaksinya secara kualitatif dan melakukan interview kepada user secara langsung.
--- Mereka membutuhkan data customer berupa nama, email, nomor telepon, alamat user, metode_bayar,
--- dan jumlah ordernya (dari table rakamin_orders), yang dibayarkan secara cash.
--- Pastikan user sudah mengkonfirmasi nomor telepon, bukan penipu, dan masih aktif.

--query
----- cara 1
SELECT
	rc.nama,
	rc.email,
	rc.telepon,
	rca.alamat,
	ro.metode_bayar,
	COUNT(id_order) AS total_order
FROM rakamin_customer AS rc
JOIN rakamin_order AS ro ON rc.id_pelanggan = ro.id_pelanggan
JOIN rakamin_customer_address AS rca ON rc.id_pelanggan = rca.id_pelanggan
WHERE
	metode_bayar = 'cash'
	AND penipu = 0
	AND konfirmasi_telepon = 1
	AND pengguna_aktif = 1
GROUP BY 1,2,3,4,5
ORDER BY 1 ASC;

-----cara 2
WITH user_never_non_cash AS (
SELECT
	id_pelanggan,
	COUNT(DISTINCT CASE WHEN bayar_cash = 1 THEN id_order END) AS
	total_order_cash,
	COUNT(DISTINCT CASE WHEN bayar_cash = 0 THEN id_order END) AS
	total_order_non_cash,
	COUNT(DISTINCT id_order) AS total_order
FROM
	rakamin_order
GROUP BY
	1
HAVING
	COUNT(DISTINCT CASE WHEN bayar_cash = 0 THEN id_order END) = 0
)
SELECT
	unnc.id_pelanggan, rc.nama, rc.email, rc.telepon, unnc.total_order
FROM
	user_never_non_cash AS unnc
LEFT JOIN rakamin_customer rc ON rc.id_pelanggan = unnc.id_pelanggan
LEFT JOIN rakamin_customer_address rca ON rca.id_pelanggan = unnc.id_pelanggan
WHERE
	rc.pengguna_aktif = 1 AND rc.penipu = 0 AND rc.konfirmasi_telepon = 1;


-- case 4 ---------------------------------------------------------------------------------------------------------------------
--- Salah satu tantangan bisnis yang sedang dihadapi oleh RakaFood adalah untuk meningkatkan transaksi
--- menggunakan digital payment (cahsless). Kira-kira dari data yang kita miliki,
--- data apa yang dapat membantu business problem tersebut? Sediakan suatu query untuk bisa membantu
--- tim-tim terkait dari RakaFood untuk bisa menjawab tantangan bisnis tersebut,
--- kemudian jelaskan mengapa menurut Anda data hasil dari query Anda itu bisa membantu menyelesaikan
--- business problem tersebut, yaitu untuk meningkatkan digital payment di transaksi RakaFood!

--query
----- cara 1
SELECT
	rc.nama,
	rca.kota,
	rca. alamat,
	rc.email,
	rc.telepon,
	ro.metode_bayar,
	COUNT(id_order) AS total_order
FROM rakamin_customer AS rc
JOIN rakamin_order AS ro ON rc.id_pelanggan = ro.id_pelanggan
JOIN rakamin_customer_address AS rca ON rc.id_pelanggan = rca.id_pelanggan
WHERE
	metode_bayar = 'cash'
	AND penipu = 0
	AND konfirmasi_telepon = 1
GROUP BY 1,2,3,4,5,6
ORDER BY
	2 ASC;

--- Finding
--dari query ini bisa diketahui di kota mana saja user yang menggunakan cash tinggal, 3 kota dengan user cash terbanyak diantaranya Jakarta Utara, Depok, dan Jakarta Timur.
--tim marketing disarankan lebih foks melakukan pemasaran di 3 kota ini atau alamat" di 3 kota ini.
--atau juga bisa dengan memberikan promo berupa diskon khusus pengguna cashless agar user cash mau beralih menggunakan cashless.
--nama, alamat, nomor telepon, email dapat digunakan dalam memaksimalkan proses pemberian promosi sehingga lebih efektif,
--contohnya bisa melaui telepon, sms, email, maupun baliho atau poster.

----- cara 2
SELECT
	a.nama,
	a.email,
	a.telepon,
	a.metode_bayar,
	a.jumlah_order,
	rca.alamat
FROM
(
	SELECT
		rc.id_pelanggan,
		rc.nama,
		rc.email,
		rc.telepon,
		ro.metode_bayar,
		COUNT(ro.id_pelanggan) AS jumlah_order
	FROM
		rakamin_customer rc
		LEFT JOIN rakamin_order ro ON rc.id_pelanggan = ro.id_pelanggan
	WHERE
		rc.penipu = 0
		AND rc.pengguna_aktif = 1
		AND rc.konfirmasi_telepon = 1
		AND ro.bayar_cash = 1
	GROUP BY
		1,2,3,4,5
) a
LEFT JOIN rakamin_customer_address rca ON a.id_pelanggan = rca.id_pelanggan;

--- Finding
-- salah satu cara mengatasi tantangan ini adalah dengan memahami apa alasan customer
-- tetap menggunakan metode pembayaran secara cash dan tidak tertarik menggunakan digital payment
-- kita dapat merekomendasikan alternatif solusi denga melakukan survey pada customer yang
-- masih menggunakan metode cash. Kita bisa menyediakan informasi-informasi personal dari
-- customer yang masih menggunakan cash: seperti email, nomor telepon dan alamat untuk mempermudah
-- tim yang akan melakukan survey menjangkau customer tersebut.
-- Informasi tambahan seperti berapa banyak order yang dibayarkan dengan cash juga dapat membantu.


-- case 5 ---------------------------------------------------------------------------------------------------------------------
--- Tim customer experience (CX) ingin mengoptimalkan penggunaan dompet digital dan membuat program membership
--- untuk meningkatkan loyalitas pelanggan. Membership ini berbasis poin, setiap poin diperoleh dari total belanja
--- minimal 1000 menggunakan dompet digital. Adapun kategori membership berbasis poin, adalah sebagai berikut:
---- a. Total poin kurang dari 10 adalah non member
---- b. Total poin 10 - 100 adalah bronze member
---- c. Total poin 100 - 300 adalah silver member
---- d. Total poin lebih dari 300 adalah gold member
--- Tim CX membutuhkan data jumlah pelanggan di setiap kota berdasarkan kategori membershipnya.

--query
----- cara 1
WITH poin AS(
SELECT
	id_pelanggan,
	metode_bayar,
	SUM(CASE WHEN bayar_cash = 0 THEN kuantitas*harga END ) AS total_transaksi_non_cash, 
	SUM(CASE WHEN bayar_cash = 0 THEN kuantitas*harga END)/1000 AS poin
FROM
	rakamin_order
GROUP BY 1, 2)

SELECT
	kota,
	COUNT(CASE WHEN kategori_membership = 'bronze' THEN kategori_membership END) AS bronze,
	COUNT(CASE WHEN kategori_membership = 'silver' THEN kategori_membership END) AS silver,
	COUNT(CASE WHEN kategori_membership = 'gold' THEN kategori_membership END) AS gold,
	COUNT(CASE WHEN kategori_membership = 'non_member' THEN kategori_membership END) AS non_member
	FROM (SELECT
		  kota,
	CASE WHEN poin BETWEEN 10 AND 100 THEN 'bronze'
		 WHEN poin BETWEEN 100 AND 300 THEN 'silver'
		 WHEN poin > 300 THEN 'gold'
		 ELSE 'non_member'
	END AS kategori_membership
FROM poin AS p
LEFT JOIN rakamin_customer_address AS rca
		  ON p.id_pelanggan = rca.id_pelanggan) p
GROUP BY 1;

----- cara 2
WITH customer_membership AS (
	SELECT
		kota,
		CASE
			WHEN poin_belanja BETWEEN 10 AND 100 THEN 'Bronze'
			WHEN poin_belanja BETWEEN 100 AND 300 THEN 'Silver'
			WHEN poin_belanja > 300 THEN 'Gold'
			ELSE 'Non Member'
		END AS membership
	FROM
		rakamin_customer_address AS rca
	RIGHT JOIN (
		SELECT
			id_pelanggan,
			SUM(CASE WHEN bayar_cash = 0 THEN kuantitas * harga END) AS total_belanja_non_cash,
			SUM(CASE WHEN bayar_cash = 0 THEN kuantitas * harga END) / 1000 AS poin_belanja
		FROM rakamin_order
		GROUP BY 1
	) AS ro ON rca.id_pelanggan=ro.id_pelanggan
)
SELECT
	kota,
	COUNT(CASE WHEN membership = 'Non Member' THEN membership END) AS non_member,
	COUNT(CASE WHEN membership = 'Bronze' THEN membership END) AS bronze_member,
	COUNT(CASE WHEN membership = 'Silver' THEN membership END) AS silver_member,
	COUNT(CASE WHEN membership = 'Gold' THEN membership END) AS gold_member
FROM
	customer_membership
GROUP BY
	1;