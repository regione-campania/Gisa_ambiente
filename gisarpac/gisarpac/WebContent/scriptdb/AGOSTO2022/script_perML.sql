
CREATE OR REPLACE FUNCTION public.refresh_ml_materializzata(_id_linea integer DEFAULT NULL::integer)
  RETURNS integer AS
$BODY$
DECLARE
BEGIN

delete from ml8_linee_attivita_nuove_materializzata where 1=1 
-- solo le nuove linee 
and id_nuova_linea_attivita in (select id_nuova_linea_attivita from master_list_view)
and (_id_linea is null or id_nuova_linea_attivita = null);

insert into ml8_linee_attivita_nuove_materializzata (
 id_nuova_linea_attivita, enabled, id_macroarea, id_aggregazione, id_attivita, codice_macroarea, codice_aggregazione, codice_attivita, macroarea, aggregazione,
 attivita, id_norma, norma, descrizione, livello, id_padre, path_id, path_descrizione, codice, path_codice,rev, codice_norma
) select id_nuova_linea_attivita, enabled, id_macroarea, id_aggregazione, id_attivita, codice_macroarea, codice_aggregazione, codice_attivita, macroarea, aggregazione,
 attivita, id_norma, norma, descrizione, livello, id_padre, path_id, path_desc, codice, path_codice, 10 as rev, codice_norma from master_list_view 
 where 1=1
 and (_id_linea is null or id_nuova_linea_attivita = _id_linea);

return 1;

 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.refresh_ml_materializzata(integer)
  OWNER TO postgres;

update master_list_linea_attivita set linea_attivita = replace(linea_attivita, 'à', 'a''');
update master_list_linea_attivita set linea_attivita = replace(linea_attivita, 'è', 'e''');
update master_list_linea_attivita set linea_attivita = replace(linea_attivita, 'ì', 'i''');
update master_list_linea_attivita set linea_attivita = replace(linea_attivita, 'ò', 'o''');
update master_list_linea_attivita set linea_attivita = replace(linea_attivita, 'ù', 'u''');

update master_list_macroarea set macroarea='Gestione Rifiuti' where macroarea='Gestione Rifiuti''';
update master_list_macroarea set macroarea='Industria chimica' where macroarea='Industria chimica''';
update master_list_macroarea set macroarea='Industria dei prodotti minerali' where macroarea='Industria dei prodotti minerali''';
update master_list_macroarea set macroarea='Produzione e trasformazione dei metalli' where macroarea='Produzione e trasformazione dei metalli''';
update master_list_linea_attivita set linea_attivita = regexp_replace(regexp_replace(linea_attivita, E'[\\n\\r\\u2028]+', ' ', 'g' ),  '\s+', ' ', 'g');
update master_list_linea_attivita set linea_attivita = trim(linea_attivita);
update master_list_linea_attivita  set linea_attivita = 'Impianti per il trattamento di superfici di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare con una capacita'' di consumo solvente superiore a 150 kg all''ora oppure a 200 tonnellate all''anno, con capacita'' massima di 540 kg/h' 
where id_aggregazione in (select id from master_list_aggregazione  where aggregazione ='6.7') --1record

-- disable trigger su master_list_linea_attivita e  master_list_aggregazione

insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20743,'Impianti destinati alla produzione di clinker (cemento) in forni rotativi la cui capacita'' di produzione supera 500 tonnellate al giorno oppure di calce viva in forni rotativi la cui capacita'' di produzione supera 50 tonnellate al giorno, o in altri tipi di forno aventi una capacita'' di produzione di oltre 50 tonnellate al giorno',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20744,'Impianti per la fabbricazione del vetro compresi quelli destinati alla produzione di fibre di vetro, con capacita'' di fusione di oltre 20 tonnellate al giorno.',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20761,'Smaltimento o recupero di rifiuti pericolosi, con capacita'' di oltre 10 Mg. al giorno, che comporti il ricorso ad uno o piu'' delle seguenti attivita''  dosaggio o miscelatura prima di una delle altre attivita'' di cui ai punti 5.1 e 5.2',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20761,'Lo smaltimento o il recupero di rifiuti pericolosi, con capacita'' di oltre 10 Mg al giorno, che comporti il ricorso ad una o piu'' delle seguenti attivita'': trattamento chimico-fisico',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20757,'trattamento di superficie di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, spalmare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare, con una capacita'' di consumo di solventi organici superiore a 150 kg/ora o a 200 Mg/anno',true);
update master_list_linea_attivita set codice_prodotto_specie  = concat('L',id) where codice_prodotto_specie is null;
update master_list_linea_attivita set codice_univoco  = 'M140-A20761-L41917' where id=41917;
update master_list_linea_attivita set codice_univoco  = 'M140-A20761-L41918' where id=41918;
update master_list_linea_attivita set codice_univoco  = 'M142-A20743-L41915' where id=41915; --3.1 ok
update master_list_linea_attivita set codice_univoco  = 'M142-A20744-L41916' where id=41916; --3.3 ok
update master_list_linea_attivita set codice_univoco  = 'M138-A20757-L41919' where id=41919; --6.7 ok

insert into master_list_aggregazione(id_macroarea, aggregazione)  values (142,'3.5');
insert into master_list_aggregazione(id_macroarea, aggregazione)  values (140,'5.2');
insert into master_list_aggregazione(id_macroarea, aggregazione)  values (140,'5.2b');

update master_list_aggregazione set codice_attivita = concat('A',id) where codice_attivita is null;

insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(763,'Impianti per la fabbricazione di prodotti ceramici mediante cottura, in particolare tegole, mattoni, mattoni refrattari, piastrelle, gres, porcellane, con una capacita'' di produzione di oltre 75 Mg al giorno',true);
--140
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(764,'Impianti di incenerimento dei rifiuti urbani quali definiti nella direttiva 89/369/CEE del Consiglio, dell''8 giugno 1989, concernente la prevenzione dell''inquinamento atmosferico provocato dai nuovi impianti di incenerimento dei rifiuti urbani, e nella direttiva 89/429/CEE del 21 giugno 1989 del Consiglio, concernente la riduzione dell''inquinamento atmosferico provocato dagli impianti di incenerimento rifiuti urbani, con una capacita'' superiore a 3 tonnellate all''ora',true);
--140
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(765,'Smaltimento o recupero dei rifiuti in impianti di incenerimento dei rifiuti o in impianti di coincenerimento dei rifiuti: b) per i rifiuti pericolosi con una capacita'' superiore a 10 Mg al giorno',true);

update master_list_linea_attivita set codice_prodotto_specie  = concat('L',id) where codice_prodotto_specie is null;
update master_list_linea_attivita set codice_univoco  = 'M142-A763-L41920' where id=41920; 
update master_list_linea_attivita set codice_univoco  = 'M140-A764-L41921' where id=41921; 
update master_list_linea_attivita set codice_univoco  = 'M140-A765-L41922', linea_Attivita=replace(linea_attivita,'"','') where id=41922; 

update master_list_linea_attivita  set linea_attivita ='Lo smaltimento dei rifiuti non pericolosi, con capacita'' superiore a 50 Mg al giorno, che comporta il ricorso ad una o piu'' delle seguenti attivita'' ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate al paragrafo 1.1 dell''Allegato 5 alla Parte Terza: 1) trattamento biologico; 2) trattamento fisico-chimico;'
where id=41892;

update master_list_linea_attivita set linea_attivita  = replace(linea_attivita, 'comtemplati', 'contemplati') where linea_attivita ilike '%comtemplati%';
update master_list_linea_attivita set linea_attivita = 'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m3.' where linea_attivita = 'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m³.';
select * from refresh_ml_materializzata();
