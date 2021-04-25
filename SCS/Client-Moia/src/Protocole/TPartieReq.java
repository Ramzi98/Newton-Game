package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TPartieReq extends Newton {
    private TIdReq idReq;               /* Identificateur de la requete */
    private char[] nomJoueur = new char[T_NOM];      /* Nom du joueur */

    public TPartieReq(TIdReq idReq, char[] nomJoueur) {
        this.idReq = idReq;
        this.nomJoueur = nomJoueur;
    }

    public TIdReq getIdReq() {
        return idReq;
    }

    public void setIdReq(TIdReq idReq) {
        this.idReq = idReq;
    }

    public char[] getNomJoueur() {
        return nomJoueur;
    }

    public void setNomJoueur(char[] nomJoueur) {
        this.nomJoueur = nomJoueur;
    }

    @Override
    public int size() {
        return 4 + 30 + 2;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] idReq_bytes = intToBytes(idReq.ordinal());
        //byte[] nomJoueur_bytes = charToBytes(nomJoueur);
        String name = new String(nomJoueur);
        byte[] nomJoueur_bytes = StringToByteArray(name);
        //System.out.println("idReq taille :"+idReq_bytes.length);
        //System.out.println("nomJoueur taille :"+nomJoueur_bytes.length);
        buffer.put(idReq_bytes);
        buffer.put(nomJoueur_bytes);
    }

    @Override
    public void send(OutputStream os) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(size());
        putInBuffer(buffer);
        os.write(buffer.flip().array());
    }


    @Override
    public void recive(InputStream is) throws IOException {

    }


}
