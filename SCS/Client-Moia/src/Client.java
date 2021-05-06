import Protocole.*;

import java.net.* ;
import java.io.* ;
import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.util.*;
import java.util.Scanner;


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
        String name_adversaire;
        TCoul ma_coulPion;
        TCoup mon_tcoup;
        int num_partie = 1;
        int mes_parties_gagnees = 0;
        int adv_parties_gagnees = 0;
        boolean new_partie = false;

        /******************************/
        int colonne;
        String ligne;
        int coup;

        /******************************/

        for (int i = 0; i < name1.length(); i++) {
            name_joueur[i] = name1.charAt(i);
        }



        try {

            s = new Socket (hote, port);

            OutputStream os = s.getOutputStream();
            InputStream is = s.getInputStream();


            /**************  Requete PARTIE **************/

            TIdReq requete_partie = PARTIE;
            TPartieReq tPartieReq = new TPartieReq(requete_partie, name_joueur);
            tPartieReq.send(os);

            /********* La réponse PARTIE *******/
            TPartieRep tPartieRep = new TPartieRep();

            tPartieRep.recive(is);
            name_adversaire = tPartieRep.getNomAdvers();
            ma_coulPion = tPartieRep.getCoulPion();

	   System.out.println("L'adversaire est"+name_adversaire);

            while(num_partie <= 2)
            {
                os.flush();
                System.out.println("Partie N :"+num_partie);
                if(ma_coulPion == TCoul.BLEU && num_partie == 1 || ma_coulPion == TCoul.ROUGE && num_partie == 2)
                {
                    /**************  Requete COUP **************/

                    /************ @TODO A récuprer de puis le Moteur IA *************/

                    mon_tcoup = TCoup.POSE; // POSE | DEPL (Réceperation depuis le Moteur IA)

                    TLg ma_ligne = F;
                    TCol ma_clonne = TROIS;


                    System.out.println("Entrez le Coup qui vous souhaitez jouer\n (1 ==> Poser un Pion) \n  (2 ==> Deplacer un Pion) ");
                    Scanner sc1 = new Scanner(System.in);
                    Scanner sc2 = new Scanner(System.in);
                    Scanner sc3 = new Scanner(System.in);
                    coup = sc1.nextInt();
                    
                    if(coup==1)
                    { // Poser un Pion
                        System.out.println("Entrez la Colonne ou Poser le Pion (1,2,3,4,5) ");
                        colonne = sc2.nextInt();

                        System.out.println("Entrez la Ligne ou Pose le Pion (A,B,C,D,E,F) ");
                        ligne = sc3.nextLine();
                    }
                    else
                    { //Deplacer un Pion
                        System.out.println("Entrez la Colonne du Pion a déplacer (1,2,3,4,5) ");
                        colonne = sc2.nextInt();

                        System.out.println("Entrez la Ligne ou déplacer le Pion (A,B,C,D,E,F)");
                        ligne = sc3.nextLine();
                    }

                    switch (ligne.toUpperCase())
                    {
                        case "A":
                            ma_ligne = A;
                            break;
                        case "B":
                            ma_ligne = B;
                            break;
                        case "C":
                            ma_ligne = C;
                            break;
                        case "D":
                            ma_ligne = D;
                            break;
                        case "E":
                            ma_ligne = E;
                            break;
                        case "F":
                            ma_ligne = F;
                            break;
                        case "G":
                            ma_ligne = F;
                            break;
                        case "H":
                            ma_ligne = F;
                            break;
                        default:
                            System.out.println("Numero de Ligne invalide");
                    }
                    switch (colonne)
                    {
                        case 1 :
                            ma_clonne = UN;
                            break;
                        case 2 :
                            ma_clonne = DEUX;
                            break;
                        case 3 :
                            ma_clonne = TROIS;
                            break;
                        case 4 :
                            ma_clonne = QUATRE;
                            break;
                        case 5 :
                            ma_clonne = CINQ;
                            break;
                        default:
                            System.out.println("Numero de Colonne invalide");
                    }



                    /******************************************************************/

                    TPosPion tPosPion;
                    TDeplPion tDeplPion;
                    TCoupReq ma_tCoupReq ;

                    TIdReq ma_requete_coup = COUP;
                    TPropCoup ma_tPropCoup_client = CONT; // A modifier  on le récuper depuis le Moteur IA

                    if(mon_tcoup == TCoup.POSE)
                    {
                        TCase tCase = new TCase(ma_ligne, ma_clonne);
                        tPosPion = new TPosPion(ma_coulPion, tCase);
                        tDeplPion = new TDeplPion();
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);
                    }
                    else
                    {
                        tDeplPion = new TDeplPion(ma_coulPion, ma_clonne, ma_ligne);
                        tPosPion = new TPosPion();
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);
                    }


                    ma_tCoupReq.send(os);

                    /******** Réponse COUP ***********/

                    TCoupRep mon_tCoupRep = new TCoupRep();
                    mon_tCoupRep.recive(is);

                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();

                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        affichageresultat(0, num_partie, name1);
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
                                TCoupRep adv_tCoupRep = new TCoupRep();
                                adv_tCoupRep.recive(is);
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
                                    TCoupReq adv_tCoupReq = new TCoupReq();
                                    adv_tCoupReq.recive(is);
                                    TIdReq adv_id_req = adv_tCoupReq.getIdRequest();
                                    int adv_num_partie = adv_tCoupReq.getNumPartie();
                                    TCoup adv_tcoup = adv_tCoupReq.getTypeCoup();
                                    TPosPion adv_tPosPion = adv_tCoupReq.getPosePion();
                                    TDeplPion adv_tDeplPion = adv_tCoupReq.getDeplPion();
                                    //Param adv_param = adv_tCoupReq.getParam();
                                    TPropCoup adv_tPropCoup_client = adv_tCoupReq.getPropCoup();

                                    TCoul adv_coulPion;
                                    TLg adv_ligne;
                                    TCol adv_colonne;

                                    if(adv_tcoup == TCoup.POSE)
                                    {

                                        adv_coulPion = adv_tPosPion.getCoulPion();
                                        TCase adv_tCase = adv_tPosPion.getPosPion();
                                        adv_ligne = adv_tCase.getL();
                                        adv_colonne = adv_tCase.getC();

                                    }
                                    else
                                    {
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

                    TCoupRep adv_tCoupRep = new TCoupRep();
                    adv_tCoupRep.recive(is);

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
                        affichageresultat(1, num_partie, name1);
                        mes_parties_gagnees++;
                        num_partie++;
                        continue;
                    }



                    if (adv_tValCoup == TValCoup.VALID) {

                        TCoupReq adv_tCoupReq = new TCoupReq();
                        adv_tCoupReq.recive(is);
                        TIdReq adv_id_req = adv_tCoupReq.getIdRequest();
                        int adv_num_partie = adv_tCoupReq.getNumPartie();
                        TCoup adv_tcoup = adv_tCoupReq.getTypeCoup();
                        TPosPion adv_tPosPion = adv_tCoupReq.getPosePion();
                        TDeplPion adv_tDeplPion = adv_tCoupReq.getDeplPion();
                        TPropCoup adv_tPropCoup_client = adv_tCoupReq.getPropCoup();

                        TCoul adv_coulPion;
                        TLg adv_ligne;
                        TCol adv_colonne;

                        if (adv_tcoup == TCoup.POSE) {
                            adv_coulPion = adv_tPosPion.getCoulPion();
                            TCase adv_tCase = adv_tPosPion.getPosPion();
                            adv_ligne = adv_tCase.getL();
                            adv_colonne = adv_tCase.getC();

                        } else {
                            adv_coulPion = adv_tDeplPion.getCoulPion();
                            adv_ligne = adv_tDeplPion.getLgPionD();
                            adv_colonne = adv_tDeplPion.getColPion();
                        }

                        //@TODO Mise a jour de la grille dans le moteur IA


                    } else if (adv_tValCoup == TValCoup.TIMEOUT || adv_tValCoup == TValCoup.TRICHE) {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;
                        continue;
                    }

                    /**************  Requete COUP **************/

                    /************ @TODO A récuprer de puis le Moteur IA *************/

                    mon_tcoup = TCoup.POSE; // POSE | DEPL (Réceperation depuis le Moteur IA)

                    TLg ma_ligne = F;
                    TCol ma_clonne = CINQ;



                    System.out.println("Entrez le Coup qui vous souhaitez jouer\n (1 ==> Poser un Pion) \n  (2 ==> Deplacer un Pion) ");
                    Scanner sc1 = new Scanner(System.in);
                    Scanner sc2 = new Scanner(System.in);
                    Scanner sc3 = new Scanner(System.in);
                    coup = sc1.nextInt();

                    if(coup==1)
                    { // Poser un Pion
                        System.out.println("Entrez la Colonne ou Poser le Pion (1,2,3,4,5) ");
                        colonne = sc2.nextInt();

                        System.out.println("Entrez la Ligne ou Pose le Pion (A,B,C,D,E,F) ");
                        ligne = sc3.nextLine();
                    }
                    else
                    { //Deplacer un Pion
                        System.out.println("Entrez la Colonne du Pion a déplacer (1,2,3,4,5) ");
                        colonne = sc2.nextInt();

                        System.out.println("Entrez la Ligne ou déplacer le Pion (A,B,C,D,E,F)");
                        ligne = sc3.nextLine();
                    }

                    switch (ligne.toUpperCase())
                    {
                        case "A":
                            ma_ligne = A;
                            break;
                        case "B":
                            ma_ligne = B;
                            break;
                        case "C":
                            ma_ligne = C;
                            break;
                        case "D":
                            ma_ligne = D;
                            break;
                        case "E":
                            ma_ligne = E;
                            break;
                        case "F":
                            ma_ligne = F;
                            break;
                        case "G":
                            ma_ligne = F;
                            break;
                        case "H":
                            ma_ligne = F;
                            break;
                        default:
                            System.out.println("Numero de Ligne invalide");
                    }
                    switch (colonne)
                    {
                        case 1 :
                            ma_clonne = UN;
                            break;
                        case 2 :
                            ma_clonne = DEUX;
                            break;
                        case 3 :
                            ma_clonne = TROIS;
                            break;
                        case 4 :
                            ma_clonne = QUATRE;
                            break;
                        case 5 :
                            ma_clonne = CINQ;
                            break;
                        default:
                            System.out.println("Numero de Colonne invalide");
                    }


                    /******************************************************************/

                    TPosPion tPosPion;
                    TDeplPion tDeplPion;
                    TCoupReq ma_tCoupReq ;

                    TIdReq ma_requete_coup = COUP;
                    TPropCoup ma_tPropCoup_client = CONT; // A modifier  on le récuper depuis le Moteur IA

                    if(mon_tcoup == TCoup.POSE)
                    {
                        TCase tCase = new TCase(ma_ligne, ma_clonne);
                        tPosPion = new TPosPion(ma_coulPion, tCase);
                        tDeplPion = new TDeplPion();
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);
                    }
                    else
                    {
                        tDeplPion = new TDeplPion(ma_coulPion, ma_clonne, ma_ligne);
                        tPosPion = new TPosPion();
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);
                    }


                    ma_tCoupReq.send(os);


                    /******** Réponse COUP ***********/

                    TCoupRep mon_tCoupRep = new TCoupRep() ;
                    mon_tCoupRep.recive(is);

                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();

                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;
                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        affichageresultat(0, num_partie, name1);
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
        } catch (IOException e) {
            System.out.println("IO exception" + e);
        }
    }
    public static void affichageresultat(int joueur, int partie, String name)
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

    @Override
    public int size() {
        return 0;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {

    }

    @Override
    public void send(OutputStream os) throws IOException {

    }


    @Override
    public void recive(InputStream is) throws IOException {

    }

    @Override
    public void getFromBuffer(ByteBuffer buffer) throws IOException {

    }
}