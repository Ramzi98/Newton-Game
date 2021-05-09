FLAGS = -cp
JC = javac -cp
CLASSPATH = ../lib/jpl.jar
#CLASSPATH = /usr/lib/swi-prolog/lib/jpl.jar


.SUFFIXES: .java .class
.java.class:
	 $(JC) $(CLASSPATH): $*.java

CLASSES = Client.java \
          CommunicationProlog.java \
		  Grille.java \
		  Protocole/Newton.java \
          Protocole/TCase.java \
          Protocole/TCodeRep.java \
          Protocole/TCol.java \
          Protocole/TCoul.java \
          Protocole/TCoup.java \
          Protocole/TcoupRep.java \
          Protocole/TCoupReq.java \
          Protocole/TDeplPion.java \
          Protocole/TIdReq.java \
          Protocole/TLg.java \
          Protocole/TPartieRep.java \
          Protocole/TPartieReq.java \
          Protocole/TPosPion.java \
          Protocole/TPropCoup.java \
          Protocole/TValCoup.java 

run: Client.class
	java -D java.library.path=/usr/lib/swi-prolog/lib/x86_64-linux
	java -cp $(CLASSPATH): Client $(ADRESSE) $(PORT) $(NAME) 
	make clean

default: classes

classes: $(CLASSES:.java=.class)

clean:
	$(RM) *.class
	$(RM) Protocole/*.class
