import Protocole.*;
import org.jpl7.Query;
import org.jpl7.Term;

import java.util.Map;

import static Protocole.TCol.*;
import static Protocole.TCoul.*;
import static Protocole.TCoup.*;
import static Protocole.TLg.*;

public class CommunicationProlog {
    private TCoul macouleur;
    private TCoul advcouleur;
    private int mon_numjoueur;
    private Grille grille;
    private int numeroTour;
    private int nbToursMax;
    private TIdReq idrequest;
    private int profendeur;
    private String emplacementIA;
    Term meilleurCoup;

    public CommunicationProlog(TCoul macouleur, int nbToursMax, int mon_numjoueur, int profendeur, Grille grille, String emplacementIA)
    {
        this.grille = grille;
        this.macouleur = macouleur;
        this.mon_numjoueur = mon_numjoueur;
        this.profendeur = profendeur;
        this.emplacementIA = emplacementIA;


        if(macouleur == TCoul.BLEU)
        {
            advcouleur = ROUGE;
        }
        else
        {
            advcouleur = TCoul.BLEU;
        }

        this.numeroTour = 0;
        this.nbToursMax = nbToursMax;


    }

    public TCoul getMacouleur() {
        return macouleur;
    }

    public void setMacouleur(TCoul macouleur) {
        this.macouleur = macouleur;
    }

    public TCoul getAdvcouleur() {
        return advcouleur;
    }

    public void setAdvcouleur(TCoul advcouleur) {
        this.advcouleur = advcouleur;
    }

    public int getProfendeur() {
        return profendeur;
    }

    public void setProfendeur(int profendeur) {
        this.profendeur = profendeur;
    }

    public void coupAdversaire(TCoup tcoup, TCol tCol, TLg tLg, TCoul tcouleur)
    {
        grille.miseAjourGrille(tcoup,tCol,tLg,tcouleur);
        this.numeroTour++;
    }


    public Term getMeilleurCoup()
    {
        Query q = new Query("consult('"+emplacementIA+"')");
        q.hasSolution();

        //alphaBeta(Grille,Player, Tour, TourMax, Prof, MeilleurCoup)
        System.out.println(grille.getGrilleTotale());
        q = new Query("alphaBeta("+grille.getGrilleTotale()+","+mon_numjoueur+","+numeroTour+","+nbToursMax+","+profendeur+", MeilleurCoup)");
        Map<String, Term> coup = q.oneSolution();

        Term meilleurCoup = coup.get("MeilleurCoup");
        this.meilleurCoup = meilleurCoup;

        // Mise a jour grille avec NVG
        Term NvGrille = meilleurCoup.arg(1);
        grille.setGrilleTotale(NvGrille);

        return meilleurCoup;
    }


    public TCase getCoup()
    {
        TCol tCol;
        TLg tLg;

        Term Mcoup = meilleurCoup.arg(2);
        Term LeCoup = Mcoup.arg(1);

        Term TermColonne = LeCoup.arg(1).arg(1);
        Term TermLigne = LeCoup.arg(1).arg(2).arg(1);


        switch (TermLigne.toString())
        {
            case "1" -> {
                tLg = A;
                break;
            }
            case "2" -> {
                tLg = B;
                break;
            }
            case "3" -> {
                tLg = C;
                break;
            }
            case "4" -> {
                tLg = D;
                break;
            }
            case "5" -> {
                tLg = E;
                break;
            }
            case "6" -> {
                tLg = F;
                break;
            }
            case "7" -> {
                tLg = G;
                break;
            }
            case "8" -> {
                tLg = H;
                break;
            }

            default -> {
                tLg = A;
                break;
            }
        }

        switch (TermColonne.toString())
        {
            case "1" -> {
                tCol = UN;
                break;
            }
            case "2" -> {
                tCol = DEUX;
                break;
            }
            case "3" -> {
                tCol = TROIS;
                break;
            }
            case "4" -> {
                tCol = QUATRE;
                break;
            }
            case "5" -> {
                tCol = CINQ;
                break;
            }
            default -> {
                tCol = UN;
                break;
            }
        }
        TCase tCase = new TCase(tLg,tCol);
        System.out.println(tLg);
        System.out.println(tCol);
        System.out.println(tCase);
        return tCase;

    }

    public TCol getCol()
    {
        TCol tCol;

        Term Mcoup = meilleurCoup.arg(2);
        Term LeCoup = Mcoup.arg(1);

        Term TermColonne = LeCoup.arg(1).arg(1);

        switch (TermColonne.toString())
        {
            case "1" -> {
                tCol = UN;
                break;
            }
            case "2" -> {
                tCol = DEUX;
                break;
            }
            case "3" -> {
                tCol = TROIS;
                break;
            }
            case "4" -> {
                tCol = QUATRE;
                break;
            }
            case "5" -> {
                tCol = CINQ;
                break;
            }
            default -> {
                tCol = UN;
                break;
            }
        }
        System.out.println(tCol);
        return tCol;

    }

    public TLg getLigne()
    {
        TLg tLg;

        Term Mcoup = meilleurCoup.arg(2);
        Term LeCoup = Mcoup.arg(1);
        Term TermLigne = LeCoup.arg(1).arg(2).arg(1);

        switch (TermLigne.toString())
        {
            case "1" -> {
                tLg = A;
                break;
            }
            case "2" -> {
                tLg = B;
                break;
            }
            case "3" -> {
                tLg = C;
                break;
            }
            case "4" -> {
                tLg = D;
                break;
            }
            case "5" -> {
                tLg = E;
                break;
            }
            case "6" -> {
                tLg = F;
                break;
            }
            case "7" -> {
                tLg = G;
                break;
            }
            case "8" -> {
                tLg = H;
                break;
            }

            default -> {
                tLg = A;
                break;
            }
        }

        System.out.println(tLg);
        return tLg;

    }

    public TCoul coupCouleur()
    {
        TCoul tCoul;
        Term Mcoup = meilleurCoup.arg(2);
        Term LeCoup = Mcoup.arg(1);
        Term TermColeur = LeCoup.arg(2).arg(1);

        switch (TermColeur.toString())
        {
            case "r" -> {
                tCoul = ROUGE;
                break;
            }
            case "b" -> {
                tCoul = BLEU;
                break;
            }
            default -> {
                tCoul = BLEU;
                break;
            }
        }
        System.out.println(tCoul);
        return tCoul;
    }

    public TPropCoup getpropCoup()
    {
        TPropCoup tPropCoup;
        Term Mcoup = meilleurCoup.arg(2);
        Term TermPropostionCoup = Mcoup.arg(2).arg(1);

        switch (TermPropostionCoup.toString())
        {
            case "g" -> {
                tPropCoup = TPropCoup.GAGNE;
                break;
            }
            case "p" -> {
                tPropCoup = TPropCoup.PERDU;
                break;
            }
            case "n" -> {
                tPropCoup = TPropCoup.NUL;
                break;
            }
            case "c" -> {
                tPropCoup = TPropCoup.CONT;
                break;
            }
            default -> {
                tPropCoup = TPropCoup.CONT;
                break;
            }

        }
        System.out.println(tPropCoup);
        return tPropCoup;
    }

    public TCoup getTypeDeplacement()
    {
        TCoup tCoup;
        Term Mcoup = meilleurCoup.arg(2);
        Term Typedepl = Mcoup.arg(2).arg(2).arg(1);

        switch (Typedepl.toString())
        {
            case "p" -> {
                tCoup = POSE;
                break;
            }
            case "d" -> {
                tCoup = DEPL;
                break;
            }
            default -> {
                tCoup = POSE;
                break;
            }
        }
        System.out.println(Typedepl);

        return tCoup;

    }




}
