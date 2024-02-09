INSERT INTO public.permission_category(
            category, description, level, enabled, active, folders, 
            lookups, viewpoints, categories, scheduled_events, object_events, 
            reports, webdav, logos, constant, action_plans, custom_list_views)
VALUES ('ITER', 'ITER', 80,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,14,FALSE,FALSE);


insert into permission (category_id,permission,permission_view,permission_add,permission_edit,permission_delete,description , level,enabled,active)
values ((select category_id from permission_category where category = 'ITER'),'iter',true,true,true,true,'GESTIONE CAVALIERE ITER',1,true,true) returning permission_id;

insert into role_permission (role_id, permission_id, role_view) values (1,(select permission_id from permission where permission = 'iter'),true); 
insert into role_permission (role_id, permission_id, role_view) values (32,(select permission_id from permission where permission = 'iter'),true); 


CREATE TABLE iter_cartografie(id serial primary key, nome text, descrizione text, url text, level integer default 0, entered timestamp without time zone default now(), enabled boolean default true, note_hd text);

insert into iter_cartografie(nome, descrizione, url) values (
'Pale Eoliche',
'Anagrafe FER relativa agli impianti eolici, Autorizzati ed in fase Istruttoria, al fine di consentire, per i nuovi impianti, un corretto inserimento ed una mitigazione dell''impatto sul paesaggio;',
'https://itergis.regione.campania.it/maplite/?mapID=8760-4052&x=14.912238359240737&y=40.98005476924932&zoom=10&baseMap=GOOGLE_SATELLITE#map=152.8740565703525/1660022.78/5009400.19/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Acqua disponibile nel suolo',
'La mappa, elaborata dalla carta dei suoli della Campania, fornisce il valore dell''acqua disponibile nel suolo agricolo. Viene utilizzata per determinare il deficit idrico nei procedimenti di deroga invernale allo spandimento agronomico dei reflui zootecnici (DGR 585/2020).',
'https://itergis.regione.campania.it/maplite/?mapID=8413-3605&x=14.755157470510543&y=40.8351317001947&zoom=9&baseMap=GOOGLE_SATELLITE#map=305.748113140705/1642536.62/4988053.96/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Aree ZES Campania',
'      La Direzione Generale 02 Attività produttive con il supporto dello Staff Tecnico Operativo 50.09.92 ha realizzato la mappatura delle aree ZES categorizzandole in 5 strati informativi:
<ul>
<li>Aree ZES disponibili, in cui sono presenti edifici o lotti disponibili per l''impianto di una attività industriale; </li>
<li>Aree in cui non sono presenti edifici o lotti disponibili per l''impianto di una attività industriale;  </li>
<li>Aree ZES per le quali i consorzi non hanno, al momento, fornito dati di dettaglio concernenti eventuali edifici o lotti disponibili;  </li>
<li>Edifici disponibili per l''impianto di una attività industriale;  </li>
<li>Lotti disponibili per l''impianto di una attività industriale; </li>
</ul>',
'https://itergis.regione.campania.it/maplite/?mapID=8600-3350&x=14.329544544086135&y=40.88925248559953&zoom=11&baseMap=GOOGLE_SATELLITE#map=76.43702828517625/1595157.6/4996020.13/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Pericolositá Frane',
'      Mappa realizzata da Staff Tecnico Operativo 50.09.92<br/>
      La mappa è composta da:<ul>
<li>Reticolo idrografico principale e secondario (fonte dati 1:25.000 CTR 2011) con specifici relativi toponimi (fonte dati IGM 1:25.000 1909 e 1956 - ex CASMEZ 1:5.000 1978 – 1980);</li>
<li>Limiti comunali CTR 2011</li>
<li> Pericolosità Frane (perimetrazioni di origine Autorità di Bacino – omogeneizzazione realizzata dall''ISPRA - fonte dati ISPRA – PCN).</li></ul>',
'https://itergis.regione.campania.it/maplite/?mapID=7660-4052&x=15.25404968830764&y=40.44243464795084&zoom=18&baseMap=GOOGLE_SATELLITE#map=4.777314267823516/1698637.96/4930308.47/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Pericolositá Idraulica',
'      Mappa realizzata da Staff Tecnico Operativo 50.09.92<br/>
      La mappa è composta da:<ul>
<li>reticolo idrografico principale e secondario (fonte dati 1:25.000 CTR 2011) con specifici relativi toponimi (fonte dati IGM 1:25.000 1909 e 1956 - ex CASMEZ 1:5.000 1978 - 1980) ;</li>
<li>Limiti comunali CTR 2011;</li>
<li>Pericolositá Idraulica (perimetrazioni di origine Autoritá di Bacino – omogeneizzazione realizzata dall''ISPRA - fonte dati ISPRA – PCN).</li></ul>',
'https://itergis.regione.campania.it/maplite/?mapID=7659-4052&x=14.505561828455386&y=40.74418727727144&zoom=14&baseMap=GOOGLE_SATELLITE#map=9.554628535647032/1612611.52/4973239.51/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Catasto Impianti Rifiuti',
'La Direzione Generale Ciclo integrato delle Acque – Osservatorio rifiuti ha realizzato il Catasto Impianti Georeferenziato integrato nella piattaforma iTer Campania dove è possibile visualizzare un estratto della banca dati degli impianti autorizzati alla gestione rifiuti in Campania aggiornata a dicembre 2020, pubblicata sul portale regionale e raggiungibile dal portale regionale attraverso il percorso Ambiente, Osservatori ambientali, Catasto impianti georeferenziato;',
'https://itergis.regione.campania.it/maplite/?mapID=8387-4557&x=14.80452144741738&y=40.761647150375694&zoom=9&baseMap=GOOGLE_SATELLITE#map=305.748113140705/1648031.79/4977247.99/0');

insert into iter_cartografie(nome, descrizione, url) values (
'Il Catasto Incendi Boschivi',
'      Il servizio è aggiornato all''annualità 2019 e mira a predisporre le modalità di aggiornamento dinamico nel tempo, a partire dal 2008, della perimetrazione delle aree bruciate a partire dai dati comunicati dagli enti interessati quali il Corpo Forestale dello Stato per l''intero territorio regionale.

<ul>
<li>Predisporre le modalità di aggiornamento, dinamico nel tempo, della perimetrazione delle aree bruciate a partire dai dati comunicati dagli enti interessati quali il Corpo Forestale dello Stato;</li>
<li>Consentire agli operatori comunali la verifica e la gestione, in banca dati, dei dati relativi all''apposizione del vincolo e il documento integrale del vincolo medesimo per ogni area incendiata accatastata;</li>
<li>Predisporre una funzionalità di reportistica avanzata per l''utente regionale.</li>

        </ul>',
'https://itergis.regione.campania.it/maplite/?mapID=8610-3400&x=13.374999999999694&y=42.32899999999987&zoom=5&baseMap=GOOGLE_SATELLITE#map=76.43702828517625/1596528.6/5002137.17/0');


update iter_cartografie set level = id;