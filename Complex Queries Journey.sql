--contoh 1 Subquery sebagai Tabel Virtual
---Bagaimana persebaran total customer pada masing-masing provider
---dengan jumlah customernya lebih dari sama dengan 20
select
	*
from (
	select
		case when telepon like '62852%' then 'Telkomsel'
			 when telepon like '62878%' then 'XL'
			 when telepon like '62896%' then '3'
			 else 'Other'
		end as provider,
		count(nama) as total_pelanggan
	from
	rakamin_customer
	group by 1)
	as rc
where total_pelanggan >= 20;

--contoh 2 Subquery sebagai Filter Tabel
---Ambil data customer yang pernah melakukan order di KFC

select
	nama,
	email,
	telepon
from
	rakamin_customer
where
	id_pelanggan in
		(
		select distinct
			id_pelanggan
		from
			rakamin_order
		where
			id_merchant = 5
		);

--contoh 3 Join
---Guys, kita kasih service lebih yuk untuk pelanggan yang menggunakan provider X,
---kita bakal kirimin souvenir ke alamat mereka biar jadi lebih loyal ke kita.
-----Boleh tuh. Berarti kita bakal dapetin user yang punya nomor hp dengan
-----awalan '62852' ya

select
	nama,
	email,
	telepon,
	alamat,
	kota
from
	rakamin_customer as rc
join
	rakamin_customer_address as rca on rc.id_pelanggan = rca.id_pelanggan
where
	telepon like '62852%'
limit
	5;

--contoh 4

select
	nama,
	email,
	telepon,
	alamat,
	kota,
	tanggal_pembelian,
	nama_merchant
from
	rakamin_customer as rc
join
	rakamin_customer_address as rca on rc.id_pelanggan = rca.id_pelanggan
left join
	rakamin_order as ro on ro.id_pelanggan = rc.id_pelanggan
inner join
	rakamin_merchant as rm on rm.id_merchant = ro.id_merchant
where
	telepon like '62852%';

--contoh 5
select
	nama,
	email,
	telepon,
	alamat,
	kota,
	tanggal_pembelian
from
	rakamin_customer as rc
join
	rakamin_customer_address as rca on rc.id_pelanggan = rca.id_pelanggan
right join
	rakamin_order as ro on ro.id_pelanggan = rc.id_pelanggan
where
	telepon like '62852%';

--contoh 6 Subquery dalam Join

select
	*
from (
		(
			select id_pelanggan, sum(harga) as total_harga
			from rakamin_order
			group by 1
			having sum(harga) > 5000
) as ro
left join rakamin_customer as rc on rc.id_pelanggan = ro.id_pelanggan
);

--contoh 7 Union
---Ambil data customer yang memiliki umur lebih dari 20. Ambil juga
---customer yang lahir pada bulan Mei
select
	nama,
	umur,
	bulan_lahir
from
	rakamin_customer
where
	umur > 20
union all
select
	nama,
	umur,
	bulan_lahir
from
	rakamin_customer
where
	bulan_lahir = 'Mei';

--contoh 8 With ... AS
---Ambil data customer yang pernah melakukan transaksi yang total harganya lebih dari 50000

with orders as (
	select
		id_pelanggan,
		sum(harga*kuantitas) as total_belanja
from rakamin_order
group by 1
	having sum(harga*kuantitas) > 50000
)
select
	nama,
	telepon,
	total_belanja
from
	orders as o
join
	rakamin_customer as rc on o.id_pelanggan = rc.id_pelanggan

union
select
	nama,
	telepon,
	total_belanja
from
	orders as o
join
	rakamin_customer as rc on o.id_pelanggan = rc.id_pelanggan
where
	telepon like '62852%';