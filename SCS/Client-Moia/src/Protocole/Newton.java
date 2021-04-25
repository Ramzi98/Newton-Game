package Protocole;
import java.net.* ;
import java.io.* ;
import java.util.Scanner;
import java.nio.ByteBuffer;
import java.nio.*;
import java.lang.*;
import java.nio.charset.Charset;
import java.util.*;

public abstract class Newton {

    public static final int T_NOM = 30;

    /* Identificateurs des requetes */
    public enum TIdReq { PARTIE, COUP }

    /* Types d'erreur */
    public enum TCodeRep { ERR_OK,      /* Validation de la requete */
            ERR_PARTIE,  /* Erreur sur la demande de partie */
            ERR_COUP,    /* Erreur sur le coup joue */
            ERR_TYP      /* Erreur sur le type de requete */
    }

    /*
     * Structures demande de partie
     */
    public enum TCoul{ BLEU, ROUGE }


    /*
     * Definition d'une position de case
     */
    public enum TLg { A, B, C, D, E, F, G, H }
    public enum TCol { UN, DEUX, TROIS, QUATRE, CINQ }

    /* Coups possibles */
    public enum TCoup { POSE, DEPL }

    /* Propriete des coups */
    public enum TPropCoup { CONT, GAGNE, NUL, PERDU }

    /* Validite du coup */
    public enum TValCoup{ VALID, TIMEOUT, TRICHE }

/********************************* Fonction For Send And Recive *///////////////////////////////
    public float reciveFloat(InputStream inputStream) throws IOException{
        byte[] bytes = new byte[4];
        inputStream.read(bytes);
        return Float.intBitsToFloat((bytes[0] & 0xFF) | ((bytes[1] & 0xFF) << 8) | ((bytes[2] & 0xFF) << 16) | ((bytes[3] & 0xFF) << 24));
    }

    public void sendFloat(OutputStream outputStream,float valeur) throws IOException{
        int intBits =  Float.floatToIntBits(valeur);

        byte[] bytes = new byte[] { (byte) (intBits) ,(byte) (intBits >> 8), (byte) (intBits >> 16), (byte) (intBits >> 24) };

        outputStream.write(bytes);
        outputStream.flush();
    }


    public byte[] charToBytes(char[] chars) {
        byte[] bytes = new byte[4];
        CharBuffer charBuffer = CharBuffer.wrap(chars);
        ByteBuffer byteBuffer = Charset.forName("UTF-8").encode(charBuffer);
        bytes = Arrays.copyOfRange(byteBuffer.array(),
                byteBuffer.position(), byteBuffer.limit());
        Arrays.fill(byteBuffer.array(), (byte) 0);
        return bytes;
    }



    public byte[] intToBytes(int value) {
        return new byte[] {
                (byte) (value) ,
                (byte) (value >> 8),
                (byte) (value >> 16),
                (byte) (value >> 24) };
    }


    public abstract int size();
    public abstract void putInBuffer(ByteBuffer buffer);
    public abstract void send(OutputStream os) throws IOException;
    public abstract void recive(InputStream is) throws IOException;

    public <T extends Enum<T>> T readEnumuration(ByteBuffer buf,Class<T> en){
        int i = Integer.reverseBytes(buf.getInt());
        return en.getEnumConstants()[i%en.getEnumConstants().length];
    }

    public static String readString(ByteBuffer buf) throws IOException{
        byte[] res = new byte[32];
        buf.get(res);
        int i;
        for (i = 0; i < res.length && res[i] != '\0'; i++){}
        return new String(res,0,i);
    }

    public static String byteToString(byte[] bytes){
        for (byte b : bytes) {
            System.out.print((char)b);
        }
        System.out.println();
        String res=null;
        try {
            res = new String(bytes,0,bytes.length,"8859_1");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return res;
    }

    public int readInt(InputStream is) throws IOException{
        byte[] bytes = new byte[4];
        is.read(bytes);
        return ((bytes[0] & 0xFF)
                | ((bytes[1] & 0xFF) << 8)
                | ((bytes[2] & 0xFF) << 16)
                | ((bytes[3] & 0xFF) << 24));
    }

    public int readIntBytes(ByteBuffer buffer) throws IOException{
        byte[] bytes = new byte[4];
        int n = buffer.getInt();
        return little2big(n);
    }

    public static byte[] StringToByteArray(String s) {
        byte[] old, res;
        old=null;
        res = new byte[30];
        try {
            old = s.getBytes("US-ASCII");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        System.arraycopy(old, 0, res, 0, s.length());
        return res;
    }

    int little2big(int i) {
        return (i&0xff)<<24 | (i&0xff00)<<8 | (i&0xff0000)>>8 | (i>>24)&0xff;
    }

    public abstract void getFromBuffer(ByteBuffer buffer) throws IOException;






}
