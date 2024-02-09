package org.aspcfs.modules.dpat.actions;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.dpat.base.DpatAttivita;
import org.aspcfs.modules.dpat.base.DpatCoefficiente;
import org.aspcfs.modules.dpat.base.DpatIndicatore;
import org.aspcfs.modules.dpat.base.DpatIstanza;
import org.aspcfs.modules.dpat.base.DpatPiano;
import org.aspcfs.modules.dpat.base.DpatSezione;
import org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo;
import org.aspcfs.modules.dpat.base.DpatStrutturaIndicatore;
import org.aspcfs.modules.dpatnew.base.DpatIndicatoreNewBean;
import org.aspcfs.modules.dpatnew.base.DpatPianoAttivitaNewBean;
import org.aspcfs.modules.dpatnew.base.DpatSezioneNewBean;
import org.aspcfs.modules.dpatnew.base.DpatWrapperSezioniBean;
import org.aspcfs.modules.dpatnew_interfaces.DpatIndicatoreNewBeanAbstract;
import org.aspcfs.modules.dpatnew_interfaces.DpatPianoAttivitaNewBeanInterface;
import org.aspcfs.modules.dpatnew_interfaces.DpatSezioneNewBeanInterface;
import org.aspcfs.modules.dpatnew_interfaces.DpatWrapperSezioniNewBeanAbstract;
import org.aspcfs.modules.dpatnew_templates.base.DpatIndicatoreNewBeanPreCong;
import org.aspcfs.modules.dpatnew_templates.base.DpatPianoAttivitaNewBeanPreCong;
import org.aspcfs.modules.dpatnew_templates.base.DpatSezioneNewBeanPreCong;
import org.aspcfs.modules.dpatnew_templates.base.DpatWrapperSezioniBeanPreCong;
import org.aspcfs.modules.dpatnew_templates.base.WrapperTuttiModelli;
import org.aspcfs.modules.gestioneDocumenti.base.DocumentaleAllegatoList;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.oia.base.OiaNodo;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.web.LookupElement;
import org.aspcfs.utils.web.LookupList;
import org.json.JSONException;

import com.darkhorseventures.framework.actions.ActionContext;

public class Dpat extends CFSModule {

	public String executeCommandDefault(ActionContext context) { /*chiamato dal cavaliere */
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");

		Connection db = null;
		ArrayList<DpatIstanza> anniList = new ArrayList<DpatIstanza>();
		try {
			db = this.getConnection(context);
			LookupList siteList = new LookupList(db, "lookup_site_id");
			siteList.addItem(-1, "--Seleziona--");
			siteList.remove(siteList.size() - 1);

			// String sql = "select anno from dpat group by anno order by anno";
			String sql = "select *  from dpat_istanza where trashed_date is null   order by anno desc";
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {

				DpatIstanza ist = new DpatIstanza();
				ist.buildRecord(rs);
				anniList.add(ist);
			}
			rs.close();
			pst.close();
			context.getRequest().setAttribute("anniList", anniList);
			context.getRequest().setAttribute("siteList", siteList);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			super.freeConnection(context, db);
		}

		return "DpatHomeRegOK"; /*home.jsp */
	}

	public String executeCommandHomeConfiguraDpat(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");

		Connection db = null;
		ArrayList<DpatIstanza> anniList = new ArrayList<DpatIstanza>();
		try {
			db = this.getConnection(context);
			LookupList siteList = new LookupList(db, "lookup_site_id");
			siteList.addItem(-1, "--Seleziona--");
			siteList.remove(siteList.size() - 1);

			// String sql = "select anno from dpat group by anno order by anno";
			String sql = "select *  from dpat_istanza where trashed_date is null order by anno desc";
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {

				DpatIstanza ist = new DpatIstanza();
				ist.buildRecord(rs);
				anniList.add(ist);
			}
			rs.close();
			pst.close();
			context.getRequest().setAttribute("anniList", anniList);
			context.getRequest().setAttribute("siteList", siteList);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			super.freeConnection(context, db);
		}

		return "DpatHomeConfiguraOK";
	}
	
	
	
	
	

	public String executeCommandHome(ActionContext context) throws JSONException, ParseException { /*chiamata da home.jsp */
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		int anno = Integer.parseInt(context.getRequest().getParameter("anno"));
		Connection db = null;

		int idAsl = utente.getUserRecord().getSiteId();
		if (idAsl != -1) {
			context.getRequest().setAttribute("idAsl", String.valueOf(idAsl));
		} else {
			idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			context.getRequest().setAttribute("idAsl", String.valueOf(idAsl));
		}

		String idArea = "";
		idArea = context.getRequest().getParameter("combo_area");
		int idStrutturaAreaSelezionata = -1;
		if (idArea != null && !"".equals(idArea))
			idStrutturaAreaSelezionata = Integer.parseInt(idArea);

		context.getRequest().setAttribute("anno", String.valueOf(anno));
		try {
			db = this.getConnection(context);
			DpatStrumentoCalcolo dsc = new DpatStrumentoCalcolo(db, idAsl, anno, false, idStrutturaAreaSelezionata);

			context.getRequest().setAttribute("dsc", dsc);

			org.aspcfs.modules.dpat.base.Dpat dpatAtt = new org.aspcfs.modules.dpat.base.Dpat();
			dpatAtt.builRecordAslAnno(idAsl, anno, db);
			context.getRequest().setAttribute("dpatAtt", dpatAtt);

			DocumentaleAllegatoList listaAllegati = new DocumentaleAllegatoList();
//			if (anno > 2015) {
//				GestioneAllegatiUpload gestioneAllegati = new GestioneAllegatiUpload();
//				listaAllegati = gestioneAllegati.getListaAllegatiDpat(context, db);
//
//				OiaNodo[] listaStrutture = PopolaCombo.getAreeStruttureComplesse(idAsl, anno, -1);
//
//				LookupList listaStruttureDirezione = new LookupList();
//				listaStruttureDirezione.setTable("");
//
//				for (int i = 0; i < listaStrutture.length; i++) {
//					listaStruttureDirezione.addItem(listaStrutture[i].getId(),
//							listaStrutture[i].getDescrizione_lunga());
//				}
//				context.getRequest().setAttribute("ListaStruttureDirezione", listaStruttureDirezione);
//
//			}
			context.getRequest().setAttribute("ListaAllegati", listaAllegati);

			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);

		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			super.freeConnection(context, db);
		}
		return "DpatHomeOK"; /*home2.jsp*/
	}

	/****************************
	 * ACTION PER DPAT GENERALE *
	 *****************************/

	public String executeCommandDpatModifyGenerale(ActionContext context) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		context.getRequest().setAttribute("anno", anno);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.Dpat d = null;
		try {
			db = this.getConnection(context);
			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));

			String comboArea = context.getRequest().getParameter("combo_area");
			int idAreaSelezionata = -1;
			if (comboArea != null & !"".equals(comboArea))
				idAreaSelezionata = Integer.parseInt(comboArea);

			sql = "select id from dpat where id_asl=" + idAsl + " and anno=" + anno + " and enabled ";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			if (rs.next()) {
				d = new org.aspcfs.modules.dpat.base.Dpat();
				d.setId(rs.getInt("id"));
				d.builRecord(d.getId(), db, this.getSystemStatus(context), idAreaSelezionata);
				d.buildlistSezioni(db, d.getAnno());
			}

			if (d != null) {

				if (d.isCompleto() == true) {

					context.getRequest().setAttribute("dpat", d);
					return "DpatModifyOK";

				}

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE
							double somma = d.getSaldo();
							d.setSaldo(somma + d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
									.get(k).getUi());

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else if (num_indicatori_this_piano <= num_indicatori_per_sezioni) {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {

							int ii = num_indicatori_this_piano / num_indicatori_per_sezioni;
							if ((num_indicatori_this_piano % num_indicatori_per_sezioni) > 0) {
								ii++;
							}
							ArrayList<DpatPiano> pp = new ArrayList<DpatPiano>();
							for (int jj = 0; jj < ii; jj++) {
								DpatPiano app_piano = new DpatPiano();// (DpatPiano)(d.getElencoSezioni().get(i).getElencoPiani().get(j));
								app_piano.setId(d.getElencoSezioni().get(i).getElencoPiani().get(j).getId());
								app_piano.setId_sezione(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getId_sezione());
								app_piano.setDescription(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getDescription());
								app_piano.setEnabled(d.getElencoSezioni().get(i).getElencoPiani().get(j).getEnabled());
								app_piano.setElencoAttivita(new ArrayList<DpatAttivita>());
								pp.add(jj, app_piano);
							}

							int index_indicatori = 0;
							for (int jj = 0; jj < pp.size(); jj++) {
								DpatPiano pp2 = pp.get(jj);
								pp2.buildlistAttivita(db, pp2.getId(), statoDpatConfig, Integer.parseInt(anno));
								for (int ll = 0; ll < pp2.getElencoAttivita().size(); ll++) {
									pp2.getElencoAttivita().get(ll).buildlistIndicatori(db,
											pp2.getElencoAttivita().get(ll).getId(), statoDpatConfig,
											Integer.parseInt(anno));
									ArrayList<DpatIndicatore> app = new ArrayList<DpatIndicatore>();
									for (int kk = 0; kk < num_indicatori_per_sezioni; kk++) {
										if (index_indicatori < pp2.getElencoAttivita().get(ll).getElencoIndicatori()
												.size()) {
											// app.add(kk,
											// pp2.getElencoAttivita().get(ll).getElencoIndicatori().get(index_indicatori));
											DpatIndicatore ind_app = pp2.getElencoAttivita().get(ll)
													.getElencoIndicatori().get(index_indicatori);
											if (ind_app.getUiCalcolabile() == true)
												ind_app.setCarico_in_ui(
														calcolaUiIndicatoreTotale(d.getId(), db, ind_app.getId()));
											else
												ind_app.setCarico_in_ui(0);
											app.add(kk, ind_app);
											index_indicatori++;
										}
									}
									if (pp2.getElencoAttivita().get(ll).getUiCalcolabile() == true)
										pp2.getElencoAttivita().get(ll).setUi(calcolaUiAttivitaTotale(d.getId(), db,
												pp2.getElencoAttivita().get(ll).getId()));
									else
										pp2.getElencoAttivita().get(ll).setUi(0);
									pp2.getElencoAttivita().get(ll).setElencoIndicatori(app);
									pp.set(jj, pp2);
								}

								listaSezioniSplitted.add(newsz);
								newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
								listaPianiDaIncludere = new ArrayList<DpatPiano>();
								listaPianiDaIncludere.add(pp.get(jj));
								newsz.setElencoPiani(listaPianiDaIncludere);
								num_indicatori = num_indicatori_this_piano;
								if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
									listaSezioniSplitted.add(newsz);
								}
							}
						}

					}
				}
				d.setElencoSezioniSplitted(listaSezioniSplitted);

				// CALCOLO CARICO E SALDO (TOTALE)
				d.setCarico_in_ui(calcolaCaricoTotale(d.getAnno(), d.getIdAsl(), db));
				double somma_ui_attivita = d.getSaldo();
				d.setSaldo(d.getCarico_in_ui() - somma_ui_attivita);

				// CALCOLO SALDO PER OGNI STRUTTURA
				for (int i = 0; i < d.getElencoStrutture().size(); i++) {
					int idStrutt = d.getElencoStrutture().get(i).getId();
					int idDpat = d.getId();
					int carico = d.getElencoStrutture().get(i).getCaricoInUi();
					// double saldo = carico -
					// calcolaSaldoPerStruttura(idStrutt, idDpat, db); //DAVIDE
					// DAVIDE
					double saldo = ottieniSaldoPerStrutturaDaDb(idStrutt, db);
					d.getElencoStrutture().get(i).setSaldo(saldo);
					d.getElencoStrutture().get(i).buildElenco(db, idStrutt, idDpat, idAreaSelezionata);
				}

				DpatStrutturaIndicatore dsi = new DpatStrutturaIndicatore();
				HashMap<Integer, HashMap<Integer, DpatStrutturaIndicatore>> dsiList = dsi.buildLista(db, d.getId(),
						idAreaSelezionata);
				context.getRequest().setAttribute("dsiList", dsiList);

				int idSDC = -1;
				PreparedStatement pst2 = db.prepareStatement("select id from dpat_strumento_calcolo where id_asl="
						+ d.getIdAsl() + " and anno=" + d.getAnno());
				ResultSet rs2 = pst2.executeQuery();
				while (rs2.next()) {
					idSDC = rs2.getInt(1);
				}
				context.getRequest().setAttribute("idSDC", idSDC);
				pst2.close();
				rs2.close();

				pst.close();
				rs.close();

			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}

		return "DpatModifyOK";
	}

	public String executeCommandUpdateClosedDpat(ActionContext context) {
		Connection db = null;

		String id = (String) context.getRequest().getParameter("id");
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		context.getRequest().setAttribute("anno", anno);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.Dpat d = null;
		try {

			String comboArea = context.getRequest().getParameter("combo_area");
			int idAreaSelezionata = -1;
			if (comboArea != null & !"".equals(comboArea))
				idAreaSelezionata = Integer.parseInt(comboArea);

			db = this.getConnection(context);
			d = new org.aspcfs.modules.dpat.base.Dpat();
			d.builRecord(Integer.parseInt(id), db, this.getSystemStatus(context), idAreaSelezionata);
			d.buildlistSezioni(db, d.getAnno());

			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));

			if (d != null) {
				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE
							double somma = d.getSaldo();
							d.setSaldo(somma + d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
									.get(k).getUi());

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						}

					}
				}
				d.setElencoSezioniSplitted(listaSezioniSplitted);

				// CALCOLO CARICO E SALDO (TOTALE)
				d.setCarico_in_ui(calcolaCaricoTotale(d.getAnno(), d.getIdAsl(), db));
				double somma_ui_attivita = d.getSaldo();
				d.setSaldo(d.getCarico_in_ui() - somma_ui_attivita);

				// CALCOLO SALDO PER OGNI STRUTTURA
				for (int i = 0; i < d.getElencoStrutture().size(); i++) {
					int idStrutt = d.getElencoStrutture().get(i).getId();
					int idDpat = d.getId();
					int carico = d.getElencoStrutture().get(i).calcolaCaricoInUi(idStrutt, d.getAnno(), db);

					// double saldo = carico -
					// calcolaSaldoPerStruttura(idStrutt, idDpat, db);//DAVIDE
					double saldo = ottieniSaldoPerStrutturaDaDb(idStrutt, db);
					d.getElencoStrutture().get(i).setSaldo(saldo);
					d.getElencoStrutture().get(i).buildElenco(db, idStrutt, idDpat, idAreaSelezionata);
				}

				DpatStrutturaIndicatore dsi = new DpatStrutturaIndicatore();
				HashMap<Integer, HashMap<Integer, DpatStrutturaIndicatore>> dsiList = dsi.buildLista(db, d.getId(),
						idAreaSelezionata);
				context.getRequest().setAttribute("dsiList", dsiList);
			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		return "DpatUpdateClosedDpatOK";
	}

	public String executeCommandRiapriCompetenze(ActionContext context) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		if (anno.equals("corrente")) {
			int a = Calendar.getInstance().get(Calendar.YEAR);
			anno = String.valueOf(a);
		}
		context.getRequest().setAttribute("anno", anno);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza d = null;

		String idArea = "";
		idArea = context.getRequest().getParameter("combo_area");
		int idStrutturaAreaSelezionata = -1;
		if (idArea != null && !"".equals(idArea))
			idStrutturaAreaSelezionata = Integer.parseInt(idArea);

		try {
			db = this.getConnection(context);
			sql = "select id from dpat_attribuzione_competenze where id_asl=" + idAsl + " and anno=" + anno;
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				d = new org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza();
				d.setId(rs.getInt("id"));
				d.setIdArea(idStrutturaAreaSelezionata);
				d.builRecord(d.getId(), db, this.getSystemStatus(context), idStrutturaAreaSelezionata);
				d.setCompleto(false);
				d.buildlistSezioni(db, Integer.parseInt(anno));
			}

			if (d.isCompleto())
				return executeCommandDpatDetailGeneraleCompetenze(context);
			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));
			if (d != null) {

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// int part = 1;
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						}

					}
				}

				d.setElencoSezioni(listaSezioniSplitted);

				// RECORD DI DPAT_STRUTTURA_INDICATORE PER POPOLARE LE CELLE DEL
				// DPAT

				String comboArea = context.getRequest().getParameter("combo_area");
				int idAreaSelezionata = -1;
				if (comboArea != null & !"".equals(comboArea))
					idAreaSelezionata = Integer.parseInt(comboArea);

				DpatStrutturaIndicatore dsi = new DpatStrutturaIndicatore();
				HashMap<Integer, HashMap<Integer, DpatStrutturaIndicatore>> dsiList = dsi.buildLista(db, d.getId(),
						idAreaSelezionata);

				context.getRequest().setAttribute("dsiList", dsiList);

				pst.close();
				rs.close();

				int idSDC = -1;
				PreparedStatement pst2 = db.prepareStatement("select id from dpat_strumento_calcolo where id_asl="
						+ d.getIdAsl() + " and anno=" + d.getAnno());
				ResultSet rs2 = pst2.executeQuery();
				while (rs2.next()) {
					idSDC = rs2.getInt(1);
				}
				context.getRequest().setAttribute("idSDC", idSDC);
				pst2.close();
				rs2.close();

				// context.getRequest().setAttribute("elencoStruttureComplesse",
				// elencoStruttureComplesse);
				// context.getRequest().setAttribute("elencoStrutture",
				// elencoStrutture);
			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		return "DpatModifyCompetenzeOK";
	}

	
	
	
	
	public String executeCommandDpatModifyGeneraleCompetenzeNEW(ActionContext context)
	{
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		if (anno.equals("corrente")) 
		{
			int a = Calendar.getInstance().get(Calendar.YEAR);
			anno = String.valueOf(a);
		}
		context.getRequest().setAttribute("anno", anno);

		String comboArea = context.getRequest().getParameter("combo_area");
		int idAreaSelezionata = -1;
		if (comboArea != null & !"".equals(comboArea))
			idAreaSelezionata = Integer.parseInt(comboArea);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpatnew.base.DpatAttribuzioneCompetenzeNewBean d = null; /*sicuramente quello col modello dpat configurato congelato */
		try {
			db = this.getConnection(context);

			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			sql = "select id,completo,id_asl,anno from dpat where id_asl=" + idAsl + " and anno=" + anno
					+ " and enabled";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			
			while (rs.next()) 
			{
				d = new org.aspcfs.modules.dpatnew.base.DpatAttribuzioneCompetenzeNewBean();
				d.setIdArea(idAreaSelezionata);
				d.setId(rs.getInt("id"));
				d.setCompleto(rs.getBoolean("completo"));
				d.setIdAsl(rs.getInt("id_asl"));
				d.setAnno(rs.getInt("anno"));
				d.buildRecord(d.getId(), db, this.getSystemStatus(context), idAreaSelezionata);
				d.buildlistSezioni(db, Integer.parseInt(anno),true);
			}

			if (d.getStrutturaAmbito().getStato_all6() == 2 || (d.isCompleto() == true && d.getAnno() < 2016))
				return executeCommandDpatDetailGeneraleCompetenze(context);

//			DpatIstanza istanza = new DpatIstanza();
//			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));
			if (d != null) {

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezioneNewBeanInterface> listaSezioniSplitted = new ArrayList<DpatSezioneNewBeanInterface>();
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().getSezioni().size(); i++) {
					 

					DpatSezioneNewBeanInterface  newsz = (DpatSezioneNewBeanInterface) ((DpatSezioneNewBeanInterface) d.getElencoSezioni().getSezioni().get(i)).clone();
					ArrayList<DpatPianoAttivitaNewBeanInterface> listaPianiDaIncludere = new ArrayList<DpatPianoAttivitaNewBeanInterface>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;
					ArrayList elencoPiani = ((DpatSezioneNewBeanInterface)d.getElencoSezioni().getSezioni().get(i)).getPianiAttivitaFigli();
					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < elencoPiani.size();/*d.getElencoSezioni().get(i).getElencoPiani().size();*/ j++) {
						 
						
						DpatPianoAttivitaNewBeanInterface piano = (DpatPianoAttivitaNewBeanInterface)elencoPiani.get(j);
						ArrayList indicatoriPiano = piano.getIndicatoriFigli();
						num_indicatori_this_piano = indicatoriPiano.size();
						 

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(piano);
							newsz.setPianiAttivitaFigli(listaPianiDaIncludere); 
							if (j == elencoPiani.size()- 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else if (num_indicatori_this_piano <= num_indicatori_per_sezioni) {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezioneNewBeanInterface) ((DpatSezioneNewBeanInterface) (d.getElencoSezioni().getSezioni(). get(i))).clone();
							listaPianiDaIncludere = new ArrayList<DpatPianoAttivitaNewBeanInterface >();
							listaPianiDaIncludere.add((DpatPianoAttivitaNewBeanInterface )elencoPiani.get(j));
							newsz.setPianiAttivitaFigli(listaPianiDaIncludere); 
							num_indicatori = num_indicatori_this_piano;
							if (j == elencoPiani.size()- 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {

							int ii = num_indicatori_this_piano / num_indicatori_per_sezioni;
							if ((num_indicatori_this_piano % num_indicatori_per_sezioni) > 0) {
								ii++;
							}
							ArrayList<DpatPianoAttivitaNewBeanInterface > pp = new ArrayList<DpatPianoAttivitaNewBeanInterface>();
							for (int jj = 0; jj < ii; jj++) 
							{
								long oidP = ((DpatPianoAttivitaNewBeanInterface)elencoPiani.get(j)).getOid();
								DpatPianoAttivitaNewBeanInterface app_piano = new DpatPianoAttivitaNewBean().buildByOid(db, (int)oidP, true, true);// (DpatPiano)(d.getElencoSezioni().get(i).getElencoPiani().get(j));
								pp.add(jj, app_piano);
							}

							int index_indicatori = 0;
							for (int jj = 0; jj < pp.size(); jj++) 
							{
								DpatPianoAttivitaNewBeanInterface pp2 = pp.get(jj);
								
								ArrayList<DpatIndicatoreNewBeanAbstract> app = new ArrayList<DpatIndicatoreNewBeanAbstract>();
								for(int kk= 0; kk < num_indicatori_per_sezioni; kk++)
								{
									
									if(index_indicatori < pp2.getIndicatoriFigli().size())
									{
										DpatIndicatoreNewBeanAbstract ind_app = (DpatIndicatoreNewBeanAbstract)pp2.getIndicatoriFigli().get(index_indicatori);
										app.add(kk, ind_app);
										index_indicatori++;
									}
								}
								pp2.setIndicatoriFigli(app);
								pp.set(jj, pp2);
								
								
								listaSezioniSplitted.add(newsz);
								newsz = (DpatSezioneNewBeanInterface) ((DpatSezioneNewBeanInterface) (d.getElencoSezioni().getSezioni(). get(i))).clone();
								listaPianiDaIncludere = new ArrayList<DpatPianoAttivitaNewBeanInterface >();
								listaPianiDaIncludere.add((DpatPianoAttivitaNewBeanInterface )pp.get(jj));
								newsz.setPianiAttivitaFigli(listaPianiDaIncludere); 
								num_indicatori = num_indicatori_this_piano;
								if (j == elencoPiani.size()- 1) {
									listaSezioniSplitted.add(newsz);
								}
								
								 
								 
							}
						}

					}
				}

				d.getElencoSezioni().setSezioni(listaSezioniSplitted); 

				// RECORD DI DPAT_STRUTTURA_INDICATORE PER POPOLARE LE CELLE DEL
				// DPAT

				pst.close();
				rs.close();

				int idSDC = -1;
				PreparedStatement pst2 = db.prepareStatement("select id from dpat_strumento_calcolo where id_asl="
						+ d.getIdAsl() + " and anno=" + d.getAnno());
				ResultSet rs2 = pst2.executeQuery();
				while (rs2.next()) {
					idSDC = rs2.getInt(1);
				}
				context.getRequest().setAttribute("idSDC", new Integer(idSDC));
				pst2.close();
				rs2.close();

				// context.getRequest().setAttribute("elencoStruttureComplesse",
				// elencoStruttureComplesse);
				// context.getRequest().setAttribute("elencoStrutture",
				// elencoStrutture);
			}
			context.getRequest().setAttribute("dpat2", d);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		return "DpatModifyCompetenzeNEWOK";
	
		
	}
	
	
	public String executeCommandDpatModifyGeneraleCompetenze(ActionContext context) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		if (anno.equals("corrente")) 
		{
			int a = Calendar.getInstance().get(Calendar.YEAR);
			anno = String.valueOf(a);
		}
		context.getRequest().setAttribute("anno", anno);

		String comboArea = context.getRequest().getParameter("combo_area");
		int idAreaSelezionata = -1;
		if (comboArea != null & !"".equals(comboArea))
			idAreaSelezionata = Integer.parseInt(comboArea);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza d = null;
		try {
			db = this.getConnection(context);

			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			sql = "select id,completo,id_asl,anno from dpat where id_asl=" + idAsl + " and anno=" + anno
					+ " and enabled";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			
			while (rs.next()) 
			{
				d = new org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza();
				d.setIdArea(idAreaSelezionata);
				d.setId(rs.getInt("id"));
				d.setCompleto(rs.getBoolean("completo"));
				d.setIdAsl(rs.getInt("id_asl"));
				d.setAnno(rs.getInt("anno"));
				d.builRecord(d.getId(), db, this.getSystemStatus(context), idAreaSelezionata);
				d.buildlistSezioni(db, Integer.parseInt(anno));
			}

			if (d.getStrutturaAmbito().getStato_all6() == 2 || (d.isCompleto() == true && d.getAnno() < 2016))
				return executeCommandDpatDetailGeneraleCompetenze(context);

			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));
			if (d != null) {

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// int part = 1;
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else if (num_indicatori_this_piano <= num_indicatori_per_sezioni) {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {

							int ii = num_indicatori_this_piano / num_indicatori_per_sezioni;
							if ((num_indicatori_this_piano % num_indicatori_per_sezioni) > 0) {
								ii++;
							}
							ArrayList<DpatPiano> pp = new ArrayList<DpatPiano>();
							for (int jj = 0; jj < ii; jj++) {
								DpatPiano app_piano = new DpatPiano();// (DpatPiano)(d.getElencoSezioni().get(i).getElencoPiani().get(j));
								app_piano.setId(d.getElencoSezioni().get(i).getElencoPiani().get(j).getId());
								app_piano.setId_sezione(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getId_sezione());
								app_piano.setDescription(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getDescription());
								app_piano.setEnabled(d.getElencoSezioni().get(i).getElencoPiani().get(j).getEnabled());
								app_piano.setElencoAttivita(new ArrayList<DpatAttivita>());
								pp.add(jj, app_piano);
							}

							int index_indicatori = 0;
							for (int jj = 0; jj < pp.size(); jj++) {
								DpatPiano pp2 = pp.get(jj);
								pp2.buildlistAttivita(db, pp2.getId(), statoDpatConfig, Integer.parseInt(anno));
								for (int ll = 0; ll < pp2.getElencoAttivita().size(); ll++) {
									pp2.getElencoAttivita().get(ll).buildlistIndicatori(db,
											pp2.getElencoAttivita().get(ll).getId(), statoDpatConfig,
											Integer.parseInt(anno));
									ArrayList<DpatIndicatore> app = new ArrayList<DpatIndicatore>();
									for (int kk = 0; kk < num_indicatori_per_sezioni; kk++) {
										if (index_indicatori < pp2.getElencoAttivita().get(ll).getElencoIndicatori()
												.size()) {
											// app.add(kk,
											// pp2.getElencoAttivita().get(ll).getElencoIndicatori().get(index_indicatori));
											DpatIndicatore ind_app = pp2.getElencoAttivita().get(ll)
													.getElencoIndicatori().get(index_indicatori);
											if (ind_app.getUiCalcolabile() == true)
												ind_app.setCarico_in_ui(
														calcolaUiIndicatoreTotale(d.getId(), db, ind_app.getId()));
											else
												ind_app.setCarico_in_ui(0);
											app.add(kk, ind_app);
											index_indicatori++;
										}
									}
									if (pp2.getElencoAttivita().get(ll).getUiCalcolabile() == true)
										pp2.getElencoAttivita().get(ll).setUi(calcolaUiAttivitaTotale(d.getId(), db,
												pp2.getElencoAttivita().get(ll).getId()));
									else
										pp2.getElencoAttivita().get(ll).setUi(0);
									pp2.getElencoAttivita().get(ll).setElencoIndicatori(app);
									pp.set(jj, pp2);
								}

								listaSezioniSplitted.add(newsz);
								newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
								listaPianiDaIncludere = new ArrayList<DpatPiano>();
								listaPianiDaIncludere.add(pp.get(jj));
								newsz.setElencoPiani(listaPianiDaIncludere);
								num_indicatori = num_indicatori_this_piano;
								if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
									listaSezioniSplitted.add(newsz);
								}
							}
						}

					}
				}

				d.setElencoSezioni(listaSezioniSplitted);

				// RECORD DI DPAT_STRUTTURA_INDICATORE PER POPOLARE LE CELLE DEL
				// DPAT

				pst.close();
				rs.close();

				int idSDC = -1;
				PreparedStatement pst2 = db.prepareStatement("select id from dpat_strumento_calcolo where id_asl="
						+ d.getIdAsl() + " and anno=" + d.getAnno());
				ResultSet rs2 = pst2.executeQuery();
				while (rs2.next()) {
					idSDC = rs2.getInt(1);
				}
				context.getRequest().setAttribute("idSDC", idSDC);
				pst2.close();
				rs2.close();

				// context.getRequest().setAttribute("elencoStruttureComplesse",
				// elencoStruttureComplesse);
				// context.getRequest().setAttribute("elencoStrutture",
				// elencoStrutture);
			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		return "DpatModifyCompetenzeOK";
	}

	public String executeCommandDpatDetailGeneraleCompetenze(ActionContext context) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		if (anno.equals("corrente")) {
			int a = Calendar.getInstance().get(Calendar.YEAR);
			anno = String.valueOf(a);
		}
		context.getRequest().setAttribute("anno", anno);

		String comboArea = context.getRequest().getParameter("combo_area");
		int idAreaSelezionata = -1;
		if (comboArea != null & !"".equals(comboArea))
			idAreaSelezionata = Integer.parseInt(comboArea);
		else if (context.getRequest().getAttribute("ComboArea") != null)
			idAreaSelezionata = (Integer) context.getRequest().getAttribute("ComboArea");

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza d = null;
		try {
			db = this.getConnection(context);

			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			sql = "select id from dpat where id_asl=" + idAsl + " and anno=" + anno + " and enabled";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				d = new org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza();
				d.setIdArea(idAreaSelezionata);
				d.setId(rs.getInt("id"));
				d.builRecord(d.getId(), db, this.getSystemStatus(context), idAreaSelezionata);
				d.buildlistSezioni(db, Integer.parseInt(anno));
			}
			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));
			if (d != null) {

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// int part = 1;
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else if (num_indicatori_this_piano <= num_indicatori_per_sezioni) {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {

							int ii = num_indicatori_this_piano / num_indicatori_per_sezioni;
							if ((num_indicatori_this_piano % num_indicatori_per_sezioni) > 0) {
								ii++;
							}
							ArrayList<DpatPiano> pp = new ArrayList<DpatPiano>();
							for (int jj = 0; jj < ii; jj++) {
								DpatPiano app_piano = new DpatPiano();// (DpatPiano)(d.getElencoSezioni().get(i).getElencoPiani().get(j));
								app_piano.setId(d.getElencoSezioni().get(i).getElencoPiani().get(j).getId());
								app_piano.setId_sezione(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getId_sezione());
								app_piano.setDescription(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getDescription());
								app_piano.setEnabled(d.getElencoSezioni().get(i).getElencoPiani().get(j).getEnabled());
								app_piano.setElencoAttivita(new ArrayList<DpatAttivita>());
								pp.add(jj, app_piano);
							}

							int index_indicatori = 0;
							for (int jj = 0; jj < pp.size(); jj++) {
								DpatPiano pp2 = pp.get(jj);
								pp2.buildlistAttivita(db, pp2.getId(), statoDpatConfig, Integer.parseInt(anno));
								for (int ll = 0; ll < pp2.getElencoAttivita().size(); ll++) {
									pp2.getElencoAttivita().get(ll).buildlistIndicatori(db,
											pp2.getElencoAttivita().get(ll).getId(), statoDpatConfig,
											Integer.parseInt(anno));
									ArrayList<DpatIndicatore> app = new ArrayList<DpatIndicatore>();
									for (int kk = 0; kk < num_indicatori_per_sezioni; kk++) {
										if (index_indicatori < pp2.getElencoAttivita().get(ll).getElencoIndicatori()
												.size()) {
											// app.add(kk,
											// pp2.getElencoAttivita().get(ll).getElencoIndicatori().get(index_indicatori));
											DpatIndicatore ind_app = pp2.getElencoAttivita().get(ll)
													.getElencoIndicatori().get(index_indicatori);
											if (ind_app.getUiCalcolabile() == true)
												ind_app.setCarico_in_ui(
														calcolaUiIndicatoreTotale(d.getId(), db, ind_app.getId()));
											else
												ind_app.setCarico_in_ui(0);
											app.add(kk, ind_app);
											index_indicatori++;
										}
									}
									if (pp2.getElencoAttivita().get(ll).getUiCalcolabile() == true)
										pp2.getElencoAttivita().get(ll).setUi(calcolaUiAttivitaTotale(d.getId(), db,
												pp2.getElencoAttivita().get(ll).getId()));
									else
										pp2.getElencoAttivita().get(ll).setUi(0);
									pp2.getElencoAttivita().get(ll).setElencoIndicatori(app);
									pp.set(jj, pp2);
								}

								listaSezioniSplitted.add(newsz);
								newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
								listaPianiDaIncludere = new ArrayList<DpatPiano>();
								listaPianiDaIncludere.add(pp.get(jj));
								newsz.setElencoPiani(listaPianiDaIncludere);
								num_indicatori = num_indicatori_this_piano;
								if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
									listaSezioniSplitted.add(newsz);
								}
							}
						}

					}
				}

				d.setElencoSezioni(listaSezioniSplitted);

				// RECORD DI DPAT_STRUTTURA_INDICATORE PER POPOLARE LE CELLE DEL
				// DPAT

				pst.close();
				rs.close();

				// context.getRequest().setAttribute("elencoStruttureComplesse",
				// elencoStruttureComplesse);
				// context.getRequest().setAttribute("elencoStrutture",
				// elencoStrutture);
			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		// SERVER DOCUMENTALE
		String layout = context.getRequest().getParameter("layout");
		if (layout != null && layout.equals("style"))
			return ("DpatDetailCompetenzeStyleOK");
		// SERVER DOCUMENTALE

		return "DpatDetailCompetenzeOK";
	}

	public String executeCommandDpatDetailGenerale(ActionContext context) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		context.getRequest().setAttribute("anno", anno);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.Dpat d = null;
		try {
			db = this.getConnection(context);
			LookupList listaAsl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			sql = "select id from dpat where id_asl=" + idAsl + " and anno=" + anno + " and enabled ";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();

			String comboArea = context.getRequest().getParameter("combo_area");
			int idAreaSelezionata = -1;
			if (comboArea != null & !"".equals(comboArea))
				idAreaSelezionata = Integer.parseInt(comboArea);

			while (rs.next()) {
				d = new org.aspcfs.modules.dpat.base.Dpat();
				d.setId(rs.getInt("id"));
				d.builRecord(d.getId(), db, this.getSystemStatus(context), idAreaSelezionata);
				d.buildlistSezioni(db, d.getAnno());
			}

			d.setIdAreaSelezionata(idAreaSelezionata);
			if (d != null) {

				DpatIstanza istanza = new DpatIstanza();
				int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));

				int num_indicatori_per_sezioni = Integer
						.parseInt(ApplicationProperties.getProperty("NR_INDICATORI_PER_SEZIONE"));
				int num_indicatori = 0;
				ArrayList<DpatSezione> listaSezioniSplitted = new ArrayList<DpatSezione>();
				// ELENCO SEZIONI, PIANI, ATTIVITA' ED INDICATORI DEL DPAT

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db, d.getElencoSezioni().get(i).getId(), statoDpatConfig,
							Integer.parseInt(anno));

					DpatSezione newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
					ArrayList<DpatPiano> listaPianiDaIncludere = new ArrayList<DpatPiano>();
					int num_indicatori_this_piano = 0;
					num_indicatori = 0;

					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(), statoDpatConfig,
								Integer.parseInt(anno));

						num_indicatori_this_piano = 0;
						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA
						// LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
								.size(); k++) {

							int idAtt = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getId();
							if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.getUiCalcolabile() == true) {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(calcolaUiAttivitaTotale(d.getId(), db, idAtt));
							} else {
								d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.setUi(0.0);
							}

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
									.buildlistIndicatori(db, d.getElencoSezioni().get(i).getElencoPiani().get(j)
											.getElencoAttivita().get(k).getId(), statoDpatConfig,
											Integer.parseInt(anno));

							num_indicatori_this_piano = num_indicatori_this_piano
									+ (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k))
											.getElencoIndicatori().size();
							// SOMMA DELLE UI ATTIVITA' PER IL CALCOLO DEL SALDO
							// FINALE
							double somma = d.getSaldo();
							d.setSaldo(somma + d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
									.get(k).getUi());

							// PER OGNI INDICATORE CALCOLA L'UI TOTALE
							for (int ind = 0; ind < d.getElencoSezioni().get(i).getElencoPiani().get(j)
									.getElencoAttivita().get(k).getElencoIndicatori().size(); ind++) {
								if (d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
										.getElencoIndicatori().get(ind).getUiCalcolabile() == true) {
									int idInd = d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita()
											.get(k).getElencoIndicatori().get(ind).getId();
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind)
											.setCarico_in_ui(calcolaUiIndicatoreTotale(d.getId(), db, idInd));
								} else {
									d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k)
											.getElencoIndicatori().get(ind).setCarico_in_ui(0);
								}
							}

						}

						if ((num_indicatori + num_indicatori_this_piano) <= num_indicatori_per_sezioni) {
							num_indicatori = num_indicatori + num_indicatori_this_piano;
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else if (num_indicatori_this_piano <= num_indicatori_per_sezioni) {
							listaSezioniSplitted.add(newsz);
							newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
							listaPianiDaIncludere = new ArrayList<DpatPiano>();
							listaPianiDaIncludere.add(d.getElencoSezioni().get(i).getElencoPiani().get(j));
							newsz.setElencoPiani(listaPianiDaIncludere);
							num_indicatori = num_indicatori_this_piano;
							if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
								listaSezioniSplitted.add(newsz);
							}
						} else {

							int ii = num_indicatori_this_piano / num_indicatori_per_sezioni;
							if ((num_indicatori_this_piano % num_indicatori_per_sezioni) > 0) {
								ii++;
							}
							ArrayList<DpatPiano> pp = new ArrayList<DpatPiano>();
							for (int jj = 0; jj < ii; jj++) {
								DpatPiano app_piano = new DpatPiano();// (DpatPiano)(d.getElencoSezioni().get(i).getElencoPiani().get(j));
								app_piano.setId(d.getElencoSezioni().get(i).getElencoPiani().get(j).getId());
								app_piano.setId_sezione(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getId_sezione());
								app_piano.setDescription(
										d.getElencoSezioni().get(i).getElencoPiani().get(j).getDescription());
								app_piano.setEnabled(d.getElencoSezioni().get(i).getElencoPiani().get(j).getEnabled());
								app_piano.setElencoAttivita(new ArrayList<DpatAttivita>());
								pp.add(jj, app_piano);
							}

							int index_indicatori = 0;
							for (int jj = 0; jj < pp.size(); jj++) {
								DpatPiano pp2 = pp.get(jj);
								pp2.buildlistAttivita(db, pp2.getId(), statoDpatConfig, Integer.parseInt(anno));
								for (int ll = 0; ll < pp2.getElencoAttivita().size(); ll++) {
									pp2.getElencoAttivita().get(ll).buildlistIndicatori(db,
											pp2.getElencoAttivita().get(ll).getId(), statoDpatConfig,
											Integer.parseInt(anno));
									ArrayList<DpatIndicatore> app = new ArrayList<DpatIndicatore>();
									for (int kk = 0; kk < num_indicatori_per_sezioni; kk++) {
										if (index_indicatori < pp2.getElencoAttivita().get(ll).getElencoIndicatori()
												.size()) {
											// app.add(kk,
											// pp2.getElencoAttivita().get(ll).getElencoIndicatori().get(index_indicatori));
											// index_indicatori++;
											DpatIndicatore ind_app = pp2.getElencoAttivita().get(ll)
													.getElencoIndicatori().get(index_indicatori);
											if (ind_app.getUiCalcolabile() == true)
												ind_app.setCarico_in_ui(
														calcolaUiIndicatoreTotale(d.getId(), db, ind_app.getId()));
											else
												ind_app.setCarico_in_ui(0);
											app.add(kk, ind_app);
											index_indicatori++;
										}
									}
									if (pp2.getElencoAttivita().get(ll).getUiCalcolabile() == true)
										pp2.getElencoAttivita().get(ll).setUi(calcolaUiAttivitaTotale(d.getId(), db,
												pp2.getElencoAttivita().get(ll).getId()));
									else
										pp2.getElencoAttivita().get(ll).setUi(0);
									pp2.getElencoAttivita().get(ll).setElencoIndicatori(app);
									pp.set(jj, pp2);
								}

								listaSezioniSplitted.add(newsz);
								newsz = (DpatSezione) (d.getElencoSezioni().get(i)).clone();
								listaPianiDaIncludere = new ArrayList<DpatPiano>();
								listaPianiDaIncludere.add(pp.get(jj));
								newsz.setElencoPiani(listaPianiDaIncludere);
								num_indicatori = num_indicatori_this_piano;
								if (j == d.getElencoSezioni().get(i).getElencoPiani().size() - 1) {
									listaSezioniSplitted.add(newsz);
								}
							}
						}
					}
				}
				d.setElencoSezioniSplitted(listaSezioniSplitted);

				// CALCOLO CARICO E SALDO (TOTALE)
				d.setCarico_in_ui(calcolaCaricoTotale(d.getAnno(), d.getIdAsl(), db));
				double somma_ui_attivita = d.getSaldo();
				d.setSaldo(d.getCarico_in_ui() - somma_ui_attivita);

				// CALCOLO SALDO PER OGNI STRUTTURA
				for (int i = 0; i < d.getElencoStrutture().size(); i++) {
					int idStrutt = d.getElencoStrutture().get(i).getId();
					int idDpat = d.getId();
					int carico = d.getElencoStrutture().get(i).calcolaCaricoInUi(idStrutt, d.getAnno(), db);
					// double saldo = carico -
					// calcolaSaldoPerStruttura(idStrutt, idDpat, db); //DAVIDE
					double saldo = ottieniSaldoPerStrutturaDaDb(idStrutt, db); // DAVIDE
					d.getElencoStrutture().get(i).setSaldo(saldo);
					d.getElencoStrutture().get(i).buildElenco(db, idStrutt, idDpat, idAreaSelezionata);
				}

				DpatStrutturaIndicatore dsi = new DpatStrutturaIndicatore();
				HashMap<Integer, HashMap<Integer, DpatStrutturaIndicatore>> dsiList = dsi.buildLista(db, d.getId(),
						idAreaSelezionata);

				context.getRequest().setAttribute("dsiList", dsiList);

				pst.close();
				rs.close();
			}
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}

		// SERVER DOCUMENTALE
		String layout = context.getRequest().getParameter("layout");
		if (layout != null && layout.equals("style"))
			return ("DpatDetailStyleOK");
		// SERVER DOCUMENTALE

		return "DpatDetailOK";
	}

	public String executeCommandSalvaDefinitivo(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		String idDpat = (String) context.getRequest().getParameter("id");
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");
		Connection db = null;
		PreparedStatement pst = null;

		try {
			db = this.getConnection(context);
			DpatStrumentoCalcolo sdc = new DpatStrumentoCalcolo(db, Integer.parseInt(idAsl), Integer.parseInt(anno),
					this.getSystemStatus(context), -1);
			sdc.congelaStrumentoCalcolo(db);

			String sql = "update dpat set completo=true, modified=now(), modified_by=" + utente.getUserId()
					+ " where id=" + idDpat;

			pst = db.prepareStatement(sql);
			pst.executeUpdate();
			pst.close();

			pst = db.prepareStatement("update dpat_risorse_strumentali set completo=true, modified=now(), modifiedby="
					+ utente.getUserId() + " where id_asl=" + idAsl + " and anno = " + anno);
			pst.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("idAsl", idAsl);
		context.getRequest().setAttribute("anno", anno);
		return executeCommandDpatDetailGenerale(context);
	}

	public String executeCommandCongelaDpat(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		String idDpat = (String) context.getRequest().getParameter("id");
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");
		Connection db = null;
		PreparedStatement pst = null;
		String sql = "update dpat set congelato=true, dta_congelamento=now(), modified_by=" + utente.getUserId()
				+ " where id=" + idDpat;
		try {
			db = this.getConnection(context);
			pst = db.prepareStatement(sql);
			pst.executeUpdate();
			pst.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		context.getRequest().setAttribute("idAsl", idAsl);
		context.getRequest().setAttribute("anno", anno);
		return executeCommandDpatDetailGenerale(context);
	}

	public String executeCommandSalvaDefinitivoCompetenze(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		String idDpat = (String) context.getRequest().getParameter("id");
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");
		Connection db = null;
		PreparedStatement pst = null;

		String comboArea = context.getRequest().getParameter("combo_area");
		int idAreaSelezionata = -1;
		if (comboArea != null & !"".equals(comboArea))
			idAreaSelezionata = Integer.parseInt(comboArea);

		try {
			db = this.getConnection(context);

			if (idAreaSelezionata <= 0) {
				String sql = "update dpat set completo=true, modified=now(), modified_by=" + utente.getUserId()
						+ " where id=" + idDpat;
				pst = db.prepareStatement(sql);
				pst.executeUpdate();
				pst.close();
			} else {
				String sql = "update strutture_asl set stato_all6=2 where id=" + idAreaSelezionata;
				pst = db.prepareStatement(sql);
				pst.executeUpdate();
				pst.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("ComboArea", idAreaSelezionata);
		context.getRequest().setAttribute("idAsl", idAsl);
		context.getRequest().setAttribute("anno", anno);
		return executeCommandDpatDetailGeneraleCompetenze(context);
	}

	/******************
	 * METODI UTILITY *
	 ********************/

	private int ottieniSaldoPerStrutturaDaDb(int idStruttura, Connection conn) {
		int saldo = 0;
		String sql = "select saldo from saldi_strutture where id_struttura = ?";
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, idStruttura);
			rs = pst.executeQuery();
			rs.next();
			if (rs.next())
				saldo = Integer.parseInt(rs.getString(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return saldo;

	}

	private double calcolaUiAttivitaPerStruttura(int idAttivita, int idStruttura, Connection db) {
		double tot = 0.0F;
		try {
			String sql = "select sum(si.ui*c.coefficiente) as somma from dpat_struttura_indicatore si"
					+ " join dpat_coefficiente c on si.id_indicatore=c.id_indicatore" + " where si.id_struttura="
					+ idStruttura + " and si.descr_attivita='" + idAttivita + "'";
			PreparedStatement pst = null;
			ResultSet rs = null;
			double f = 0.0F;
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				f = rs.getDouble("somma");
			}
			pst.close();
			rs.close();
			tot = f;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return tot;
	}

	// DAVIDE
	// private double calcolaSaldoPerStruttura(int idStruttura, int idDpat,
	// Connection db) {
	// double saldo = 0;
	// try {
	//// String sql = "select descr_attivita, somma_ui from
	// dpat_struttura_indicatore "
	//// + "where id_struttura="
	//// + idStruttura
	//// + " and id_dpat="
	//// + idDpat + " and enabled=true group by descr_attivita,somma_ui";
	// PreparedStatement pst = null;
	// ResultSet rs = null;
	// pst = db.prepareStatement(sql);
	// rs = pst.executeQuery();
	// while (rs.next()) {
	// saldo = saldo + rs.getDouble("somma_ui");
	// }
	// pst.close();
	// rs.close();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	// return saldo;
	// }

	private int calcolaCaricoTotale(int anno, int idAsl, Connection db) {
		int carico = 0;
		PreparedStatement pst = null;
		ResultSet rs = null;
		// String sql =
		// "select sum(ui) as somma from dpat_ui_struttura where
		// id_dpat="+idDpat;
		String sql = "select sum(a.carico_lavoro_effettivo) as somma " + "from dpat_strumento_calcolo_strutture a "
				+ "join dpat_strumento_calcolo b on a.id_strumento_calcolo = b.id " + "where b.id_asl=" + idAsl
				+ " and a.trashed_Date is null and b.anno=" + anno;
		try {
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				carico = rs.getInt("somma");
			}
			pst.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return carico;
	}

	private int calcolaUiIndicatoreTotale(int idDpat, Connection db, int idInd) {
		int tot = 0;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select sum(ui::int) as somma from dpat_struttura_indicatore where id_dpat=" + idDpat
				+ " and id_indicatore=" + idInd + " and enabled=true";
		try {
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				tot = rs.getInt("somma");
			}
			pst.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return tot;
	}

	// DAVIDE : RITORNA INT INVECE DI DOUBLE
	private int calcolaUiAttivitaTotale(int idDpat, Connection db, int idAtt) {
		int tot = 0;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select sum(somma_ui::int) as somma from" + "("
				+ "select distinct dsi.descr_attivita,dsi.id_struttura,somma_ui "
				+ "from dpat_struttura_indicatore dsi  " + "join dpat_indicatore ind on ind.id = dsi.id_indicatore "
				+ " where descr_attivita='" + idAtt + "' and id_dpat=" + idDpat + " and dsi.enabled=true " + ")c ";
		try {
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				tot = rs.getInt("somma");
			}
			pst.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return tot;
	}

	private double calcolaSaldoTotale(int idDpat, Connection db) {
		double tot = 0.0F;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		try {
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				tot = rs.getDouble("somma");
			}
			pst.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return tot;
	}

	private LookupList ritorna_lookup_tutti_comuni(ActionContext context, int idAsl, Connection db) {
		LookupList ret = new LookupList();
		int i = -1;

		PreparedStatement stat = null;
		ResultSet res = null;
		String sql = "SELECT codiceistatcomune, comune FROM comuni ";
		if (idAsl > 0) {
			sql += " where 1=1 and codiceistatasl='" + idAsl + "'";
		}

		try {
			stat = db.prepareStatement(sql);
			res = stat.executeQuery();

			while (res.next()) {
				LookupElement thisElement = new LookupElement();
				thisElement.setCode(Integer.parseInt(res.getString(1)));
				thisElement.setDescription(res.getString(2));
				thisElement.setEnabled(true);
				ret.add(thisElement);
			}
			return (ret);

		} catch (Exception e) {
			e.printStackTrace();
			return (null);
		}
	}
		
	
	public String executeCommandCreaTemplateNewDpat(ActionContext context)
	{
		Connection db = null;
		ArrayList<DpatIstanza> anniList = new ArrayList<DpatIstanza>();
		String risultato = null;
		
		try {
			db = this.getConnection(context);
			/*devo prendere tutti i modelli non templates (quelli che non hanno nodi in stato 1, ma in 2 o 0) per gli anni
			 * e tutti quelli che invece hann otutti i nodi in stato 1, e sono caratterizzati dal nome template
			 */
			Integer anno = Integer.parseInt(context.getParameter("anno"));
			
			/*il nome scelto viene concatenato all'anno e viene messo un ID numerico per evitare duplicati alla fine*/
			
			WrapperTuttiModelli.creaNuovoTemplate(db,anno);
			risultato = "ok";
			
			
			
		} catch(Exception ex)
		{
			ex.printStackTrace();
			risultato = "ko";
			
		}finally {
			super.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("risultato", risultato);
		return "risultatoCreazioneTemplateDpatNew";
	}
	

	
//	public String executeCommandSearchPianiMonitoraggioAttivi(ActionContext context) throws ParseException {
//		if (!hasPermission(context, "piani-piani-view")) {
//			return ("PermissionError");
//		}
//		PagedListInfo ticListInfo = this.getPagedListInfo(context, "TicListPianiInfo");
//
//		UserBean user = (UserBean) context.getSession().getAttribute("User");
//		Connection db = null;
//		PianoMonitoraggioList ticList = new PianoMonitoraggioList();
//		String tipo = context.getRequest().getParameter("searchcodetipo_piano");
//		if (tipo == null || tipo.equals("")) {
//			tipo = (String) context.getRequest().getAttribute("searchcodetipo_piano");
//		}
//
//		String descrizione = context.getRequest().getParameter("searchdescrizione_piano");
//		if (descrizione == null || descrizione.equals("")) {
//			descrizione = (String) context.getRequest().getAttribute("searchdescrizione_piano");
//		}
//		String link = "Dpat.do?command=SearchPianiMonitoraggioAttivi";
//		if (tipo != null) {
//			ticList.setTipo(Integer.parseInt(tipo));
//			link += "&searchcodetipo_piano=" + tipo;
//			context.getRequest().setAttribute("searchcodetipo_piano", Integer.parseInt(tipo));
//		}
//		if (descrizione != null) {
//			ticList.setDescrizione(descrizione);
//			link += "&searchdescrizione_piano=" + descrizione;
//			context.getRequest().setAttribute("searchdescrizione_piano", descrizione);
//		}
//		ticListInfo.setLink(link);
//
//		String includiAttivita = context.getParameter("includiAttivita");
//
//		if (includiAttivita != null) {
//			context.getRequest().setAttribute("includiAttivita", includiAttivita);
//			if ("si".equalsIgnoreCase(includiAttivita)) {
//				ticList.setIncludeAttivita(true);
//			} else
//				ticList.setIncludeAttivita(false);
//		}
//
//		ticListInfo.setSearchCriteria(ticList, context);
//		ticList.setPagedListInfo(ticListInfo);
//
//		int year = Calendar.getInstance().get(Calendar.YEAR);
//
//		SystemStatus systemStatus = this.getSystemStatus(context);
//		try {
//			db = this.getConnection(context);
//
//			DpatIstanza istanzaDpat = new DpatIstanza(db, year);
//			istanzaDpat.setValoreFlagPianiImportati(db, year);
//			istanzaDpat.setValoreFlagAttivitaImportate(db, year);
//			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);
//
//			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
//			context.getRequest().setAttribute("lookup_asl", lookup_asl);
//
//			LookupList lookup_gruppi_piani = new LookupList(db, "lookup_sezioni_piani_monitoraggio");
//			lookup_gruppi_piani.addItem(-1, "-SELEZIONA GRUPPO DI MONITORAGGIO-");
//			context.getRequest().setAttribute("lookup_sezioni_piani", lookup_gruppi_piani);
//			ticList.buildList(db);
//		} catch (Exception e) {
//			context.getRequest().setAttribute("Error", e);
//			return ("SystemError");
//		} finally {
//			this.freeConnection(context, db);
//		}
//		context.getRequest().setAttribute("TicListPiani", ticList);
//
//		if (context.getRequest().getAttribute("ErrorDpat") != null)
//			context.getRequest().setAttribute("ErrorDpat", context.getRequest().getAttribute("ErrorDpat"));
//
//		return ("ResultsAttiviOK");
//	}

	public String executeCommandToReplace(ActionContext context)
			throws ParseException { /*
									 * Chiamato sia per piano/attivita che
									 * indicatore, con cessato = si quando si
									 * cessa
									 */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));

			DpatIstanza istanzaDpat = new DpatIstanza();
			istanzaDpat.setAnno(anno);
			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			context.getRequest().setAttribute("Cessazione", context.getParameter("cessato"));

			String tipoInserimento = context.getParameter("tipoInserimento");

			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));

			if ("dpat_indicatore".equalsIgnoreCase(context.getParameter("tipoPianoAtt"))) {
				DpatIndicatore indicatore = new DpatIndicatore(db, idPianoRiferimento, anno);
				indicatore.setTipoInserimento(tipoInserimento);
				context.getRequest().setAttribute("PianoRiferimentoInd",
						indicatore); /* vecchia gestione */
			} else {
				DpatAttivita att = new DpatAttivita(db, idPianoRiferimento,
						anno);/* vecchia gestione */
				att.setTipoInserimento(tipoInserimento);

				context.getRequest().setAttribute("PianoRiferimentoAtt", att);
			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		
		
		
		
		return ("ReplaceOK");
	}
	
	
 
	public String executeCommandDisabilitaEntry(ActionContext context) /*nuova gestione */
			throws ParseException {  
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			boolean congelato = context.getParameter("congelato") != null && Boolean.parseBoolean(context.getRequest().getParameter("congelato"));
			context.getRequest().setAttribute("congelato", context.getParameter("congelato"));
//			DpatIstanza istanzaDpat = new DpatIstanza();
//			istanzaDpat.setAnno(anno);
//			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			context.getRequest().setAttribute("Cessazione", context.getParameter("cessato"));

			String tipoInserimento = context.getParameter("tipoInserimento");

			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));

			Integer oidSezione = null;
			Integer oidPiano = null;
			
			if ("dpat_indicatore".equalsIgnoreCase(context.getParameter("tipoPianoAtt"))) {
				
				DpatIndicatoreNewBeanAbstract indicatoreNewDpat = null;
				if(congelato)
					indicatoreNewDpat = new DpatIndicatoreNewBean().buildByOid(db, idPianoRiferimento,false);
				else
					indicatoreNewDpat = new DpatIndicatoreNewBeanPreCong().buildByOid(db, idPianoRiferimento,false);
				
				indicatoreNewDpat.setTipoInserimento(tipoInserimento);
				context.getRequest().setAttribute("IndicatoreNewDPat", indicatoreNewDpat);
				
				oidPiano = indicatoreNewDpat.getOidPianoAttivita() != null ? indicatoreNewDpat.getOidPianoAttivita().intValue() : null;
				if(null != oidPiano)
				{
					DpatPianoAttivitaNewBeanInterface piano = null;
					if(congelato)
						piano = new DpatPianoAttivitaNewBean().buildByOid(db, oidPiano,false,true);
					else
						piano = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db, oidPiano,false,true);
					
					if(null != piano )
					{
						oidSezione = piano.getOidSezione() != null ? piano.getOidSezione().intValue() : null;
					}
					
				}
				
				
				
				
			} else {
				
				DpatPianoAttivitaNewBeanInterface pianoAttivitaNewDPat = null;
				if(congelato)
					pianoAttivitaNewDPat = new DpatPianoAttivitaNewBean().buildByOid(db, idPianoRiferimento,false,true);
				else
					pianoAttivitaNewDPat = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db, idPianoRiferimento, false, true);
				
				pianoAttivitaNewDPat.setTipoInserimento(tipoInserimento);
				context.getRequest().setAttribute("PianoAttivitaNewDPat", pianoAttivitaNewDPat);
				
				oidSezione = pianoAttivitaNewDPat.getOidSezione() != null ? pianoAttivitaNewDPat.getOidSezione().intValue() : null;
				
			}
			
			if(null != oidSezione)
			{
				DpatSezioneNewBeanInterface sez =null;
				if(congelato)
					sez = new DpatSezioneNewBean().buildByOid(db, oidSezione,false,true);
				else
					sez = new DpatSezioneNewBeanPreCong().buildByOid(db, oidSezione,false,true);
				
				context.getRequest().setAttribute("SezioneNewDpat", sez);
			}
			
			

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		
		
		return ("DisattivaEntryOK");
	}
	
	
	

	public String executeCommandToMoveAttivita(ActionContext context)
			throws ParseException {/* chiamato per update su attivita */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));

			DpatIstanza istanzaDpat = new DpatIstanza();
			istanzaDpat.setAnno(anno);
			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));

			DpatAttivita att = new DpatAttivita(db, idPianoRiferimento, anno);
			context.getRequest().setAttribute("PianoRiferimentoAtt", att);

			org.aspcfs.modules.dpat.base.Dpat dpat = new org.aspcfs.modules.dpat.base.Dpat();
			dpat.buildlistSezioni(db, anno);
			context.getRequest().setAttribute("ListaSezioniDpat", dpat);

			return ("MoveAttivitaOK");
		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
	}
	
	
	public String executeCommandUpdateEntryAttivita(ActionContext context)
	{ /* chiamato per update attivita */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			boolean congelato = false;
			if(context.getRequest().getAttribute("congelato") != null)
			{
				congelato = Boolean.parseBoolean((String)context.getRequest().getAttribute("congelato"));
			}
			else if(context.getParameter("congelato") != null)
			{
				congelato = Boolean.parseBoolean(context.getParameter("congelato"));
			}
			context.getRequest().setAttribute("congelato", congelato+"");
			

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			int idAttivita = Integer.parseInt(context.getParameter("idPianoRiferimento"));
			//DpatIndicatoreNewBean indicatore = DpatIndicatoreNewBean.buildByOid(db, idPianoRiferimento,false);
			DpatPianoAttivitaNewBeanInterface toolPA = null;
			DpatPianoAttivitaNewBeanInterface pianoAttivita = null;
			DpatSezioneNewBeanInterface toolSez = null;
			DpatSezioneNewBeanInterface sezione = null;
			DpatWrapperSezioniNewBeanAbstract sez = null;
			
			if(congelato)
			{
				sez = new DpatWrapperSezioniBean(anno,db,true,false);
				toolPA = new DpatPianoAttivitaNewBean();
				toolSez = new DpatSezioneNewBean();
			}
			else
			{
				sez = new DpatWrapperSezioniBeanPreCong(anno,db,true,false);
				toolPA = new DpatPianoAttivitaNewBeanPreCong();
				toolSez = new DpatSezioneNewBeanPreCong();
			}
			pianoAttivita = toolPA.buildByOid(db,idAttivita,true,true);
			sezione = toolSez.buildByOid(db,pianoAttivita.getOidSezione().intValue(),true,true);
			
			
//			context.getRequest().setAttribute("IndicatoreNewDPat", indicatore); 
			context.getRequest().setAttribute("PianoAttivitaNewDPat", pianoAttivita);
			context.getRequest().setAttribute("SezioneNewDPat", sezione);
			context.getRequest().setAttribute("ListaSezioniNewDPat", sez);
			

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		return ("UpdateAttivitaOK");
	
		
	}
	
	
	public String executeCommandUpdateEntryIndicatore(ActionContext context)
			throws ParseException { /* chiamato per update indicatore */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			boolean congelato = false;
			if(context.getRequest().getAttribute("congelato") != null)
			{
				congelato = Boolean.parseBoolean((String)context.getRequest().getAttribute("congelato"));
			}
			else if(context.getRequest().getParameter("congelato") != null)
			{
				congelato = Boolean.parseBoolean((String)context.getRequest().getParameter("congelato"));
			}
			context.getRequest().setAttribute("congelato", congelato+"");

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);
			

			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));
			
			DpatIndicatoreNewBeanAbstract indicatore = null;
			DpatPianoAttivitaNewBeanInterface pianoAttivita = null;
			DpatSezioneNewBeanInterface sezione = null;
			DpatWrapperSezioniNewBeanAbstract sez = null;
			if(congelato)
			{
				 indicatore = new DpatIndicatoreNewBean().buildByOid(db, idPianoRiferimento,false);
				 pianoAttivita = new DpatPianoAttivitaNewBean().buildByOid(db,indicatore.getOidPianoAttivita().intValue(),true,true);
				 sezione = new DpatSezioneNewBean().buildByOid(db, pianoAttivita.getOidSezione().intValue(),true,true);
				 sez =  new DpatWrapperSezioniBean(anno,db,true,true);
			}
			else
			{ 
				indicatore = new DpatIndicatoreNewBeanPreCong().buildByOid(db, idPianoRiferimento,false);
				 pianoAttivita = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db,indicatore.getOidPianoAttivita().intValue(),true,true);
				 sezione = new DpatSezioneNewBeanPreCong().buildByOid(db, pianoAttivita.getOidSezione().intValue(),true,true);
				 sez =  new DpatWrapperSezioniBeanPreCong(anno,db,true,true);
				
			}
			
		
			
			context.getRequest().setAttribute("IndicatoreNewDPat", indicatore); 
			context.getRequest().setAttribute("PianoAttivitaNewDPat", pianoAttivita);
			context.getRequest().setAttribute("SezioneNewDPat", sezione);
			context.getRequest().setAttribute("ListaSezioniNewDPat", sez);
			

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		return ("UpdateIndicatoreOK");
	}
	
	
	public String executeCommandToMoveIndicatore(ActionContext context)
			throws ParseException { /* chiamato per update indicatore */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {

			int anno = Integer.parseInt(context.getParameter("anno"));

			DpatIstanza istanzaDpat = new DpatIstanza();
			istanzaDpat.setAnno(anno);
			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);

			db = this.getConnection(context);
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));
			DpatIndicatore indicatore = new DpatIndicatore(db, idPianoRiferimento, anno);
			context.getRequest().setAttribute("PianoRiferimentoInd", indicatore);

			org.aspcfs.modules.dpat.base.Dpat dpat = new org.aspcfs.modules.dpat.base.Dpat();
			dpat.buildlistSezioni(db, anno);
			context.getRequest().setAttribute("ListaSezioniDpat", dpat);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		return ("MoveIndicatoreOK");
	}

		
	public String executeCommandNuovaEntry(ActionContext context) /*nuova gestione */
			throws ParseException { /*
									 * Chiamata quando si aggiunge
									 * piano/attivita o indicatore (discrimina
									 * tipoPianoAttivita)
									 */
		String viewName = null;
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			db = this.getConnection(context);

			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			String tipoInserimento = context.getParameter("tipoInserimento");
			boolean congelato = context.getParameter("congelato") != null && Boolean.parseBoolean((String)context.getParameter("congelato"));
			context.getRequest().setAttribute("congelato", context.getParameter("congelato"));
			
			/*DpatIstanza istanzaDpat = new DpatIstanza();
			istanzaDpat.setAnno(anno);
			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);
			*/
			
			int idPianoRiferimento = Integer.parseInt(context.getParameter(
					"idPianoRiferimento")); /*
											 * a seconda del tipoPianoAtt questo
											 * e' id piano_attivita o id
											 * indicatore
											 */
			 
			 
			
			
			if (tipoInserimento.equalsIgnoreCase("firstchild")) { /*se tipo inserimento e' firstchild, sicuramente e' per un tipoPianoAttivita = indicatore */
				 DpatPianoAttivitaNewBeanInterface pianoAttivitaRiferimento = null;
				 
				 if(congelato)
				 {
					 pianoAttivitaRiferimento = new DpatPianoAttivitaNewBean().buildByOid(db, idPianoRiferimento, false,true);
				 }
				 else
				 {
					 pianoAttivitaRiferimento = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db, idPianoRiferimento, false, true);
					  
				 }
				 
				 pianoAttivitaRiferimento.setTipoInserimento("firstchild");
				 context.getRequest().setAttribute("PianoAttivitaNewDPat", pianoAttivitaRiferimento);
				
				  

			} else {

				if ("dpat_indicatore".equalsIgnoreCase(context.getParameter("tipoPianoAtt"))) {
					/*distinguo se e' template o no */
					
					DpatIndicatoreNewBeanAbstract indicatoreNewDpat = null;
					if(congelato)
					{
						indicatoreNewDpat =new  DpatIndicatoreNewBean().buildByOid(db, idPianoRiferimento,false);  
						
					}
					else
					{
						indicatoreNewDpat = new  DpatIndicatoreNewBeanPreCong().buildByOid(db, idPianoRiferimento,false);   
						((DpatIndicatoreNewBeanPreCong)indicatoreNewDpat).setTipoInserimento(tipoInserimento);
					}
					
					indicatoreNewDpat.setTipoInserimento(tipoInserimento);																									 
					context.getRequest().setAttribute("IndicatoreNewDPat", indicatoreNewDpat);
					
				} else {
//					DpatAttivita att = new DpatAttivita(db, idPianoRiferimento, anno);
					DpatPianoAttivitaNewBeanInterface pianoAttivitaNewDPat = null;
					if(congelato)
					{
						pianoAttivitaNewDPat = new DpatPianoAttivitaNewBean().buildByOid(db,
								idPianoRiferimento,false,true);

						
					}
					else
					{
						pianoAttivitaNewDPat = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db,
								idPianoRiferimento,false,true);
						
					}
					pianoAttivitaNewDPat.setTipoInserimento(tipoInserimento);
					context.getRequest().setAttribute("PianoAttivitaNewDPat", pianoAttivitaNewDPat);
				}
				
				

			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		
		return ("AggiungiEntryOK");

	}
	

	public String executeCommandAdd(ActionContext context)
			throws ParseException { /*
									 * Chiamata quando si aggiunge
									 * piano/attivita o indicatore (discrimina
									 * tipoPianoAttivita)
									 */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			db = this.getConnection(context);

			int anno = Integer.parseInt(context.getParameter("anno"));
			String tipoInserimento = context.getParameter("tipoInserimento");

			DpatIstanza istanzaDpat = new DpatIstanza();
			istanzaDpat.setAnno(anno);

			context.getRequest().setAttribute("IstanzaDpat", istanzaDpat);
			int idPianoRiferimento = Integer.parseInt(context.getParameter(
					"idPianoRiferimento")); /*
											 * a seconda del tipoPianoAtt questo
											 * e' id piano_attivita o id
											 * indicatore
											 */

			if (tipoInserimento.equalsIgnoreCase("firstchild")) {
				DpatAttivita att = new DpatAttivita(db, idPianoRiferimento, anno);
				att.setTipoInserimento(tipoInserimento);

				DpatIndicatore indicatore = new DpatIndicatore();
				indicatore.setTipoInserimento(tipoInserimento);
				indicatore.setDescrizioneAttivita(att.getDescription());
				indicatore.setDescrizioneAttivita(att.getDescription());
				indicatore.setCodiceAttivita(att.getCodiceInterno());
				indicatore.setId_attivita(att.getId());
				indicatore.setIdAttivita_(att.getId_());
				indicatore.setDescription(att.getDescription());
				indicatore.setId(att.getId());
				context.getRequest().setAttribute("PianoRiferimentoInd", indicatore);

			} else {

				if ("dpat_indicatore".equalsIgnoreCase(context.getParameter("tipoPianoAtt"))) {
					DpatIndicatore indicatore = new DpatIndicatore(db, idPianoRiferimento, anno);// vecchia
																									// gestione

					indicatore.setTipoInserimento(tipoInserimento);
					context.getRequest().setAttribute("PianoRiferimentoInd", indicatore);
				} else {
					DpatAttivita att = new DpatAttivita(db, idPianoRiferimento, anno);
					att.setTipoInserimento(tipoInserimento);
					context.getRequest().setAttribute("PianoRiferimentoAtt", att);
				}

			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		return ("AddOK");
	}


	public String executeCommandInsertEffettivo(   /*nuova gestione*/
			ActionContext context) {  
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		boolean autocommit = false;
		try {
			/*l'inserimento viene fatto specificando rispetto a quale piano/attivita o indicatore (a seconda del tipo di inserimento) creare fratello (e se sopra o sotto come ordine) */
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			autocommit = db.getAutoCommit();
			db.setAutoCommit(false);
			
			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento")); /*a seconda del tipo di inserimento e' id piano/attivita o id indicatore */
			int idIndicatore = Integer.parseInt(context.getParameter("idIndicatore"));
			
			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			boolean congelato = context.getRequest().getParameter("congelato") != null ? Boolean.parseBoolean(context.getRequest().getParameter("congelato")) : false;
			context.getRequest().setAttribute("congelato", context.getRequest().getParameter("congelato"));
			
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			String descrizione = context.getRequest().getParameter("descrizione");
			String codice_esame = context.getRequest().getParameter("codice_esame");
			String asl = context.getRequest().getParameter("asl");
			String tipoAttivita = context.getParameter("tipoAttivita");
			String alias = context.getParameter("alias");
			String tipoInserimento = context.getParameter("tipoInserimento");
			String codiceAlias = context.getParameter("cup");
			/* nuova gestione */
			if(tipoInserimento.equalsIgnoreCase("firstchild")) /*unico caso in cui il riferimento e' piano attivita ma l'inserimento e' per indicatore */
			{
				DpatPianoAttivitaNewBeanInterface pianoAttivitaRiferimento = null;
				if(congelato)
				{
					pianoAttivitaRiferimento = new DpatPianoAttivitaNewBean().buildByOid(db, idPianoRiferimento, false, true);
					 
				}
				else
				{
					pianoAttivitaRiferimento = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db, idPianoRiferimento, false, true);
				}
						 
				/*non ha sicuramente figli attivi. Controllo se ne ha qualcuno non attivo */
				ArrayList figliNonAttivi = pianoAttivitaRiferimento.getIndicatoriFigli();
				
				DpatIndicatoreNewBeanAbstract indicatoreRiferimentoPerInserimento = null;
				DpatIndicatoreNewBeanAbstract tool = null;
				
				if(congelato)
				{
					tool = new DpatIndicatoreNewBean();
				}
				else
				{
					tool = new DpatIndicatoreNewBeanPreCong();
				}
				
				if(figliNonAttivi == null || figliNonAttivi.size() == 0)
				{
					/*devo creare allora un dummy per l'inserimento */
					
					int idIndicatoreRif = tool.insertDummyChildPerPianoAttivitaScelto(db, anno  , pianoAttivitaRiferimento.getOid() ); 
					indicatoreRiferimentoPerInserimento = tool.buildByOid( db,idIndicatoreRif, true);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: IL PIANO ATTIVITA PADRE NON AVEVA NEANCHE UN FIGLIO SCADUTO, QUINDI DEVO CREARE UN DUMMY CHILD TEMPORANEO");
					
					
				}
				else
				{
					/*prendo l'ultimo (i figli sono ordinati per campo order */
					indicatoreRiferimentoPerInserimento = (DpatIndicatoreNewBeanAbstract) figliNonAttivi.get(pianoAttivitaRiferimento.getIndicatoriFigli().size()-1);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: IL PIANO ATTIVITA PADRE AVEVA ALMENO UN FIGLIO SCADUTO("+indicatoreRiferimentoPerInserimento.getOid()+") , QUINDI USO QUESTO COME INDICATORE FRATELLO DI RIFERIMENTO PER L'INSERIMENTO");
				}
				
				
				DpatIndicatoreNewBeanAbstract toInsert = null;
				if(congelato)
					toInsert = new DpatIndicatoreNewBean();
				else
					toInsert = new DpatIndicatoreNewBeanPreCong();
				
				toInsert.setDescrizione(descrizione);
				toInsert.setCodiceEsame(codice_esame);
				toInsert.setCodiceAsl(asl);
				toInsert.setTipoAttivita(tipoAttivita);
				toInsert.setAliasIndicatore(alias);
				toInsert.setCodiceAliasIndicatore(codiceAlias);
				indicatoreRiferimentoPerInserimento.setTipoInserimento("down");
				
				tool.insert(db, indicatoreRiferimentoPerInserimento, descrizione, codice_esame, asl, tipoAttivita, alias, codiceAlias);
				/*potrei aver usatao come indicatoreDiRiferimento un dummy appositamente creato, quindi eventualmente lo cancello */
				int deleted = tool.deleteDummyBrother(db,indicatoreRiferimentoPerInserimento);
				if(deleted > 0)
				{
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: CANCELLATO DUMMY INDICATORE");
				}
						
				context.getRequest().setAttribute("IndicatoreNewDPat", toInsert);
				
			}
			else
			{
				if (context.getParameter("tipoPianoAttInd").equalsIgnoreCase(
						"dpat_attivita")) /* inserimento piano_attivita */
				{
					
					DpatPianoAttivitaNewBeanInterface pianoAttivitaRiferimento = null;
					DpatPianoAttivitaNewBeanInterface tool = null;
					DpatPianoAttivitaNewBeanInterface toInsert = null;
					if(congelato)
					{
						
						tool = new DpatPianoAttivitaNewBean();
						toInsert = new DpatPianoAttivitaNewBean();
					}
					else
					{
						tool = new DpatPianoAttivitaNewBeanPreCong();
						toInsert = new DpatPianoAttivitaNewBeanPreCong();
					}
					pianoAttivitaRiferimento = tool.buildByOid(db,idPianoRiferimento,false,true);
					
					
					toInsert.setDescrizione(descrizione);
					toInsert.setCodiceEsame(codice_esame);
					toInsert.setCodiceAsl(asl);
					toInsert.setTipoAttivita(tipoAttivita);
					toInsert.setAliasAttivita(alias);
					toInsert.setAliasPiano(alias); /*stessi alias, corretto ? */
					/*if (tipoAttivita!=null && tipoAttivita.equalsIgnoreCase("piano"))							
						toInsert.setAliasPiano(alias);
					else
						toInsert.setAliasAttivita(alias);
					stessi alias, corretto ? */
					
					toInsert.setCodiceAliasAttivita(codiceAlias);
					tool.insertBeforeOrAfter(db, toInsert, pianoAttivitaRiferimento, tipoInserimento);
					
					
					context.getRequest().setAttribute("PianoAttivitaNewDPat", toInsert );
//					DpatPianoAttivitaNewBean.insert(db, pianoAttivitaRiferimento, descrizione, codice_esame, asl,
//							tipoAttivita, alias );
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: INSERITO PIANO ATTIVITA RISPETTO A PIANO ATTIVITA "+idPianoRiferimento);

				} else {
					/* inserimento indicatore */
					DpatIndicatoreNewBeanAbstract indicatoreRiferimento = null;
					DpatIndicatoreNewBeanAbstract toInsert = null;
					DpatIndicatoreNewBeanAbstract tool = null;
					
					if(congelato)
					{
						tool = new DpatIndicatoreNewBean();
						toInsert = new DpatIndicatoreNewBean();
					}
					else
					{
						tool = new DpatIndicatoreNewBeanPreCong();
						toInsert = new DpatIndicatoreNewBean();
					}
					
					 indicatoreRiferimento = tool.buildByOid(db, idIndicatore,false);
					toInsert.setDescrizione(descrizione);
					toInsert.setCodiceEsame(codice_esame);
					toInsert.setCodiceAsl(asl);
					toInsert.setTipoAttivita(tipoAttivita);
					toInsert.setAliasIndicatore(alias);
					toInsert.setCodiceAliasIndicatore(codiceAlias);
//					indicatoreRiferimento.setTipoInserimento(tipoInserimento);
//					DpatIndicatoreNewBean.insert(db, indicatoreRiferimento, descrizione, codice_esame, asl, tipoAttivita,
//							alias);
					
					tool.insertBeforeOrAfter(db, toInsert, indicatoreRiferimento, tipoInserimento);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: INSERITO NUOVO INDICATORE, RISPETTO AD INDICATORE DI RIFERIMENTO (FRATELLO) "+idIndicatore);
					/*cancelliamo fratello dummy se eventualmente esiste (cioe' quello inserito di default quando si inserisce per la prima volta un piano/attivita, ovvero
					 * indicatore con descrizione INDICATORE DI DEFAULT DA SOSTITUIRE 
					 * NB: visto che gli inserimenti possono avvenire solo selezionando il fratello, quando si fa il primo inserimento di indicatore valido, che dovra' far saltare
					 * il dummy, il dummy sara' proprio quello usato come riferimento per l'inserimento, quindi si potrebbe pure fare delete secca usando come oid da cancellare
					 * quello dell'indicatoreRiferimento
					 */
					int deleted = tool.deleteDummyBrother(db,indicatoreRiferimento);
					if(deleted > 0)
						System.out.println(">>>>>>DPAT NUOVA GESTIONE: CANCELLATO DUMMY INDICATORE PRECEDENTEMENTE ESISTENTE");
					

					
					context.getRequest().setAttribute("IndicatoreNewDPat", toInsert);

				}
			}
			
			
			refreshMotiviCu(db,anno,true);
			
			db.commit();
			
			context.getRequest().setAttribute("inserito", "true");

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			try{
				db.rollback();
				System.out.println("ROllback eseguito");
				
			}catch(Exception ex){ex.printStackTrace(); }
			return ("SystemError");
		} finally {
			try{db.setAutoCommit(autocommit); } catch(Exception ex){}
			this.freeConnection(context, db);
		}

		return ("AggiungiEntryOK");

	}
	
	

	private void refreshMotiviCu(Connection db, int anno,boolean nuovaGestione) { /*se nuova gestione e' true, la tabella dei motivi viene popolata usando le nuove viste che si agganciano alle nuove tabelle */
		 PreparedStatement pst = null;
		 try
		 {
			 
			 pst = db.prepareStatement("select * from refresh_motivi_cu(?,?)");
			 pst.setInt(1, anno);
			 pst.setBoolean(2, nuovaGestione);
			 pst.executeQuery();
			 System.out.println(">>>>>>DPAT NUOVA GESTIONE: LANCIATO REFRESH_MOTIVI_CU PER ANNO "+anno);
			 System.out.println(">>>>>>DPAT NUOVA GESTIONE: IL REFRESH_MOTIVI_CU HA FATTO FINIRE LE ENTRIES DA "+(nuovaGestione ? "NUOVO FLUSSO " : "VECCHIO FLUSSO"));
		 }
		 catch(Exception ex)
		 {
			 ex.printStackTrace();
		 }
		 finally
		 {
			 try{pst.close();} catch(Exception ex){}
		 }
	}

	public String executeCommandInsert(ActionContext context)
			throws ParseException { /*
									 * chiamato per effettivo inserimento
									 * (indipend per piano/attivita indicatore
									 */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			int idPianoRiferimento = Integer.parseInt(context.getParameter("idPianoRiferimento"));
			int anno = Integer.parseInt(context.getParameter("anno"));
			LookupList lookup_asl = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("lookup_asl", lookup_asl);

			String descrizione = context.getRequest().getParameter("descrizione");
			String codice_esame = context.getRequest().getParameter("codice_esame");
			;
			String asl = context.getRequest().getParameter("asl");
			String tipoAttivita = context.getParameter("tipoAttivita");
			String codiceAlias = context.getParameter("alias");
			String tipoInserimento = context.getParameter("tipoInserimento");

			DpatAttivita attivitaRiferimento = new DpatAttivita(db, idPianoRiferimento, anno);
			DpatPiano piano = new DpatPiano();
			piano.setEnabled(true);

			String note = context.getRequest().getParameter("note");
			// String tipo_piano =
			// context.getRequest().getParameter("tipo_piano");
			String sezione = context.getRequest().getParameter("sezione");

			String descrizionePiano = "";
			if (context.getParameter("tipoAttivita").contains("ATTIVITA"))
				descrizionePiano = "ATTIVITA";
			else
				descrizionePiano = "PIANO";

			if (context.getParameter("tipoPianoAttInd").equalsIgnoreCase("dpat_attivita")) {

				attivitaRiferimento.setTipoInserimento(context.getParameter("tipoInserimento"));

				String selectStato = "select max(stato) from dpat_attivita where id_piano = ? and anno =" + anno;

				PreparedStatement pst = db.prepareStatement(selectStato);
				pst.setInt(1, attivitaRiferimento.getId_piano());
				ResultSet rs = pst.executeQuery();
				int stato = 1;
				if (rs.next())
					stato = rs.getInt(1) % 2;
				piano.setId_sezione(Integer.parseInt(context.getParameter("root")));
				piano.setDescription(descrizionePiano + " " + context.getParameter("alias"));
				piano.setAlias(context.getParameter("alias"));
				piano.setTipoAttivita(context.getParameter("tipoAttivita"));
				piano.setOrdinamento(attivitaRiferimento.getOrdinamento());

				piano.setStato(stato);
				piano.insert(db, attivitaRiferimento, anno);

				DpatAttivita att = new DpatAttivita();
				att.setId_piano(piano.getId());
				att.setDescription(descrizione);
				att.setCodiceEsame(codice_esame);
				att.setStato(stato);
				att.setCodiceAlias(context.getParameter("cup"));
				att.setCodicePiano(piano.getCodiceInterno());
				att.setAlias(context.getParameter("alias"));
				att.setTipoAttivita(context.getParameter("tipoAttivita"));
				att.insert(db, attivitaRiferimento, anno);

				DpatIndicatore ind = new DpatIndicatore();
				ind.setId_attivita(att.getId());
				ind.setDescription("INDICATORE DI DEFAULT DASOSTITUIRE");
				ind.setCodiceEsame("");
				ind.setCodiceAttivita(att.getCodiceInterno());
				ind.setAlias("");
				ind.setTipoAttivita(att.getTipoAttivita());
				ind.setStato(stato);

				ind.setUiCalcolabile(false);

				DpatCoefficiente coeff = new DpatCoefficiente();
				coeff.setCoefficiente(0);

				ind.setCoefficiente(coeff);
				ind.insert(db, anno);

				context.getRequest().setAttribute("inserito", "true");
			} else {

				DpatIndicatore indRif = null;
				if ((context.getParameter("tipoInserimento")).equalsIgnoreCase("firstchild")) {
					indRif = new DpatIndicatore();
					indRif.setId_attivita(idPianoRiferimento);
					indRif.setCodiceAttivita(idPianoRiferimento);
					indRif.setOrdinamento(0);
				} else
					indRif = new DpatIndicatore(db, idPianoRiferimento, anno);

				indRif.setTipoInserimento(context.getParameter("tipoInserimento"));

				String selectStato = "select max(stato) from dpat_indicatore where id_attivita = ?";

				PreparedStatement pst = db.prepareStatement(selectStato);
				pst.setInt(1, indRif.getId_attivita());
				ResultSet rs = pst.executeQuery();
				int stato = 1;
				if (rs.next())
					stato = rs.getInt(1) % 2;

				DpatIndicatore ind = new DpatIndicatore();

				ind.setId_attivita(Integer.parseInt(context.getParameter("root")));

				ind.setCodiceAttivita(indRif.getCodiceAttivita());
				ind.setDescription(descrizione);
				ind.setCodiceEsame(codice_esame);
				ind.setAlias(context.getParameter("alias"));
				ind.setTipoAttivita(context.getParameter("tipoAttivita"));
				ind.setStato(stato);
				ind.setOrdinamento(indRif.getOrdinamento());
				ind.setCodiceAlias(context.getParameter("cup"));
				ind.setUiCalcolabile(false);
				if (context.getParameter("uiCalcolabile") != null
						&& "si".equalsIgnoreCase(context.getParameter("uiCalcolabile")))
					ind.setUiCalcolabile(true);

				DpatCoefficiente coeff = new DpatCoefficiente();
				// coeff.setCoefficiente(Double.parseDouble(
				// context.getParameter("coefficiente")));
				coeff.setCodiceIndicatore(ind.getCodiceInterno());
				ind.setCoefficiente(coeff);
				ind.insert(db, indRif, anno);
				context.getRequest().setAttribute("inserito", "true");
			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}

		return ("AddOK");
	}

	public String executeCommandReplace(ActionContext context) throws ParseException {
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			int anno = Integer.parseInt(context.getParameter("anno"));

			int id = Integer.parseInt(context.getParameter("id"));

			String descrizione = context.getRequest().getParameter("descrizione");
			String note = context.getRequest().getParameter("note");
			String codice_esame = context.getRequest().getParameter("codice_esame");
			String sezione = context.getRequest().getParameter("sezione");
			String asl = context.getRequest().getParameter("asl");

			String descrizionePiano = "";
			if (context.getParameter("tipoAttivita").contains("ATTIVITA"))
				descrizionePiano = "ATTIVITA";
			else
				descrizionePiano = "PIANO";

			String cessazione = context.getParameter("cessato");

			if ("dpat_attivita".equalsIgnoreCase(context.getParameter("tipoClasse"))) {

				DpatAttivita dpatAtt = new DpatAttivita(db, id, anno);
				if (dpatAtt.getDataScadenza() == null) {

					DpatPiano piano = new DpatPiano(db, dpatAtt.getId_piano());
					piano.setEnabled(true);

					String selectStato = "select max(stato) from dpat_attivita where id_piano = ? and anno = " + anno;

					PreparedStatement pst = db.prepareStatement(selectStato);
					pst.setInt(1, dpatAtt.getId_piano());
					ResultSet rs = pst.executeQuery();
					int stato = 1;
					if (rs.next())
						stato = rs.getInt(1) % 2;

					dpatAtt.disabilitaAttivita(db, context.getParameter("dataScadenza"), anno);

					if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
						piano.setStato(stato);
						piano.setId_sezione(Integer.parseInt(context.getParameter("root")));
						piano.setDescription(descrizionePiano + " " + context.getParameter("alias"));
						piano.setAlias(context.getParameter("alias"));
						piano.setTipoAttivita(context.getParameter("tipoAttivita"));

						piano.insert(db, anno);

						dpatAtt.setStato(stato);
						dpatAtt.setId_piano(piano.getId());
						dpatAtt.setCodicePiano(piano.getCodiceInterno());
						dpatAtt.setDescription(descrizione);
						dpatAtt.setCodiceEsame(codice_esame);
						dpatAtt.setAlias(context.getParameter("alias"));
						dpatAtt.setTipoAttivita(context.getParameter("tipoAttivita"));
						dpatAtt.insert(db, anno);
					}
				} else {

					String selectStato = "select max(stato) from dpat_attivita where id_piano = ? and anno = " + anno;
					int stato = 1;
					PreparedStatement pst = db.prepareStatement(selectStato);
					pst.setInt(1, dpatAtt.getId_piano());
					ResultSet rs = pst.executeQuery();

					if (rs.next())
						stato = rs.getInt(1) % 2;

					if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
						dpatAtt.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), false, anno);

						dpatAtt.setDescription(descrizione);
						dpatAtt.setCodiceEsame(codice_esame);
						dpatAtt.setAlias(context.getParameter("alias"));

						dpatAtt.setTipoAttivita(context.getParameter("tipoAttivita"));
						dpatAtt.setStato(stato);

						dpatAtt.updateRecordDaAttivate(db, anno);
					} else {
						dpatAtt.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), true, anno); // setto
																													// la
																													// data
																													// scadenza
																													// anche
																													// sul
																													// record
																													// che
																													// sidovraattualizzare
					}

				}

			} else {

				DpatIndicatore ind = new DpatIndicatore(db, id, anno);
				if (ind.getDataScadenza() == null) {

					String selectStato = "select max(stato) from dpat_indicatore where id_attivita = ? and anno = "
							+ anno;

					PreparedStatement pst = db.prepareStatement(selectStato);
					pst.setInt(1, ind.getId_attivita());
					ResultSet rs = pst.executeQuery();
					int stato = 1;
					if (rs.next())
						stato = rs.getInt(1) % 2;

					ind.disabilitaIndicatore(db, context.getParameter("dataScadenza"), anno);

					if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
						ind.setStato(stato);
						ind.setId_attivita(Integer.parseInt(context.getParameter("root")));
						ind.setDescription(descrizione);
						ind.setCodiceEsame(codice_esame);
						ind.setAlias(context.getParameter("alias"));
						ind.setTipoAttivita(context.getParameter("tipoAttivita"));

						ind.setUiCalcolabile(false);
						if (context.getParameter("uiCalcolabile") != null
								&& "si".equalsIgnoreCase(context.getParameter("uiCalcolabile")))
							ind.setUiCalcolabile(true);

						DpatCoefficiente coeff = new DpatCoefficiente();
						coeff.setId_indicatore(ind.getCodiceInterno());
						coeff.setCoefficiente(Double.parseDouble(context.getParameter("coefficiente")));
						coeff.setCodiceIndicatore(ind.getCodiceInterno());

						ind.setCoefficiente(coeff);

						ind.insert(db, anno);
					}
				} else {

					if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
						ind.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), false);

						ind.setDescription(descrizione);
						ind.setCodiceEsame(codice_esame);
						ind.setAlias(context.getParameter("alias"));
						ind.setTipoAttivita(context.getParameter("tipoAttivita"));

						ind.setUiCalcolabile(false);
						if (context.getParameter("uiCalcolabile") != null
								&& "si".equalsIgnoreCase(context.getParameter("uiCalcolabile")))
							ind.setUiCalcolabile(true);

						ind.updateRecordDaAttivate(db, anno); // OK

					} else {
						ind.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), true);
					}

				}
			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");

		return ("AddOK");
	}
	
	
	
	public String executeCommandDisattivaEffettivo(ActionContext context) throws ParseException { /*nuova gestione */
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		boolean autocommit = false;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			autocommit = db.getAutoCommit();
			db.setAutoCommit(false);
			
			int anno = Integer.parseInt(context.getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			boolean congelato = context.getParameter("congelato") != null && Boolean.parseBoolean((String)context.getRequest().getParameter("congelato"));
			context.getRequest().setAttribute("congelato", context.getParameter("congelato"));
			
			int id = Integer.parseInt(context.getParameter("id"));




			if ("dpat_attivita".equalsIgnoreCase(context.getParameter("tipoClasse"))) /*piano attivita*/
			{
				DpatPianoAttivitaNewBeanInterface pInterf = congelato ? new DpatPianoAttivitaNewBean() : new DpatPianoAttivitaNewBeanPreCong();
				pInterf.disabilitaByOid(db,id,anno);
				System.out.println(">>>>>>DPAT NUOVA GESTIONE: DISABILITATO PIANO ATTIVITA (CON FIGLI)");
			} 
			else /*piano indicatore*/
			{
				DpatIndicatoreNewBeanAbstract indInterf = congelato ? new DpatIndicatoreNewBean() : new DpatIndicatoreNewBeanPreCong();
				indInterf.disabilitaByOid(db,id,anno);
				
				System.out.println(">>>>>>DPAT NUOVA GESTIONE: DISABILITATO INDICATORE CON OID "+id);
				/*lancio funzione che inserisce dummy child per il padre a cui ho disabilitato indicatore*/
				/*questa funzione inserisce il dummy soltanto se quel padre non ha piu' figli */
//				DpatIndicatoreNewBean indicatoreDisabilitato = DpatIndicatoreNewBean.buildByOid(db, id, false);
//				Long idPianoAttivitaPadre = indicatoreDisabilitato.getOidPianoAttivita();
//				int idDummyInserito = DpatIndicatoreNewBean.insertDummyChildPerPianoAttivitaScelto(db, anno, idPianoAttivitaPadre);
//				if(idDummyInserito > 0)
//				{
//					System.out.println(">>>>>>DPAT NUOVA GESTIONE: DOPO LA DISATTIVAZIONE DELL INDICATORE CON OID "+id+" IL PIANO ATTIVITA PADRE("+idPianoAttivitaPadre+") NON HA PIU' FIGLI. AGGIUNTO DUMMY INDICATORE CON OID "+idDummyInserito);
//				}
				
			}
			
			refreshMotiviCu(db, anno,true);
			db.commit();
			
			
		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			try
			{
				db.rollback();
				System.out.println("rollback eseguito");
			}
			catch(Exception ex)
			{
				ex.printStackTrace();;
			}
			return ("SystemError");
		} finally {
			
			try
			{
				db.setAutoCommit(autocommit);
			}
			catch(Exception ex){ex.printStackTrace();}
			
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");
		return ("DisattivaEntryOK");
		
	}

	
	
	public String executeCommandModificaAttivitaEffettivo(ActionContext context) throws ParseException {
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		boolean autocommit = false;
		
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			autocommit = db.getAutoCommit();
			db.setAutoCommit(false);
			
			
			int operazione = Integer.parseInt(context.getParameter("operazione"));
			int id = Integer.parseInt(context.getParameter("id"));
			//String descrizione = context.getRequest().getParameter("descrizione");
			String descrizione;
			if(context.getRequest().getParameter("descrizione") != null){
				descrizione = context.getRequest().getParameter("descrizione").trim();
			} else {
				descrizione = context.getRequest().getParameter("descrizione");
			}
			
			String codice_esame = context.getRequest().getParameter("codice_esame");
			String alias = context.getRequest().getParameter("alias"); /*lo usiamo come alias piano */
			String codiceAliasAttivita = context.getParameter("cup");
			
			HttpServletRequest request = context.getRequest();
			Integer anno = Integer.parseInt(context.getRequest().getParameter("anno"));
			request.setAttribute("anno", anno+"");
			
			boolean congelato = false;
			if(request.getAttribute("congelato")!= null)
			{
				congelato = Boolean.parseBoolean((String)request.getAttribute("congelato"));
			}
			else if(request.getParameter("congelato") != null)
			{
				congelato = Boolean.parseBoolean((String)request.getParameter("congelato"));
			}
			request.setAttribute("congelato", congelato+"");
			
			DpatPianoAttivitaNewBeanInterface toolPA = null;
			DpatPianoAttivitaNewBeanInterface attivitaDaModificare = null, toInsert = null, pianoAttivitaDaSpostare = null, pianoAttivitaNuovoFratello,lastChild = null;
			DpatSezioneNewBeanInterface	toolSez = null;
			Integer oidInserito = null;
			
			if(congelato)
			{
				toolPA = new DpatPianoAttivitaNewBean();
				toInsert = new DpatPianoAttivitaNewBean();
				toolSez = new DpatSezioneNewBean();
			}
			else
			{
				toolPA = new DpatPianoAttivitaNewBeanPreCong();
				toInsert = new DpatPianoAttivitaNewBeanPreCong();
				toolSez = new DpatSezioneNewBeanPreCong();
			}
			
			switch(operazione)
			{
				case 1 : 
				{
					/*modifica  con mantenimento dei vecchi controlli sui vecchi motivi (quindi con dup)*/
					/*l'inserimento con duplicazione e' visto come :
					 * creo un nuovo bean, e lo inserisco dopo quello che sto modificando
					 * quindi prendo i campi che arrivano dalle maschere e li metto nel bean da inserire (l'ho gia' fatto prima di chiamare questo metodo
					 * ) e prendo i campi che non arrivano da maschere, che devono quindi provenire dal bean che sto duplicando (che e'  indicatore di riferimento)
					 * e li scarico in quello da inserire
					 */
					attivitaDaModificare = toolPA.buildByOid(db,id,false,true);
					toInsert.setDescrizione(descrizione);
					toInsert.setCodiceEsame(codice_esame);
					toInsert.setAliasPiano(alias);
					toInsert.setAliasAttivita(alias);
					/*if (attivitaDaModificare.getTipoAttivita()!=null && attivitaDaModificare.getTipoAttivita().equalsIgnoreCase("piano"))							
						toInsert.setAliasPiano(alias);
					else
						toInsert.setAliasAttivita(alias);
					stessi alias, corretto ? */
					
					toInsert.setCodiceAliasAttivita(codiceAliasAttivita);
					toInsert.setCodiceRaggruppamento(attivitaDaModificare.getCodiceRaggruppamento()); /*questo fa si che nell'insertBeforeOrAfter venga mantenuto e non sia considerato un vero inserimento ex novo */
					toInsert.setOidSezione(attivitaDaModificare.getOidSezione());
					toInsert.setAnno(attivitaDaModificare.getAnno());
					toInsert.setOrdine(attivitaDaModificare.getOrdine()+1);
					toInsert.setTipoAttivita(attivitaDaModificare.getTipoAttivita());
					toInsert.setCodiceInternoPiano(attivitaDaModificare.getCodiceInternoPiano());
					toInsert.setCodiceInternoAttivita(attivitaDaModificare.getCodiceInternoAttivita());
					/*aggiungo i figli che mi voglio portare (il controllo sugli scaduti verra' fatto in fase di effettivo trasferimento) */
					toInsert.setIndicatoriFigli(attivitaDaModificare.getIndicatoriFigli());
					oidInserito =toolPA.update(toInsert,attivitaDaModificare,db);
					int aggiornati = toolPA.aggiornaCodiceAliasAttivitaPerTutteVersioni(db, toInsert);
					
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: SONO STATI AGGIORNATI "+aggiornati+" CODICI ALIAS ATTIVITA PER LO STESSO CODICE RAGGRUPPAMENTO)");
					break;
				}
				case 2 : 
				{
					/* AGGIORNATO : ELIMINATA COME CASISTICA
					 * modifica di indicatore senza mantenimento dei vecchi controlli sui vecchi motivi (quindi senza dup)*/
					
					/*DpatPianoAttivitaNewBean pianoDaModificare = DpatPianoAttivitaNewBean.buildByOid(db,id,false);;
					pianoDaModificare.updateSenzaDup(descrizione, codiceAlias,alias,codice_esame,db);
					break*/
					
					throw new Exception("OPERAZIONE NON PIU' PREVISTA");
					
				}
				case 3 : 
				{
					/*spostamento indicatore */
					/*se come posizione indico 1 (prima di) allora devo fare inserimento come fratello dell'indicatore con oid in indicatoreRiferimento, prima */
					/*altrimenti inserisco come ultimo figlio del piano/attivita */
					Integer oidSezioneNuovoPadre = Integer.parseInt(context.getRequest().getParameter("sezione"));
					Integer posizione = Integer.parseInt(context.getRequest().getParameter("posizione"));
					Integer oidPianoAttivitaFratello = Integer.parseInt(context.getRequest().getParameter("pianoAttivitaRiferimento"));
					 pianoAttivitaDaSpostare = toolPA.buildByOid(db, id,false,true);
					 
					if(posizione == 1) /* inserimento di indicatore prima (up) di indicatore scelto */
					{
						 pianoAttivitaNuovoFratello = toolPA.buildByOid(db,oidPianoAttivitaFratello,false,true);
						oidInserito = toolPA.insertBeforeOrAfter(db, pianoAttivitaDaSpostare, pianoAttivitaNuovoFratello, "up");
						
						
					}
					else /*inserimento alla fine della sezione */
					{
						/*cerco ultimo figlio (attivo) del piano attivita specificato */
						 lastChild = toolPA.searchLastChildOf(db,oidSezioneNuovoPadre,false);
						 oidInserito = toolPA.insertBeforeOrAfter(db, pianoAttivitaDaSpostare, lastChild, "down");
						
					}
					/*disabilito quello che ho spostato, cioe' la vecchia copia */
					
					toolPA.disabilitaByOid(db, pianoAttivitaDaSpostare.getOid().intValue(), pianoAttivitaDaSpostare.getAnno());
					System.out.println(">>>>>>DPAT NUOVA GESTIONE:LO SPOSTAMENTO HA FATTO SI CHE VENISSE DISABILITATA LA VECCHIA VERSIONE CON OID "+pianoAttivitaDaSpostare.getOid().intValue()+" CON FIGLI" );
					 
				}
				
				
			}
			
			
			if(congelato)
			{
				refreshMotiviCu(db,anno,true);
			}
//			ELSE //FORSE NUN ZERV
//			{
//				REFRESHMOTIVICU(DB,ANNO,FALSE);
//			}
			
			
			/*risetto i bean affinche' la pagina di rientro non schiatti */
			DpatPianoAttivitaNewBeanInterface toResendPA = toolPA.buildByOid(db, oidInserito, true,false);
			DpatSezioneNewBeanInterface toResendSez = toolSez.buildByOid(db, toResendPA.getOidSezione().intValue(), true, false);
			context.getRequest().setAttribute("PianoAttivitaNewDPat", toResendPA);
			context.getRequest().setAttribute("SezioneNewDPat", toResendSez);
			
			if(congelato)
			{
				context.getRequest().setAttribute("ListaSezioniNewDPat", new DpatWrapperSezioniBean());
			}
			else
			{
				context.getRequest().setAttribute("ListaSezioniNewDPat", new DpatWrapperSezioniBeanPreCong());
			}
			
			db.commit();
			 
			

		} catch (Exception e) {
			
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			try{
				db.rollback();
				System.out.println("Rollback eseguito");
			} catch(Exception ex) {ex.printStackTrace(); }
			return ("SystemError");
		} finally {
			try{db.setAutoCommit(autocommit); } catch(Exception ex){}
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");

		return ("UpdateAttivitaOK");
	
		
	}
	
	
	
	
	
	public String executeCommandModificaIndicatoreEffettivo(ActionContext context) throws ParseException {
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		boolean autocommit = false;
		
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			autocommit = db.getAutoCommit();
			db.setAutoCommit(false);
			int operazione = Integer.parseInt(context.getParameter("operazione"));
			int id = Integer.parseInt(context.getParameter("id"));
			String descrizione;
			if(context.getRequest().getParameter("descrizione") != null){
				descrizione = context.getRequest().getParameter("descrizione").trim();
			} else {
				descrizione = context.getRequest().getParameter("descrizione");
			}
			String codice_esame = context.getRequest().getParameter("codice_esame");
			String alias = context.getRequest().getParameter("alias");
			String codiceAliasIndicatore = context.getParameter("cup");
			
			Integer anno = Integer.parseInt(context.getRequest().getParameter("anno"));
			context.getRequest().setAttribute("anno", anno+"");
			
			HttpServletRequest request = context.getRequest();
			
			boolean congelato = false;
			if(request.getAttribute("congelato") != null)
			{
				congelato = Boolean.parseBoolean((String)request.getAttribute("congelato"));
			}
			else if(request.getParameter("congelato") != null)
			{
				congelato = Boolean.parseBoolean(request.getParameter("congelato"));
				
			}
			request.setAttribute("congelato", congelato+"");
			
			DpatIndicatoreNewBeanAbstract indicatoreDaModificare = null,  indicatoreNuovoFratello = null, lastChild = null, riferimentoPerInserimento = null;
			DpatIndicatoreNewBeanAbstract toInsert = null;
			DpatIndicatoreNewBeanAbstract tool = null;
			DpatSezioneNewBeanInterface toolSez = null; 
			
			DpatPianoAttivitaNewBeanInterface beanNuovoPadre = null,toolPA = null; 
			Integer oidNuovoIndicatore = null;
			
			if(congelato)
			{
				tool = new DpatIndicatoreNewBean();
				toInsert = new DpatIndicatoreNewBean();
				toolPA = new DpatPianoAttivitaNewBean();
				toolSez = new DpatSezioneNewBean(); 
				
			}
			else
			{
				tool = new DpatIndicatoreNewBeanPreCong();
				toInsert = new DpatIndicatoreNewBeanPreCong();
				toolPA = new DpatPianoAttivitaNewBeanPreCong();
				toolSez = new DpatSezioneNewBeanPreCong(); 
				
			}
			
			switch(operazione)
			{
				
				case 1 : 
				{
					/*modifica di indicatore con mantenimento dei vecchi controlli sui vecchi motivi (quindi con dup)*/
					
					
					
					

					/*l'inserimento con duplicazione e' visto come :
					 * creo un nuovo bean, e lo inserisco dopo quello che sto modificando
					 * quindi prendo i campi che arrivano dalle maschere e li metto nel bean da inserire (l'ho gia' fatto prima di chiamare questo metodo
					 * ) e prendo i campi che non arrivano da maschere, che devono quindi provenire dal bean che sto duplicando (che e'  indicatore di riferimento)
					 * e li scarico in quello da inserire
					 */
					indicatoreDaModificare = tool.buildByOid(db,id,false);
					
					toInsert.setDescrizione(descrizione);
					toInsert.setCodiceEsame(codice_esame);
					toInsert.setAliasIndicatore(alias);
					toInsert.setCodiceAliasIndicatore(codiceAliasIndicatore);
					toInsert.setCodiceRaggruppamento(indicatoreDaModificare.getCodiceRaggruppamento()); /*questo fa si che nell'insertBeforeOrAfter venga mantenuto */
					toInsert.setOidPianoAttivita(indicatoreDaModificare.getOidPianoAttivita());
					toInsert.setAnno(indicatoreDaModificare.getAnno());
					toInsert.setOrdine(indicatoreDaModificare.getOrdine()+1);
					toInsert.setTipoAttivita(indicatoreDaModificare.getTipoAttivita());
					toInsert.setCodiceInternoIndicatore(indicatoreDaModificare.getCodiceInternoIndicatore());
					toInsert.setCodiceInternoPianiGestioneCu(indicatoreDaModificare.getCodiceInternoPianiGestioneCu());
					toInsert.setCodiceInternoAttivitaGestioneCu(indicatoreDaModificare.getCodiceInternoAttivitaGestioneCu());
					toInsert.setCodiceInternoUnivocoTipoAttivitaGestioneCu(indicatoreDaModificare.getCodiceInternoUnivocoTipoAttivitaGestioneCu());
						
					/*SPOSTO COMPETENZE */
					 oidNuovoIndicatore   = tool.update(toInsert,indicatoreDaModificare,db);
					Integer competenzeSpostate = tool.spostaCompetenzeFromTo(indicatoreDaModificare.getOid(), oidNuovoIndicatore.longValue(),db);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: SONO STATE SPOSTATE "+competenzeSpostate+" COMPETENZE (MODELLO 5)");
					
					int aggiornati = tool.aggiornaCodiceAliasIndicatorePerTutteVersioni(db, toInsert);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: SONO STATI AGGIORNATI "+aggiornati+" CODICI ALIAS INDICATORI PER LO STESSO CODICE RAGGRUPPAMENTO)");
					
					break;
				}
				case 2 : 
				{
					/*AGGIORNAMENTO : CASO ELIMINATO
					 * 
					 * modifica di indicatore senza mantenimento dei vecchi controlli sui vecchi motivi (quindi senza dup)*/
					/*
					 * 
					DpatIndicatoreNewBean indicatoreDaModificare = DpatIndicatoreNewBean.buildByOid(db,id,false);;
					indicatoreDaModificare.updateSenzaDup(descrizione, codiceAlias,alias,codice_esame,db);
					break;
					*/
					
					throw new Exception("OPERAZIONE NON PIU' PREVISTA");
					
					 
				}
				case 3 : 
				{
					/*spostamento indicatore */
					/*se come posizione indico 1 (prima di) allora devo fare inserimento come fratello dell'indicatore con oid in indicatoreRiferimento, prima */
					/*altrimenti inserisco come ultimo figlio del piano/attivita */
					Integer oidPianoAttivitaNuovoPadre = Integer.parseInt(context.getRequest().getParameter("piano"));
					Integer posizione = Integer.parseInt(context.getRequest().getParameter("posizione"));
					indicatoreDaModificare = tool.buildByOid(db, id,false);
					
					//il cup puo' essere modificato perche' gia' esistente
					indicatoreDaModificare.setCodiceAliasIndicatore(codiceAliasIndicatore);					
					
					if(context.getRequest().getParameter("indicatoreRiferimento") != null && context.getRequest().getParameter("indicatoreRiferimento").trim().length() > 0)
					{
						Integer oidIndicatoreFratello = Integer.parseInt(context.getRequest().getParameter("indicatoreRiferimento"));
						
//						int idPadreVecchio = indicatoreDaSpostare.getOidPianoAttivita().intValue();
						
						if(posizione == 1) /* inserimento di indicatore prima (up) di indicatore scelto */
						{
							indicatoreNuovoFratello = tool.buildByOid(db,oidIndicatoreFratello,false);
							oidNuovoIndicatore = tool.insertBeforeOrAfter(db, indicatoreDaModificare, indicatoreNuovoFratello, "up");
							tool.deleteDummyBrother(db,indicatoreNuovoFratello);
							
							
						}
						else /*inserimento alla fine del piano attivita, cioe' come ultimo figlio del piano attivita */
						{
							/*cerco ultimo figlio (attivo) del piano attivita specificato */
							 lastChild = tool.searchLastChildOf(db,oidPianoAttivitaNuovoPadre,false);
							oidNuovoIndicatore = tool.insertBeforeOrAfter(db, indicatoreDaModificare, lastChild, "down");
							tool.deleteDummyBrother(db,lastChild);
							
						}
					}
					else /*allora stiamo facendo spostamento verso un nuovo piano attivita che non ha figli attivi o non ha proprio figli */
					{
						 beanNuovoPadre = toolPA.buildByOid(db, oidPianoAttivitaNuovoPadre, false,true);
						/*controllo se ha almeno un figlio disattivato (i figli se esistono sono sicuramente disattivati per dove siamo arrivati col flusso  */
						ArrayList figliScaduti = beanNuovoPadre.getIndicatoriFigli();
						riferimentoPerInserimento = null;
						if(figliScaduti != null && figliScaduti.size() > 0)
						{
							riferimentoPerInserimento = (DpatIndicatoreNewBeanAbstract) figliScaduti.get(figliScaduti.size() -1);
							System.out.println(">>>>>>DPAT NUOVA GESTIONE: IL PIANO ATTIVITA SCELTO VERSO CUI SPOSTARE("+oidPianoAttivitaNuovoPadre+") HA ALMENO UN FIGLIO SCADUTO ("+riferimentoPerInserimento.getOid()+") USO QUESTO COME RIFERIMENTO SPOSTAMENTO INDICATORE");
						}
						else
						{
							int oidDummy = tool.insertDummyChildPerPianoAttivitaScelto(db, anno, new Long((long)oidPianoAttivitaNuovoPadre));
							riferimentoPerInserimento = tool.buildByOid(db, oidDummy, true);
							System.out.println(">>>>>>DPAT NUOVA GESTIONE: IL PIANO ATTIVITA SCELTO VERSO CUI SPOSTARE("+oidPianoAttivitaNuovoPadre+" NON HA  FIGLI, NE' ATTIVI NE' SCADUTI, QUINDI USO INSERISCO E USO DUMMY CHILD COME RIFERIMENTO PER SPOSTAMENTO ");
						}
						
						oidNuovoIndicatore = tool.insertBeforeOrAfter(db, indicatoreDaModificare, riferimentoPerInserimento, "down");
						/*nell'eventualita' che abbia dovuto inserire un dummy child */
						tool.deleteDummyBrother(db, riferimentoPerInserimento);
						
						
					}
					
					 
					
					Integer competenzeSpostate = tool.spostaCompetenzeFromTo(indicatoreDaModificare.getOid(), oidNuovoIndicatore.longValue(),db);
					System.out.println(">>>>>>DPAT NUOVA GESTIONE: SONO STATE SPOSTATE "+competenzeSpostate+" COMPETENZE (MODELLO 5)");
					
					
					/*disabilito quello che ho spostato, cioe' la vecchia copia */ 
					tool.disabilitaByOid(db, indicatoreDaModificare.getOid().intValue(), indicatoreDaModificare.getAnno());
					/*lancio funzione che , se il vecchio padre non ha piu' figli attivi, gli crea dummy */
//					DpatIndicatoreNewBean.insertDummyChildPerPianoAttivitaScelto(db, anno, new Long((long)idPadreVecchio));
					
				}
				
				
			}
			
			refreshMotiviCu(db,anno,true);
			
			/*rimetto i bean nella request cosi' la pagina di rientro non schiatta */
			DpatIndicatoreNewBeanAbstract toResend = tool.buildByOid(db, oidNuovoIndicatore, true);
			DpatPianoAttivitaNewBeanInterface toResendPA = toolPA.buildByOid(db, toResend.getOidPianoAttivita().intValue() , true,false );
			DpatSezioneNewBeanInterface toResendSez= toolSez.buildByOid(db, toResendPA.getOidSezione().intValue(), true, false);
			context.getRequest().setAttribute("IndicatoreNewDPat",toResend); 
			context.getRequest().setAttribute("PianoAttivitaNewDPat", toResendPA);
			context.getRequest().setAttribute("SezioneNewDPat", toResendSez);
			if(congelato)
			{
				
				context.getRequest().setAttribute("ListaSezioniNewDPat", new DpatWrapperSezioniBean());
			}
			else
			{
				 
				context.getRequest().setAttribute("ListaSezioniNewDPat", new DpatWrapperSezioniBeanPreCong());
			}
			
			db.commit();
			 
			
 

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			try {db.rollback(); 
				System.out.println("ROllback eseguito");
			} catch(Exception ex) {ex.printStackTrace(); }
			return ("SystemError");
		} finally {
			try {db.setAutoCommit(autocommit); } catch(Exception ex){}
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");

		return ("UpdateIndicatoreOK");
	}
	
	
	
	

	public String executeCommandUpdateIndicatore(ActionContext context) throws ParseException {
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			int anno = Integer.parseInt(context.getParameter("anno"));

			int id = Integer.parseInt(context.getParameter("id"));

			String descrizione = context.getRequest().getParameter("descrizione");
			String codice_esame = context.getRequest().getParameter("codice_esame");
			int operazione = Integer.parseInt(context.getParameter("operazione"));

			String cessazione = context.getParameter("cessato");

			DpatIndicatore ind = new DpatIndicatore(db, id, anno);
			if (ind.getDataScadenza() == null) {

				String selectStato = "select max(stato) from dpat_indicatore where id_attivita = ? and anno = " + anno;

				PreparedStatement pst = db.prepareStatement(selectStato);
				pst.setInt(1, ind.getId_attivita());
				ResultSet rs = pst.executeQuery();
				int stato = 1;
				if (rs.next())
					stato = rs.getInt(1) % 2;

				ind.disabilitaIndicatore(db, context.getParameter("dataScadenza"), anno);

				if (cessazione != null && cessazione.equalsIgnoreCase("no")) {

					ind.setStato(stato);
					ind.setId_attivita(Integer.parseInt(context.getParameter("root_")));
					ind.setDescription(descrizione);
					ind.setCodiceEsame(codice_esame);
					ind.setAlias(context.getParameter("alias"));
					ind.setTipoAttivita(context.getParameter("tipoAttivita"));
					ind.setUiCalcolabile(false);
					ind.setCodiceAlias(context.getParameter("cup"));

					switch (operazione) {

					case 1: {
						System.out.println("MODIFICA PER SOSTITUZIONE INDICATORE CON NUOVO CODICE");
						ind.insert(db, anno);
						break;
					}

					case 2: {
						System.out.println("MODIFICA PER SOSTITUZIONE INDICATORE CON NUOVO CODICE");
						ind.setCodiceInternoUnivoco(-1);
						ind.insert(db, anno);
						break;
					}
					case 3: {
						String indicatoreRiferimento = context.getParameter("indicatoreRiferimento");
						String posizionamento = context.getParameter("posizione");
						DpatIndicatore indRif = new DpatIndicatore(db, Integer.parseInt(indicatoreRiferimento), anno);
						if (posizionamento.equals("1")) {

							ind.setId_attivita(Integer.parseInt(context.getParameter("root_")));

							indRif.setTipoInserimento("up");
							ind.setTipoAttivita(indRif.getTipoAttivita());
							ind.disabilitaIndicatore(db, context.getParameter("dataScadenza"), anno);
							ind.setOrdinamento(indRif.getOrdinamento());
							ind.insert(db, indRif, anno);

						} else {
							indRif.setTipoInserimento("down");
							ind.setTipoAttivita(indRif.getTipoAttivita());
							ind.disabilitaIndicatore(db, context.getParameter("dataScadenza"), anno);
							ind.setOrdinamento(indRif.getOrdinamento());
							ind.insert(db, indRif, anno);
						}

						System.out.println("MODIFICA PER SPOSTAMENTO INDICATORE");
						break;
					}
					}

				}
			} else {

				if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
					ind.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), false);

					ind.setDescription(descrizione);
					ind.setCodiceEsame(codice_esame);
					ind.setAlias(context.getParameter("alias"));
					ind.setTipoAttivita(context.getParameter("tipoAttivita"));

					ind.setUiCalcolabile(false);
					if (context.getParameter("uiCalcolabile") != null
							&& "si".equalsIgnoreCase(context.getParameter("uiCalcolabile")))
						ind.setUiCalcolabile(true);

					ind.updateRecordDaAttivate(db, anno); // OK

				} else {
					ind.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), true);
				}

			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");

		return ("AddOK");
	}

	public String executeCommandUpdateAttivita(ActionContext context) throws ParseException {
		if (!hasPermission(context, "piani-piani-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);
			int anno = Integer.parseInt(context.getParameter("anno"));

			int id = Integer.parseInt(context.getParameter("id"));

			String descrizione = context.getRequest().getParameter("descrizione");
			String codice_esame = context.getRequest().getParameter("codice_esame");
			int operazione = Integer.parseInt(context.getParameter("operazione"));

			String descrizionePiano = "";
			if (context.getParameter("tipoAttivita").contains("ATTIVITA"))
				descrizionePiano = "ATTIVITA";
			else
				descrizionePiano = "PIANO";

			String cessazione = context.getParameter("cessato");

			DpatAttivita dpatAtt = new DpatAttivita(db, id, anno);
			if (dpatAtt.getDataScadenza() == null) {

				DpatPiano piano = new DpatPiano(db, dpatAtt.getId_piano(), anno);
				piano.setEnabled(true);

				String selectStato = "select max(stato) from dpat_attivita where id_piano = ? and anno = " + anno;

				PreparedStatement pst = db.prepareStatement(selectStato);
				pst.setInt(1, dpatAtt.getId_piano());
				ResultSet rs = pst.executeQuery();
				int stato = 1;
				if (rs.next())
					stato = rs.getInt(1) % 2;

				// dpatAtt.disabilitaAttivita(db,
				// context.getParameter("dataScadenza"),anno);

				if (cessazione != null && cessazione.equalsIgnoreCase("no")) {

					switch (operazione) {
					case 1: {
						// dpatAtt.disabilitaAttivita(db,
						// context.getParameter("dataScadenza"),anno);

						String insert_log = "insert into dpat_log_modifica_piano (data_operazione, user_id, id_piano, description_piano, alias_piano, id_att, description_att, codice_esame_att, alias_att, codice_alias_att)"
								+ " values (now(), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
						PreparedStatement pst0 = db.prepareStatement(insert_log);
						pst0.setInt(1, user.getIdApiario());
						pst0.setInt(2, piano.getId());
						pst0.setString(3, piano.getDescription());
						pst0.setString(4, piano.getAlias());
						pst0.setInt(5, dpatAtt.getId());
						pst0.setString(6, dpatAtt.getDescription());
						pst0.setString(7, dpatAtt.getCodiceEsame());
						pst0.setString(8, dpatAtt.getAlias());
						pst0.setString(9, dpatAtt.getCodiceAlias());

						piano.setStato(2);
						// piano.setId_sezione(Integer.parseInt(context.getParameter("root_")));
						piano.setDescription(descrizionePiano + " " + context.getParameter("alias"));
						piano.setAlias(context.getParameter("alias"));
						// piano.setTipoAttivita(context.getParameter("tipoAttivita"));
						piano.update(db, anno, dpatAtt.getId_piano());

						dpatAtt.setStato(2);
						// dpatAtt.setId_piano(piano.getId());
						// dpatAtt.setCodicePiano(piano.getCodiceInterno());
						dpatAtt.setDescription(descrizione);
						dpatAtt.setCodiceEsame(codice_esame);
						dpatAtt.setAlias(context.getParameter("alias"));
						dpatAtt.setCodiceAlias(context.getParameter("cup"));
						// dpatAtt.setTipoAttivita(context.getParameter("tipoAttivita"));
						// dpatAtt.insert(db,anno);
						dpatAtt.update(db, dpatAtt.getId(), anno); // where id

						pst0.execute();
						pst0.close();

						break;
					}

					case 3: {
						dpatAtt.disabilitaAttivita(db, context.getParameter("dataScadenza"), anno);

						int idPianoRiferimento = Integer.parseInt(context.getParameter("root"));
						DpatAttivita attivitaRiferimento = new DpatAttivita(db, idPianoRiferimento, anno);
						DpatPiano pianoRiferimento = new DpatPiano(db, attivitaRiferimento.getId_piano(), anno);
						String posizionamento = context.getParameter("posizione");
						switch (posizionamento) {
						case "1": {
							attivitaRiferimento.setTipoInserimento("up");
							break;
						}
						case "2": {
							attivitaRiferimento.setTipoInserimento("down");
							break;
						}
						}

						piano.setStato(stato);
						piano.setId_sezione(Integer.parseInt(context.getParameter("sezione")));
						piano.setTipoAttivita(context.getParameter("tipoAttivita"));
						piano.setOrdinamento(pianoRiferimento.getOrdinamento());
						piano.insert(db, attivitaRiferimento, anno);

						dpatAtt.setCodiceAlias(context.getParameter("cup"));
						dpatAtt.setStato(stato);
						dpatAtt.setId_piano(piano.getId());
						dpatAtt.setOrdinamento(attivitaRiferimento.getOrdinamento());
						dpatAtt.setCodicePiano(piano.getCodiceInterno());
						dpatAtt.insert(db, attivitaRiferimento, anno);

						break;
					}
					default:
						dpatAtt.disabilitaAttivita(db, context.getParameter("dataScadenza"), anno);
					}

				}
			} else {

				dpatAtt.disabilitaAttivita(db, context.getParameter("dataScadenza"), anno);

				String selectStato = "select max(stato) from dpat_attivita where id_piano = ? and anno = " + anno;
				int stato = 1;
				PreparedStatement pst = db.prepareStatement(selectStato);
				pst.setInt(1, dpatAtt.getId_piano());
				ResultSet rs = pst.executeQuery();

				if (rs.next())
					stato = rs.getInt(1) % 2;

				if (cessazione != null && cessazione.equalsIgnoreCase("no")) {
					dpatAtt.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), false, anno);

					dpatAtt.setDescription(descrizione);
					dpatAtt.setCodiceEsame(codice_esame);
					dpatAtt.setAlias(context.getParameter("alias"));

					dpatAtt.setTipoAttivita(context.getParameter("tipoAttivita"));
					dpatAtt.setStato(stato);

					dpatAtt.updateRecordDaAttivate(db, anno);
				} else {
					dpatAtt.updateDataScadenzaRecordOld(db, context.getParameter("dataScadenza"), true, anno); // setto
																												// la
																												// data
																												// scadenza
																												// anche
																												// sul
																												// record
																												// che
																												// sidovraattualizzare
				}

			}

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		context.getRequest().setAttribute("inserito", "true");

		return ("AddOK");
	}



public String executeCommandDpatGeneraXlsModifyGeneraleCompetenze(ActionContext context) throws IOException {
		
		
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet();
		HSSFRow row = sheet.createRow(0);
		
		HSSFCell cell = row.createCell(0);
		cell.setCellValue("SEZIONE");
		
		HSSFCell cel1 = row.createCell(1);
		cel1.setCellValue("PIANO");
		
		HSSFCell cel2 = row.createCell(2);
		cel2.setCellValue("ATTIVITA");
		
		HSSFCell cel3 = row.createCell(3);
		cel3.setCellValue("ALIAS");
		
		HSSFCell cel4 = row.createCell(4);
		cel4.setCellValue("INDICATORE");
		
		HSSFCell cel5 = row.createCell(5);
		cel5.setCellValue("STRUTTURA");
		
		HSSFCell cel6 = row.createCell(6);
		cel6.setCellValue("CODICE PIANO");
		
		HSSFCell cel7 = row.createCell(7);
		cel7.setCellValue("CODICE SOTTOPIANO");
		
		HSSFCell cel8 = row.createCell(8);
		cel8.setCellValue("##");
		
		int s =1 ;
		
		
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "";
		String idAsl = (String) context.getRequest().getParameter("idAsl");
		String anno = (String) context.getRequest().getParameter("anno");

		if (anno.equals("corrente")) {
			int a = Calendar.getInstance().get(Calendar.YEAR);
			anno = String.valueOf(a);
		}
		context.getRequest().setAttribute("anno", anno);


		String comboArea = context.getRequest().getParameter("combo_area");
		int idAreaSelezionata = -1 ;
		if (comboArea!=null & !"".equals(comboArea))
			idAreaSelezionata = Integer.parseInt(comboArea);

		// DPAT PER L'ASL SELEZIONATA
		org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza d = null;
		try {
			db = this.getConnection(context);
			
			LookupList listaAsl = new LookupList(db,"lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			
			
			ArrayList <Integer> listaStruttureAsl = new ArrayList<Integer>();
			if (idAreaSelezionata==-999){
				PreparedStatement pstStrutture = db.prepareStatement("select id from dpat_strutture_asl where id_asl = ? and livello = 2 and enabled and anno = ?");
				pstStrutture.setInt(1, Integer.parseInt(idAsl));
				pstStrutture.setInt(2, Integer.parseInt(anno));
				ResultSet rsStrutture = pstStrutture.executeQuery();
				while (rsStrutture.next()){
					listaStruttureAsl.add(rsStrutture.getInt(1));
				}
				}
			else
				listaStruttureAsl.add(idAreaSelezionata);


			
			for (int b = 0; b<listaStruttureAsl.size(); b++){
				
				int idAreaDaEstrarre = listaStruttureAsl.get(b);
			
			sql = "select id,completo,id_asl,anno from dpat where id_asl=" + idAsl + " and anno="
					+ anno+" and enabled";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				d = new org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza();
				d.setIdArea(idAreaDaEstrarre);
				d.setId(rs.getInt("id"));
				d.setCompleto(rs.getBoolean("completo"));
				d.setIdAsl(rs.getInt("id_asl"));
				d.setAnno(rs.getInt("anno"));
				d.builRecord(d.getId(), db,this.getSystemStatus(context),idAreaDaEstrarre);
				d.buildlistSezioni(db, Integer.parseInt(anno));
			} 


			DpatIstanza istanza = new DpatIstanza();
			int statoDpatConfig = istanza.getStatoFromAnno(db, Integer.parseInt(anno));
			if (d != null) {

				// PER OGNI SEZIONE COSTRUISCI LA LISTA DEI PIANI
				for (int i = 0; i < d.getElencoSezioni().size(); i++) {
					d.getElencoSezioni().get(i).buildlistPiani(db,d.getElencoSezioni().get(i).getId(),statoDpatConfig,Integer.parseInt(anno));
					// PER OGNI PIANO COSTRUISCI LA LISTA DELLE ATTIVITA'
					for (int j = 0; j < d.getElencoSezioni().get(i).getElencoPiani().size(); j++) {
						d.getElencoSezioni().get(i).getElencoPiani().get(j).buildlistAttivita(db,d.getElencoSezioni().get(i).getElencoPiani().get(j).getId(),statoDpatConfig,Integer.parseInt(anno));

						// PER OGNI ATTIVITA CALCOLA L'UI TOTALE E COSTRUISCI LA LISTA DEGLI INDICATORI
						for (int k = 0; k < d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().size(); k++) {

							d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k).buildlistIndicatori(	db,d.getElencoSezioni().get(i).getElencoPiani().get(j).getElencoAttivita().get(k).getId(),statoDpatConfig,Integer.parseInt(anno));

						}

					}
				}   

				
				
				
				
			
				for(DpatSezione sez : d.getElencoSezioni())
				{
					for(DpatPiano p : sez.getElencoPiani())
					{
						for (DpatAttivita att : p.getElencoAttivita())
						{
							for (DpatIndicatore ind : att.getElencoIndicatori())
							{
								HSSFRow row_ = sheet.createRow(s);
								HSSFCell cell_0 = row_.createCell(0);
								cell_0.setCellValue(sez.getDescription());
								HSSFCell cel_1 = row_.createCell(1);
								cel_1.setCellValue(p.getDescription());
								
								HSSFCell cel_2 = row_.createCell(2);
								cel_2.setCellValue(att.getDescription());
								HSSFCell cel_3 = row_.createCell(3);
								cel_3.setCellValue(ind.getAlias());
								HSSFCell cel_4 = row_.createCell(4);
								cel_4.setCellValue(ind.getDescription());
							
								
								for (OiaNodo struttura : d.getElencoStrutture())
								{
									HSSFCell cel_5 = row_.createCell(5);
									cel_5.setCellValue(struttura.getDescrizione_lunga());
									
									HSSFCell cel_6 = row_.createCell(6);
									cel_6.setCellValue(att.getCodiceAlias());
									
									HSSFCell cel_7 = row_.createCell(7);
									cel_7.setCellValue(ind.getCodiceAlias());
									
									HSSFCell cel_8 = row_.createCell(8);
									if (struttura.getCompetenzeIndicatori().get(ind.getId())!= null && struttura.getCompetenzeIndicatori().get(ind.getId())==Boolean.TRUE )
										cel_8.setCellValue("X");
									else
										cel_8.setCellValue("");
								
								}
								
								
								
								s++;
							}
						}
					}
				}
			}
			}	
				ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
				wb.write(outByteStream);
				byte [] outArray = outByteStream.toByteArray();
				context.getResponse().setContentType("application/vnd.ms-excel");
				context.getResponse().setContentLength(outArray.length);
				context.getResponse().setHeader("Expires:", "0"); // eliminates browser caching
				
				String nomeStruttura = "";
				
				if (idAreaSelezionata==-999)
					nomeStruttura=listaAsl.getSelectedValue(d.getIdAsl()).replaceAll(" ",  "_");
				else
					nomeStruttura=d.getStrutturaAmbito().getDescrizione_lunga().replaceAll(" ",  "_");
				
				context.getResponse().setHeader("Content-Disposition", "attachment; filename=MODELLO_5_"+anno+"_"+nomeStruttura+".xls");
				
				java.io.OutputStream outStream = context.getResponse().getOutputStream();
				outStream.write(outArray);
				outStream.flush();
			
			context.getRequest().setAttribute("dpat", d);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.freeConnection(context, db);
		}
		return "-none-";
	}


	public String executeCommandListaAttivitaCodiceInterno_NewDpat(ActionContext context) throws Exception
	{


		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);

			String anno = context.getParameter("anno");
			boolean congelato = context.getParameter("congelato") != null && Boolean.parseBoolean((String)context.getParameter("congelato"));
			context.getRequest().setAttribute("congelato", context.getParameter("contelato"));

			
			int codRaggruppamento = Integer.parseInt(context.getParameter("codRaggruppamento"));
			
			ArrayList  piani = null;
			if(congelato)
			{
				piani = new DpatPianoAttivitaNewBean().searchVersioniPerCodiceRaggruppamento(db, codRaggruppamento,true,Integer.parseInt(anno));
			}
			else
			{
				piani = new DpatPianoAttivitaNewBeanPreCong().searchVersioniPerCodiceRaggruppamento(db, codRaggruppamento,true,Integer.parseInt(anno));
			}
			
			if(piani != null && piani.size() > 0)
			{
				int idSez = ((DpatPianoAttivitaNewBeanInterface)piani.get(0)).getOidSezione().intValue();
				
				DpatSezioneNewBeanInterface  sez = null;
				if(congelato)
					sez = new DpatSezioneNewBean().buildByOid(db, idSez, false,true);
				else
					sez = new DpatSezioneNewBeanPreCong().buildByOid(db, idSez, false,true);
				
				context.getRequest().setAttribute("sezione", sez);
			}
			 
			context.getRequest().setAttribute("alPianiAttivita", piani);

		} catch (SQLException e) {

		} finally {
			this.freeConnection(context, db);
		}

		String toRet = "ListaStoriaAttivitaOK_NEWDPAT";
		return toRet;
	
	}
	
	
	
	public String executeCommandListaIndicatoriCodiceInterno_NewDpat(ActionContext context) throws Exception {

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);

			String anno = context.getParameter("anno");
			boolean congelato = context.getParameter("congelato") != null && Boolean.parseBoolean((String)context.getParameter("congelato"));
			context.getRequest().setAttribute("congelato", context.getParameter("contelato"));

			
			int codRaggruppamento = Integer.parseInt(context.getParameter("codRaggruppamento"));
			
			ArrayList  indicatori = null;
			if(congelato)
			{
				indicatori = new DpatIndicatoreNewBean().searchVersioniPerCodiceRaggruppamento(db, codRaggruppamento,Integer.parseInt(anno));
			}
			else
			{
				indicatori = new DpatIndicatoreNewBeanPreCong().searchVersioniPerCodiceRaggruppamento(db, codRaggruppamento,Integer.parseInt(anno));
			}
			
			
			context.getRequest().setAttribute("alIndicatori", indicatori);
			
			if(indicatori != null && indicatori.size() > 0)
			{
				int idPianoAttivita = ((DpatIndicatoreNewBeanAbstract)indicatori.get(0)).getOidPianoAttivita().intValue();
				DpatPianoAttivitaNewBeanInterface piano = null;
				if(congelato)
					piano = new DpatPianoAttivitaNewBean().buildByOid(db, idPianoAttivita, false,true);
				else
					piano = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db, idPianoAttivita, false,true);
				
				context.getRequest().setAttribute("piano", piano);
				
				if(piano != null)
				{
					int idSez = piano.getOidSezione().intValue();
					DpatSezioneNewBeanInterface sez = null;
					if(congelato)
						sez = new DpatSezioneNewBean().buildByOid(db, idSez, false,true);
					else
						sez = new DpatSezioneNewBeanPreCong().buildByOid(db, idSez, false,true);
					
					context.getRequest().setAttribute("sezione",sez);
				}
				
			}

		} catch (SQLException e) {

		} finally {
			this.freeConnection(context, db);
		}
		String toReturn = "ListaStoriaIndicatoriOK_NEWDPAT";

		return toReturn;
	}
	
	
	

	public String executeCommandListaAttivitaCodiceInterno(ActionContext context) throws ParseException {

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);

			String anno = context.getParameter("anno");

			int id = Integer.parseInt(context.getParameter("idAttivita"));
			DpatAttivita ind = new DpatAttivita(db, id, Integer.parseInt(anno));
			context.getRequest().setAttribute("DettaglioAttivita", ind);

		} catch (SQLException e) {

		} finally {
			this.freeConnection(context, db);
		}

		return "ListaStoriaAttivitaOK";
	}

	public String executeCommandListaIndicatoriCodiceInterno(ActionContext context) throws ParseException {

		Connection db = null;
		try {
			UserBean user = (UserBean) context.getRequest().getSession().getAttribute("User");
			db = this.getConnection(context);

			String anno = context.getParameter("anno");

			int id = Integer.parseInt(context.getParameter("idIndicatore"));
			DpatIndicatore ind = new DpatIndicatore(db, id, Integer.parseInt(anno));
			context.getRequest().setAttribute("DettaglioIndicatore", ind);

		} catch (SQLException e) {

		} finally {
			this.freeConnection(context, db);
		}

		return "ListaStoriaIndicatoriOK";
	}
	
	
	public static void setNullableField(PreparedStatement pst,Object value, int index,int sqltype) throws Exception
	{
		if(value == null)
		{
			pst.setNull(index, sqltype);
		}
		else
		{
			switch(sqltype)
			{
			case  java.sql.Types.VARCHAR:
				pst.setString(index, (String)value );
				break;
				
			case  java.sql.Types.INTEGER:
				pst.setInt(index, (Integer)value );
				break;
				
			case  java.sql.Types.DOUBLE:
				pst.setDouble(index, (Double)value );
				break;
			default:
				throw new Exception("tipo non supportato in setNullableFields");
			}
		}
		
	}
	
	 
	public static void main(String args[]) throws IOException
	{
		
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		int n = Integer.parseInt(br.readLine());
		for(int k = 0; k< n; k++)
		{
			int g = Integer.parseInt(br.readLine());
			String[] tt = br.readLine().split(" ");
			int a[] = new int[g];
			for(int p = 0; p<g;p++)
			{
				 a[p]= Integer.parseInt(tt[p]);
			}
            getBribes(a);
		}
		
	}
	
	public static void getBribes(int t[])
	{
		 
		int[] cumdiff = new int[t.length];
		int bribes = 0;
		
		for(int i = 0; i< t.length; i++)
		{
			int diff = t[i]-(i+1 -cumdiff[i]);
			if(diff <= 0)
				continue;
			if(diff > 2)
			{
				System.out.println("Too chaotic");
				return;
			}
			
			for(int j = 1; j<= diff; j++)
			{
				if(t[i+j] < t[i])
					cumdiff[i+j]++;
			}
			bribes += diff;
		}
		
		System.out.println(bribes);
	}
	
	
	
}
