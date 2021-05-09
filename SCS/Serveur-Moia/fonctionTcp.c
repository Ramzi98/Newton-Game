
#include "fonctionTcp.h"

int socketServeur(unsigned short port){
  int  sockConx,  sizeAddr,err  ;

  struct sockaddr_in addServ;	/* adresse socket connex serveur */
  struct sockaddr_in addClient;
sockConx = socket(AF_INET, SOCK_STREAM, 0); //c'est la creation de la socket de connexion 
  if (sockConx < 0) {
    perror("(serveurTCP) erreur de socket");
    return -2;
  }

addServ.sin_family = AF_INET; //pour dire le type d'adresse
addServ.sin_port = htons(port);
addServ.sin_addr.s_addr = INADDR_ANY;
 bzero(addServ.sin_zero, 8);


sizeAddr = sizeof(struct sockaddr_in);

  /* 
   * attribution de l'adresse a la socket
   */  
  err = bind(sockConx, (struct sockaddr *)&addServ, sizeAddr); 
  if (err < 0) {
    perror("(serveurTCP) erreur sur le bind");
    close(sockConx);
    return -3;
  }


    err = listen(sockConx, 1);
  if (err < 0) {
    perror("(serveurTCP) erreur dans listen");
    close(sockConx);
    return -4;
  }

return sockConx;
}




int socketClient(char* nomMachine, unsigned short port){
   struct sockaddr_in addrServer; 
   
 struct sockaddr_in addSockServ; 
   struct addrinfo hints;   /* parametre pour getaddrinfo */
  struct addrinfo *result; /* les adresses obtenues par getaddrinfo */ 

int sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("(client) erreur sur la creation de socket");
    return -2;
  }
  

    
  addSockServ.sin_family = AF_INET;
  int err = inet_aton(nomMachine, &addSockServ.sin_addr);
  if (err != 0) { 
    perror("(client) erreur obtention IP serveur");
    close(sock);
    return -3;
  }

    
  addSockServ.sin_port = htons(port);
  bzero(addSockServ.sin_zero, 8);
 	
 int  sizeAdd = sizeof(struct sockaddr_in);

 memset(&hints, 0, sizeof(struct addrinfo));
  hints.ai_family = AF_INET; // AF_INET / AF_INET6 
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = 0;
  hints.ai_protocol = 0;
  
  
  // récupération de la liste des adresses corespondante au serveur
  char str_port[20];
  sprintf(str_port, "%u" , port); //TODO chercher format unsigned short
  err = getaddrinfo(nomMachine, str_port, &hints, &result);
  if (err != 0) {
    perror("(client) erreur sur getaddrinfo");
    close(sock);
    return -3;
  }
  
  addSockServ = *(struct sockaddr_in*) result->ai_addr;
  sizeAdd = result->ai_addrlen;

  err = connect(sock, (struct sockaddr *)&addSockServ, sizeAdd); 

  if (err < 0) {
    perror("(client) erreur a la connection de socket");
    close(sock);
    return -4;
  }
  

return sock;
}
