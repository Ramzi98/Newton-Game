package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TPartieRep extends Newton {
    private TCodeRep err;               /* Code de retour */
    private String nomAdvers;      /* Nom du joueur adverse */
    private TCoul coulPion;             /* Couleur pour le pion */

    public TCodeRep getErr() {
        return err;
    }

    public void setErr(TCodeRep err) {
        this.err = err;
    }

    public String getNomAdvers() {
        return nomAdvers;
    }

    public void setNomAdvers(String nomAdvers) {
        this.nomAdvers = nomAdvers;
    }

    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }

    @Override
    public int size() {
        return 4 + 30 + 4 + 2;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        /*
        buffer = ByteBuffer.allocate(size());
        byte[] err_bytes = intToBytes(err.ordinal());
        //byte[] nomAdvers_bytes = charToBytes(nomAdvers);
        byte[] coulPion_bytes = intToBytes(coulPion.ordinal());
        buffer.put(err_bytes);
        //buffer.put(nomAdvers_bytes);
        buffer.put(coulPion_bytes);
    */
    }

    @Override
    public void send(OutputStream os) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(size());
        putInBuffer(buffer);
        os.write((byte[]) buffer.flip().array());
    }

    @Override
    public void recive(InputStream is) throws IOException {
        byte[] bytes = new byte[size()];
        is.read(bytes);
        ByteBuffer buffer = (ByteBuffer) ByteBuffer.allocate(size()).put(bytes).flip();
        getFromBuffer(buffer);
    }

    @Override
    public void getFromBuffer(ByteBuffer buffer) throws IOException {
        err = readEnumuration(buffer, TCodeRep.class);
        nomAdvers = readString(buffer);
        coulPion = readEnumuration(buffer, TCoul.class);
    }


}
