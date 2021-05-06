import Protocole.TCol;
import Protocole.TCoul;
import Protocole.TCoup;
import Protocole.TLg;
import org.jpl7.Query;
import org.jpl7.Term;

import java.util.Map;

public class Grille {
    Term magrille;
    Term advgrille;
    Term grilleTotale;
    int num_joueur;



    public Grille(int num_joueur, String emplacementIA)
    {
        this.num_joueur= num_joueur;

        //Query q = new Query("consult('\\Prolog\\alphaBeta.pl')");
        Query q = new Query("consult('"+emplacementIA+"')");
        q.hasSolution();

        q = new Query("grilleinitiale(G)");
        Map<String, Term> grille_totale = q.oneSolution();
        q = new Query("grilleinitiale(1, G)");
        Map<String, Term> grille_joueur1 = q.oneSolution();
        q = new Query("grilleinitiale(1, G)");
        Map<String, Term> grille_joueur2 = q.oneSolution();

        System.out.println(grille_totale.get("G"));

        System.out.println(grille_joueur1.get("G"));

        System.out.println(grille_joueur2.get("G"));

        if(num_joueur == 1)
        {
            magrille = grille_joueur1.get("G");
            advgrille = grille_joueur2.get("G");
        }
        else
        {
            magrille = grille_joueur2.get("G");
            advgrille = grille_joueur1.get("G");
        }

        grilleTotale = grille_totale.get("G");


    }

    public Term getMagrille() {
        return magrille;
    }

    public void setMagrille(Term magrille) {
        this.magrille = magrille;
    }

    public Term getAdvgrille() {
        return advgrille;
    }

    public void setAdvgrille(Term advgrille) {
        this.advgrille = advgrille;
    }

    public Term getGrilleTotale() {
        return grilleTotale;
    }

    public void setGrilleTotale(Term grilleTotale) {
        this.grilleTotale = grilleTotale;
    }

    public void miseAjourGrille(TCoup tcoup, TCol tCol, TLg tLg, TCoul tcouleur)
    {
        int col ;
        int ligne ;
        String typecoup;
        String couleur;

        switch (tCol)
        {
            case UN -> {
                col = 1;
                break;
            }
            case DEUX -> {
                col = 2;
                break;
            }
            case TROIS -> {
                col = 3;
                break;
            }
            case QUATRE -> {
                col = 4;
                break;
            }
            case CINQ -> {
                col = 5;
                break;
            }
            default -> {
                col = 0;
                break;
            }

            }

        switch (tLg) {
            case A -> {
                ligne = 1;
                break;
            }
            case B -> {
                ligne = 2;
                break;
            }
            case C -> {
                ligne = 3;
                break;
            }
            case D -> {
                ligne = 4;
                break;
            }
            case E -> {
                ligne = 5;
                break;
            }
            case F -> {
                ligne = 6;
                break;
            }
            case G -> {
                ligne = 7;
                break;
            }
            case H -> {
                ligne = 8;
                break;
            }

            default -> {
                ligne = 0;
                break;
            }
        }

        switch (tcoup) {
            case POSE -> {
                typecoup = "p";
                break;
            }
            case DEPL -> {
                typecoup = "d";
                break;
            }
            default -> {
                typecoup = "erreur_coup";
                break;
            }
        }

        switch (tcouleur) {
            case BLEU -> {
                couleur = "b";
                break;
            }
            case ROUGE -> {
                couleur = "r";
                break;
            }
            default -> {
                couleur = "erreur_couleur";
                break;
            }
        }


        Query q = new Query("consult('alphaBeta.pl')");
        q.hasSolution();

        q = new Query("updateGrille("+grilleTotale+","+ligne+","+col+","+couleur+","+typecoup+", NVGrille)");
        Map<String, Term> nouvellegrille = q.oneSolution();

        grilleTotale = nouvellegrille.get("NVGrille");

        //System.out.println(grilleTotale);



    }
}
