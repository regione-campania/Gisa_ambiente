package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	wkhtml "github.com/SebastiaanKlippert/go-wkhtmltopdf"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/kataras/iris/v12"
	"github.com/kataras/iris/v12/sessions"
)

var (
	cookieNameForSessionID = "mycookiesessionnameid"
	sess                   = sessions.New(sessions.Config{Cookie: cookieNameForSessionID})
)

var dbUrl = ""
var dbPort = ""
var dbName = ""
var dbNome2 = ""
var dbUsr2 = ""
var dbPass2 = ""
var dbUsr = ""
var dbPwd = ""
var sslCert = ""
var sslKey = ""
var port = ""
var isHttps = ""
var endPointDocumentale = ""
var endPointLogin = ""
var endPointSpid = ""

func main() {
	setConfigFile("config/config.json")
	dbUrl = getProperty("dbUrl")
	dbPort = getProperty("dbPort")
	dbName = getProperty("dbName")
	dbUsr = getProperty("dbUsr")
	dbPwd = getProperty("dbPwd")
	dbNome2 = getProperty("dbNome2")
	dbUsr2 = getProperty("dbUsr2")
	dbPass2 = getProperty("dbPass2")
	sslCert = getProperty("sslCert")
	sslKey = getProperty("sslKey")
	port = getProperty("port")
	isHttps = getProperty("isHttps")
	endPointDocumentale = getProperty("endPointDocumentale")
	endPointLogin = getProperty("endPointLogin")
	endPointSpid = getProperty("endPointSpid")

	dbConn := " host=" + dbUrl + " port=" + dbPort + " user=" + dbUsr + " dbname=" + dbName + " password=" + dbPwd + " sslmode=disable"
	fmt.Println("main connecting to: ", dbConn)

	db, err := gorm.Open("postgres", dbConn)
	if err != nil {
		panic("could not connect to database")
	}
	defer func() {
		_ = db.Close()
	}()

	app := newApp(db)
	app.Logger().SetLevel("info")
	//app.Logger().SetLevel("debug")

	app.Logger().Infof("\n ========================== \n Config file %s ", getConfig())

	// Start the web server on port ...
	if isHttps == "true" {
		app.Run(iris.TLS(":"+port, sslCert, sslKey), iris.WithCharset("utf-8"), iris.WithoutServerError(iris.ErrServerClosed))
	} else {
		app.Run(iris.Addr(":"+port), iris.WithCharset("utf-8"), iris.WithoutServerError(iris.ErrServerClosed))
	}
}

func newApp(db *gorm.DB) *iris.Application {

	app := iris.New()

	tmpl := iris.HTML("./templates", ".html").Reload(true)
	app.RegisterView(tmpl)

	app.HandleDir("/static", iris.Dir("./static"))

	app.HandleDir("/", iris.Dir("./templates"))

	app.OnErrorCode(iris.StatusInternalServerError, func(ctx iris.Context) {
		errMessage := ctx.Values().GetString("error")
		if errMessage != "" {
			ctx.Writef("Internal server error: %s", errMessage)
			return
		}
		ctx.Writef("(Unexpected) internal server error")
	})

	app.OnErrorCode(iris.StatusNotFound, func(ctx iris.Context) {
		ctx.Application().Logger().Infof("Not Found Handler for: %s", ctx.Path())
	})

	app.Get("/home", func(ctx iris.Context) {

		ctx.View("home.html")

	})

	app.Get("/", func(ctx iris.Context) {

		ctx.View("myrouter.html")
	})

	app.Get("/index", func(ctx iris.Context) {
		ctx.ViewData("EndpointSpid", endPointSpid)
		ctx.View("/index.html")

	})

	app.Get("/doc", func(ctx iris.Context) {

		Szs := []Sz{}
		db.Raw("select id, doc, code, tit from appdocu order by ord::integer ").Find(&Szs)
		app.Logger().Infof("%v", Szs)
		ctx.ViewData("Szs", Szs)
		ctx.View("doc.html")

	})
	app.Get("/ml", func(ctx iris.Context) {
		session := sess.Start(ctx)
		Mls := []Ml{}
		db.Raw("select id_norma n_id, norma n_desc from norma(?::text, ?::text) ", session.GetString("osaId"), session.GetString("osaTab")).Find(&Mls)

		//app.Logger().Infof("%v", Mls)

		ctx.ViewData("Mls", Mls)
		ctx.View("ml.html")
	})

	app.Get("/ml_base", func(ctx iris.Context) {
		/*
		   		Mls := []Ml{}
		           db.Raw("select id_norma n_id, norma n_desc from norma ").Find(&Mls)

		   		//app.Logger().Infof("%v", Mls)

		   		ctx.ViewData("Mls", Mls)
		*/

		ctx.View("ml_base.html")
	})

	app.Get("/get_cls_pre/{idlda:string}", func(ctx iris.Context) {

		idLda := ctx.Params().GetString("idlda")

		app.Logger().Infof(" Cl of Lda_id: %s", idLda)

		type Cl struct {
			L_id   string
			C_name string
		}

		var Cls []Cl

		qry := fmt.Sprintf("select '-999' as l_id, allegati_categ  as c_name  from cl_23.a_tipol_ml where codice_univoco ilike '%%%s%%'", idLda)
		fmt.Println("get_cls_pre executing -> " + qry)

		db.Raw(qry).Scan(&Cls)

		fmt.Printf("Cls: %v", Cls)

		//options := iris.JSON{Indent: "    ", Secure: true}

		if len(Cls) == 1 { //nuova gestione
			if Cls[0].L_id == "-1" {
				Cls = []Cl{}
			}
		}
		//ctx.JSON(len(Cls), options)
		ctx.JSON(len(Cls))

	})

	app.Get("/cl", func(ctx iris.Context) {

		Cls := []Cl{}
		db.Raw("select l_id, l_desc, ver from cl_lists order by 1 ").Find(&Cls)

		//app.Logger().Infof("%v", Cls)

		ctx.ViewData("Cls", Cls)
		ctx.View("cl.html")
	})

	app.Get("/cl_1", func(ctx iris.Context) {

		Cls := []Cl{}
		db.Raw("select l_id, l_desc, ver from cl_lists order by 1 ").Find(&Cls)
		//app.Logger().Infof("%v", Cls)

		ctx.ViewData("Cls", Cls)
		ctx.View("cl_1.html")
	})

	app.Get("/get_chpqst/{idcl:int}", func(ctx iris.Context) {

		//	id,_ := ctx.Params().GetInt("idcl")

	})

	app.Get("/get_chp/{idcl:int}", func(ctx iris.Context) {
		session := sess.Start(ctx)

		Chps := []Chp{}

		id, _ := ctx.Params().GetInt("idcl")
		app.Logger().Infof(" chapters of l_id: %d", id)

		db.Raw("select c_id, c_desc from cl_chapts where l_id=? AND not c_is_disabilitato order by 1", id).Find(&Chps)
		Us := User{}
		var userId, _ = strconv.Atoi(session.GetString("idUser"))
		Us.Id = userId

		ctx.ViewData("UserId", userId)
		ctx.ViewData("Chps", Chps)
		ctx.View("chp.html")

	})

	app.Get("/get_qst/{idchp:int}", func(ctx iris.Context) {

		Qsts := []Qst{}

		id, _ := ctx.Params().GetInt("idchp")

		app.Logger().Infof(" chapter of idchp: %d", id)

		db.Raw("select q_id, domanda, sotto_domanda, punti_si, punti_no from cl_quests cq where id_chap=? order by 1", id).Find(&Qsts)

		ctx.ViewData("Qsts", Qsts)
		ctx.View("qst.html")

	})

	app.Post("/save_cl", func(ctx iris.Context) {
		session := sess.Start(ctx)

		Cl_23 := []Cl_23_1{}
		err := ctx.ReadJSON(&Cl_23)
		if err != nil {
			app.Logger().Info("Errore lettura json")
			app.Logger().Info(err)
			return
		}
		var id_cl = Cl_23[0].Id_Cl

		db.Exec("insert into log_checklist (id_checklist, id_utente, entered) values (?, ?, current_timestamp)", id_cl, session.Get("idUser"))

		db.Exec("delete from utente_risposta where id_checklist = ?  and id_utente = ?", id_cl, session.Get("idUser"))

		for _, ans := range Cl_23 {
			if ans.Risposta != "" {
				Punti_Risposta := ans.Punti_Risposta

				/*
					non è corretta per quando si disabilitano delle sottodomande, bisogna fare prima la delete dell intera cl
					db.Exec("insert into utente_risposta (id_utente, id_domanda, punteggio, risposta, id_checklist) values ( ?, ?, ?, ?, ?) on conflict (id_utente, id_domanda, id_checklist) do update set punteggio = ?, risposta = ?, entered = current_timestamp",
						session.Get("idUser"), ans.Id_Domanda, ans.Punti_Risposta, ans.Risposta, ans.Id_Cl, ans.Punti_Risposta, ans.Risposta);*/
				db.Exec("insert into utente_risposta (id_utente, id_domanda, punteggio, risposta, id_checklist, entered) values ( ?, ?, ?, ?, ?, current_timestamp)", session.Get("idUser"), ans.Id_Domanda, Punti_Risposta, ans.Risposta, ans.Id_Cl)
			}
		}
	})

	app.Post("/delete_cl", func(ctx iris.Context) {
		session := sess.Start(ctx)

		Cl_23 := []Cl_23{}
		err := ctx.ReadJSON(&Cl_23)
		if err != nil {
			app.Logger().Info("Errore lettura json")
			app.Logger().Info(err)
			return
		}
		var id_cl = Cl_23[0].Id
		db.Exec("delete from utente_risposta where id_checklist = ?  and id_utente = ?", id_cl, session.Get("idUser"))

		/*for _, ans := range Qst_2 {
			if (ans.Risposta != "") {
				//db.Exec("delete from utente_risposta where id_domanda in (select q_id from cl_all where l_id in (select l_id from cl_all where q_id = ?) ) and id_utente = ?", ans.Id_Domanda, session.Get("idUser"))
				db.Exec("delete from utente_risposta where id_checklist = ?  and id_utente = ?", ans.Id_Cl, ans.Id_Domanda, session.Get("idUser"))
			}
		}*/
	})

	app.Get("/login", func(ctx iris.Context) {
		app.Logger().Info("Errore chiamata login")
		ctx.Redirect("/") //, iris.StatusPermanentRedirect)
	})

	app.Post("/login", func(ctx iris.Context) {

		session := sess.Start(ctx)
		fmt.Printf("Indirizzo di memoria della variabile di sessione (/login): %p\n", session)

		app.Logger().Infof("New login attempt from %s", ctx.RemoteAddr())

		nome := ctx.FormValue("nome")
		cognome := ctx.FormValue("cognome")
		codicefiscale := ctx.FormValue("cf")

		if nome != "" && cognome != "" && codicefiscale != "" {

			var dd []LoginData

			db, err := gorm.Open(
				"postgres",
				"host= "+dbUrl+" port=5432 user="+dbUsr2+" dbname=gisa password="+dbPass2+" sslmode=disable",
			)

			if err != nil {
				panic("could not connect to database")
			}

			defer func() {
				_ = db.Close()
			}()
			q := fmt.Sprintf(utentiQry, codicefiscale)
			db.Raw(q).Find(&dd)
			for i, rec := range dd {
				i++
				app.Logger().Infof("DEBUG nome ---> %s", rec.Nome)
				app.Logger().Infof("DEBUG cognome ---> %s", rec.Cognome)
				app.Logger().Infof("DEBUG cf ---> %s", rec.Cf)
			}
			app.Logger().Infof("DEBUG nome ---> %s", nome)

			app.Logger().Infof("DEBUG D ---> %s", dd)

			db, err = gorm.Open(
				"postgres",
				"host="+dbUrl+" port="+dbPort+" user="+dbUsr+" dbname="+dbName+" password="+dbPwd+" sslmode=disable",
			)
			if err != nil {
				panic("could not connect to database")
			}

			defer func() {
				_ = db.Close()
			}()
			session.Set("LoginData", dd)
			app.Logger().Infof("DEBUG LoginData ---> %v", session.Get("LoginData"))

			ctx.ViewData("LoginData", dd)
			ctx.View("stabs.html")
			return

		}

		user := ctx.FormValue("user")
		password := ctx.FormValue("password")
		cf := ctx.FormValue("cfSpid")

		var jsonReq = []byte("{\"user\":\"" + user + "\", \"password\":\"" + password + "\" , \"cf\":\"" + cf + "\" }")
		app.Logger().Infof("DEBUG REQ ---> %s", string(jsonReq))

		session.Set("username", string(ctx.FormValue("nameSpid")))

		req, err := http.NewRequest("POST", endPointLogin, bytes.NewBuffer(jsonReq))
		req.Header.Set("Content-Type", "application/json")

		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			panic(err)
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		var jsonStr = string(body)
		app.Logger().Info(jsonStr)

		var userId = ""
		var osaType = ""
		var osaTab = "null"
		var osaId = "null"
		var idAsl = "-1"
		var ragione_sociale = ""
		if user == "admin" && password == "20071113!Reg" {
			userId = "1"
		} else if jsonStr == "{}" {
			app.Logger().Infof("User <%s> o Password <%s> non validi", user, password)
			var errore = "Utente e/o Password non validi"
			if cf != "" {
				errore = "Nessun Impianto AUA associato"
			}
			ctx.ViewData("Errore", errore)
			ctx.ViewData("EndpointSpid", endPointSpid)
			ctx.View("index.html")
			return
		} else {
			d := map[string]interface{}{}
			json.Unmarshal([]byte(jsonStr), &d)
			var messaggio = d["messaggio"].(string)

			app.Logger().Infof("DEBUG MESSAGGIO ---> %s", messaggio)

			var dd []LoginData
			json.Unmarshal([]byte(messaggio), &dd)

			app.Logger().Infof("DEBUG DD ---> %d", len(dd))

			if len(dd) == 0 {
				app.Logger().Infof("User <%s> non ha stabilimento associato", user)
				var errore = "L'utente " + user + " non ha OSA associato"
				if cf != "" {
					errore = "Il codice fiscale " + cf + " non ha OSA associato"
				}
				ctx.ViewData("Errore", errore)
				ctx.ViewData("EndpointSpid", endPointSpid)
				ctx.View("index.html")
				return
			}
			/*user = dd["username"].(string)
			userId = dd["user_id"].(string)
			osaType = dd["riferimento_id_nome"].(string)
			osaId = dd["riferimento_id"].(string)
			osaTab = dd["riferimento_id_nome_tab"].(string)
			idAsl = dd["id_asl"].(string)
			ragione_sociale = dd["ragione_sociale"].(string)*/
			session.Set("authenticated", true)
			session.Set("idUser", userId)
			session.Set("osaId", osaId)
			session.Set("osaType", osaType)
			session.Set("osaTab", osaTab)
			session.Set("ragione_sociale", ragione_sociale)
			session.Set("id_asl", idAsl)
			session.Set("LoginData", dd)
			ctx.ViewData("LoginData", dd)
			ctx.View("stabs.html")
			return
		}
	})

	app.Get("/postLogin", func(ctx iris.Context) {

		//fmt.Printf("Indirizzo di memoria della variabile di sessione (/postLogin): %p\n", session)
		session := sess.Start(ctx)

		app.Logger().Infof("DEBUG POSTLOGIN ---> %s %s %s", ctx.URLParam("rif_id"),
			ctx.URLParam("rif_nome"),
			ctx.URLParam("rif_tab"))

		var loginData = session.Get("LoginData").([]LoginData)
		app.Logger().Infof("DEBUG POSTLOGIN ---> %s", loginData)
		for _, d := range loginData {
			if d.Riferimento_id == ctx.URLParam("rif_id") && d.Riferimento_id_nome == ctx.URLParam("rif_nome") && d.Riferimento_id_nome_tab == ctx.URLParam("rif_tab") {
				app.Logger().Infof("DEBUG TROVATO ---> %v", d)
				session.Set("authenticated", true)
				session.Set("idUser", d.User_id)
				session.Set("osaId", d.Riferimento_id)
				session.Set("osaType", d.Riferimento_id_nome)
				session.Set("osaTab", d.Riferimento_id_nome_tab)
				//session.Set("username", d.Riferimento_id)
				session.Set("ragione_sociale", d.Ragione_sociale)
				session.Set("id_asl", d.Id_asl)
				app.Logger().Infof("user %s authenticated", d.Username)
				db.Exec("insert into log_access (id_utente, entered, id_asl, ip) values (?, current_timestamp, ?, ?)", d.User_id, d.Id_asl, ctx.RemoteAddr())
				ctx.ViewData("Ragione_Sociale", d.Ragione_sociale)
				ctx.ViewData("Username", session.GetString("username"))
				ctx.View("main.html")
			}
		}

		/*app.Logger().Info(userId)
		// Set user as authenticated
		session.Set("authenticated", true)
		session.Set("idUser", userId)
		session.Set("osaId", osaId)
		session.Set("osaType", osaType)
		session.Set("osaTab", osaTab)
		session.Set("username", user)
		session.Set("ragione_sociale", ragione_sociale)

		app.Logger().Infof("user %s authenticated", user)
		session.Set("osaTab", osaTab)
		session.Set("username", user)
		session.Set("ragione_sociale", ragione_sociale)

		app.Logger().Infof("user %s authenticated", user)
		//db.Exec("insert into log_access (id_utente, first_login, last_login, id_asl) values (?, current_timestamp, current_timestamp, ?) on conflict (id_utente) do update set last_login = current_timestamp, id_asl = ?", session.Get("idUser"), idAsl, idAsl)
		db.Exec("insert into log_access (id_utente, entered, id_asl, ip) values (?, current_timestamp, ?, ?)", session.Get("idUser"), idAsl, ctx.RemoteAddr())
		ctx.ViewData("Ragione_Sociale", ragione_sociale)
		ctx.ViewData("Username", user)
		ctx.View("main.html")*/
	})

	app.Get("/public", func(ctx iris.Context) {
		session := sess.Start(ctx)

		var auth = false
		auth, _ = session.GetBoolean("authenticated")
		app.Logger().Infof("authenticated, %s", auth)
		//if(!auth){

		app.Logger().Infof("New public user from %s", ctx.RemoteAddr())

		//var userId = ""
		var osaType = ""
		var osaTab = "null"
		var osaId = "null"
		var idAsl = "-1"

		// Set user as authenticated
		session.Set("authenticated", true)
		session.Set("osaId", osaId)
		session.Set("osaType", osaType)
		session.Set("osaTab", osaTab)

		Users := []User{}

		//app.Logger().Infof("OldId %s", session.Get("idUser"))

		//if (session.Get("idUser") == nil /*|| int(session.Get("idUser").(string)) > 0*/) { //sen non c'è un altro opsite loggato, o era loggato un osa, incremento contatore nuovo ospite
		// if(session.GetInt("idUser") > 0){

		db.Raw("select -nextval('public_user_id_seq') as id").Find(&Users)

		if session.Get("idUser") == nil /*|| int(session.Get("idUser").(string)) > 0*/ { //sen non c'è un altro opsite loggato, o era loggato un osa, incremento contatore nuovo ospite

			db.Exec("insert into log_access (id_utente, entered, id_asl, ip) values (?, current_timestamp, ?, ?)", Users[0].Id, idAsl, ctx.RemoteAddr())
			//	}
		}

		session.Set("idUser", Users[0].Id)
		session.Set("username", strconv.Itoa(Users[0].Id))

		app.Logger().Infof("Public user authenticated, ID: %d", Users[0].Id)

		ctx.ViewData("Username", "Ospite: "+session.GetString("username"))
		ctx.View("main.html")
	})

	app.Get("/getContatoriAccessi", func(ctx iris.Context) {

		AccessCounters := AccessCounter{}
		db.Raw("select ospiti.count ospiticounter, osa.count osacounter from (select count(*) from log_access where id_utente < 0) ospiti left join (select  count(*) from log_access where id_utente > 0) osa on 1=1").Find(&AccessCounters)

		app.Logger().Infof("OspitiCounter: %d", AccessCounters)

		options := iris.JSON{Indent: "    ", Secure: true}
		ctx.JSON(AccessCounters, options)

	})

	app.Get("/test", func(ctx iris.Context) {
		ctx.View("/test.html")

	})

	app.Post("/h2p", func(ctx iris.Context) {
		session := sess.Start(ctx)

		currentTime := time.Now()
		stringTime := currentTime.Format("2006_01_02_15_04_05")

		var clString = strings.Replace(session.GetString("selectedCl"), " ", "_", -1)

		var filename = "Autovalutazione_" + clString + "_" + stringTime + ".pdf"
		var filepdf = "/tmp/" + filename

		//	htmlStr := ctx.PostValue("htmlStr")

		fmt.Println("Generating:", filepdf)

		pdfg, err := wkhtml.NewPDFGenerator()
		if err != nil {
			log.Fatal(err)
		}

		rawBodyAsBytes, err := ioutil.ReadAll(ctx.Request().Body)
		if err != nil {
			log.Fatal(err)
		}
		htmlStr := string(rawBodyAsBytes)

		//app.Logger().Info( "htmlStr\n", htmlStr, "\nend")

		pageReader := wkhtml.NewPageReader(strings.NewReader(htmlStr))
		pageReader.PageOptions.EnableLocalFileAccess.Set(true)
		pdfg.AddPage(pageReader)
		//pdfg.XServer = true

		// Create PDF document in internal buffer
		err = pdfg.Create()
		if err != nil {
			log.Fatal(err)
		}

		/*		app.Logger().Infof("serving file %s\n",  filepdf)
				//ctx.Header("Content-type", "application/pdf")

				ctx.SendFile(filepdf, filepdf)
		*/

		pageReader = wkhtml.NewPageReader(strings.NewReader(htmlStr))
		pageReader.PageOptions.EnableLocalFileAccess.Set(true)
		pdfg.AddPage(pageReader)
		err = pdfg.WriteFile(filepdf) //scrivo file tpm da inviare a Documentale
		if err != nil {
			log.Fatal(err)
		}

		if session.GetString("osaType") != "null" && session.GetString("osaId") != "null" {
			content, err := ioutil.ReadFile(filepdf)
			if err != nil {
				log.Fatal(err)
			}

			data := url.Values{
				"baString":        {string(content)},
				"provenienza":     {"gisa_nt"},
				"tipoCertificato": {"CHECKLIST_GIAVA"},
				"oggetto":         {filename},
				"parentId":        {"-1"},
				"folderId":        {"-1"},
				"filename":        {filename},
				"fileDimension":   {string(len(string(content)))},
				"idUtente":        {session.GetString("idUser")},
				"ipUtente":        {ctx.RemoteAddr()},
				"jsonEntita":      {"{\"idStabilimentoAUA\":" + "\"" + session.GetString("osaId") + "\"}"},
				"noteHd":          {"test"},
			}
			app.Logger().Info("Post documentale:\n",
				url.Values{
					"provenienza":     {"gisa_nt"},
					"tipoCertificato": {"CHECKLIST_GIAVA"},
					"oggetto":         {filename},
					"parentId":        {"-1"},
					"folderId":        {"-1"},
					"filename":        {filename},
					"fileDimension":   {string(len(string(content)))},
					"idUtente":        {session.GetString("idUser")},
					"ipUtente":        {ctx.RemoteAddr()},
					"baString":        {string(content)},
					"jsonEntita":      {"{\"idStabilimentoAUA\":" + "\"" + session.GetString("osaId") + "\"}"},
					"noteHd":          {"test"},
				}, "\nend")

			resp, err := http.PostForm(endPointDocumentale, data)
			if err != nil {
				log.Fatal(err)
			}
			var res map[string]interface{}
			json.NewDecoder(resp.Body).Decode(&res)
			app.Logger().Info(resp)
		}

		ctx.ContentType("application/pdf")
		pdfg.SetOutput(ctx.ResponseWriter()) //imposto l'output per il browser
		ctx.SendFile(filepdf, filepdf)

	})

	app.Get("/logout", func(ctx iris.Context) {

		session := sess.Start(ctx)
		session.Set("authenticated", false)
		session.Set("idUser", nil)
		var auth = false
		auth, _ = session.GetBoolean("authenticated")
		app.Logger().Infof("authenticated, %s", auth)
		//  ctx.View("main.html")
		ctx.Redirect("/")
		sess.Destroy(ctx)

	})

	app.Get("/getSw", func(ctx iris.Context) {

		ctx.SendFile("./static/js/sw.js", "sw.js")

	})

	app.Get("/get_mac/{idnor:int}", func(ctx iris.Context) {
		session := sess.Start(ctx)

		id := ""
		Macs := []Mac{}

		int_id, _ := ctx.Params().GetInt("idnor")

		if int_id == -1 {
			id = "%"
		} else {
			id = strconv.Itoa(int_id)
		}

		app.Logger().Infof(" Macros of N_id: %s", id)

		//db.Raw("select distinct id_macroarea m_id, macroarea m_desc, codice_macroarea as m_code from ml10(?::text, ?::text) where id_norma like ? order by 2", session.GetString("osaId"), session.GetString("osaTab"), id).Find(&Macs)

		osaId := session.GetString("osaId")
		if len(osaId) == 0 {
			osaId = "null"
		}

		osaTab := session.GetString("osaTab")
		if len(osaTab) == 0 {
			osaTab = "null"
		}

		/* ### proto cl2023
		qry:= fmt.Sprintf("select distinct id_macroarea m_id, macroarea m_desc, codice_macroarea as m_code from ml10('%s'::text, '%s'::text)  order by 2", osaId, osaTab)
		*/
		qry := "select distinct 123 as m_id, desc_macroarea as m_desc, cod_macroarea m_code, 'codice_univoco' as m_cod_univ from cl_23.a_tipol_ml where codice_univoco is not null order by 2"

		fmt.Println("get Mac qry -> " + qry)
		db.Raw(qry).Find(&Macs)

		ctx.ViewData("Macs", Macs)
		ctx.View("mac.html")

	})

	app.Get("/get_agg/{codmac:string}", func(ctx iris.Context) {

		Aggs := []Agg{}

		id := ctx.Params().GetString("codmac")

		app.Logger().Infof(" Aggrs of M_id: %s", id)

		qry := fmt.Sprintf("select distinct '-1' a_id, desc_aggregazione a_desc, cod_attivita a_code from cl_23.a_tipol_ml where cod_macroarea='%s'", id)
		fmt.Println("get Agg qry -> " + qry)

		db.Raw(qry).Find(&Aggs)

		ctx.ViewData("Aggs", Aggs)
		ctx.View("agg.html")

	})

	app.Get("/get_lda/{idagg:string}", func(ctx iris.Context) {

		Ldas := []Lda{}

		id := ctx.Params().GetString("idagg")

		app.Logger().Infof(" Lda of A_id: %s", id)

		qry := fmt.Sprintf("select codice_univoco l_id, desc_lda l_desc, cod_lda l_code from  cl_23.a_tipol_ml where cod_attivita = '%s'", id)
		fmt.Println("get LdA qry -> " + qry)

		db.Raw(qry).Find(&Ldas)

		ctx.ViewData("Ldas", Ldas)
		ctx.View("lda.html")

	})

	app.Get("/get_cls23/{idlda:string}", func(ctx iris.Context) {

		idLda := ctx.Params().GetString("idlda")

		app.Logger().Infof(" Cl of Lda_id: %s", idLda)

		type Cl struct {
			L_id          string
			l_codice_univ string
			C_name        string
			C_title       string
		}

		var Cls []Cl

		qry := fmt.Sprintf("select ml.id::text as l_id, ml.codice_univoco as l_codice_univ, cl.name as c_name, cl.title as c_title from cl_23.a_tipol_ml ml left join cl_23.anag_cl cl on upper(trim(ml.allegati_categ))=upper(trim(cl.name)) where codice_univoco ilike '%%%s%%'", idLda)

		fmt.Println("/get_cls23/idlda() qry -> " + qry)

		db.Raw(qry).Find(&Cls)
		fmt.Print("get Cls -> ")
		fmt.Println(Cls)

		ctx.ViewData("Cls", Cls) //più row, le visualizzo. Zero row darà pagina vuota
		ctx.View("cl_1.html")

	})

	app.Get("/get_cl23/{cl_name}", func(ctx iris.Context) {
		session := sess.Start(ctx)

		cl_name := ctx.Params().Get("cl_name")
		type Cl_title struct {
			Cl_title string
			Id_cl    string
		}
		var Title Cl_title
		qry := fmt.Sprintf("select  title as cl_title, id as id_cl from cl_23.anag_cl  where name ilike '%s'", cl_name)
		fmt.Println("/get_cl23/cl_name get pt qry -> " + qry)
		db.Raw(qry).Find(&Title)
		fmt.Println(Title)

		ctx.ViewData("Title", Title.Cl_title)

		Cls := []Cl_23{}
		qry = fmt.Sprintf("SELECT id, "+Title.Id_cl+" as id_cl , prog, trim(sez) as sez, domanda, si_punti * peso as punti_si, no_punti * peso as punti_no, grp, comm, blocker, grp_block, risposta_block FROM cl_23.%s order by prog", cl_name)
		fmt.Println("get cl qry -> " + qry)
		db.Raw(qry).Find(&Cls)
		Us := User{}
		var userId, _ = strconv.Atoi(session.GetString("idUser"))
		Us.Id = userId

		ctx.ViewData("UserId", userId)
		ctx.ViewData("Cls", Cls)

		ctx.View("cl23.html")

	})

	/*
		app.Get("/get_cl23/{cl_name}", func(ctx iris.Context) {

			cl_name := ctx.Params().Get("cl_name")
			ctx.Redirect("/get_cl23/" + cl_name + "/%25")  // url %25 == sql %

		})
	*/

	//==============
	return app
	//==============
}
