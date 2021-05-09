import Protocole.*;

import java.io.File;
import java.lang.Integer;
import java.net.* ;
import java.io.* ;
import java.nio.ByteBuffer;
import java.util.*;
import java.util.Scanner;
import org.jpl7.*;





import static Protocole.TCodeRep.*;
import static Protocole.TCol.*;
import static Protocole.TCoul.*;
import static Protocole.TCoup.*;
import static Protocole.TIdReq.*;
import static Protocole.TLg.*;
import static Protocole.TPropCoup.*;
import static Protocole.TValCoup.*;


public class Client extends Newton {
    public static void main(String [] args) {

        //Récuperation de localisation du fichier alphaBeata.pl
        String fileIA = ClassLoader.getSystemResource("Prolog"+File.separator+"alphaBeta.pl").getPath();


        /*****  Récuperation de host Port nom_joueur depuis la ligne de commande   ************/
        if (args.length!=3){
            System.out.println("arguments - host port nom_joueur");
            System.exit(1);
        }

        String hote = args[0];
        int port = Integer.parseInt(args[1]);
        String name1 = args[2];

        /***** References de la socket ***********/
        Socket s ;

        /**** Déclaration des variables *************/
        char[] name_joueur = new char[name1.length()];
        String name_adversaire;
        TCoul ma_coulPion;
        TCoup mon_tcoup;
        int num_partie = 1;
        int mon_numjoueur;
        int mes_parties_gagnees = 0;
        int adv_parties_gagnees = 0;
        boolean new_partie = false;
        int profondeur = 4;
        int colonne;
        String ligne;
        int coup;

        /******************************/

        /**** Transformation de noms vers chaine de caractères *************/
        for (int i = 0; i < name1.length(); i++) {
            name_joueur[i] = name1.charAt(i);
        }



        try {
            /********** Initialisation de la Socket et Déclaration des Streams ***********/
            s = new Socket (hote, port);

            OutputStream os = s.getOutputStream();
            InputStream is = s.getInputStream();


            /**************  Requete PARTIE **************/

            /************ Initialisation de l'id de larequete avec PARTIE ***********/
            TIdReq requete_partie = PARTIE;
            /************ Création d'une instance de type Tpartie Requete avec le nom du joueur et id PARTIE ***********/
            TPartieReq tPartieReq = new TPartieReq(requete_partie, name_joueur);
            /************ Envoi de la requete vers le serveur dans le outputstream ************/
            tPartieReq.send(os);

            /********* La réponse PARTIE *******/

            /****** Création d'une instance de classe TpartieRep afin de sauvegarder la réponse ***********/
            TPartieRep tPartieRep = new TPartieRep();

            /****** Attenet d'une réponse de type Tpartie Requete ***********/
            tPartieRep.recive(is);
            /******* Affectaion du nom de l'advarsaire recu ***********/
            name_adversaire = tPartieRep.getNomAdvers();
            /******* Affectaion de la couleur des pions de joueur recu ***********/
            ma_coulPion = tPartieRep.getCoulPion();

            /********** Initialiser le numéro du joueur paraport la couleur de ses pions ********/
            if (ma_coulPion == BLEU)
            {
                mon_numjoueur = 1;
            }
            else
            {
                mon_numjoueur = 2;
            }

            /*** Création d'une nouvelles grille *****/
            Grille grille = new Grille( mon_numjoueur,fileIA);
            /*** Création d'une nouvelle communication avec le prolog en utilise la bibliothèque JPL *****/
            CommunicationProlog comm = new CommunicationProlog(ma_coulPion,80,mon_numjoueur,profondeur,grille,fileIA);



            /********* une boucle while afin de joueur plusieurs coups et lorsque en termine la deuxième partie on sort ***********/
            while(num_partie <= 2)
            {
                //os.flush();
                System.out.println("Partie N : "+num_partie);


                if(ma_coulPion == TCoul.BLEU && num_partie == 1 || ma_coulPion == TCoul.ROUGE && num_partie == 2)
                {
                    /***** Dans le cas où je suis le joueur avec des pions bleus et on est dans la 1er partie
                     *  ou je suis le joueur avec des pions rouges et partie 2
                     *  le joueur commence par envoyer son coup puis il attent la validation du serveur et le coup de l'adversaire
                     */


                    /**************  Requete COUP **************/


                    /************************ Récuperation du Coup depuis IA ************/



                    /**** Récupération du meilleur coup depuis prolog pour jouer avec ****////
                    Term mc = comm.getMeilleurCoup();


                    /******************************************************************/

                    TPosPion tPosPion;
                    TDeplPion tDeplPion;
                    TCoupReq ma_tCoupReq ;

                    /**** Initialisation de l'id de la requête avec COUP ********/
                    TIdReq ma_requete_coup = COUP;

                    /**** Initialisation de proposition de coup avec la valeur récupérait depuis l'IA ********/
                    TPropCoup ma_tPropCoup_client = comm.getpropCoup();
                    /**** Initialisation de type de deplacement de coup avec la valeur récupérait depuis l'IA ********/
                    mon_tcoup = comm.getTypeDeplacement();


                    if(mon_tcoup == TCoup.POSE)
                    {
                        /**** dans le cas ou le deplacement est un POSE de pion ********/
                        /**** Récupération de la case du coup a jouer depuis l'IA dans laquelle on pose le pion *******/
                        TCase tCase = comm.getCoup();
                        /**** initilaisation de la classe TPosPion avec la couleur des pions et la case récupérait depuis l'IA ****/
                        tPosPion = new TPosPion(ma_coulPion, tCase);
                        /**** initilaisation de la classe TDeplPion avec le vide car on a pas un deplacement ****/
                        tDeplPion = new TDeplPion();
                        /**** Initialisation de la classe TCoupReq avec les valeurs déjà initialiser et le num partie ****/
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);


                    }
                    else
                    {
                        /**** dans le cas ou le deplacement est un Deplacement de pion ********/
                        /**** Récupération de la la ligne et la colonne du coup a jouer depuis l'IA dans laquelle on pose le pion *******/
                        TLg tligne = comm.getLigne();
                        TCol tcolonne = comm.getCol();
                        /**** initilaisation de la classe TDeplPion avec la couleur des pions et la case récupérait depuis l'IA ****/
                        tDeplPion = new TDeplPion(ma_coulPion, tcolonne, tligne);
                        /**** initilaisation de la classe TPosPion avec le vide car on a un deplacement ****/
                        tPosPion = new TPosPion();
                        /**** Initialisation de la classe TCoupReq avec les valeurs déjà initialiser et le num partie ****/
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);

                    }

                    /**** Envoi de la requete dans le outputStram ****/
                    ma_tCoupReq.send(os);

                    /******** Réponse COUP ***********/

                    /****** Création d'une instance de classe TcoupRep et l'attent de la reponse de serveur *******/
                    TCoupRep mon_tCoupRep = new TCoupRep();
                    mon_tCoupRep.recive(is);

                    /********** initilaisation des variables avec les valeurs recu ************/
                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();


                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        /******* Si le serveur nous informe qu'on a gagné *********/
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        /******* Si le serveur nous informe qu'on a fait un matche null *********/
                        affichageresultat(0, num_partie, name1);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }
                    else if(mon_tPropCoup_serveur == PERDU)
                    {
                        /******* Si le serveur nous informe qu'on a perdu le matche *********/
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

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
                                /*** Dans le cas ou notre coup était valide *******/

                                /********* Attent de la réponse de serveur pour l'adversaire et en met la réponse dans
                                 * une instance TCouprep puis on affect les valeur recu dans des variables
                                 */
                                TCoupRep adv_tCoupRep = new TCoupRep();
                                adv_tCoupRep.recive(is);
                                TCodeRep adv_tCodeRep = adv_tCoupRep .getErr();
                                TValCoup adv_tValCoup = adv_tCoupRep .getValidCoup();
                                TPropCoup adv_tPropCoup_serveur = adv_tCoupRep.getPropCoup();

                                if(adv_tPropCoup_serveur == GAGNE || adv_tPropCoup_serveur == NUL || adv_tPropCoup_serveur == PERDU )
                                {
                                    /******* Si le serveur nous informe que  l'adversaire a perdu le matche
                                     *      ou qu'il a gagné ou il fait un marche NUl *********/
                                    if(adv_tPropCoup_serveur == GAGNE)
                                    {
                                        adv_parties_gagnees++;
                                    }

                                    /*** reinitialiserGrille la grille *****/
                                    Grille grille2 = new Grille( mon_numjoueur,fileIA);
                                    comm.reinitialiserGrille(grille2);

                                    num_partie++;
                                    continue;
                                }

                                if(adv_tValCoup == TValCoup.VALID)
                                {
                                    /*** Dans le cas ou le coup de l'adversaire était valide *******/

                                    /**** l'attente de la requête de l'adversaire
                                     * * et on va mettre cette réponse dans une instance de la classe TcoupReq
                                     * puis on affecte les valeur recu dans des variables ****/
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

                                    if(adv_tcoup == TCoup.POSE)
                                    {
                                        /**** dans le cas ou l'adversaire a fait un coup de type POSE ********/

                                        /**** Récupération de la couleur des pions de joueur *******/
                                        adv_coulPion = adv_tPosPion.getCoulPion();

                                        /**** Récupération de la ligne et la colonne de la case
                                         * du coup jouer par l'adversaire *******/
                                        TCase adv_tCase = adv_tPosPion.getPosPion();
                                        adv_ligne = adv_tCase.getL();
                                        adv_colonne = adv_tCase.getC();

                                    }
                                    else
                                    {
                                        /**** dans le cas ou l'adversaire a fait un coup de type DEPL ********/

                                        /**** Récupération de la couleur des pions de joueur *******/
                                        adv_coulPion = adv_tDeplPion.getCoulPion();

                                        /**** Récupération de la ligne et la colonne de la case
                                         * du coup jouer par l'adversaire *******/
                                        adv_ligne = adv_tDeplPion.getLgPionD();
                                        adv_colonne = adv_tDeplPion.getColPion();
                                    }

                                    /************** Update Grille apès Coup Adv ***********/
                                    comm.coupAdversaire(adv_tcoup,adv_colonne,adv_ligne,adv_coulPion);
                                    /*********************************************************/



                                }
                                else if(adv_tValCoup == TValCoup.TIMEOUT || adv_tValCoup == TValCoup.TRICHE)
                                {
                                    /*** Dans le cas ou le coup de l'adversaire n'est pas valide soit TRICHE ou TIMEOUT *******/
                                    mes_parties_gagnees++;
                                    num_partie++;

                                    /*** reinitialiserGrille la grille *****/
                                    Grille grille2 = new Grille( mon_numjoueur,fileIA);
                                    comm.reinitialiserGrille(grille2);

                                    continue;
                                }

                            }
                            else if(mon_tValCoup == TValCoup.TIMEOUT || mon_tValCoup == TValCoup.TRICHE)
                            {
                                /*** Dans le cas ou mon coup n'est pas valide soit TRICHE ou TIMEOUT *******/
                                num_partie++;

                                /*** reinitialiserGrille la grille *****/
                                Grille grille2 = new Grille( mon_numjoueur,fileIA);
                                comm.reinitialiserGrille(grille2);

                                continue;
                            }
                            break;
                    }
                }
                else
                {
                    /***** Dans le cas où je suis le joueur avec des pions bleus et on est dans la 2 eme partie
                     *  ou je suis le joueur avec des pions rouges et partie 1
                     *  le joueur commence recvoir le coup de l'adversaire puis il envoi son coup et attent la validation du serveur
                     */


                    /********* Attent de la réponse de serveur pour l'adversaire et en met la réponse dans
                     * une instance TCouprep puis on affect les valeur recu dans des variables
                     */
                    TCoupRep adv_tCoupRep = new TCoupRep();
                    adv_tCoupRep.recive(is);
                    TCodeRep adv_tCodeRep = adv_tCoupRep.getErr();
                    TValCoup adv_tValCoup = adv_tCoupRep.getValidCoup();
                    TPropCoup adv_tPropCoup_serveur = adv_tCoupRep.getPropCoup();


                    if (adv_tPropCoup_serveur == GAGNE) {
                        /******* Si le serveur nous informe que l'adversaire a gagné le matche *********/
                        adv_parties_gagnees++;
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    } else if (adv_tPropCoup_serveur == NUL) {
                        /******* Si le serveur nous informe que c'est un matche null *********/
                        affichageresultat(0, num_partie, name_adversaire);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    } else if (adv_tPropCoup_serveur == PERDU) {
                        /******* Si le serveur nous informe que l'adversaire a perdu le matche *********/
                        affichageresultat(1, num_partie, name1);
                        mes_parties_gagnees++;
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }



                    if (adv_tValCoup == TValCoup.VALID) {

                        /*** Dans le cas ou le coup de l'adversaire était valide *******/

                        /**** l'attente de la requête de l'adversaire
                         * * et on va mettre cette réponse dans une instance de la classe TcoupReq
                         * puis on affecte les valeur recu dans des variables ****/
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

                        if(adv_tcoup == TCoup.POSE)
                        {
                            /**** dans le cas ou l'adversaire a fait un coup de type POSE ********/

                            /**** Récupération de la couleur des pions de joueur *******/
                            adv_coulPion = adv_tPosPion.getCoulPion();

                            /**** Récupération de la ligne et la colonne de la case
                             * du coup jouer par l'adversaire *******/
                            TCase adv_tCase = adv_tPosPion.getPosPion();
                            adv_ligne = adv_tCase.getL();
                            adv_colonne = adv_tCase.getC();

                        }
                        else
                        {
                            /**** dans le cas ou l'adversaire a fait un coup de type DEPL ********/

                            /**** Récupération de la couleur des pions de joueur *******/
                            adv_coulPion = adv_tDeplPion.getCoulPion();

                            /**** Récupération de la ligne et la colonne de la case
                             * du coup jouer par l'adversaire *******/
                            adv_ligne = adv_tDeplPion.getLgPionD();
                            adv_colonne = adv_tDeplPion.getColPion();
                        }

                        /************** Update Grille apès Coup Adv ***********/
                        comm.coupAdversaire(adv_tcoup,adv_colonne,adv_ligne,adv_coulPion);
                        /*********************************************************/




                    } else if (adv_tValCoup == TValCoup.TIMEOUT || adv_tValCoup == TValCoup.TRICHE) {
                        /*** Dans le cas ou le coup de l'adversaire n'est pas valide soit TRICHE ou TIMEOUT *******/
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }

                    /**************  Requete COUP **************/

                    /************************ Récuperation du Coup depuis IA ************/

                    /**** Récupération du meilleur coup depuis prolog pour jouer avec ****////
                    Term mc = comm.getMeilleurCoup();

                    /******************************************************************/



                    TPosPion tPosPion;
                    TDeplPion tDeplPion;
                    TCoupReq ma_tCoupReq ;

                    /**** Initialisation de l'id de la requête avec COUP ********/
                    TIdReq ma_requete_coup = COUP;

                    /**** Initialisation de proposition de coup avec la valeur récupérait depuis l'IA ********/
                    TPropCoup ma_tPropCoup_client = comm.getpropCoup();
                    /**** Initialisation de type de deplacement de coup avec la valeur récupérait depuis l'IA ********/
                    mon_tcoup = comm.getTypeDeplacement();


                    if(mon_tcoup == TCoup.POSE)
                    {
                        /**** dans le cas ou le deplacement est un POSE de pion ********/
                        /**** Récupération de la case du coup a jouer depuis l'IA dans laquelle on pose le pion *******/
                        TCase tCase = comm.getCoup();
                        /**** initilaisation de la classe TPosPion avec la couleur des pions et la case récupérait depuis l'IA ****/
                        tPosPion = new TPosPion(ma_coulPion, tCase);
                        /**** initilaisation de la classe TDeplPion avec le vide car on a pas un deplacement ****/
                        tDeplPion = new TDeplPion();
                        /**** Initialisation de la classe TCoupReq avec les valeurs déjà initialiser et le num partie ****/
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);


                    }
                    else
                    {
                        /**** dans le cas ou le deplacement est un Deplacement de pion ********/
                        /**** Récupération de la la ligne et la colonne du coup a jouer depuis l'IA dans laquelle on pose le pion *******/
                        TLg tligne = comm.getLigne();
                        TCol tcolonne = comm.getCol();
                        /**** initilaisation de la classe TDeplPion avec la couleur des pions et la case récupérait depuis l'IA ****/
                        tDeplPion = new TDeplPion(ma_coulPion, tcolonne, tligne);
                        /**** initilaisation de la classe TPosPion avec le vide car on a un deplacement ****/
                        tPosPion = new TPosPion();
                        /**** Initialisation de la classe TCoupReq avec les valeurs déjà initialiser et le num partie ****/
                        ma_tCoupReq = new TCoupReq(ma_requete_coup, num_partie, mon_tcoup, tPosPion, tDeplPion, ma_tPropCoup_client);

                    }

                    /**** Envoi de la requete dans le outputStram ****/
                    ma_tCoupReq.send(os);

                    /******** Réponse COUP ***********/

                    /****** Création d'une instance de classe TcoupRep et l'attent de la reponse de serveur *******/
                    TCoupRep mon_tCoupRep = new TCoupRep() ;
                    mon_tCoupRep.recive(is);

                    /********** initilaisation des variables avec les valeurs recu ************/
                    TCodeRep mon_tCodeRep = mon_tCoupRep .getErr();
                    TValCoup mon_tValCoup = mon_tCoupRep .getValidCoup();
                    TPropCoup mon_tPropCoup_serveur = mon_tCoupRep.getPropCoup();

                    if(mon_tPropCoup_serveur == GAGNE )
                    {
                        /******* Si le serveur nous informe qu'on a gagné *********/
                        mes_parties_gagnees++;
                        affichageresultat(1, num_partie, name1);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }
                    else if(mon_tPropCoup_serveur == NUL)
                    {
                        /******* Si le serveur nous informe qu'on a fait un matche NUL *********/
                        affichageresultat(0, num_partie, name1);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

                        continue;
                    }
                    else if(mon_tPropCoup_serveur == PERDU)
                    {
                        /******* Si le serveur nous informe qu'on a perdu le matche *********/
                        affichageresultat(1, num_partie, name_adversaire);
                        num_partie++;

                        /*** reinitialiserGrille la grille *****/
                        Grille grille2 = new Grille( mon_numjoueur,fileIA);
                        comm.reinitialiserGrille(grille2);

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
                                /*** Dans le cas ou mon coup n'est pas valide soit TRICHE ou TIMEOUT *******/
                                affichageresultat(1, num_partie, name_adversaire);
                                num_partie++;
                                continue;
                            }
                            break;
                    }


                }





            }
            s.close();
        } catch (UnknownHostException e) {
            System.out.println("Unknown host" + e);
        } catch (IOException e) {
            System.out.println("IO exception" + e);
        }
    }

    /****** Fonction pour afficher le resultat du matche pour le client a chaque fin de matche **********/
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
    public void send(OutputStream os) {

    }


    @Override
    public void recive(InputStream is)  {

    }

    @Override
    public void getFromBuffer(ByteBuffer buffer)  {

    }
}