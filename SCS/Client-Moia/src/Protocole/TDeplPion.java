package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TDeplPion extends Newton{
    private TCoul coulPion;         /* Couleur du pion */
    private TCol  colPion;          /* Colonne du pion a deplacer */
    private TLg   lgPionD;          /* Nouvelle ligne du pion deplace */

    public TDeplPion(TCoul coulPion, TCol colPion, TLg lgPionD) {
        this.coulPion = coulPion;
        this.colPion = colPion;
        this.lgPionD = lgPionD;
    }

    public TDeplPion()
    {
        this.coulPion = TCoul.ROUGE;
        this.colPion = TCol.UN;
        this.lgPionD = TLg.A;
    }


    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }

    public TCol getColPion() {
        return colPion;
    }

    public void setColPion(TCol colPion) {
        this.colPion = colPion;
    }

    public TLg getLgPionD() {
        return lgPionD;
    }

    public void setLgPionD(TLg lgPionD) {
        this.lgPionD = lgPionD;
    }

    @Override
    public int size() {
        return 12;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] coulPion_bytes = intToBytes(coulPion.ordinal());
        byte[] colPion_bytes = intToBytes(colPion.ordinal());
        byte[] lgPionD_bytes = intToBytes(lgPionD.ordinal());

        buffer.put(coulPion_bytes);
        buffer.put(colPion_bytes);
        buffer.put(lgPionD_bytes);

    }

    @Override
    public void send(OutputStream os) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(size());
        putInBuffer(buffer);
        os.write(buffer.flip().array());
    }

    @Override
    public void recive(InputStream is) throws IOException {
        byte[] bytes = new byte[size()];
        is.read(bytes);
        ByteBuffer buffer = ByteBuffer.allocate(size()).put(bytes).flip();
        getFromBuffer(buffer);
    }

    @Override
    public void getFromBuffer(ByteBuffer buffer) throws IOException {
        coulPion = readEnumuration(buffer, TCoul.class);
        colPion = readEnumuration(buffer, TCol.class);
        lgPionD = readEnumuration(buffer, TLg.class);
    }
}
