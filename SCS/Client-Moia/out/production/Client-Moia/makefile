FLAGS = -cp
JC = javac -cp
CLASSPATH = jpl.jar


.SUFFIXES: .java .class
.java.class:
	 $(JC) $(JFLAGS) $(CLASSPATH): $*.java

CLASSES = Client.java CommunicationProlog.java Grille.java Protocole/Newton.java Protocole/TCase.java Protocole/TCodeRep.java Protocole/TCol.java Protocole/TCoul.java Protocole/TCoup.java Protocole/TcoupRep.java Protocole/TCoupReq.java Protocole/TDeplPion.java Protocole/TIdReq.java Protocole/TLg.java Protocole/TPartieRep.java Protocole/TPartieReq.java Protocole/TPosPion.java Protocole/TPropCoup.java Protocole/TValCoup.java

run: Client.class
	java -cp $(CLASSPATH): Client $(ADRESSE) $(PORT) $(NAME) 

	make clean

default: classes

classes: $(CLASSES:.java=.class)

clean:
	$(RM) *.class
