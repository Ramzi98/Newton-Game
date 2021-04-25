package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TCase extends Newton{
    private TLg l;           /* Ligne de la position d'un pion */
    private TCol c;          /* Colonne de la position d'un pion */

    public TCase(TLg l, TCol c) {
        this.l = l;
        this.c = c;
    }

    public TLg getL() {
        return l;
    }

    public void setL(TLg l) {
        this.l = l;
    }

    public TCol getC() {
        return c;
    }

    public void setC(TCol c) {
        this.c = c;
    }

    @Override
    public int size() {
        return 8;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] l_bytes = intToBytes(l.ordinal());
        byte[] c_bytes = intToBytes(c.ordinal());

        buffer.put(l_bytes);
        buffer.put(c_bytes);
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
        is.readNBytes(bytes, 0, size());
        ByteBuffer buffer = ByteBuffer.allocate(size()).put(bytes).flip();
        l = readEnumuration(buffer, TLg.class);
        c = readEnumuration(buffer, TCol.class);
    }
}
