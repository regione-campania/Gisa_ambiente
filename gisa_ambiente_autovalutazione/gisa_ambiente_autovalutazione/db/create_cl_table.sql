CREATE TABLE IF NOT EXISTS cl_23.cl_rifiuti
(
    id  serial,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
	si_punti numeric,
    no_punti numeric,
    sez text ,
    id_parent numeric,
    comm text ,
    trashed_date text ,
    peso numeric,
    CONSTRAINT cl_rifiuti_pkey PRIMARY KEY (id)
);

-----> copiare il csv sul server
copy 
	cl_23.cl_rifiuti (prog, grp, sez, domanda, si_punti, no_punti, peso) 
FROM 
	'/tmp/cl_rifiuti.csv' 
DELIMITER ';' CSV HEADER 

CREATE TABLE IF NOT EXISTS cl_23.cl_reflui_oleari
(
    id  serial,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
	si_punti numeric,
    no_punti numeric,
    sez text ,
    id_parent numeric,
    comm text ,
    trashed_date text ,
    peso numeric,
    CONSTRAINT cl_reflui_oleari_pkey PRIMARY KEY (id)
);

-----> copiare il csv sul server
copy 
	cl_23.cl_reflui_oleari (prog, grp, sez, domanda, si_punti, no_punti, peso) 
FROM 
	'/tmp/cl_reflui_oleari.csv' 
DELIMITER ';' CSV HEADER 



CREATE TABLE IF NOT EXISTS cl_23.cl_fanghi
(
    id  serial,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
	si_punti numeric,
    no_punti numeric,
    sez text ,
    id_parent numeric,
    comm text ,
    trashed_date text ,
    peso numeric,
    CONSTRAINT cl_fanghi_pkey PRIMARY KEY (id)
);

-----> copiare il csv sul server
copy 
	cl_23.cl_fanghi (prog, grp, sez, domanda, si_punti, no_punti, peso) 
FROM 
	'/tmp/cl_fanghi.csv' 
DELIMITER ';' CSV HEADER 



CREATE TABLE IF NOT EXISTS cl_23.cl_effluenti
(
    id  serial,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
    si_punti numeric,
    no_punti numeric,
    sez text ,
    id_parent numeric,
    comm text ,
    trashed_date text ,
    peso numeric,
    CONSTRAINT cl_effluenti_pkey PRIMARY KEY (id)
)

-----> copiare il csv sul server
copy 
	cl_23.cl_effluenti (prog, grp, sez, domanda, si_punti, no_punti, peso) 
FROM 
	'/tmp/cl_effluenti.csv' 
DELIMITER ';' CSV HEADER 