--contoh 1 Operator SQL - Tidak Sama Dengan ( != )-----------------------------------------------------------------------------

---Bro, kita kasih notifikasi lewat email yuk buat
---customers kita yang sudah tidak aktif lagi dan
---kita kasih hadiah aja kalau mereka bisa
---konfirmasi nomor telepon.
-----Oh, berarti kita butuh list email dari
-----customers yang tidak aktif dan belum
-----konfirmasi nomor telepon mereka ya?

--Ambil seluruh kolom rakamin customers yang
--sudah tidak aktif ( != 1 )

select
	*
from
	rakamin_customer
where
	pengguna_aktif !=  1;

--contoh 2 Operator SQL - Tidak Sama Dengan ( <> )-----------------------------------------------------------------------------

---Ambil semua nama dan email dari RakaFood customers
---yang nomor hp nya belum dikonfirmasi

select
	nama,
	email,
	konfirmasi_telepon
from
	rakamin_customer
where
	konfirmasi_telepon <> 1;

--contoh 3 Operator SQL - Lebih Dari (>)---------------------------------------------------------------------------------------

---Bro, kita harus kasih tau customers yang
---umurnya di atas 30 nih karena ada promo
---botol minuman jika beli makanan X, lumayan
---kan buat anak-anak mereka.
-----Oh, berarti kita butuh list nama, email
-----dan nomor hp mereka ya buat ngirimin
-----promo gitu misalnya?

---Ambil semua nama, phone dan umur dari RakaFood
---customers yang umurnya lebih dari 30

select
	nama,
	telepon,
	umur
from
	rakamin_customer
where
	umur > 30;

--contoh 4 Logical Operator - AND----------------------------------------------------------------------------------------------

---Bro, ada kah customer kita
---yang penipu dan pengguna
---aktif ini?

-----Ambil nama, email dan nomer telepon RakaFood customer
-----yang penipu dan pengguna aktif.

select
	nama,
	penipu,
	pengguna_aktif
from
	rakamin_customer
where
	penipu = 1 and pengguna_aktif = 1;

--contoh 5 Logical Operator - OR-----------------------------------------------------------------------------------------------

---Bro, adakah customer kita yang
---lahirnya di bulan juni atau juli
---ini ? Mungkin bisa kita kasih
---surprise ulang tahun jika mereka
---order pas tanggal ulang tahunnya

-----Ambil data customer RakaFood yang lahir di bulan Juni atau Juli.

select
	 nama,
	 bulan_lahir
from
	rakamin_customer
where
	bulan_lahir = 'Juni' or bulan_lahir = 'Juli';

--contoh 6 Logical Operator - NOT----------------------------------------------------------------------------------------------

---Bro, ambilin data customer yang
---bulan_lahir nya nggak kosong dong.

-----Ambil nama, email, nomor telepon dan umur RakaFood
-----customer yang bukan lahir di bulan Desember.

select
	nama,
	email,
	telepon,
	bulan_lahir
from
	rakamin_customer
where not
	bulan_lahir = 'Desember';

--contoh 7 Advanced Filtering 3 - IN-------------------------------------------------------------------------------------------

---Bro, adakah customer kita yang lahirnya
---di bulan juni, juli atau agustus ini?
---Mungkin bisa kita kasih surprise ulang
---tahun jika mereka order pas tanggal
---ulang tahunnya

-----Ambil semua kolom pada RakaFood customers
-----yang lahir di bulan juni, juli atau agustus

select
	*
from
	rakamin_customer
where
	bulan_lahir in ('Juni', 'Juli', 'Agustus');

--contoh 8 Advanced Filtering 4 - LIKE-----------------------------------------------------------------------------------------

---Bro, ada masalah hacker nih di google
---mail, bisa pastikan ga customer kita yang
---pakai gmail.com masih aman?
-----Oh oke, coba saya cari dulu email
-----customers yang mengandung kata
-----gmail.com di kolom email mereka.

---Ambil semua email yang memiliki domain @gmail.com

select
	nama,
	email
from
	rakamin_customer
where
	email like '%gmail.com';

--contoh 9 LIKE - Aturan %-----------------------------------------------------------------------------------------------------

---Bro, provider x mau ngasih promo ke
---customers kita nih, bakal ngasih diskon 40%
---kalau beli dengan point.
-----Hmm menarik-menarik, berarti
-----customer yang nomor hp nya diawali
-----62852 itu potensial customer untuk
-----promo ini ya?

---Ambil nama dan nomor hp dengan awalan
---62852 (untuk provider x)

select
	nama,
	telepon
from
	rakamin_customer
where
	telepon like '62852%';

--contoh 10 Advanced Filtering 5 - BETWEEN-------------------------------------------------------------------------------------

---Bro, ada ga customers kita yang umurnya
---mulai 20 tahun hingga 25 tahun?
---harusnya sih ada bro

---Ambil semua kolom customers yang umurnya 20
---hingga 25 tahun

select
	nama,
	umur
from
	rakamin_customer
where
	umur between 20 and 25;

--challenge 1------------------------------------------------------------------------------------------------------------------

---Bro, provider Telkomsel mau ngasih promo ke
---customers kita nih, bakal ngasih diskon 40%
---kalau beli dengan telkomsel point.
---Tapi syarat lainnya harus yang bulan lahirnya di
---Mei aja, karena bulan Mei adalah hari ulang
---tahunnya Telkomsel.

---Ambil nama dan nomor hp dengan awalan
---62852 dan bulan lahir = Mei

select
	nama,
	bulan_lahir,
	telepon
from
	rakamin_customer
where
	telepon like '62852%'
	and bulan_lahir = 'Mei';

--challenge 2------------------------------------------------------------------------------------------------------------------

---Bro bro, ada tambahan syarat lagi
---ternyata yang dapat promo Telkomsel harus
---yang berumur 22 Tahun, karena ulang tahun
---Telkomsel yang 22 besok.

---Ambil nama dan nomor hp dengan awalan
---62852, bulan lahir = Mei dan umur = 22

select
	nama,
	bulan_lahir,
	telepon,
	umur
from
	rakamin_customer
where
	telepon like '62852%'
	and bulan_lahir = 'Mei'
	and umur = '22';

--challenge 3------------------------------------------------------------------------------------------------------------------

---Ada kabar baik nih, ternyata Telkomsel lagi
---colab dengan provider 3 nih
---mereka mau kasih promo juga, tapi diundi gitu
---buat 5 customer aja.
---Bisa dapetin semua email yang nomor hpnya
---telkomsel atau 3 ga bro? ambil acak aja, dan
---cukup 5 customer

---Ambil email dari customers yang nomor hp nya
---telkomsel atau 3, dan ambil 5 email aja

select
	nama,
	email,
	telepon
from
	rakamin_customer
where
	telepon like '62852%'
	or telepon like '62896%'
limit 5;

--contoh 11 Select Condition - CASE WHEN---------------------------------------------------------------------------------------

---Bro, gw udah punya nih customers yang pakai
---Telkomsel , cuma umur nya masih bervariasi.
---Bisa dibuat 3 grup umur aja ga sih?
---Misalnya nih
-----● umur 1 - 20 : anak
-----● umur 21 - 70 : bapak
-----● umur 71 ke atas : kakek 

---kolom baru (grup umur) menjadi 3 bagian

select
	nama,
	email,
	telepon,
	umur,
	case when umur between 1 and 20 then 'anak'
		 when umur between 21 and 70 then 'bapak'
		 when umur between 71 and 100 then 'kakek'
	end as grup_umur
from
	rakamin_customer
where
	telepon like '62852%';

--contoh 12 Select Condition - CASE WHEN---------------------------------------------------------------------------------------

---Bro, ini ada data nomor telepon, bisa ga kita
---definisikan itu dari provider apa?
---sesederhana ini aja definisinya
---Hmm mungkin jadi gini ya bro?
-----● diawali 62852 : telkomsel
-----● diawali 62878 : XL
-----● diawali 62896 : 3
-----● sisanya anggap aja “lainnya”

---kolom baru (provider) sesuai awalan nomor telepon

select
	nama,
	telepon,
	case when telepon like '62852%' then 'Telkomsel'
		 when telepon like '62878%' then 'XL'
		 when telepon like '62896%' then '3'
		 else 'lainnya'
	end as provider
from
	rakamin_customer;

--contoh 13 Aggregation 1 - COUNT(1)-------------------------------------------------------------------------------------------

---Bro, coba tebak…
---ada berapa customers kita
---sekarang ?

---Ada berapa total customer RakaFood?

select
	count(1)
from
	rakamin_customer;

--contoh 14 Aggregation 2 - COUNT(kolom)---------------------------------------------------------------------------------------

---ada berapa total data tidak kosong pada kolom
---bulan_lahir dari customers kita?

select
	count (bulan_lahir)
from
	rakamin_customer;

--contoh 15 Alias kolom (as)---------------------------------------------------------------------------------------------------

---ada berapa total customer dan total baris tidak kosong
---pada kolom bulan_lahir dari customers kita?
---(rapikan nama kolom pada hasilnya)

select
	count(1) as total_customer,
	count(bulan_lahir) as total_bulan_nonull
from
	rakamin_customer;

--contoh 16 Aggregation 3 - COUNT(DISTINCT kolom)------------------------------------------------------------------------------

---ada berapa total unik data tidak kosong pada kolom
---bulan_lahir dari customers kita?

select
	count (distinct bulan_lahir) as bulan_unik
from
	rakamin_customer;

--contoh 17

select
	count (bulan_lahir) as total_bulan_nonull,
	count (distinct bulan_lahir) as bulan_unik
from
	rakamin_customer;

--contoh 18  Aggregation 4 - MIN(kolom)----------------------------------------------------------------------------------------

---Bro, customer kita yang paling muda, berapa
---umurnya?.. kantor kita ingin terapkan batas
---minimal umur nih buat dapatkan promo spesial.
---nanti umur terkecil itu kita jadikan batasnya.

select
	min(umur) as umur_termuda
from
	rakamin_customer;

--contoh 19 Aggregation 5 - MAX(kolom)-----------------------------------------------------------------------------------------

---Bro, customer kita paling tua umurnya berapa?

select
	max(umur) as umur_tertua
from
	rakamin_customer;

--contoh 20 Aggregation 6 - AVG(kolom)-----------------------------------------------------------------------------------------

---Bro, coba tebak…
---berapa umur rata-rata customer kita ?

select
	avg(umur) as rata2_umur
from
	rakamin_customer;

--contoh 21 Aggregation 7 - GROUP BY-------------------------------------------------------------------------------------------

---Bro, sekarang bulan juli nih..
---ada berapa customers yang ulang tahun di
---bulan juli ya?

---ada berapa total customers yang lahir di bulan juli?

select
	bulan_lahir,
	count(1) as total_customer
from
	rakamin_customer
group by
	bulan_lahir;


---berapa total customers yang aktif dan tidak aktif ?

select
	pengguna_aktif,
	count(1) as total_customer
from
	rakamin_customer
group by
	pengguna_aktif;

-----modifikasi

select
	pengguna_aktif,
	count(1) as total_customer
from
	rakamin_customer
group by
	1;