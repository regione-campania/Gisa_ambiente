package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"strings"

	"github.com/360EntSecGroup-Skylar/excelize"
	_ "github.com/lib/pq"
)

const (
	dbType     = "postgres"
	dbhost     = "HRDBHOST"
	dbuser     = " postgres "
	dbname     = " dca43_2019_2 "
	dbmode     = " sslmode=disable "
	connection = "host=" + dbhost + " user=" + dbuser + " dbname=" + dbname + dbmode
)

var (
	tabs_map = map[string]string{
		"1": "1 - Linea d'azione regione",
		"2": "2 - Piano d'azione aziendale",
		"3": "3 - Cronoprogramma",
		"4": "4 - Monit Piano azione azienda",
	}

	tab1_map = map[string]string{
		"C6":  "denominazione",
		"A9":  "programma",
		"C9":  "ob1",
		"C11": "ob2",
		"C13": "ob3",
		"D9":  "in1",
		"D11": "in2",
		"D13": "in3",
	}

	tab2_map = map[string]string{
		"C8":  "pianoDesc",
		"C11": "contesto",
		"D16": "AttA",
		"D17": "AttB",
		"D18": "AttC",
		"D19": "AttD",
		"D20": "AttE",
		"D21": "AttF",
		"D23": "inA",
		"D24": "inB",
		"D25": "inC",
		"D26": "inD",
		"D27": "inE",
		"D28": "inF",
		"C31": "impatto",
		"C35": "lea1",
		"C36": "lea2",
		"C37": "lea3",
	}

	tab3_map = map[string]string{
		"D13": "Q4_19A",
		"D14": "Q4_19B",
		"D15": "Q4_19C",
		"D16": "Q4_19D",
		"D17": "Q4_19E",
		"D18": "Q4_19F",
		"E13": "Q1_20A",
		"E14": "Q1_20B",
		"E15": "Q1_20C",
		"E16": "Q1_20D",
		"E17": "Q1_20E",
		"E18": "Q1_20F",
		"F13": "Q2_20A",
		"F14": "Q2_20B",
		"F15": "Q2_20C",
		"F16": "Q2_20D",
		"F17": "Q2_20E",
		"F18": "Q2_20F",
		"G13": "Q3_20A",
		"G14": "Q3_20B",
		"G15": "Q3_20C",
		"G16": "Q3_20D",
		"G17": "Q3_20E",
		"G18": "Q3_20F",
		"H13": "Q4_20A",
		"H14": "Q4_20B",
		"H15": "Q4_20C",
		"H16": "Q4_20D",
		"H17": "Q4_20E",
		"H18": "Q4_20F",
	}

	tab4_map = map[string]string{
		"E12": "avvA",
		"E13": "avvB",
		"E14": "avvC",
		"E15": "avvD",
		"E16": "avvE",
		"E17": "avvF",
		"F12": "conclA",
		"F13": "conclB",
		"F14": "conclC",
		"F15": "conclD",
		"F16": "conclE",
		"F17": "conclF",
		"G12": "incorsoA",
		"G13": "incorsoB",
		"G14": "incorsoC",
		"G15": "incorsoD",
		"G16": "incorsoE",
		"G17": "incorsoF",
		"H12": "dataConclA",
		"H13": "dataConclB",
		"H14": "dataConclC",
		"H15": "dataConclD",
		"H16": "dataConclE",
		"H17": "dataConclF",
		"G20": "valorIndA",
		"G21": "valorIndB",
		"G22": "valorIndC",
		"G23": "valorIndD",
		"G24": "valorIndE",
		"G25": "valorIndF",
		"G28": "statoAvanzOb1",
		"G30": "statoAvanzOb2",
		"G32": "statoAvanzOb3",
		"C35": "impOrg",
		"C38": "critInEst",
	}

	sheet = map[string]map[string]string{
		"1": tab1_map,
		"2": tab2_map,
		"3": tab3_map,
		"4": tab4_map,
	}

	db  *sql.DB
	err error
)

func appendRec(tab, campo, dest, lprog, laz, valore, file, where string) {

	ins_tpl := `insert into dati_xls_new (tab, dest, lprog, laz, campo, valore, file, cell ) values ('%s', %s, %s, %s, '%s', '%s', '%s', '%s')`
	insqry := fmt.Sprintf(ins_tpl, tab, dest, lprog, laz, campo, strings.Replace(valore, "'", "''", -1), file, where)
	log.Println(insqry)
	_, err = db.Exec(insqry)
	if err != nil {
		log.Println("WARNING: ", err)
	}

}

func main() {

	log.SetPrefix("LOG: ")
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	db, err = sql.Open(dbType, connection)
	if err != nil {
		log.Fatal(err.Error())
	}
	defer db.Close()

	filePtr := flag.String("file", "", "input file .xlsx")

	destPtr := flag.String("dest", "", "dest id")
	lineaPtr := flag.String("linea", "", "linea prog id")
	lazPtr := flag.String("laz", "", "linea az id")

	flag.Parse()

	xlsx, err := excelize.OpenFile(*filePtr)
	if err != nil {
		log.Fatal(err)
	}

	for tab_index, tab_desc := range tabs_map {
		for cell, fld_name := range sheet[tab_index] {
			fld_val, _ := xlsx.GetCellValue(tab_desc, cell)
			appendRec(tab_index, fld_name, *destPtr, *lineaPtr, *lazPtr, fld_val, *filePtr, cell)
		}
	}
}
