--select * from ml8_linee_attivita_nuove_materializzata  

delete from master_list_macroarea ;
delete from master_list_aggregazione;
delete from master_list_linea_attivita where id > 41572;
delete from master_list_flag_linee_attivita;
delete from opu_lookup_norme_master_list  where code >1

select * from opu_lookup_norme_master_list
 

insert into master_list_macroarea(codice_sezione, macroarea) values ('','Altre Attivita''');
insert into master_list_macroarea(codice_sezione, macroarea) values ('','Attivita'' energetiche');
insert into master_list_macroarea(codice_sezione, macroarea) values ('','Gestione Rifiuti''');
insert into master_list_macroarea(codice_sezione, macroarea) values ('','Industria chimica''');
insert into master_list_macroarea(codice_sezione, macroarea) values ('','Industria dei prodotti minerali''');
insert into master_list_macroarea(codice_sezione, macroarea) values ('','Produzione e trasformazione dei metalli''');

select * from master_list_aggregazione where id_macroarea  =138
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.6b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.4b') returning id;
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.4a');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.4b.2');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.1c');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.1b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.5');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.7');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.4c');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.6a');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (138,'6.11');


select * from master_list_aggregazione where id_macroarea = 140
insert into master_list_aggregazione (id_macroarea,aggregazione) values (139,'1.1');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.1b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.1b-c');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.1e');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3a');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3a-5.3b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3a1-5.3a2');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3b.1');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3b.4');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.3b2');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.4');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.5');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (140,'5.1');

insert into master_list_aggregazione (id_macroarea,aggregazione) values (141,'4.1b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (141,'4.1g-4.1h');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (141,'4.2a');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (141,'4.5');

insert into master_list_aggregazione (id_macroarea,aggregazione) values (142,'3.1');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (142,'3.3');

insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.1');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.3a');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.3c');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.4');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.5b');
insert into master_list_aggregazione (id_macroarea,aggregazione) values (143,'2.6');

-- linee per altre attività 6.6b
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20724,'Impianti per l''allevamento intensivo di pollame o di suini con più di: b) 2.000 posti suini da produzione (di oltre 30 kg)',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20724,'Escluso il caso in cui la materia prima sia esclusivamente il latte, trattamento e 
trasformazione, diversi dal semplice imballo, delle seguenti materie prime, sia trasformate in 
precedenza sia non trasformate destinate alla fabbricazione di prodotti alimentari o mangimi da 
materie prime vegetali con una capacità di produzione di prodotti finiti di oltre 300 Mg al giorno o 600 
Mg al giorno se l''installazione e'' in funzione per un periodo non superiore a 90 giorni consecutivi 
all''anno',true);
-- linee per altre attività 6.4b
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20751,'Trattamento e trasformazione destinati alla fabbricazione di prodotti alimentari 
a partire da: materie prime animali (diverse dal latte) con una capacita'' di produzione di prodotti finiti di oltre 75 tonnellate al giorno ovvero materie prime vegetali 
con una capacita'' di produzione di prodotti  finiti di oltre 300 tonnellate al giorno (valore medio su base trimestrale)',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20751,'Escluso il caso in cui la materia prima sia esclusivamente il latte, trattamento e 
trasformazione, diversi dal semplice imballo, delle seguenti materie prime, sia trasformate in 
precedenza sia non trasformate destinate alla fabbricazione di prodotti alimentari o mangimi da 
materie prime vegetali con una capacità di produzione di prodotti finiti di oltre 300 Mg al giorno o 600 
Mg al giorno se l''installazione e'' in funzione per un periodo non superiore a 90 giorni consecutivi 
all''anno',true);

 -- linee per altre attività 6.4a
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20752,'Macelli aventi una capacità di produzione di carcasse di oltre 50 tonnellate al giorno',true);
 -- linee per altre attività 6.4b.2 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20753,'Escluso il caso in cui la materia prima sia esclusivamente il latte, trattamento e trasformazione, 
diversi dal semplice imballo , delle seguenti materie prime, sia trasformate in precedenza sia non trasformate destinate alla fabbricazione di prodotti alimentari o mangimi da  
2) solo materie prime vegetali con una capacità di produzione di prodotti finiti di oltre 300 Mg al giorno o 600 Mg al giorno se l''installazione è in funzione per un periodo non 
superiore a 90 giorni consecutivi all''anno',true);
 -- linee per altre attività 6.1c
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20754,'Fabbricazione in installazioni industriali di c) uno o più dei seguenti pannelli a base legno: 
pannelli a fibre orientate (pannelli OSB), pannelli truciolari o pannelli di fibre, con capacità di produzione superiore a 600 m3 al giorno',true);
 -- linee per altre attività 6.1b 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20755,'Fabbricazione in installazioni industriali di carta e cartoni con capacità di produzione superiore a 20 Mg algiorno',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20755,'Produzione di pasta per carta, carta e prodotti della carta',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20755,'Impianti industriali destinati alla fabbricazione: b) di carta e cartoni con capacità di produzione superiore a 20 tonnellate al giorno',true);
 -- linee per altre attività 6.5 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20756,'Impianti per l''eliminazione o il recupero di carcasse e di residui di animali con una capacità di trattamento di oltre 10 tonnellate al giorno.',true);
-- linee per altre attività 6.7 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20757,'Impianti per il trattamento di superficie di materie, oggetti o prodotti utilizzando 
solventi organici, in particolare per apprettare, stampare, spalmare, sgrassare, impermeabilizzare, incollare, verniciare, pulire o impregnare, con una capacità di consumo di solvente
 superiore a 150 kg all''ora o a 200 tonnellate all''anno',true);
 -- linee per altre attività 6.4c 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20758,'Trattamento e trasformazione del latte, con un quantitativo di latte ricevuto di oltre 200 tonnellate al giorno (valore medio su base annua)',true);
 -- linee per altre attività 6.6a 
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20759,'Allevamento intensivo di pollame',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20759,'Ampliamento impianto per allevamento intensivo di pollame con piu'' di 60.000 posti per galline',true);
insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20759,'Impianti per l''allevamento intensivo di pollame o di suini con più di: a) 40.000 posti pollame',true);
 -- linee per altre attività 6.11 
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20760,'Attività di trattamento a gestione indipendente di acque reflue non coperte dalle norme di recepimento della direttiva 91/271/CEE ed evacuate 
 da un''installazione in cui è svolta una delle attività di cui al presente allegato.',true);
--------------------------------------------------------------------- 21/03
 -- linee per da lanciare per attività energetiche 1.1
  insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20725,'Impianti di combustione con potenza termica di combustione di oltre 50 MW',true);
 -- linee per da lanciare per rifiuti 5.1 da lanciare
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20761,'Impianti per l''eliminazione o il ricupero di rifiuti pericolosi, della lista di cui all''art. 1, 
   paragrafo 4, della direttiva 91/689/CEE quali definiti negli allegati II A e II B (operazioni R 1, R 5, R 6, R 8 e R 9) della direttiva 75/442/CEE e nella direttiva 75/439/CEE del 16 giugno 1975 
   del Consiglio, concernente l''eliminazione degli oli usati, con capavità di oltre 10 tonnellate al giorno',true);
   -- 5.1b
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20726,'Lo smaltimento o il recupero di rifiuti pericolosi, con capacità di oltre 10 Mg al giorno,
    che comporti il ricorso ad una o più delle seguenti attività: b) trattamento chimico-fisico',true);
    -- 5.1b-c = 5.1bc 
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20727,'Lo smaltimento o il recupero di rifiuti pericolosi, con capacità di oltre 10 Mg al giorno, 
   che comporti il ricorso ad una o più delle seguenti attività: b) trattamento chimico-fisico c) dosaggio o miscelatura prima di una delle altre attività di cui ai punti 5.1 e 5.2',true);
   -- 5.e
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20729,'Lo smaltimento o il recupero di rifiuti pericolosi, con capacità di oltre 10 Mg al giorno, che comporti 
   il ricorso ad una o più delle seguenti attività: e) rigenerazione/recupero dei solventi',true);
    -- 5.3 (diventa al psoto di 5.1bc)
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20728,'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 
   75/442/CEE ai punti D 8, D 9 con capacità superiore a 50 tonnellate al giorno. ',true);
   -- 5.3a
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20730,'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 75/442/CEE ai punti D 8, 
   D 9 con capacità superiore a 50 tonnellate al giorno:  1) trattamento biologico;  2) trattamento chimico-fisico; 3) pretrattamento dei rifiuti destinati all''incenerimento o al coincenerimento; 
   4) trattamento di scorie e ceneri  5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti.',true);
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20728,'Lo smaltimento dei rifiuti non pericolosi, con capacità superiore a 50 Mg al giorno, che comporta il ricorso ad una o 
   più delle seguenti attività ed escluse le attività di trattamento delle acque reflue urbane, disciplinate al paragrafo 1.1 dell''Allegato 5 alla Parte Terza: 1) trattamento biologico; 2)trattamento fisico-chimico; ',true);
   -- 5.3a-3.b
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20731,'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 
   75/442/CEE ai punti D 8, D 9 con capacità superiore a 50 tonnellate al giorno:  1) trattamento biologico;  2) trattamento chimico-fisico;  3) pretrattamento dei rifiuti destinati all''incenerimento 
   o al coincenerimento;  4) trattamento di scorie e ceneri;  5) trattamento in frantumatori di rifiuti metalli, compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso 
   e relativi componenti.',true);
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20731,'Impianti per il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, 
   con una capacità superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attività ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate 
   al paragrafo 1.1 dell''Allegato 5 alla Parte Terza:',true);
   -- 5.3a1-5.3a2
  insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20732,'Impianti per l''eliminazione dei rifiuti non pericolosi quali definiti nell''allegato 11 A della direttiva 
   75/442/CEE ai punti D 8, D 9 con capacità superiore a 50 tonnellate al giorno:  1) trattamento biologico;  2) trattamento chimico-fisico;',true);
   ---5.3b
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20733,'Impianti per il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi,
   con una capacità superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attività ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate al 
   paragrafo 1.1 dell''Allegato 5 alla Parte Terza',true);
   --5.3b.1
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20734,'Il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, 
   con una capacità superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attività ed escluse le attivita'' di trattamento delle acque reflue urbane, 
   disciplinate al paragrafo 1.1 dell''Allegato 5 alla Parte Terza: 1) trattamento biologico. ',true);
   --5.3.b.4
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20735,'Il recupero, o una combinazione di recupero e smaltimento, di rifiuti non pericolosi, con una capacità superiore a 
   75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attività ed escluse le attività di trattamento delle acque reflue urbane. Trattamento in frantumatori di rifiuti metallici, 
   compresi i rifiuti di apparecchiature elettriche ed elettroniche e i veicoli fuori uso e relativi componenti, con una capacità massima di trattamento degli impianti di 360 Mg/g',true);
   -- 5.3b2
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20736,'Impianti per il recupero o una combinazione di recupero e smaltimento, di rifiuti non pericolosi,
   con una capacità superiore a 75 Mg al giorno, che comportano il ricorso ad una o più delle seguenti attività ed escluse le attivita'' di trattamento delle acque reflue urbane, disciplinate al 
   paragrafo 1.1 dell''Allegato 5 alla Parte Terza',true);
   -- 5.4
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20737,'Discariche che ricevono più di 10 tonnellate al giorno o con una capacità totale di oltre 25.000 tonnellate, 
   ad esclusione delle discariche per i rifiuti inerti.',true);
   -- 5.5
   insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20738,'Accumulo temporaneo di rifiuti pericolosi non comtemplati al punto 5.4 prima di una delle attività elencate ai punti 
   5.1, 5.2, 5.4 e 5.6 con una capacità totale superiore a 50 Mg, eccetto il deposito temporaneo, prima della raccolta, nel luogo in cui sono generati i rifiuti',true);
 ---------------------------- industria chimica 
 --4.1b
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20739,'Impianti chimici per la fabbricazione di prodotti chimici organici di base come: b) idrocarburi ossigenati, 
 segnatamente alcoli, aldeidi, chetoni, acidi carbossilici, esteri, acetati, eteri, perossidi, resine, epossidi ',true);
 --4.1g-4.1h
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20740,'Impianti chimici per la fabbricazione di prodotti chimici organici di base come: g) composti organometallici  
 e  h) materie plastiche di base (polimeri, fibre sintetiche, fibre a base di cellulosa)',true);
  --4.2a
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20741,'fabbricazione di prodotti chimici inorganici e in particolare: a) gas, quali ammoniaca, cloro o cloruro di idrogeno, 
 fluoro e fluoruro di idrogeno, ossidi di carbonio, composti di zolfo, ossidi di azoto, idrogeno, biossido di zolfo, bicloruro di carbonile',true);
  --4.5
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20742,'Fabbricazione di prodotti farmaceutici compresi i prodotti intermedi',true);
 ---------------------------- industria prodotti minerale 
  --3.1
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20743,'Impianti destinati alla produzione di clinker (cemento) in forni rotativi la cui capacità di produzione supera 500 tonnellate 
 al giorno oppure di calce viva in forni rotativi la cui capacità di produzione supera 50 tonnellate al giorno, o in altri tipi di forno aventi una capacità di produzione di  oltre 50 tonnellate al giorno ',true);
  --3.3
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20744,'Impianti per la fabbricazione del vetro compresi quelli destinati alla produzione di fibre di vetro, con capacità 
 di fusione di oltre 20 tonnellate al giorno.',true);
  ---------------------------- prod e trasf metalli
  --2.1
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20745,'Impianti di arrostimento o sinterizzazione di minerali metallici compresi i minerali solforati.',true);
  --2.3a
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20746,'Impianti destinati alla trasformazione di metalli ferrosi mediante: a) laminazione a caldo con una capacità 
 superiore a 20 tonnellate di acciaio grezzo all''ora ',true);
  --2.3c
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20747,'Impianti destinati alla trasformazione di metalli ferrosi mediante: c) applicazione di strati protettivi di 
 metallo fuso con una capacità di trattamento superiore a 2 Mg di acciaio grezzo all''ora',true);
 --2.4
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20748,'Funzionamento di fonderie di metalli ferrosi con una capacità di produzione superiore a 20 Mg al giorno.',true);
 --2.5b
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20749,'Impianti: b) di fusione e lega di metalli non ferrosi, compresi i prodotti di recupero (affinazione, formatura in fonderia), 
 con una capacità di fusione superiore a 4 tonnellate al giorno per il piombo e il cadmio o a 20 tonnellate al giorno per tutti gli altri metalli',true);
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20749,'lavorazione di metalli non ferrosi: b) di fusione e lega di metalli non ferrosi, compresi i prodotti di recupero e funzionamento di 
 fonderie di metalli non ferrosi, con una capacità di fusione superiore a 4 Mg al giorno per il piombo e il cadmio o a 20 Mg al giorno per tutti gli altri metalli ',true);
 --2.6
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20750,'Trattamento di superficie di metalli e/o materie plastiche mediante processi elettrolitici o chimici qualora le 
 vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m³.',true);
 insert into master_list_linea_attivita (id_aggregazione, linea_attivita, enabled) values(20750,'Impianti per il trattamento di superficie di metalli e materie plastiche mediante processi elettrolitici o 
 chimici qualora le vasche destinate al trattamento utilizzate abbiano un volume superiore a 30 m3',true);


update master_list_macroarea set codice_sezione = concat('M',id);
update master_list_aggregazione set codice_attivita  = concat('A',id);
update master_list_linea_attivita set codice_prodotto_specie = concat('L',id);


CREATE OR REPLACE VIEW master_list_view AS
SELECT master_list_macroarea.id as id_nuova_linea_attivita,
         true as enabled,
          master_list_macroarea.id as id_macroarea,
           null::integer  as id_aggregazione,
          null::integer  as id_attivita,
          master_list_macroarea.codice_sezione as  codice_macroarea,
          '' as codice_aggregazione,
          '' as codice_attivita,
           master_list_macroarea.macroarea,
           '' as aggregazione,
           '' as attivita,
           master_list_macroarea.id_norma,
           master_list_macroarea.norma,
           norme.codice_norma,
	   master_list_macroarea.macroarea as descrizione,
	   1 as livello,
           -1 as id_padre,
           '-1'::character varying(1000) AS path_id,
           master_list_macroarea.macroarea::character varying(1000) AS path_desc,
           master_list_macroarea.codice_sezione as codice,
           master_list_macroarea.codice_sezione::character varying(1000) AS path_codice
           FROM master_list_macroarea  
           left join opu_lookup_norme_master_list norme on norme.code = master_list_macroarea.id_norma
          
        UNION ALL
         SELECT t.id as id_nuova_linea_attivita ,true as enabled, t.id_macroarea as id_macroarea,
          t.id as id_aggregazione,
          null::integer as id_attivita,
           rt.codice_sezione as codice_macroarea,
           t.codice_attivita as codice_aggregazione,
           '' as codice_attivita,
           rt.macroarea,
           t.aggregazione,
           '' as attivita,
           rt.id_norma,
            rt.norma,
            norme2.codice_norma,
            t.aggregazione as descrizione,
            2 as livello, 
            t.id_macroarea as id_padre, 
            (((rt.id::text || ';'::text) || t.id))::character varying(1000) AS path_id,
            (((rt.macroarea::text || '->'::text) || t.aggregazione))::character varying(1000) AS path_desc,
            t.codice_attivita as codice,
           (((rt.codice_sezione::text || '->'::text) || t.codice_attivita))::character varying(1000) AS path_codice
           FROM master_list_aggregazione t
             JOIN master_list_macroarea rt ON rt.id = t.id_macroarea
            left join opu_lookup_norme_master_list norme2 on norme2.code = rt.id_norma
          UNION ALL
          SELECT a.id as id_nuova_linea_attivita, true as enabled, 
          rt3.id as id_macroarea,
           rt2.id as id_aggregazione, 
           a.id as id_attivita,
           rt3.codice_sezione as codice_macroarea,
           rt2.codice_attivita as codice_aggregazione,
           a.codice_prodotto_specie as codice_attivita,
		rt3.macroarea,
		rt2.aggregazione,
           a.linea_attivita as attivita,
           rt3.id_norma,
           norme3.codice_norma,
           rt3.norma,
           a.linea_attivita as descrizione,
           3 as livello, 
           a.id_aggregazione as id_padre, 
           (((rt3.id::text || ';'::text) ||(rt2.id::text || ';'::text) || a.id))::character varying(1000) AS path_id,
           (((rt3.macroarea::text || '->'::text) ||(rt2.aggregazione::text || '->'::text) || a.linea_attivita))::character varying(1000) AS path_desc,
           concat_ws('-',rt3.codice_sezione, rt2.codice_attivita, a.codice_prodotto_specie) as codice,
           (((rt3.codice_sezione::text || '->'::text) ||(rt2.codice_attivita::text || '->'::text) || a.codice_prodotto_specie))::character varying(1000) AS path_codice
        FROM master_list_linea_attivita a
          JOIN master_list_aggregazione rt2 ON rt2.id = a.id_aggregazione
            JOIN master_list_macroarea rt3 ON rt3.id = rt2.id_macroarea
     left join opu_lookup_norme_master_list norme3 on norme3.code = rt3.id_norma
           

CREATE OR REPLACE FUNCTION public.insert_into_ml_materializzata(IN _id_linea integer default null::integer)
  RETURNS integer AS
$BODY$
DECLARE

BEGIN

insert into ml8_linee_attivita_nuove_materializzata (
 id_nuova_linea_attivita, enabled, id_macroarea, id_aggregazione, id_attivita, codice_macroarea, codice_aggregazione, codice_attivita, macroarea, aggregazione,
 attivita, id_norma, norma, descrizione, livello, id_padre, path_id, path_descrizione, codice, path_codice
) select id_nuova_linea_attivita, enabled, id_macroarea, id_aggregazione, id_attivita, codice_macroarea, codice_aggregazione, codice_attivita, macroarea, aggregazione,
 attivita, id_norma, norma, descrizione, livello, id_padre, path_id, path_desc, codice, path_codice from master_list_view 
 where 1=1
 and (_id_linea is null or id_nuova_linea_attivita = _id_linea);

       return 1;


 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.insert_into_ml_materializzata(integer)
  OWNER TO postgres;

-- popolo ml8
select * from insert_into_ml_materializzata()

select 'insert into master_list_flag_linee_attivita (codice_univoco, mobile, fisso, apicoltura, registrabili, riconoscibili, sintesis, bdu, vam, categorizzabili, no_scia) values 
('''||codice||''',false, true, false, true, false, false, false, false, false, false);' from ml8_linee_attivita_nuove_materializzata  where livello=3;

select 'update master_list_linea_attivita set codice_univoco='''||codice||''' where id = '||id_attivita||';' 
from ml8_linee_attivita_nuove_materializzata  where livello=3

update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ãˆ', 'E''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ã ', 'a''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ã¨', 'e''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ã¬', 'i''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ã²', 'u''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'Ã¹', 'u''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'à', 'a''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'è', 'e''');
update master_list_linea_attivita set linea_attivita = replace (linea_attivita, 'ì ', 'i''');

select * from master_list_linea_attivita 
delete from ml8_linee_attivita_nuove_materializzata ; 
select * from insert_into_ml_materializzata()



CREATE OR REPLACE VIEW public.ricerca_anagrafiche AS 
 SELECT DISTINCT o.id_stabilimento AS riferimento_id,
    'stabId'::text AS riferimento_id_nome,
    'id_stabilimento'::text AS riferimento_id_nome_col,
    'opu_stabilimento'::text AS riferimento_id_nome_tab,
    o.id_indirizzo_operatore AS id_indirizzo_impresa,
    o.id_indirizzo AS id_sede_operativa,
    '-1'::integer AS sede_mobile_o_altro,
    'opu_indirizzo'::text AS riferimento_nome_tab_indirizzi,
    o.id_opu_operatore AS id_impresa,
    'opu_operatore'::text AS riferimento_nome_tab_impresa,
    o.id_soggetto_fisico,
    'opu_soggetto_fisico'::text AS riferimento_nome_tab_soggetto_fisico,
    o.id_linea_attivita_stab AS id_attivita,
    o.pregresso_o_import,
    o.riferimento_org_id,
    o.stab_entered AS data_inserimento,
    o.ragione_sociale,
    o.id_asl_stab AS asl_rif,
    o.stab_asl AS asl,
    o.codice_fiscale_impresa AS codice_fiscale,
    o.cf_rapp_sede_legale AS codice_fiscale_rappresentante,
    o.partita_iva,
    o.categoria_rischio,
    o.data_prossimo_controllo AS prossimo_controllo,
        CASE
            WHEN o.linea_codice_ufficiale_esistente ~~* 'U150%'::text THEN o.linea_codice_nazionale
            ELSE COALESCE(o.linea_codice_nazionale, o.linea_codice_ufficiale_esistente)
        END AS num_riconoscimento,
    o.numero_registrazione AS n_reg,
        CASE
            WHEN norme.codice_norma = '852-04'::text THEN COALESCE(NULLIF(o.linea_codice_nazionale, ''::text), NULLIF(o.linea_numero_registrazione, ''::text), NULLIF(o.linea_codice_ufficiale_esistente, ''::text))
            ELSE COALESCE(NULLIF(o.linea_codice_nazionale, ''::text), NULLIF(o.linea_codice_ufficiale_esistente, ''::text), NULLIF(o.linea_numero_registrazione, ''::text))
        END AS n_linea,
    concat_ws(' '::text, o.nome_rapp_sede_legale, o.cognome_rapp_sede_legale) AS nominativo_rappresentante,
    o.stab_descrizione_attivita AS tipo_attivita_descrizione,
    o.stab_id_attivita AS tipo_attivita,
    o.data_inizio_attivita,
    o.data_fine_attivita,
    o.linea_stato_text AS stato,
    o.linea_stato AS id_stato,
        CASE
            WHEN o.stab_id_attivita = 1 THEN o.comune_stab
            WHEN o.stab_id_attivita = 2 AND o.impresa_id_tipo_impresa = 1 THEN o.comune_residenza
            WHEN o.stab_id_attivita = 2 AND o.impresa_id_tipo_impresa <> 1 THEN o.comune_sede_legale
            ELSE o.comune_stab
        END AS comune,
    o.prov_stab AS provincia_stab,
    concat(o.indirizzo_stab, ' ', o.civico_sede_stab) AS indirizzo,
    o.cap_stab,
    o.lat_stab AS latitudine_stab,
    o.long_stab AS longitudine_stab,
    o.comune_sede_legale AS comune_leg,
    o.prov_sede_legale AS provincia_leg,
    o.indirizzo_sede_legale AS indirizzo_leg,
    o.cap_sede_legale AS cap_leg,
    NULL::double precision AS latitudine_leg,
    NULL::double precision AS longitudine_leg,
    o.macroarea,
    o.aggregazione,
    o.attivita,
    o.path_attivita_completo,
        CASE
            WHEN o.flag_nuova_gestione IS NULL OR o.flag_nuova_gestione = false THEN 'LINEA NON AGGIORNATA SECONDO MASTER LIST.'::text
            ELSE NULL::text
        END AS gestione_masterlist,
    norme.description AS norma,
    o.id_norma,
    999 AS tipologia_operatore,
    --m.targa,
    1 AS tipo_ricerca_anagrafica,
    'gray'::text AS color,
    o.linea_codice_ufficiale_esistente AS n_reg_old,
    o.id_tipo_linea_produttiva AS id_tipo_linea_reg_ric,
    --o.id_controllo_ultima_categorizzazione,
    o.id_linea_attivita AS id_linea,
    --d.matricola,
    o.codice_macroarea,
    o.codice_aggregazione,
    o.codice_attivita_only AS codice_attivita,
    NULL::boolean AS miscela
   FROM opu_operatori_denormalizzati_view o
   --  LEFT JOIN opu_stabilimento_mobile m ON m.id_stabilimento = o.id_stabilimento
    -- LEFT JOIN opu_stabilimento_mobile_distributori d ON d.id_rel_stab_linea = o.id_linea_attivita
     LEFT JOIN opu_lookup_norme_master_list norme ON o.id_norma = norme.code;

ALTER TABLE public.ricerca_anagrafiche
  OWNER TO postgres;

  

CREATE OR REPLACE VIEW public.opu_operatori_denormalizzati_view AS 
 SELECT DISTINCT
        CASE
            WHEN stab.flag_dia IS NOT NULL THEN stab.flag_dia
            ELSE false
        END AS flag_dia,
    o.id AS id_opu_operatore,
    o.ragione_sociale,
    o.partita_iva,
    o.codice_fiscale_impresa,
    (((
        CASE
            WHEN topsedeop.description IS NOT NULL THEN topsedeop.description
            ELSE ''::character varying
        END::text || ' '::text) || sedeop.via::text) || ' '::text) ||
        CASE
            WHEN sedeop.civico IS NOT NULL THEN sedeop.civico
            ELSE ''::text
        END AS indirizzo_sede_legale,
    comunisl.nome AS comune_sede_legale,
    comunisl.istat AS istat_legale,
    sedeop.cap AS cap_sede_legale,
    provsedeop.description AS prov_sede_legale,
    o.note,
    o.entered,
    o.modified,
    o.enteredby,
    o.modifiedby,
    o.domicilio_digitale,
    o.flag_ric_ce,
    o.num_ric_ce,
    i.comune,
    stab.id_asl,
    stab.id AS id_stabilimento,
    stab.esito_import,
    stab.data_import,
    stab.cun,
    stab.id_sinvsa,
    stab.descrizione_errore,
    comuni1.nome AS comune_stab,
    comuni1.istat AS istat_operativo,
    ((
        CASE
            WHEN topsedestab.description IS NOT NULL THEN topsedestab.description
            ELSE ''::character varying
        END::text || ' '::text) || sedestab.via::text) || ' '::text AS indirizzo_stab,
    sedestab.cap AS cap_stab,
    provsedestab.description AS prov_stab,
    stab.data_fine_dia,
    stab.categoria_rischio,
    soggsl.codice_fiscale AS cf_rapp_sede_legale,
    soggsl.nome AS nome_rapp_sede_legale,
    soggsl.cognome AS cognome_rapp_sede_legale,
    stab.numero_registrazione AS codice_registrazione,
    latt.id_norma,
    latt.codice_attivita AS cf_correntista,
    latt.codice_attivita,
    lps.primario,
    (((latt.macroarea || '->'::text) || latt.aggregazione) || '->'::text) || latt.attivita AS attivita,
    lps.data_inizio,
    lps.data_fine,
    stab.numero_registrazione,
    concat_ws(' '::text, topsoggind.description, soggind.via, soggind.civico,
        CASE
            WHEN comunisoggind.id > 0 THEN comunisoggind.nome::text
            ELSE soggind.comune_testo
        END, concat('(', provsoggind.cod_provincia, ')'), soggind.cap) AS indirizzo_rapp_sede_legale,
    stati.description AS stato,
    latt.attivita AS solo_attivita,
    stab.data_inizio_attivita,
    stab.data_fine_attivita,
    stab.data_prossimo_controllo,
    stab.stato AS id_stato,
    latt.path_descrizione AS path_attivita_completo,
    stab.id_indirizzo,
    stab.linee_pregresse,
    true AS flag_nuova_gestione,
    loti.description AS tipo_impresa,
    lotis.description AS tipo_societa,
    stab.codice_ufficiale_esistente,
    stab.id_asl AS id_asl_stab,
    lps.id AS id_linea_attivita,
    lps.modified AS data_mod_attivita,
    stab.entered AS stab_entered,
    lps.numero_registrazione AS linea_numero_registrazione,
    lps.stato AS linea_stato,
    statilinea.description AS linea_stato_text,
    lps.codice_ufficiale_esistente AS linea_codice_ufficiale_esistente,
    stab.codice_ufficiale_esistente AS stab_codice_ufficiale_esistente,
    sedeop.id AS id_indirizzo_operatore,
    stab.import_opu,
    lps.id_linea_produttiva AS id_linea_attivita_stab,
    o.note AS note_operatore,
    stab.note AS note_stabilimento,
    lps.codice_nazionale AS linea_codice_nazionale,
    latt.flag_pnaa,
    (con.namefirst::text || ' '::text) || con.namelast::text AS stab_inserito_da,
        CASE
            WHEN ml.fisso THEN 1
            WHEN stab.tipo_attivita = 1 THEN 1
            WHEN ml.mobile OR latt.codice_macroarea = 'MS.090'::text THEN 2
            WHEN stab.tipo_attivita = 2 THEN 2
            ELSE '-1'::integer
        END AS stab_id_attivita,
        CASE
            WHEN ml.fisso THEN 'Con Sede Fissa'::text
            WHEN stab.tipo_attivita = 1 THEN 'Con Sede Fissa'::text
            WHEN ml.mobile OR latt.codice_macroarea = 'MS.090'::text THEN 'Senza Sede Fissa'::text
            WHEN stab.tipo_attivita = 2 THEN 'Senza Sede Fissa'::text
            ELSE 'N.D.'::text
        END AS stab_descrizione_attivita,
    stab.tipo_carattere AS stab_id_carattere,
    lsc.description AS stab_descrizione_carattere,
    o.tipo_impresa AS impresa_id_tipo_impresa,
    asl.description AS stab_asl,
    o.flag_clean,
    stab.data_generazione_numero,
    sedestab.latitudine AS lat_stab,
    sedestab.longitudine AS long_stab,
    lps.entered AS linea_entered,
    lps.modified AS linea_modified,
    latt.macroarea,
    latt.aggregazione,
    latt.attivita AS attivita_xml,
    comuni1.codiceistatasl_old,
    provsedestab.cod_provincia AS sigla_prov_operativa,
    provsedeop.cod_provincia AS sigla_prov_legale,
    provsoggind.cod_provincia AS sigla_prov_soggfisico,
    comunisoggind.nome AS comune_residenza,
    soggsl.data_nascita AS data_nascita_rapp_sede_legale,
    lotis.code AS impresa_id_tipo_societa,
    soggsl.comune_nascita AS comune_nascita_rapp_sede_legale,
    soggsl.sesso,
    soggind.civico,
    topsoggind.description AS toponimo_residenza,
    soggind.toponimo AS id_toponimo_residenza,
    sedeop.civico AS civico_sede_legale,
    sedeop.toponimo AS tiponimo_sede_legale,
    topsedeop.description AS toponimo_sede_legale,
    sedestab.civico AS civico_sede_stab,
    sedestab.toponimo AS tiponimo_sede_stab,
    topsedestab.description AS toponimo_sede_stab,
    soggind.via AS via_rapp_sede_legale,
    sedeop.via AS via_sede_legale,
        CASE
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 1 THEN comuni1.id
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 2 THEN comunisoggind.id
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 1 THEN comuni1.id
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 2 THEN comunisl.id
            ELSE NULL::integer
        END AS id_comune_richiesta,
        CASE
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 1 THEN comuni1.nome
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 2 THEN comunisoggind.nome
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 1 THEN comuni1.nome
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 2 THEN comunisl.nome
            ELSE NULL::character varying
        END AS comune_richiesta,
        CASE
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 1 THEN btrim(sedestab.via::text)::character varying
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 2 THEN btrim(soggind.via::text)::character varying
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 1 THEN btrim(sedestab.via::text)::character varying
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 2 THEN btrim(sedeop.via::text)::character varying
            ELSE NULL::character varying
        END AS via_stabilimento_calcolata,
        CASE
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 1 THEN btrim(sedestab.civico)::character varying
            WHEN o.tipo_impresa = 1 AND stab.tipo_attivita = 2 THEN btrim(soggind.civico)::character varying
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 1 THEN btrim(sedestab.civico)::character varying
            WHEN o.tipo_impresa <> 1 AND stab.tipo_attivita = 2 THEN btrim(sedeop.civico)::character varying
            ELSE NULL::character varying
        END AS civico_stabilimento_calcolato,
    soggind.cap AS cap_residenza,
    soggind.nazione AS nazione_residenza,
    sedeop.nazione AS nazione_sede_legale,
    sedestab.nazione AS nazione_stab,
    latt.id_lookup_tipo_linee_mobili,
    '-1'::integer AS id_tipo_linea_produttiva,
    rels.id_soggetto_fisico,
    lps.pregresso_o_import,
    stab.riferimento_org_id,
    --stab.id_controllo_ultima_categorizzazione,
    latt.codice_macroarea,
    latt.codice_aggregazione,
    latt.codice_attivita AS codice_attivita_only
   FROM opu_operatore o
     JOIN opu_rel_operatore_soggetto_fisico rels ON rels.id_operatore = o.id AND rels.enabled
     JOIN opu_soggetto_fisico soggsl ON soggsl.id = rels.id_soggetto_fisico
     LEFT JOIN opu_indirizzo soggind ON soggind.id = soggsl.indirizzo_id
     LEFT JOIN comuni1 comunisoggind ON comunisoggind.id = soggind.comune
     LEFT JOIN opu_indirizzo sedeop ON sedeop.id = o.id_indirizzo
     LEFT JOIN comuni1 comunisl ON sedeop.comune = comunisl.id
     JOIN opu_stabilimento stab ON stab.id_operatore = o.id
     JOIN opu_relazione_stabilimento_linee_produttive lps ON lps.id_stabilimento = stab.id AND lps.enabled
     LEFT JOIN lookup_stato_lab stati ON stati.code = stab.stato
     JOIN ml8_linee_attivita_nuove_materializzata latt ON latt.id_nuova_linea_attivita = lps.id_linea_produttiva
     LEFT JOIN master_list_flag_linee_attivita ml ON ml.codice_univoco = latt.codice
     JOIN opu_indirizzo sedestab ON sedestab.id = stab.id_indirizzo
     LEFT JOIN comuni1 ON sedestab.comune = comuni1.id
     LEFT JOIN opu_indirizzo i ON i.id = stab.id_indirizzo
     LEFT JOIN lookup_province provsedestab ON provsedestab.code::text = sedestab.provincia::text
     LEFT JOIN lookup_province provsedeop ON provsedeop.code::text = sedeop.provincia::text
     LEFT JOIN lookup_province provsoggind ON provsoggind.code::text = soggind.provincia::text
     LEFT JOIN lookup_toponimi topsedeop ON sedeop.toponimo = topsedeop.code
     LEFT JOIN lookup_toponimi topsedestab ON sedestab.toponimo = topsedestab.code
     LEFT JOIN lookup_toponimi topsoggind ON soggind.toponimo = topsoggind.code
     LEFT JOIN lookup_opu_tipo_impresa loti ON loti.code = o.tipo_impresa
     LEFT JOIN lookup_opu_tipo_impresa_societa lotis ON lotis.code = o.tipo_societa
     LEFT JOIN lookup_stato_lab statilinea ON statilinea.code = lps.stato
     LEFT JOIN access acc ON acc.user_id = stab.entered_by
     LEFT JOIN contact con ON con.contact_id = acc.contact_id
     LEFT JOIN opu_lookup_tipologia_carattere lsc ON lsc.code = stab.tipo_carattere
     LEFT JOIN lookup_site_id asl ON asl.code = stab.id_asl
  WHERE o.trashed_date IS NULL AND stab.trashed_date IS NULL AND stab.trashed_date IS NULL;

ALTER TABLE public.opu_operatori_denormalizzati_view
  OWNER TO postgres;


