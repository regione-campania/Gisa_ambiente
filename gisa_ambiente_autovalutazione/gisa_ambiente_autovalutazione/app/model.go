package main

import "github.com/jinzhu/gorm"

type Ml struct {
	N_id   int    `gorm:"type:varchar" json:"N_id"`
	N_desc string `gorm:"type:varchar" json:"N_desc"`
}
type Mac struct {
	M_id       int    `gorm:"type:varchar" json:"M_id"`
	M_desc     string `gorm:"type:varchar" json:"M_desc"`
	M_code     string `gorm:"type:varchar" json:"M_code"`
	M_cod_univ string `gorm:"type:varchar" json:"M_cod_univ"`
}
type Agg struct {
	A_id   int    `gorm:"type:varchar" json:"A_id"`
	A_desc string `gorm:"type:varchar" json:"A_desc"`
	A_code string `gorm:"type:varchar" json:"A_code"`
}
type Lda struct {
	L_id   string `gorm:"type:varchar" json:"L_id"`
	L_desc string `gorm:"type:varchar" json:"L_desc"`
	L_code string `gorm:"type:varchar" json:"L_code"`
}

type Chp struct {
	C_id   int    `gorm:"type:int" json:"C_id"`
	C_desc string `gorm:"type:varchar" json:"C_desc"`
}

type Qst struct {
	Q_id         int     `gorm:"type:int" json:"Q_id"`
	Domanda      string  `gorm:"type:varchar" json:"Domanda"`
	SottoDomanda string  `gorm:"type:varchar" json:"SottoDomanda"`
	Punti_si     float64 `gorm:"type:float" json:"Punti_si"`
	Punti_no     float64 `gorm:"type:float" json:"Punti_no"`
}

type Qst_1 struct {
	Q_id           int     `gorm:"type:int" json:"Q_id"`
	C_desc         string  `gorm:"type:varchar" json:"C_desc"`
	Domanda        string  `gorm:"type:varchar" json:"Domanda"`
	SottoDomanda   string  `gorm:"type:varchar" json:"SottoDomanda"`
	Punti_si       float64 `gorm:"type:float" json:"Punti_si"`
	Punti_no       float64 `gorm:"type:float" json:"Punti_no"`
	Risposta       string  `gorm:"type:varchar" json:"Risposta"`
	Punti_Risposta float64 `gorm:"type:float" json:"Punti_Risposta"`
	Id_Cl          int     `gorm:"type:int" json:"Id_Cl"`
	Row_Number     int     `gorm:"type:int" json:"Row_Number"`
}

type Qst_2 struct {
	Id_Domanda     string  `gorm:"type:varchar" json:"Id_Domanda"`
	Capitolo       string  `gorm:"type:varchar" json:"Capitolo"`
	Domanda        string  `gorm:"type:varchar" json:"Domanda"`
	SottoDomanda   string  `gorm:"type:varchar" json:"SottoDomanda"`
	Punti_Risposta float64 `gorm:"type:float" json:"Punti_Risposta"`
	Risposta       string  `gorm:"type:varchar" json:"Risposta"`
	Id_Cl          int     `gorm:"type:int" json:"Id_Cl"`
}

type Sz struct {
	Id   int    `gorm:"type:int" json:"Id"`
	Doc  string `gorm:"type:varchar" json:"Doc"`
	Code string `gorm:"type:varchar" json:"Code"`
	Tit  string `gorm:"type:varchar" json:"Tit"`
	ord  string `gorm:"type:varchar" json:"ord"`
}

type User struct {
	Id int `gorm:"type:int" json:"Id"`
}

type LoginData struct {
	Username                string `gorm:"type:varchar" json:"username"`
	Cf                      string `gorm:"type:varchar" json:"cf"`
	Role                    string `gorm:"type:varchar" json:"role"`
	Role_id                 string `gorm:"type:varchar" json:"role_id"`
	Last_login              string `gorm:"type:varchar" json:"last_login"`
	User_id                 string `gorm:"type:varchar" json:"user_id"`
	Id_asl                  string `gorm:"type:varchar" json:"id_asl"`
	Riferimento_id          string `gorm:"type:varchar" json:"riferimento_id"`
	Riferimento_id_nome     string `gorm:"type:varchar" json:"riferimento_id_nome"`
	Riferimento_id_nome_tab string `gorm:"type:varchar" json:"riferimento_id_nome_tab"`
	Opu_stabilimento        string `gorm:"type:varchar" json:"opu_stabilimento"`
	Ragione_sociale         string `gorm:"type:varchar" json:"ragione_sociale"`
	Dati_anag               string `gorm:"type:varchar" json:"dati_anag"`
	Nome                    string `gorm:"type:varchar" json:"nome"`
	Cognome                 string `gorm:"type:varchar" json:"cognome"`
}

type AccessCounter struct {
	Ospiticounter int `gorm:"type:int" json:"ospiticounter"`
	Osacounter    int `gorm:"type:int" json:"osacounter"`
}

type Cl struct {
	gorm.Model    `json:"model"`
	L_id          string `gorm:"type:varchar" json:"L_id"`
	L_codice_univ string `gorm:"type:varchar" json:"L_codice_univ"`
	C_name        string `gorm:"type:varchar" json:"C_name"`
	C_title       string `gorm:"type:varchar" json:"C_title"`
	C_sez         string `gorm:"type:varchar" json:"C_sez"`
}

type Cl_23 struct {
	Id             int     `gorm:"type:varchar" json:"Id"`
	Sez            string  `gorm:"type:varchar" json:"Sez`
	Prog           string  `gorm:"type:varchar" json:"Prog"`
	Domanda        string  `gorm:"type:varchar" json:"Domanda"`
	Punti_no       float64 `gorm:"type:float" json:"Punti_no"`
	Punti_si       float64 `gorm:"type:float" json:"Punti_si"`
	Grp            string  `gorm:"type:varchar" json:"Grp"`
	Comm           string  `gorm:"type:varchar" json:"Comm"`
	Risposta       string  `gorm:"type:varchar" json:"Risposta"`
	Punti_Risposta float64 `gorm:"type:float" json:"Punti_Risposta"`
	Id_Cl          int     `gorm:"type:int" json:"Id_Cl"`
	Blocker        bool    `gorm:"type:boolean" json:"Blocker"`
	Grp_block      string  `gorm:"type:varchar" json:"Grp_block"`
	Risposta_block string  `gorm:"type:varchar" json:"Risposta_block"`
}
type Cl_23_1 struct {
	Id_Domanda     string  `gorm:"type:varchar" json:"Id_Domanda"`
	Capitolo       string  `gorm:"type:varchar" json:"Capitolo"`
	Domanda        string  `gorm:"type:varchar" json:"Domanda"`
	SottoDomanda   string  `gorm:"type:varchar" json:"SottoDomanda"`
	Punti_Risposta float64 `gorm:"type:float" json:"Punti_Risposta"`
	Risposta       string  `gorm:"type:varchar" json:"Risposta"`
	Id_Cl          int     `gorm:"type:int" json:"Id_Cl"`
}

type Conf_punti struct {
	Id                  string `gorm:"type:varchar" json:"Id"`
	Totale_per_sezioni  bool   `gorm:"type:varchar" json:"Totale_per_sezioni"`
	Risposta_tripla     bool   `gorm:"type:varchar" json:"Risposta_tripla"`
	Sez_name            string `gorm:"type:varchar" json:"Sez_name`
	Cl_title            string `gorm:"type:varchar" json:"Cl_title`
	Rischio_basso_punti string `gorm:"type:varchar" json:"Rischio_basso_punti`
	Rischio_medio_param string `gorm:"type:varchar" json:"Rischio_basso_param`
	Rischio_medio_punti string `gorm:"type:varchar" json:"Rischio_medio_punti`
	Rischio_basso_param string `gorm:"type:varchar" json:"Rischio_medio_param`
	Rischio_alto_punti  string `gorm:"type:varchar" json:"Rischio_alto_punti`
	Rischio_alto_param  string `gorm:"type:varchar" json:"Rischio_alto_param`
}

var (
	utentiQry = `
	select distinct
	trim(cf::text) as cf,
	trim(user_id::text) as user_id,
	--trim(acc.site_id::text) as id_asl,
	trim(namefirst::text) as nome,
	trim(namelast::text) as cognome,
	trim(riferimento_id::text) as riferimento_id,
	trim(riferimento_id_nome::text) as riferimento_id_nome,
	trim(riferimento_id_nome_tab::text) as riferimento_id_nome_tab,
	trim(ai.ragione_sociale::text) as ragione_sociale,
	concat(trim(as2.partita_iva ::text),' - ',trim(as2.comune)) as dati_anag
from utenti_modulospid  join ricerche_anagrafiche_old_materializzata as2 on as2.riferimento_id =stab_id left join aua_impresa ai on ai.id= as2.id_impresa where upper(cf) ilike upper('%s')  and riferimento_id_nome_tab ='aua_stabilimento';

`
)
