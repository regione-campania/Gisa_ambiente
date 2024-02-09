-- Table: public.import_aia

DROP TABLE public.import_aia;
CREATE TABLE public.import_aia
(
  id_aia text,
  ragione_sociale text,
  codice_fiscale text,
  comune text,
  pr text,
  indirizzo text,
  coordinate_geografiche_x text,
  coordinate_geografiche_y text,
  denominazione_categoria_impianto text,
  codice_ipcc_principale text,
  codice_ipcc_secondaria text,
  descrizione_att_principale text,
  descrizione_att_secondaria text,
  autorizzazione text,
  num_decreto_dirigenziale text,
  data_decreto_dirigenziale text,
  nota_su_decreto text,
  burc text,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.import_aia
  OWNER TO postgres;
  
--aggiungo chiave
alter table import_aia add column id serial;
--rimuovo intestazione
delete from import_aia  where id=1;
-- svuoto tabella log
delete from log_import_aia 

CREATE TABLE import_aia_anagrafiche AS
select distinct id_aia, ragione_sociale, codice_fiscale, comune, pr, indirizzo, coordinate_geografiche_x, coordinate_geografiche_y, note from import_aia;

CREATE TABLE import_aia_linee_principali AS
select distinct id_aia, denominazione_categoria_impianto, codice_ipcc_principale, descrizione_att_principale from import_aia;

CREATE TABLE import_aia_linee_secondarie AS
select distinct id_aia, denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria from import_aia where codice_ipcc_secondaria is not null and codice_ipcc_secondaria <> '';

CREATE TABLE import_aia_decreti AS
select distinct id_aia, autorizzazione, num_decreto_dirigenziale, data_decreto_dirigenziale, nota_su_decreto, burc from import_aia;
update import_aia_anagrafiche set comune  = 'PIGNATARO MAGGIORE' where comune='PIGNATARO MAGGIOIRE';
update import_aia_anagrafiche set comune  = 'SANT''EGIDIO DEL MONTE ALBINO' where comune='S.EGIDIO DEL MONTE ALBINO';
update import_aia_anagrafiche set comune  = 'FRANCOLISE' where comune='FRAMCOLISE';
update import_aia_anagrafiche set comune  = 'MIGNANO MONTE LUNGO' where comune='MIGNANO MONTELUNGO';
update import_aia_anagrafiche set comune  = 'SANT''AGATA DE'' GOTI' where comune='S. AGATA DEI GOTI';
update import_aia_anagrafiche set comune  = 'SANT''ANTONIO ABATE' where comune='S.ANTONIO ABATE';
update import_aia_anagrafiche set comune  = 'NOCERA INFERIORE' where comune='NOCERA INF.';
update import_aia_anagrafiche set comune  = 'SANT''EGIDIO DEL MONTE ALBINO' where comune='S. EGIDIO DEL MONTE ALBINO';
update import_aia_anagrafiche set comune  = 'SAN VITALIANO' where comune='S. VITALIANO';
update import_aia_anagrafiche set comune  = 'CASALNUOVO DI NAPOLI' where comune='CASALNUOVO';
update import_aia_anagrafiche set comune  = 'SANT''ANTONIO ABATE' where comune='S. ANTONIO ABATE';
update import_aia_anagrafiche set comune  = 'MERCATO SAN SEVERINO' where comune='MERCATO S. SEVERINO';
update import_aia_anagrafiche set comune  = 'SANT''ARCANGELO TRIMONTE' where comune='S.ANGELO TRIMONTE';
update import_aia_anagrafiche set comune  = 'GRICIGNANO DI AVERSA' where comune='GRICIGNANO D''AVERSA';
update import_aia_anagrafiche set comune  = 'POMIGLIANO D''ARCO' where comune='POMIGLIANO D''ARCO (e Acerra)';
update import_aia_anagrafiche set comune  = 'MONTORO SUPERIORE' where comune='MONTORO';
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'-','/');
update import_aia_decreti set data_decreto_dirigenziale = '23/08/2016' where data_decreto_dirigenziale='23/28/2016';
update import_aia_decreti set data_decreto_dirigenziale = '16/11/2015' where data_decreto_dirigenziale='16/21/2015';
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'lug','07'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'dic','12'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'set','09'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'gen','01'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'giu','06');
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'mag','05'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'ott','10'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'apr','04'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'mar','03'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'ago','08'); 
update import_aia_decreti set data_decreto_dirigenziale = '31/12/2009' where id_aia ='AV10'; --2 date presenti
update import_aia_decreti set data_decreto_dirigenziale =  to_char(data_decreto_dirigenziale::date,'yyyy-dd-mm')
update import_aia_linee_principali set codice_ipcc_principale  = '6.7' where codice_ipcc_principale ilike '%6,7%' --1 record
update import_aia_linee_principali set codice_ipcc_principale = '5.3a-5.3b' where codice_ipcc_principale = '5.3a- 5.3b';
update import_aia_linee_principali set codice_ipcc_principale = '4.1g-4.1h' where codice_ipcc_principale = '4.1g - 4.1h';
update import_aia_linee_secondarie  set codice_ipcc_secondaria  = '5.3a-5.3b' where codice_ipcc_secondaria = '5.3a- 5.3b';
update import_aia_linee_secondarie set codice_ipcc_secondaria = '4.1g-4.1h' where codice_ipcc_secondaria = '4.1g - 4.1h';


update import_aia_linee_principali  set descrizione_att_principale  = replace (descrizione_att_principale, 'Ãˆ', 'E''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'Ã ', 'a''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¨', 'e''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¬', 'i''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'Ã²', 'u''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¹', 'u''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'à', 'a''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'è', 'e''');
update import_aia_linee_principali set descrizione_att_principale = replace (descrizione_att_principale, 'ì ', 'i''');

update import_aia_linee_secondarie  set descrizione_att_secondaria   = replace (descrizione_att_secondaria, 'Ãˆ', 'E''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã ', 'a''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¨', 'e''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¬', 'i''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã²', 'u''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¹', 'u''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'à', 'a''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'è', 'e''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'ì ', 'i''');

update import_aia_linee_principali  set denominazione_categoria_impianto    = replace (denominazione_categoria_impianto, 'Ãˆ', 'E''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã ', 'a''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¨', 'e''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¬', 'i''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã²', 'u''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¹', 'u''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'à', 'a''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'è', 'e''');
update import_aia_linee_principali set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'ì ', 'i''');

update import_aia_linee_secondarie  set denominazione_categoria_impianto    = replace (denominazione_categoria_impianto, 'Ãˆ', 'E''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã ', 'a''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¨', 'e''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¬', 'i''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã²', 'u''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¹', 'u''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'à', 'a''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'è', 'e''');
update import_aia_linee_secondarie set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'ì ', 'i''');

update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'à', 'a''');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'è', 'e''');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'ì', 'i''');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'ò', 'o''');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'ù', 'u''');

update import_aia_linee_secondarie  set descrizione_att_secondaria  = replace(descrizione_att_secondaria, 'à', 'a''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace(descrizione_att_secondaria, 'è', 'e''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace(descrizione_att_secondaria, 'ì', 'i''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace(descrizione_att_secondaria, 'ò', 'o''');
update import_aia_linee_secondarie set descrizione_att_secondaria = replace(descrizione_att_secondaria, 'ù', 'u''');

update import_aia_linee_principali set descrizione_att_principale = trim(descrizione_att_principale);
update import_aia_linee_secondarie  set descrizione_att_secondaria  = trim(descrizione_att_secondaria);


update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale,'m�','m3');
update import_aia_linee_secondarie  set descrizione_att_secondaria  = replace(descrizione_att_secondaria,'m�','m3');
--pulizia tabelle import
update import_aia_linee_principali set descrizione_att_principale = regexp_replace(regexp_replace(descrizione_att_principale, E'[\\n\\r\\u2028]+', ' ', 'g' ),  '\s+', ' ', 'g');
update import_aia_linee_secondarie  set descrizione_att_secondaria  = regexp_replace(regexp_replace(descrizione_att_secondaria, E'[\\n\\r\\u2028]+', ' ', 'g' ),  '\s+', ' ', 'g');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale,'altri metall', 'altri metalli');
update import_aia_linee_secondarie  set descrizione_att_secondaria  = replace(descrizione_att_secondaria,'altri metall', 'altri metalli');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale,'metallii', 'metalli');
update import_aia_linee_secondarie  set descrizione_att_secondaria  = replace(descrizione_att_secondaria,'metallii', 'metalli');
update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale,'trimestrale))','trimestrale)');

update import_aia_linee_principali set descrizione_att_principale = 'Impianti per l''allevamento intensivo di pollame o di suini con più di: a) 40.000 posti pollame' 
where  descrizione_att_principale ='Impianti per l''allevamento intensivo di pollame o di suini con più di: a) 40.000 posti pollame ';
update import_aia_linee_principali set descrizione_att_principale = 'Il recupero, o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, con una capacita'' superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attivita'' ed escluse le attivita'' di trattamento delle acque reflue urbane. Trattamento in frantumatori di rifiuti metallici, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti, con una capacita'' massima di trattamento degli impianti di 360 Mg/g' 
where  descrizione_att_principale ='Il recupero, o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, con una capacita'' superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attivita'' ed escluse le attivita'' di trattamento delle acque reflue urbane. Trattamento in frantumatori di rifiuti metallici, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti, con una capacita'' massima di trattamento degli impianti di 360 Mg/g ';
update import_aia_linee_principali set descrizione_att_principale = 'Trattamento e trasformazione del latte, con un quantitativo di latte ricevuto di oltre 200 tonnellate al giorno (valore medio su base annua)'
where  descrizione_att_principale ='Trattamento e trasformazione del latte, con un quantitativo di latte ricevuto di oltre 200 tonnellate al giorno (valore medio su base annua) 1 ';
update import_aia_linee_principali set descrizione_att_principale = 'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m³.' 
where  descrizione_att_principale ='Trattamento di superficie di metalli o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m³.';
update import_aia_linee_principali set descrizione_att_principale = 'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m³.' 
where  descrizione_att_principale ='trattamento di superficie di metalli e materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m^3. ';

update import_aia_linee_principali set descrizione_att_principale = 'Escluso il caso in cui la materia prima sia esclusivamente il latte, trattamento e trasformazione, diversi dal semplice imballo, delle seguenti materie prime, sia trasformate in precedenza sia non trasformate destinate alla fabbricazione di prodotti alimentari o mangimi da materie prime vegetali con una capacita'' di produzione di prodotti finiti di oltre 300 Mg al giorno o 600 Mg al giorno se l''installazione e'' in funzione per un periodo non superiore a 90 giorni consecutivi all''anno' where descrizione_att_principale = 'Escluso il caso in cui la materia prima sia esclusivamente il latte, trattamento e trasformazione, diversi dal semplice imballo, delle seguenti materie prime, sia trasformate in precedenza sia non trasformate destinate alla fabbricazione di prodotti alimentari o mangimi da materie prime vegetali con una capacita'' di produzione di prodotti finiti di oltre 300 Mg al giorno o 600 Mg al giorno se l''installazione e'' in funzione per un periodo non superiore a 90 giorni consecutivi all''anno';
update import_aia_linee_principali  set descrizione_att_principale ='Impianti per il trattamento di superfici di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare con una capacita'' di consumo solvente superiore a 150 kg all''ora oppure a 200 tonnellate all''anno, con capacita'' massima di 540 kg/h' 
where descrizione_att_principale ='Impianti per il trattamento di superfici di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare con una capacita'' di consumo solvente superiore a 150 kg all''ora oppure a 200 tonnellate all''anno, con capacita'' massima di 540 kg/h;'

update import_aia_linee_principali  set descrizione_att_principale ='Impianti per il trattamento di superfici di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare con una capacita'' di consumo solvente superiore a 150 kg all''ora oppure a 200 tonnellate all''anno, con capacita'' massima di 540 kg/h' 
where descrizione_att_principale ='Impianti per il trattamento di superficie di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, spalmare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare, con una capacita'' di consumo di solvente superiore a 150 kg all''ora o a 200 tonnellate all''anno'
update import_aia_linee_principali set descrizione_att_principale = 'trattamento di superficie di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, spalmare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare, con una capacita'' di consumo di solventi organici superiore a 150 kg/ora o a 200 Mg/anno' where descrizione_att_principale = 'trattamento di superficie di materie, oggetti o prodotti utilizzando solventi organici, in particolare per apprettare, stampare, spalmare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare, con una capacita'' di consumo di solventi organici superiore a 150 kg/ora o a 200 Mg/anno';
update import_aia_linee_principali  set codice_ipcc_principale ='5.1b-c' where codice_ipcc_principale ='5.1bc' ;
update import_aia_linee_principali  set descrizione_att_principale ='Lo smaltimento o il recupero di rifiuti pericolosi, con capacita'' di oltre 10 Mg al giorno, che comporti il ricorso ad una o piu'' delle seguenti attivita'': b) trattamento chimico-fisico c) dosaggio o miscelatura prima di una delle altre attivita'' di cui ai punti 5.1 e 5.2' 
where descrizione_att_principale ='Lo smaltimento o il recupero di rifiuti pericolosi, con capacita'' di oltre 10 Mg al giorno, che comporti il ricorso ad una o piu'' delle seguenti attivita'': b) trattamento chimico-fisico e c) dosaggio o miscelatura prima di una delle altre attivita'' di cui ai punti 5.1 e 5.2 4' 
update import_aia_linee_principali  set codice_ipcc_principale = '5.3' where codice_ipcc_principale ='5.3 a' and descrizione_att_principale ilike '%Lo smaltimento dei rifiuti non pericolosi, con capacita'' superiore a 50 Mg al giorno, che comporta il ricorso ad una%'
update import_aia_linee_principali  set descrizione_att_principale='Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico; 3) pretrattamento dei rifiuti destinati all''incenerimento o al coincenerimento; 4) trattamento di scorie e ceneri 5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti.'  
where descrizione_att_principale='Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico; 3) pretrattamento dei rifiuti destinati all''incenerimento o al coincenerimento; 4) trattamento di scorie e ceneri; 5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti.'
update import_aia_linee_principali set descrizione_att_principale = 'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico;' where descrizione_att_principale = 'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico.';

update import_aia_linee_principali set descrizione_att_principale = replace(descrizione_att_principale, 'comtemplati', 'contemplati') where descrizione_att_principale ilike '%comtemplati%';
update import_aia_linee_principali set codice_ipcc_principale='5.3a', descrizione_att_principale ='Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico; 3) pretrattamento dei rifiuti destinati all''incenerimento o al coincenerimento; 4) trattamento di scorie e ceneri 5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti.' 
where codice_ipcc_principale = '5.3a-5.3b' and descrizione_att_principale ilike '%- Impianti per il recupero%';
insert into import_aia_linee_principali(id_aia,denominazione_categoria_impianto, codice_ipcc_principale, descrizione_att_principale) values ('NA62','Gestione rifiuti', '5.3b', 'Impianti per il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, con una capacita'' superiore a 75 Mg al giorno, che comportano il ricorso ad una o piu'' delle seguenti attivita'' ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate al paragrafo 1.1 dell''Allegato 5 alla Parte Terza' );


update import_aia_linee_secondarie set codice_ipcc_secondaria='5.5', descrizione_att_secondaria = 'Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti' 
where descrizione_att_secondaria ilike '%fuori uso e relativi componenti. Accumulo temporaneo di%' and codice_ipcc_secondaria ilike '%5.3.a - 5.5%'
insert into import_aia_linee_secondarie(id_aia,denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria) values ('CE25','Gestione rifiuti', '5.3a', 'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno: 1) trattamento biologico; 2) trattamento chimico-fisico; 3) pretrattamento dei rifiuti destinati all''incenerimento o al coincenerimento; 4) trattamento di scorie e ceneri 5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti.' );

update import_aia_linee_secondarie set codice_ipcc_secondaria='5.5', descrizione_att_secondaria = 'Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti' 
where descrizione_att_secondaria ilike '%al giorno. - accumulo temporaneo%' and codice_ipcc_secondaria ilike '%5.3 / 5.5%'
--NA12
insert into import_aia_linee_secondarie(id_aia,denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria) values ('NA12','Gestione rifiuti', '5.3', 'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno.' );


update import_aia_linee_secondarie set codice_ipcc_secondaria='5.5', descrizione_att_secondaria = 'Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti' 
where  codice_ipcc_secondaria ilike '%5.2 / 5.5%'
--NA1
insert into import_aia_linee_secondarie(id_aia,denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria) values ('NA1','Gestione rifiuti', '5.2', 'Impianti di incenerimento dei rifiuti urbani quali definiti nella direttiva 89/369/CEE del Consiglio, dell''8 giugno 1989, concernente la prevenzione dell''inquinamento atmosferico provocato dai nuovi impianti di incenerimento dei rifiuti urbani, e nella direttiva 89/429/CEE del 21 giugno 1989 del Consiglio, concernente la riduzione dell''inquinamento atmosferico provocato dagli impianti di incenerimento rifiuti urbani, con una capacita'' superiore a 3 tonnellate all''ora' );

update import_aia_linee_secondarie set codice_ipcc_secondaria='5.3', descrizione_att_secondaria = 'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, D 9 con capacita'' superiore a 50 tonnellate al giorno.' 
where  codice_ipcc_secondaria ilike '%5.3 / 5.2%';
--"BN17"
insert into import_aia_linee_secondarie(id_aia,denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria) values ('BN17','Gestione rifiuti', '5.2', 'Impianti di incenerimento dei rifiuti urbani quali definiti nella direttiva 89/369/CEE del Consiglio, dell''8 giugno 1989, concernente la prevenzione dell''inquinamento atmosferico provocato dai nuovi impianti di incenerimento dei rifiuti urbani, e nella direttiva 89/429/CEE del 21 giugno 1989 del Consiglio, concernente la riduzione dell''inquinamento atmosferico provocato dagli impianti di incenerimento rifiuti urbani, con una capacita'' superiore a 3 tonnellate all''ora' );

update import_aia_linee_secondarie set codice_ipcc_secondaria='5.3b2', descrizione_att_secondaria = 'Impianti per il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, con una capacita'' superiore a 75 Mg al giorno, che comportano il ricorso ad una o piu'' delle seguenti attivita'' ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate al paragrafo 1.1 dell''Allegato 5 alla Parte Terza' 
where  codice_ipcc_secondaria ilike '%5.2b/%5.3b2%';
--""SA82""
insert into import_aia_linee_secondarie(id_aia,denominazione_categoria_impianto, codice_ipcc_secondaria, descrizione_att_secondaria) values ('SA82','Gestione rifiuti', '5.2b', 'Smaltimento o recupero dei rifiuti in impianti di incenerimento dei rifiuti o in impianti di coincenerimento dei rifiuti: b) per i rifiuti pericolosi con una capacita'' superiore a 10 Mg al giorno' );


update import_aia_linee_secondarie set descrizione_att_secondaria = 'Attivita'' di trattamento a gestione indipendente di acque reflue non coperte dalle norme di recepimento della direttiva 91/271/CEE ed evacuate da un''installazione in cui e'' svolta una delle attivita'' di cui al presente allegato.' where descrizione_att_secondaria in ('Attivita'' di trattamento a gestione indipendente di acque reflue non coperte dalle norme di recepimento della direttiva 91/271/CEE, ed evacuate da un''installazione in cui e'' svolta una delle attivita'' di cui al presente Allegato', 'Attivita'' di trattamento a gestione indipendente di acque reflue non coperte dalle norme di recepimento della direttiva 91/271/CEE ed evacuate da un''installazione in cui e'' svolta una delle attivita'' di cui al presente allegato.')
update import_aia_linee_secondarie set descrizione_att_secondaria = 'Impianti di combustione con potenza termica di combustione di oltre 50 MW' where descrizione_att_secondaria = 'combustione con presenza termica > 50 MW';


update import_aia_linee_secondarie set descrizione_att_secondaria = 'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m3.' where descrizione_att_secondaria = 'trattamento di superficie di metalli e materie plastiche mediante processi elettrolitici o chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m^3.';

update import_aia_linee_secondarie set descrizione_att_secondaria = 'Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti' where descrizione_att_secondaria in ('Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiut', 'accumulo temporaneo di rifiuti pericolosi non comtemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti', 'Accumulo temporaneo di rifiuti pericolosi non contemplati al punto 5.4 prima di una delle attivita'' elencate ai punti 5.1, 5.2, 5.4 e 5.6 con una capacita'' totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti')



update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'-','/');
update import_aia_decreti set data_decreto_dirigenziale = '23/08/2016' where data_decreto_dirigenziale='23/28/2016';
update import_aia_decreti set data_decreto_dirigenziale = '16/11/2015' where data_decreto_dirigenziale='16/21/2015';
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'lug','07'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'dic','12'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'set','09'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'gen','01'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'giu','06');
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'mag','05'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'ott','10'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'apr','04'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'mar','03'); 
update import_aia_decreti set data_decreto_dirigenziale = replace(data_decreto_dirigenziale,'ago','08'); 
update import_aia_decreti set data_decreto_dirigenziale = '31/12/2009' where id_aia ='AV10'; --2 date presenti
update import_aia_decreti set data_decreto_dirigenziale =  to_char(data_decreto_dirigenziale::date,'yyyy-dd-mm')

select * from import_aia_anagrafiche  where indirizzo  ilike '%sede legale%'

update import_aia_anagrafiche  set indirizzo ='Strada provinciale 187 Loc. Poste Zona Industriale ASI' where id_aia='CE26';
update import_aia_anagrafiche  set indirizzo ='Via F.lli Buscetto, 70/72' where id_aia='SA82';

CREATE OR REPLACE FUNCTION public.importa_anagrafica_aia(_idAia text)
  RETURNS integer AS
$BODY$
DECLARE 

_idIndirizzoOperatore integer;
_idIndirizzoStabilimento integer;
_idIndirizzoSoggetto integer;
_idOperatore integer;
_idStabilimento integer;
_idSoggetto integer;
_numeroRegistrazione text;
_numeroRegistrazioneLinea text;
_noteHd text;
_refresh boolean;
r record;
_indice integer;
BEGIN

_noteHd := '[INSERITO PER IMPORT AIA '||_idAia||']';
_indice := 0;

-- insert into opu_indirizzo (sede legale)
insert into opu_indirizzo(via, cap, provincia, nazione, latitudine, longitudine, comune, toponimo, note_hd) 
select i.indirizzo, c.cap, p.code, 'ITALIA', i.coordinate_geografiche_y::double precision, i.coordinate_geografiche_x::double precision, c.id, 100, _noteHd
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
join lookup_province p on p.cod_provincia = i.pr
where i.id_aia = _idAia returning id into _idIndirizzoOperatore;
raise info '_idIndirizzoOperatore %', _idIndirizzoOperatore;

-- insert into opu_indirizzo (sede operativa)
insert into opu_indirizzo(via, cap, provincia, nazione, latitudine, longitudine, comune, toponimo, note_hd) 
select i.indirizzo, c.cap, p.code, 'ITALIA', i.coordinate_geografiche_y::double precision, i.coordinate_geografiche_x::double precision, c.id, 100, _noteHd
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
join lookup_province p on p.cod_provincia = i.pr
where i.id_aia = _idAia returning id into _idIndirizzoStabilimento;
raise info '_idIndirizzoStabilimento %', _idIndirizzoStabilimento;

-- insert into opu_indirizzo (residenza soggetto)
insert into opu_indirizzo(via, cap, provincia, nazione,comune, toponimo, note_hd) 
select '', '', -1, '', -1, -1, _noteHd returning id into _idIndirizzoSoggetto;
raise info '_idIndirizzoSoggetto %', _idIndirizzoSoggetto;

-- insert into opu_soggetto_fisico (soggetto anonimo con codice fiscale ND)
insert into opu_soggetto_fisico (nome, cognome, codice_fiscale, indirizzo_id, note_hd) 
select 'NDN', 'NDC', 'ND', _idIndirizzoSoggetto, _noteHd returning id into _idSoggetto;
raise info '_idSoggetto %', _idSoggetto;

-- insert into opu_operatore
insert into opu_operatore(codice_fiscale_impresa, partita_iva, ragione_sociale, id_indirizzo, note_internal_use_only_hd)
select codice_fiscale, codice_fiscale, ragione_sociale, _idIndirizzoOperatore, _noteHd
from import_aia_anagrafiche 
where id_aia = _idAia returning id into _idOperatore;
raise info '_idOperatore %', _idOperatore;

-- Numero registrazione
_numeroRegistrazione := (select * from genera_numero_registrazione_da_comune((select comune from opu_indirizzo where id = _idIndirizzoStabilimento)));
raise info '_numeroRegistrazione %', _numeroRegistrazione;

-- insert into opu_stabilimento (con numero di registrazione generato, asl dell'indirizzo)
insert into opu_stabilimento (id_asl, id_operatore, id_soggetto_fisico, id_indirizzo, numero_registrazione, tipo_attivita, stato, notes_hd, entered)
select c.codiceistatasl::integer, _idOperatore, _idSoggetto, _idIndirizzoStabilimento, _numeroRegistrazione, 1, 99, _noteHd, now()
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
where i.id_aia = _idAia returning id into _idStabilimento;
raise info '_idStabilimento %', _idStabilimento;

-- insert into opu_rel_operatore_soggetto_fisico
insert into opu_rel_operatore_soggetto_fisico(id_operatore, id_soggetto_fisico, tipo_soggetto_fisico) 
select _idOperatore, _idSoggetto, 1;

-- insert into opu_relazione_stabilimento_linee_produttive

FOR r IN SELECT * FROM import_aia_linee_principali where id_aia = _idAia
    LOOP
    
SELECT _indice+1 into _indice;
SELECT _numeroRegistrazione||LPAD(_indice::text, 3, '0') into _numeroRegistrazioneLinea;

insert into opu_relazione_stabilimento_linee_produttive (id_linea_produttiva, id_stabilimento, stato, primario, numero_registrazione, codice_univoco_ml, tipo_carattere, enabled, note_hd)

select ml8.id_nuova_linea_attivita, _idStabilimento, 99, true, _numeroRegistrazioneLinea, ml8.codice, 1, true, _noteHd
from ml8_linee_attivita_nuove_materializzata ml8 where ml8.macroarea ilike r.denominazione_categoria_impianto and ml8.aggregazione ilike r.codice_ipcc_principale and ml8.attivita ilike r.descrizione_att_principale;

raise info 'Inserita linea principale % _idStabilimento % _numeroRegistrazioneLinea %', _indice, _idStabilimento, _numeroRegistrazioneLinea;
END LOOP;


FOR r IN SELECT * FROM import_aia_linee_secondarie where id_aia = _idAia
    LOOP
    
SELECT _indice+1 into _indice;
SELECT _numeroRegistrazione||LPAD(_indice::text, 3, '0') into _numeroRegistrazioneLinea;

insert into opu_relazione_stabilimento_linee_produttive (id_linea_produttiva, id_stabilimento, stato, primario, numero_registrazione, codice_univoco_ml, tipo_carattere, enabled, note_hd)

select ml8.id_nuova_linea_attivita, _idStabilimento, 99, false, _numeroRegistrazioneLinea, ml8.codice, 1, true, _noteHd
from ml8_linee_attivita_nuove_materializzata ml8 where ml8.macroarea ilike r.denominazione_categoria_impianto and ml8.aggregazione ilike r.codice_ipcc_secondaria and ml8.attivita ilike r.descrizione_att_secondaria;

raise info 'Inserita linea secondaria % _idStabilimento % _numeroRegistrazioneLinea %', _indice, _idStabilimento, _numeroRegistrazioneLinea;
END LOOP;

-- insert into select * from anag_dati_autorizzativi 

 insert into anag_dati_autorizzativi(riferimento_id, riferimento_id_nome_tab, id_aia, tipo_autorizzazione, num_decreto, data_decreto, nota, burc)
 select _idStabilimento, 'opu_stabilimento', i.id_aia, a.code, i.num_decreto_dirigenziale, i.data_decreto_dirigenziale, i.nota_su_decreto, i.burc
 from import_aia_decreti i
 join lookup_autorizzazione_tipo a on a.description ilike i.autorizzazione
 where i.id_aia = _idAia;
raise info 'Inseriti decreti _idStabilimento %', _idStabilimento;

 -- Log import AIA
 -- Qui rivedrei la tabella di log. Forse facciamo prima a usare id_aia invece di id di import_aia che � diventata una tabella di appoggio. In questa versione loggo tutti gli id relativi all'id_aia importato (11 record perch� su import_aia a causa della duplicazione dei decreti ci sono 11 righe). In alternativa una tabella di log per ogni entit� di partenza (log_anagrafiche, log_decreti, log_linee_principali, log_linee_secondarie) ma mi sembra inutile

 insert into log_import_aia (id_import_aia, riferimento_id, riferimento_id_nome_tab)
 select id, _idStabilimento, 'opu_stabilimento'
 from import_aia where id_aia = _idAia;

 -- Refresh

 _refresh := (select * from refresh_anagrafica(_idStabilimento, 'opu'));

 raise info 'Terminato inserimento _idStabilimento %', _idStabilimento;

RETURN _idStabilimento;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
  
-- rinominare a OBS la precedente
-- rimuovere temporaneamente il check
ALTER TABLE public.opu_indirizzo DROP CONSTRAINT check_capna;

CREATE OR REPLACE FUNCTION public.import_from_aia()
  RETURNS integer AS
$BODY$
DECLARE
   rec text;
BEGIN

     FOR rec IN
        SELECT distinct aia.id_aia from import_aia_anagrafiche aia 
     LOOP
        raise info 'id_aia: % ', rec;
         perform (select * from importa_anagrafica_aia(rec));
     END LOOP;

     return 1;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.import_from_aia()
  OWNER TO postgres;
  
--lancio import  
select * from   import_from_aia()

-- lancio check

ALTER TABLE public.opu_indirizzo
  ADD CONSTRAINT check_capna CHECK (btrim(cap::text) <> '80100'::text);