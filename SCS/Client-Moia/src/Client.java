import Protocole.*;

import java.net.* ;
import java.io.* ;
import java.util.*;

import static Protocole.Newton.TCol.*;
import static Protocole.Newton.TIdReq.*;
import static Protocole.Newton.TLg.*;
import static Protocole.Newton.TPropCoup.*;

public class Client extends Newton {
    public static void main(String [] args) {
        if (args.length!=3){
            System.out.println("arguments - host port nom_joueur");
            System.exit(1);
        }
        Socket s ;

        // References de la socket
        String hote = args[0];
        int port = Integer.parseInt(args[1]);
        String name1 = args[2];
        char[] name_joueur = new char[name1.length()];
        char[] name_adversaire;
        TCoul ma_coulPion;
        TCoup mon_tcoup;
        int num_partie = 1;
        int mes_parties_gagnees = 0;
        int adv_parties_gagnees = 0;
        boolean new_partie = false;

        for (int i = 0; i < name1.length(); i++) {
            name_joueur[i] = name1.charAt(i);
        }



        try {

            s = new Socket (hote, port);

            OutputStream os = s.getOutputStream();
            InputStream is = s.getInputStream();

            ObjectOutputStream oos = new ObjectOutputStream(os);
            ObjectInputStream ois = new ObjectInputStream(is);

            /**************  Requete PARTIE **************/

            TIdReq requete_partie = PARTIE;
            TPartieReq tPartieReq = new TPartieReq(requete_partie, name_joueur);
            oos.writeObject(tPartieReq);

            /********* La réponse PARTIE *******/
            TPartieRep tPartieRep = new TPartieRep();
            tPartieRep = (TPartieRep) ois.readObject();
            name_adversaire = tPartieRep.getNomAdvers();
            ma_coulPion = tPartieRep.getCoulPion();


            while(num_partie <= 2)
            {

                if(ma_coulPion == TCoul.BLEU && num_partie == 1 || ma_coulPion == TCoul.ROUGE && num_partie == 2)
                {
                    /**************  Requete COUP **************/

                    Param mes_param;

                    /************ @TODO A récuprer de puis le Moteur IA *************/
                    mon_tcoup = TCoup.POSE; // POSE | DEPL (Réceperation depuis le Moteur IA)

                    TLg ma_ligne = A;
                    TCol ma_clonne = UN;

                    /******************************************************************/


                    if(mon_tcoup == TCoup.POSE)
                    {
                        TCase tCase = new TCase(ma_ligne, ma_clonne);
                        TPosPion tPosPion = new TPosPion(ma_coulPion, tCase);
                        mes_param = new Param(tPosPion);
                    }
                    else
                    {
                        TDeplPion tDeplPion = new TDeplPion(ma_coulPion, ma_clonne, ma_ligne);
                        mes_param = new Param(tDeplPion);
                    }

                    TIdReq ma_requete_coup = COUP;
                    TPropCoup ma_tPropCoup_client = CONT; // A modifier  on le récuper depuis le Moteur IA
                    TCoupReq ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, mes_param, ma_tPropCoup_client);
                    oos.writeObject(ma_tCoupReq);

                    /******** Réponse COUP ***********/

                    TCoupRep mon_tCoupRep ;
                    mon_tCoupRep  = (TCoupRep) ois.readObject();
                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();

                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name_joueur);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        affichageresultat(0, num_partie, name_joueur);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == PERDU)
                    {
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;
                        continue;
                    }

                    switch (mon_tCodeRep)
                    {
                        case ERR_PARTIE :
                            System.out.println("Erreur sur la demande de partie");
                            break;

                        case ERR_COUP :
                            System.out.println("Erreur sur le coup joue");
                            break;

                        case ERR_TYP :
                            System.out.println("Erreur sur le type de requete");
                            break;

                        case ERR_OK :
                            System.out.println(" Validation de la requete ");
                            if(mon_tValCoup == TValCoup.VALID)
                            {
                                TCoupRep adv_tCoupRep ;
                                adv_tCoupRep  = (TCoupRep) ois.readObject();
                                TCodeRep adv_tCodeRep = adv_tCoupRep .getErr();
                                TValCoup adv_tValCoup = adv_tCoupRep .getValidCoup();
                                TPropCoup adv_tPropCoup_serveur = adv_tCoupRep.getPropCoup();

                                if(adv_tPropCoup_serveur == GAGNE || adv_tPropCoup_serveur == NUL || adv_tPropCoup_serveur == PERDU )
                                {
                                    if(adv_tPropCoup_serveur == GAGNE)
                                    {
                                        adv_parties_gagnees++;
                                    }
                                    num_partie++;
                                    continue;
                                }

                                if(adv_tValCoup == TValCoup.VALID)
                                {
                                    TCoupReq adv_tCoupReq = (TCoupReq) ois.readObject();
                                    TIdReq adv_id_req = adv_tCoupReq.getIdRequest();
                                    int adv_num_partie = adv_tCoupReq.getNumPartie();
                                    TCoup adv_tcoup = adv_tCoupReq.getTypeCoup();
                                    Param adv_param = adv_tCoupReq.getParam();
                                    TPropCoup adv_tPropCoup_client = adv_tCoupReq.getPropCoup();

                                    TCoul adv_coulPion;
                                    TLg adv_ligne;
                                    TCol adv_colonne;

                                    if(adv_tcoup == TCoup.POSE)
                                    {

                                        TPosPion adv_tPosPion = adv_param.getPosePion();
                                        adv_coulPion = adv_tPosPion.getCoulPion();
                                        TCase adv_tCase = adv_tPosPion.getPosPion();
                                        adv_ligne = adv_tCase.getL();
                                        adv_colonne = adv_tCase.getC();

                                    }
                                    else
                                    {
                                        TDeplPion adv_tDeplPion = adv_param.getDeplPion();
                                        adv_coulPion = adv_tDeplPion.getCoulPion();
                                        adv_ligne = adv_tDeplPion.getLgPionD();
                                        adv_colonne = adv_tDeplPion.getColPion();
                                    }

                                    //@TODO Mise a jour de la grille dans le moteur IA


                                }
                                else if(adv_tValCoup == TValCoup.TIMEOUT || adv_tValCoup == TValCoup.TRICHE)
                                {
                                    mes_parties_gagnees++;
                                    num_partie++;
                                    continue;
                                }

                            }
                            else if(mon_tValCoup == TValCoup.TIMEOUT || mon_tValCoup == TValCoup.TRICHE)
                            {
                                num_partie++;
                                continue;
                            }
                            break;
                    }
                }
                else
                {

                    TCoupRep adv_tCoupRep;
                    adv_tCoupRep = (TCoupRep) ois.readObject();
                    TCodeRep adv_tCodeRep = adv_tCoupRep.getErr();
                    TValCoup adv_tValCoup = adv_tCoupRep.getValidCoup();
                    TPropCoup adv_tPropCoup_serveur = adv_tCoupRep.getPropCoup();


                    if (adv_tPropCoup_serveur == GAGNE) {
                        adv_parties_gagnees++;
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;
                        continue;
                    } else if (adv_tPropCoup_serveur == NUL) {
                        affichageresultat(0, num_partie, name_adversaire);
                        num_partie++;
                        continue;
                    } else if (adv_tPropCoup_serveur == PERDU) {
                        affichageresultat(1, num_partie, name_joueur);
                        mes_parties_gagnees++;
                        num_partie++;
                        continue;
                    }



                    if (adv_tValCoup == TValCoup.VALID) {
                        TCoupReq adv_tCoupReq = (TCoupReq) ois.readObject();
                        TIdReq adv_id_req = adv_tCoupReq.getIdRequest();
                        int adv_num_partie = adv_tCoupReq.getNumPartie();
                        TCoup adv_tcoup = adv_tCoupReq.getTypeCoup();
                        Param adv_param = adv_tCoupReq.getParam();
                        TPropCoup adv_tPropCoup_client = adv_tCoupReq.getPropCoup();

                        TCoul adv_coulPion;
                        TLg adv_ligne;
                        TCol adv_colonne;

                        if (adv_tcoup == TCoup.POSE) {

                            TPosPion adv_tPosPion = adv_param.getPosePion();
                            adv_coulPion = adv_tPosPion.getCoulPion();
                            TCase adv_tCase = adv_tPosPion.getPosPion();
                            adv_ligne = adv_tCase.getL();
                            adv_colonne = adv_tCase.getC();

                        } else {
                            TDeplPion adv_tDeplPion = adv_param.getDeplPion();
                            adv_coulPion = adv_tDeplPion.getCoulPion();
                            adv_ligne = adv_tDeplPion.getLgPionD();
                            adv_colonne = adv_tDeplPion.getColPion();
                        }

                        //@TODO Mise a jour de la grille dans le moteur IA


                    } else if (adv_tValCoup == TValCoup.TIMEOUT || adv_tValCoup == TValCoup.TRICHE) {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name_joueur);
                        num_partie++;
                        continue;
                    }

                    /**************  Requete COUP **************/

                    Param mes_param;

                    /************ @TODO A récuprer de puis le Moteur IA *************/
                    mon_tcoup = TCoup.POSE; // POSE | DEPL (Réceperation depuis le Moteur IA)

                    TLg ma_ligne = A;
                    TCol ma_clonne = UN;

                    /******************************************************************/


                    if(mon_tcoup == TCoup.POSE)
                    {
                        TCase tCase = new TCase(ma_ligne, ma_clonne);
                        TPosPion tPosPion = new TPosPion(ma_coulPion, tCase);
                        mes_param = new Param(tPosPion);
                    }
                    else
                    {
                        TDeplPion tDeplPion = new TDeplPion(ma_coulPion, ma_clonne, ma_ligne);
                        mes_param = new Param(tDeplPion);
                    }

                    TIdReq ma_requete_coup = COUP;
                    TPropCoup ma_tPropCoup_client = CONT; // A modifier  on le récuper depuis le Moteur IA
                    TCoupReq ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, mes_param, ma_tPropCoup_client);
                    oos.writeObject(ma_tCoupReq);

                    /******** Réponse COUP ***********/

                    TCoupRep mon_tCoupRep ;
                    mon_tCoupRep  = (TCoupRep) ois.readObject();
                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();

                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name_joueur);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        affichageresultat(0, num_partie, name_joueur);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == PERDU)
                    {
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;
                        continue;
                    }

                    switch (mon_tCodeRep)
                    {
                        case ERR_PARTIE:
                            System.out.println("Erreur sur la demande de partie");
                            break;

                        case ERR_COUP:
                            System.out.println("Erreur sur le coup joue");
                            break;

                        case ERR_TYP:
                            System.out.println("Erreur sur le type de requete");
                            break;

                        case ERR_OK:
                            System.out.println(" Validation de la requete ");
                            if(mon_tValCoup == TValCoup.TIMEOUT || mon_tValCoup == TValCoup.TRICHE)
                            {
                                affichageresultat(1, num_partie, name_adversaire);
                                num_partie++;
                                continue;
                            }
                            break;
                    }


                }





            }


        } catch (UnknownHostException e) {
            System.out.println("Unknown host" + e);
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("IO exception" + e);
        }
    }
    public static void affichageresultat(int joueur, int partie, char[] name)
    {
        if(joueur == 0)
        {
            System.out.println("La partie "+partie+ "est nul");
        }
        else
        {
            System.out.println("Le joueur ("+name+") a gagné la partie "+partie);
        }
    }
}