package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TPosPion extends Newton{
    private TCoul coulPion;         /* Couleur du pion */
    private TCase posPion;          /* Position de la case du pion place */

    public TPosPion(TCoul coulPion, TCase posPion) {
        this.coulPion = coulPion;
        this.posPion = posPion;
    }

    public TPosPion()
    {
        this.coulPion = TCoul.ROUGE;
        this.posPion = new TCase(TLg.A, TCol.UN);

    }

    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }

    public TCase getPosPion() {
        return posPion;
    }

    public void setPosPion(TCase posPion) {
        this.posPion = posPion;
    }

    @Override
    public int size() {
        return 12;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] coulPion_bytes = intToBytes(coulPion.ordinal());

        buffer.put(coulPion_bytes);
        posPion.putInBuffer(buffer);
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
        coulPion = readEnumuration(buffer, TCoul.class);
        posPion = new TCase();
        posPion.getFromBuffer(buffer);
    }
}
