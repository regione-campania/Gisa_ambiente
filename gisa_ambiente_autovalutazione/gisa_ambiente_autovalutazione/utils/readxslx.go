package main

import (
	"database/sql"
	"flag"
	"fmt"
	"os"
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

func appendRec(tab, campo, dest, lprog, laz, valore, file, where string) {

	db, err := sql.Open(dbType, connection)
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()

	ins_tpl := `insert into dati_xls (tab, dest, lprog, laz, campo, valore, file, cell ) values ('%s', %s, %s, %s, '%s', '%s', '%s', '%s')`
	insqry := fmt.Sprintf(ins_tpl, tab, dest, lprog, laz, campo, strings.Replace(valore, "'", "''", -1), file, where)
	fmt.Println(insqry)
	db.QueryRow(insqry)
}

/*
func appendRec(rec string) {

	fname := "xlsdata.csv"

	f, err := os.OpenFile(fname, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	fmt.Fprintln(f, rec)
}
*/

func main() {

	filePtr := flag.String("file", "", "input file .xlsx")

	destPtr := flag.String("dest", "", "dest id")
	lineaPtr := flag.String("linea", "", "linea prog id")
	lazPtr := flag.String("laz", "", "linea az id")

	flag.Parse()

	tab1 := "1 - Linea d'azione regione"
	tab2 := "2 - Piano d'azione aziendale"
	tab3 := "3 - Cronoprogramma"
	//	tab4 := "4 - Monit Piano azione azienda"

	var cell, where string

	xlsx, err := excelize.OpenFile(*filePtr)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	where = "C6"
	cell, _ = xlsx.GetCellValue(tab1, "C6")
	appendRec("1", "denominazione", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "A9"
	cell, _ = xlsx.GetCellValue(tab1, "A9")
	appendRec("1", "programma", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C9"
	cell, _ = xlsx.GetCellValue(tab1, "C9")
	appendRec("1", "ob1", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C11"
	cell, _ = xlsx.GetCellValue(tab1, "C11")
	appendRec("1", "ob2", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C13"
	cell, _ = xlsx.GetCellValue(tab1, "C13")
	appendRec("1", "ob3", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D9"
	cell, _ = xlsx.GetCellValue(tab1, "D9")
	appendRec("1", "in1", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D11"
	cell, _ = xlsx.GetCellValue(tab1, "D11")
	appendRec("1", "in2", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D13"
	cell, _ = xlsx.GetCellValue(tab1, "D13")
	appendRec("1", "in3", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C8"
	cell, _ = xlsx.GetCellValue(tab2, "C8")
	appendRec("2", "pianoDesc", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C11"
	cell, _ = xlsx.GetCellValue(tab2, "C8")
	appendRec("2", "contesto", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D16"
	cell, _ = xlsx.GetCellValue(tab2, "D16")
	appendRec("2", "AttA", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D17"
	cell, _ = xlsx.GetCellValue(tab2, "D17")
	appendRec("2", "AttB", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D18"
	cell, _ = xlsx.GetCellValue(tab2, "D18")
	appendRec("2", "AttC", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D19"
	cell, _ = xlsx.GetCellValue(tab2, "D19")
	appendRec("2", "AttD", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D20"
	cell, _ = xlsx.GetCellValue(tab2, "D20")
	appendRec("2", "AttE", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D21"
	cell, _ = xlsx.GetCellValue(tab2, "D21")
	appendRec("2", "AttF", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D23"
	cell, _ = xlsx.GetCellValue(tab2, "D23")
	appendRec("2", "inA", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D24"
	cell, _ = xlsx.GetCellValue(tab2, "D24")
	appendRec("2", "inB", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D25"
	cell, _ = xlsx.GetCellValue(tab2, "D25")
	appendRec("2", "inC", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D26"
	cell, _ = xlsx.GetCellValue(tab2, "D26")
	appendRec("2", "inD", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D27"
	cell, _ = xlsx.GetCellValue(tab2, "D27")
	appendRec("2", "inE", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "D28"
	cell, _ = xlsx.GetCellValue(tab2, "D28")
	appendRec("2", "inF", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C31"
	cell, _ = xlsx.GetCellValue(tab2, "C31")
	appendRec("2", "impatto", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C35"
	cell, _ = xlsx.GetCellValue(tab2, "C35")
	appendRec("2", "lea1", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C36"
	cell, _ = xlsx.GetCellValue(tab2, "C36")
	appendRec("2", "lea2", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "C37"
	cell, _ = xlsx.GetCellValue(tab2, "C37")
	appendRec("2", "lea3", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B13"
	cell, _ = xlsx.GetCellValue(tab3, "B13")
	appendRec("3", "AttA", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B14"
	cell, _ = xlsx.GetCellValue(tab3, "B14")
	appendRec("3", "AttB", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B15"
	cell, _ = xlsx.GetCellValue(tab3, "B15")
	appendRec("3", "AttC", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B16"
	cell, _ = xlsx.GetCellValue(tab3, "B16")
	appendRec("3", "AttD", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B17"
	cell, _ = xlsx.GetCellValue(tab3, "B17")
	appendRec("3", "AttE", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

	where = "B18"
	cell, _ = xlsx.GetCellValue(tab3, "B18")
	appendRec("3", "AttF", *destPtr, *lineaPtr, *lazPtr, cell, *filePtr, where)

}
