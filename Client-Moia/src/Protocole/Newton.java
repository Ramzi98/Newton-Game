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

/********************************* Fonction For Send And Recive *///////////////////////////////

    /** Fonction pour recvoir un Float from un input Stream *****/
    public float reciveFloat(InputStream inputStream) throws IOException{
        byte[] bytes = new byte[4];
        inputStream.read(bytes);
        return Float.intBitsToFloat((bytes[0] & 0xFF) | ((bytes[1] & 0xFF) << 8) | ((bytes[2] & 0xFF) << 16) | ((bytes[3] & 0xFF) << 24));
    }

    /** Fonction pour envoyer un Float dans un output Stream *****/
    public void sendFloat(OutputStream outputStream,float valeur) throws IOException{
        int intBits =  Float.floatToIntBits(valeur);

        byte[] bytes = new byte[] { (byte) (intBits) ,(byte) (intBits >> 8), (byte) (intBits >> 16), (byte) (intBits >> 24) };

        outputStream.write(bytes);
        outputStream.flush();
    }


    /** Fonction pour convertir des char[] to byte[]*****/
    public byte[] charToBytes(char[] chars) {
        byte[] bytes = new byte[4];
        CharBuffer charBuffer = CharBuffer.wrap(chars);
        ByteBuffer byteBuffer = Charset.forName("UTF-8").encode(charBuffer);
        bytes = Arrays.copyOfRange(byteBuffer.array(),
                byteBuffer.position(), byteBuffer.limit());
        Arrays.fill(byteBuffer.array(), (byte) 0);
        return bytes;
    }

    /** Fonction pour convertir des int vers un tableau d'octet byte[]*****/
    public byte[] intToBytes(int value) {
        return new byte[] {
                (byte) (value) ,
                (byte) (value >> 8),
                (byte) (value >> 16),
                (byte) (value >> 24) };
    }


    /** Fonction abstrait a redifinir
     * pour récuperer la taille de la structure *****/
    public abstract int size();

    /** Fonction abstrait a redifinir
     * pour mettre des tableaux de d'octet dans un Bytebuffer *****/
    public abstract void putInBuffer(ByteBuffer buffer);

    /** Fonction abstrait a redifinir
     * pour envoyer un Bytebuffer dans un OutputStream *****/
    public abstract void send(OutputStream os) throws IOException;

    /** Fonction abstrait a redifinir
     * pour recevoir un Bytebuffer depuis un InputStream *****/
    public abstract void recive(InputStream is) throws IOException;

    /** Fonction abstrait a redifinir
     * pour récuperer des tableaux de d'octet dans un Bytebuffer *****/
    public abstract void getFromBuffer(ByteBuffer buffer) throws IOException;

    /** Fonction pour lire des enumerations depuis un ByteBuffer*****/
    public <T extends Enum<T>> T readEnumuration(ByteBuffer buf,Class<T> en){
        int i = Integer.reverseBytes(buf.getInt());
        return en.getEnumConstants()[i%en.getEnumConstants().length];
    }

    /** Fonction pour lire des string depuis un ByteBuffer*****/
    public static String readString(ByteBuffer buf) throws IOException{
        byte[] res = new byte[32];
        buf.get(res);
        int i;
        for (i = 0; i < res.length && res[i] != '\0'; i++){}
        return new String(res,0,i);
    }

    /** Fonction pour convertir des bytes vers des string*****/
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

    /** Fonction pour lire des int depuis un ByteBuffer*****/
    public int readIntBytes(ByteBuffer buffer) throws IOException{
        byte[] bytes = new byte[4];
        int n = buffer.getInt();
        return little2big(n);
    }

    /** Fonction pour convertir des string vers un tableau d'octet byte[]*****/
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

    /** Fonction pour convertir
     * des int depuis le little endian to big endian*****/
    int little2big(int i) {
        return (i&0xff)<<24 | (i&0xff00)<<8 | (i&0xff0000)>>8 | (i>>24)&0xff;
    }



}
