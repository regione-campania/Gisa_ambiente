create table particelle(

	id serial primary key,
	codice_sito text,
	provincia int,
	comune int,
	foglio_catastale text,
	particella_catastale text,
	classe_rischio text,
	coordinate_x text,
	coordinate_y text,
	area text,
	note text,
	entered timestamp,
	entered_by int,
	modified timestamp,
	modified_by int,
	enabled boolean default true
);