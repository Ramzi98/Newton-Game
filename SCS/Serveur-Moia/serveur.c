#include "fonctionTcp.h"
#include "protocolNewton.h"
#include "validation.h"
#include "time.h"

#define TIME_MAX 6;

int main(int argc, char** argv)
{
	int sockConx, /* descripteur socket connexion */
		sockTrans1,
		sockTrans2, /* descripteur socket transmission */
		port,		/* numero de port */
		sizeAddr,	/* taille de l'adresse d'une socket */
		err,
		nfsd = 6;
	fd_set readSet;
	fd_set readSet2;




	TIdReq codeReq;

	TCoupReq reqCoup; //requete d'un coup
	TCoupRep repCoup; // reponse d'un coup
	TPartieReq reqPartie; //reponse requete partie
	TPartieRep repPartieJ1, repPartieJ2; //requete partie Joueur1 et Joueur2
	TPropCoup propCoup;  //propriété Coup

	int numPartie = 1; //numero de la partie
	char nomJoueur1[T_NOM];  //nom du premeir joueur connecté
	char nomJoueur2[T_NOM];  // nom du deuxieme joueur connecté
	bool timeout = true;	//Avec timeout
	bool validation = true; //avec validation
	char* time = "--noTimeout"; //flag pas de timeout
	char* valid = "--noValid"; //flag pas de validation
	bool waitPartie1 = true; // attente du joueur 1
	bool waitPartie2 = false; // attente joueur 2
	bool selectionPartie = false; //mode initialisation de partie
	int retval; //valeur retourné pour le timeout
	int scoreJ1GAGNE = 0;  //nombre des matches gagnés par le joueur 1 
	int scoreJ1PERTE = 0;  //nombre des matches perdu par le joueur 1
	int scoreJ1NUL = 0;    //nombre des matches nuls par le joueur 1
	int scoreJ2GAGNE = 0;  //nombre des matches gagnés par le joueur 2
	int scoreJ2PERTE = 0;  //nombre des matches perdu par le joueur 2
	int scoreJ2NUL = 0;    //nombre des matches nul par le joueur 2


	// Affichage de la configuration du serveur
	if (argc >= 2 || argc <= 4)
	{
		if (argc == 2)
			port = atoi(argv[1]);

		else if (argc == 3 && (!(strcmp(argv[1], time)) || !(strcmp(argv[1], valid))))
		{
			port = atoi(argv[2]);

			if (!(strcmp(argv[1], time)))
				timeout = false;
			if (!(strcmp(argv[1], valid)))
				validation = false;
		}
		else if (argc == 4 && (!(strcmp(argv[1], time)) || !(strcmp(argv[1], valid))) &&
			(!(strcmp(argv[2], time)) || !(strcmp(argv[2], valid))) && (strcmp(argv[1], argv[2])))
		{
			port = atoi(argv[3]);
			if (!(strcmp(argv[1], time)) || !(strcmp(argv[2], time)))
				timeout = false;
			if (!(strcmp(argv[1], valid)) || !(strcmp(argv[2], valid)))
				validation = false;
		}
		else
		{
			printf("usage : ./serveur [--noValid|--noTimeout] no_port\n");
			return -1;
		}
	}
	else
	{
		printf("usage : ./serveur [--noValid|--noTimeout] no_port\n");
		return -2;
	}

	if (timeout && validation)
		printf("Starting ./serveur on port %d with validation and timeout \n", port);
	else if (!timeout && validation)
		printf("Starting ./serveur on port %d with validation and  no timeout \n", port);
	else if (timeout && !validation)
		printf("Starting ./serveur on port %d with no validation and timeout \n", port);
	else if (!timeout && !validation)
		printf("Starting ./serveur on port %d with no validation and  no timeout \n", port);

	struct sockaddr_in addClient; /* adresse de la socket client connectee */

    //Initialisation de la socket server
	sockConx = socketServeur(port);
	
	sizeAddr = sizeof(struct sockaddr_in);

	//Creation de la socketTrans pour le premier Joueur a se connecter
	sockTrans1 = accept(sockConx, NULL, NULL);

	if (sockTrans1 < 0)
	{
		printf("error sur le accept de la SockTrans du joueur 1\n");
		return 2;
	}

	//Creation de la socketTrans pour le dexieme Joueur a se connecter
	sockTrans2 = accept(sockConx, NULL, NULL);
	if (sockTrans2 < 0)
	{
		printf("error sur le accept de la SockTrans du joueur 2\n");
		return 2;
	}

    //Select les sockTrans1, sockTrans2
	FD_ZERO(&readSet); // initialisation à zéro
	FD_SET(sockTrans1, &readSet);
	FD_SET(sockTrans2, &readSet);

	err = select(nfsd, &readSet, NULL, NULL, NULL);

	if (err < 0)
	{
		printf("erreur sur le select \n");
		return 3;
	}

	//Tant que on est en mode de selection
	while (!selectionPartie)
	{

		
		FD_ZERO(&readSet); // initialisation à zéro
		FD_SET(sockTrans1, &readSet);
		FD_SET(sockTrans2, &readSet);

		if (FD_ISSET(sockTrans1, &readSet) != 0 && waitPartie1)
		{
			/*
			  Recevoir la premiere requete du premier joueur connecté => Joueur n 1 
			  On fait un MSG_PEEK pour avoir que le code de la requete et confirmer qu'elle est de type Partie.
			*/

			err = recv(sockTrans1, &codeReq, sizeof(TIdReq), MSG_PEEK);
			if (err < 0)
				perror("(sockTrans1) erreur sur le recv \n");

			switch (codeReq)
			{

			case PARTIE:
				/*Si le code est Partie => Preparation La réponse en affectant la couleur bleu à ce joueur */
				err = recv(sockTrans1, &reqPartie, sizeof(TPartieReq), 0);
				repPartieJ1.err = ERR_OK;
				repPartieJ1.coulPion = BLEU;
				
				memcpy(nomJoueur1, reqPartie.nomJoueur, T_NOM);  //Enregistrer le nom du premier joueur pour un envoi ulterieur
				break;

			default: //Sinon Erreur
				repPartieJ1.err = ERR_TYP;
				break;
			}
			//Attente du premierJoueur est fini
			waitPartie1 = false;
			//Attente du dexieme Joueur commence
			waitPartie2 = true;
		}

		//Meme chose avec le premier client on reçoit la requete sur la dexieme socket de transmission
		if (FD_ISSET(sockTrans2, &readSet) != 0 && waitPartie2)
		{
			err = recv(sockTrans2, &codeReq, sizeof(TIdReq), MSG_PEEK);
			if (err < 0)
				perror("(sockTrans2) erreur sur le recv \n");

			switch (codeReq)
			{

			case PARTIE:

				err = recv(sockTrans2, &reqPartie, sizeof(TPartieReq), 0);
				repPartieJ2.err = ERR_OK;
				//Le dexieme joueur prendra le rouge comme couleur
				repPartieJ2.coulPion = ROUGE;
				//On stocke son nom aussi dans une variable
				memcpy(nomJoueur2, reqPartie.nomJoueur, T_NOM);
				break;

			default:

				//Erreur 
				repPartieJ2.err = ERR_TYP;
				break;
			}


			//L'attente du dexieme joueur est fini
			waitPartie2 = false;

			//La partie selection est fini, on peut commencer le match
			selectionPartie = true;
		}
	}

	//Si on est pas en attente
	if (!waitPartie1 && !waitPartie2)
	{

		//On rajoute le nom du dexieme joueur dans l'attribut adversaire dans la reponse à envoyer au premier joueur et vice versa
		memcpy(repPartieJ1.nomAdvers, nomJoueur2, T_NOM);
		memcpy(repPartieJ2.nomAdvers, nomJoueur1, T_NOM);
		
		

		//Envoie de la reponse au joueur 1
		err = send(sockTrans1, &repPartieJ1, sizeof(TPartieRep), 0);
		if (err <= 0)
		{
			perror("(sockTrans1) erreur sur le recv \n");
			shutdown(sockTrans1, SHUT_RDWR);
			close(sockTrans1);
			return -5;
		}

		//Envoie de la reponse au joueur 2
		err = send(sockTrans2, &repPartieJ2, sizeof(TPartieRep), 0);
		if (err <= 0)
		{
			perror("(sockTrans2) erreur sur le recv \n");
			shutdown(sockTrans2, SHUT_RDWR);
			close(sockTrans2);
			return -5;
		}
	}

	//Appel de la fonction d'initialisation de la partie
	initialiserPartie();
	printf("Arbitre : partie \nnouveau joueur: %s \nnouveau joueur %s \nPieces des joueurs : \nJoueur %s - BLEU \nJoueur %s - ROUGE \nmain: attente du coup du joueur BLEU\n ",nomJoueur1,nomJoueur2,nomJoueur1,nomJoueur2);

	/*Debut de la premiere partie*/

	while (numPartie == 1)
		{
		
		if(timeout){  /*Si la configuration du serveur est avec le timeout de 6 seconds*/
		struct timeval tv1;
		tv1.tv_sec = TIME_MAX;
		tv1.tv_usec = 0;
		FD_ZERO(&readSet2);
		FD_SET(sockTrans1, &readSet2);
		//FD_SET(sockTrans2, &readSet);
		 retval = select(sockTrans1 + 1, &readSet2, NULL, NULL, &tv1); /*faire un select pour mettre en place un timer */
		}
		if((retval > 0 && timeout )|| !timeout){ // Si il y'a un timeout qui n'a pas été depassé ( moins de 6 seconds ou y'a pas de timeout )
		/* faire un recieve du coup joué par le joueur 1*/
		err = recv(sockTrans1, &codeReq, sizeof(TIdReq), MSG_PEEK);
		
		switch (codeReq)
		{
			/*Si c'est une requete coup , le cas normale : recevoir la requete */
		case COUP:

			//reception de la requete
			err = recv(sockTrans1, &reqCoup, sizeof(TCoupReq), 0);
			if (err <= 0)
			{

				perror("(sockTrans1) erreur sur le recv \n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			printf("reception: recu COUP de BLEU\nvalid pour le joueur 1 - BLEU\n");
			/*Validation du coup a partir de la requete et le joueur*/
			bool coupBool = validationCoup(1, reqCoup, &propCoup);

			//Si la configuration de serveur contient la validation et le coup n'est pas valide
			if (valid && coupBool == false && reqCoup.propCoup == CONT )
			{
				
				/*Repondre par une reponse erreur et envoyer la reponse au deux joueurs*/
				repCoup.err = ERR_COUP;
				repCoup.validCoup = TRICHE;
				repCoup.propCoup = PERDU;
				err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
					perror("(sockTrans1) erreur sur le send \n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}
				// envoie de la validité du coup au joueur 2
				err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
					perror("(sockTrans2) erreur sur le send \n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}

		   		scoreJ1PERTE++;
		   		scoreJ2GAGNE++;
				//Le joueur 1 perd la partie, on passe à la dexieme
				numPartie++;
				break;
			}
			else
			{
				printf("reception : envoi validation - 0 estCoupValide 1\nrecoitCoup : validation du coup du joueur BLEU = VALID\n");

				/* Si le coup est valide, prepare la reponse au coup */
				repCoup.err = ERR_OK;
				repCoup.validCoup = VALID;
				repCoup.propCoup = propCoup;
			}
			/*Envoyer la reponse au premier joueur*/
			err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
				perror("(sockTrans1) erreur sur le send \n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			/* Envoyer la reponse au dexieme joueur*/
			err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
				perror("(sockTrans2) erreur sur le send \n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}

			/*Si le coup est valide mais Il y'a une condition d'arret ( Gagnant, perdant ou nul ) La partie est finie*/
			if (coupBool == true && propCoup != CONT)
			{
			
			if(propCoup == GAGNE){scoreJ2PERTE++; scoreJ1GAGNE++;}
			if(propCoup == PERDU){scoreJ1PERTE++; scoreJ2GAGNE++;}
			if(propCoup == NUL){scoreJ1NUL++;scoreJ2NUL++;}
				numPartie++;
				/*Reste a revoir */
				break;
			}
			/*Si le coup est valide et on demande la continuité sinon si on s'interesse pas à la validation et le joueur veut continuer, on continue*/
			if ((coupBool == true && reqCoup.propCoup == CONT) || (!valid && reqCoup.propCoup == CONT))
			{
				printf("ENVOI COUP ADV\n");
				/*Envoie de la requete du joueur 1 au joueur 2 */
				err = send(sockTrans2, &reqCoup, sizeof(TCoupReq), 0);
				if (err <= 0)
				{
					perror("(sockTrans2) erreur sur le send \n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}
			}
			break;


		/*Si le code de la requete n'est pas COUP , envoyer une reponse d'erreur au joueur qui a envoyé cette requete*/
		default:

			repCoup.err = ERR_TYP;
			err = send(sockTrans1, &repCoup, sizeof(TCodeRep), 0);
			if (err <= 0)
			{
				perror("(sockTrans1) erreur sur le send \n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			numPartie++;
			break;
		}
		//Si on a deja incrementé le numero de la partie avant, ça veut dire qu'on est en etat de fin de partie on sort de la boucle, sinon on continue a voir le coup de l'adversaire
		if (numPartie != 1)
		{
			break;
		}
		
		/*-------------- Recevoir le coup du joueur 2 ---------- */

		/*
		C'est l'alternance des coups, les memes  instructions et commentaires seront appliqué ici, sauf qu'on commence par le dexieme joueur et non pas le premier 
		*/

		if(timeout){
		printf("main: attente du coup du joueur BLEU\n");
		FD_ZERO(&readSet2);
		FD_SET(sockTrans2, &readSet2);
		struct timeval tv2;
		tv2.tv_sec = TIME_MAX;
		tv2.tv_usec = 0;
		int retval = select(sockTrans2+1, &readSet2, NULL, NULL, &tv2);
		}
		if((retval > 0 && timeout )|| !timeout){
			
		err = recv(sockTrans2, &codeReq, sizeof(TIdReq), MSG_PEEK);
		if (err <= 0)
		{

			perror("(sockTrans2) erreur sur le recv \n");
			shutdown(sockTrans2, SHUT_RDWR);
			close(sockTrans2);
			return -5;
		}
		
		switch (codeReq)
		{
		case COUP:
			

			err = recv(sockTrans2, &reqCoup, sizeof(TCoupReq), 0);

			if (err <= 0)
			{

			perror("(sockTrans2) erreur sur le recv\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}

			printf("reception: recu COUP de ROUGE\nvalid pour le joueur 2 - ROUGE\n");
			bool coupBool = validationCoup(2, reqCoup, &propCoup);

			if (valid && coupBool == false && reqCoup.propCoup == CONT)
			{

				repCoup.err = ERR_COUP;
				repCoup.validCoup = TRICHE;
				repCoup.propCoup = PERDU;
				err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);

				if (err <= 0)
				{
			perror("(sockTrans2) erreur sur le send\n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}

				err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}
				scoreJ2PERTE++;
		   		scoreJ1GAGNE++;

				numPartie++;

				break;
			}
			else
			{
				printf("reception : envoi validation - 0 estCoupValide 1\nrecoitCoup : validation du coup du joueur ROUGE = VALID\n");
				repCoup.err = ERR_OK;
				repCoup.validCoup = VALID;
				repCoup.propCoup = propCoup;
			}

			err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);

			if (err <= 0)
			{
			perror("(sockTrans2) erreur sur le send\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}


			err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans1) erreur sur le send\n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			if (coupBool == true && propCoup != CONT)
			{
			if(propCoup == GAGNE){scoreJ1PERTE++; scoreJ2GAGNE++;}
			if(propCoup == PERDU){scoreJ2PERTE++; scoreJ1GAGNE++;}
			if(propCoup == NUL){scoreJ1NUL++;scoreJ2NUL++;}
				numPartie++;

				break;
			}
			if ((coupBool == true && reqCoup.propCoup == CONT) || (!valid && reqCoup.propCoup == CONT))
			{
				printf("ENVOI COUP ADV\n");
				err = send(sockTrans1, &reqCoup, sizeof(TCoupReq), 0);
				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}
			}

			break;

		default:

			repCoup.err = ERR_TYP;
			err = send(sockTrans2, &repCoup, sizeof(TCodeRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans2) erreur sur le send\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}
			numPartie++;
			break;
		}
	}
		//Si le timeout est expiré erreur timeout ( selui la est le time out du joueur 2 fait au dexieme coup de la partie)
		if(retval == 0 && timeout ){
		   printf("Arbitre : fin attente coup pour ROUGE\nmain: le joueur avec ROUGE a depasse le temps\ntempsDepasse: debut pour joueur ROUGE\ntempsDepasse : envoi message au joueur ROUGE\ntempsDepasse : envoi message a l'adversaire BLEU\n");
		   repCoup.err = ERR_COUP;
		   repCoup.validCoup = TIMEOUT;
		   repCoup.propCoup = PERDU;
		   err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
	           err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
	           printf("Match perdu par joueur %s",nomJoueur2);
	           scoreJ2PERTE++;
		   scoreJ1GAGNE++;
		   numPartie++;
		   break;

		}
		}
		
		//Si le timeout est expiré erreur timeout ( selui la est le time out du joueur 1 fait au debut de la partie)
		if(retval == 0 && timeout){  //Quand retval est 0 ou inferieure, ça veut dire que le temps d'attente est fini
		 /*repondre le joueur par une reponse d'erreur et la validité est Timeouy */
		   repCoup.err = ERR_COUP;
		   repCoup.validCoup = TIMEOUT;
		   repCoup.propCoup = PERDU;
		   printf("Arbitre : fin attente coup pour BLEU\nmain: le joueur avec BLEU a depasse le temps\ntempsDepasse: debut pour joueur BLEU\ntempsDepasse : envoi message au joueur BLEU\ntempsDepasse : envoi message a l'adversaire ROUGE\n");
		   err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
	           err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
	           

		  printf("Match perdu par joueur %s\n",nomJoueur1);
		   numPartie++; /* le premier joueur est perdant, On passe à la prochaine partie*/
		   scoreJ1PERTE++;
		   scoreJ2GAGNE++;
		   break; 
		}
		}
	/*-------------- Fin Partie 1 -------------------------*/

	/*-------------- Debut Partie 2------------------------- */

	/*Les memes instructions comme la premier boucle, sauf qu'on recoit le coup du dexieme joueur en premier, apres le premier joueur en dexieme, */
	initialiserPartie();
	printf("PARTIE RETOUR\n");

	while (numPartie == 2)
	{

		if(timeout){
		FD_ZERO(&readSet2);
		FD_SET(sockTrans2, &readSet2);
		struct timeval tv3;
		tv3.tv_sec = TIME_MAX;
		tv3.tv_usec = 0;
		int retval = select(sockTrans2+1, &readSet2, NULL, NULL, &tv3);
		}
		if((retval > 0 && timeout )|| !timeout){
			err = recv(sockTrans2, &codeReq, sizeof(TIdReq), MSG_PEEK);
		if (err <= 0)
		{

			perror("(sockTrans2) erreur sur le recv\n");
			shutdown(sockTrans2, SHUT_RDWR);
			close(sockTrans2);
			return -5;
		}
		switch (codeReq)
		{
		case COUP:
			err = recv(sockTrans2, &reqCoup, sizeof(TCoupReq), 0);
			if (err <= 0)
			{

			perror("(sockTrans2) erreur sur le recv\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}
			printf("reception: recu COUP de ROUGE\nvalid pour le joueur 2 - ROUGE\n");
			bool coupBool = validationCoup(1, reqCoup, &propCoup);

			if (coupBool == false && reqCoup.propCoup == CONT && valid)
			{

				repCoup.err = ERR_COUP;
				repCoup.validCoup = TRICHE;
				repCoup.propCoup = PERDU;
				err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
			perror("(sockTrans2) erreur sur le send\n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}
				// envoie de la validité du coup au joueur 1
				err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}

		   		scoreJ2PERTE++;
		   		scoreJ1GAGNE++;
				numPartie++;
				break;
			}
			else
			{
			printf("reception : envoi validation - 0 estCoupValide 1\nrecoitCoup : validation du coup du joueur ROUGE = VALID\n");
				repCoup.err = ERR_OK;
				repCoup.validCoup = VALID;
				repCoup.propCoup = propCoup;
			}

			err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans2) erreur sur le send\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}
			// envoie de la validité du coup au joueur 1
			err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans1) erreur sur le send\n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}

			if (coupBool == true && propCoup != CONT)
			{
			if(propCoup == GAGNE){scoreJ1PERTE++; scoreJ2GAGNE++;}
			if(propCoup == PERDU){scoreJ2PERTE++; scoreJ1GAGNE++;}
			if(propCoup == NUL){scoreJ1NUL++;scoreJ2NUL++;}
				numPartie++;
				break;
			}
			if ((coupBool == true && reqCoup.propCoup == CONT) || (!valid && reqCoup.propCoup == CONT))
			{
				printf("ENVOI COUP ADV\n");
				err = send(sockTrans1, &reqCoup, sizeof(TCoupReq), 0);
				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}
			}
			break;

		default:

			repCoup.err = ERR_TYP;
			err = send(sockTrans2, &repCoup, sizeof(TCodeRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans2) erreur sur le send\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}
			break;
		}
		if (numPartie != 2)
		{
			break;
		}
		/*-------------- Recevoir le coup du joueur 1 ---------- */

		if(timeout){
		printf("main: attente du coup du joueur BLEU\n");
		FD_ZERO(&readSet2);
		FD_SET(sockTrans1, &readSet2);
		struct timeval tv4;
		tv4.tv_sec = TIME_MAX;
		tv4.tv_usec = 0;
		int retval = select(sockTrans1+1, &readSet2, NULL, NULL, &tv4);
		}
		if((retval > 0 && timeout )|| !timeout){
		err = recv(sockTrans1, &codeReq, sizeof(TIdReq), MSG_PEEK);

		if (err <= 0)
		{

			perror("(sockTrans1) erreur sur le recv\n");
			shutdown(sockTrans1, SHUT_RDWR);
			close(sockTrans1);
			return -5;
		}

		switch (codeReq)
		{
		case COUP:


			err = recv(sockTrans1, &reqCoup, sizeof(TCoupReq), 0);

			if (err <= 0)
			{

			perror("(sockTrans1) erreur sur le recv\n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			printf("reception: recu COUP de BLEU\nvalid pour le joueur 1 - BLEU\n");
			bool coupBool = validationCoup(2, reqCoup, &propCoup);

			if (coupBool == false && reqCoup.propCoup == CONT && valid)
			{

				repCoup.err = ERR_COUP;
				repCoup.validCoup = TRICHE;
				repCoup.propCoup = PERDU;

				err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);

				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans1, SHUT_RDWR);
					close(sockTrans1);
					return -5;
				}

				// envoie de la validité du coup au joueur 2

				err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
				if (err <= 0)
				{
			perror("(sockTrans1) erreur sur le send\n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}
				scoreJ1PERTE++;
		   		scoreJ2GAGNE++;

				numPartie++;
				break;
			}
			else
			{
			printf("reception : envoi validation - 0 estCoupValide 1\nrecoitCoup : validation du coup du joueur BLEU = VALID\n");
				repCoup.err = ERR_OK;
				repCoup.validCoup = VALID;
				repCoup.propCoup = propCoup;
			}

			err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);

			if (err <= 0)
			{
			perror("(sockTrans1) erreur sur le send\n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}

			// envoie de la validité du coup au joueur 2

			err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans2) erreur sur le send\n");
				shutdown(sockTrans2, SHUT_RDWR);
				close(sockTrans2);
				return -5;
			}
			if (coupBool == true && propCoup != CONT)
			{
			if(propCoup == GAGNE){scoreJ2PERTE++; scoreJ1GAGNE++;}
			if(propCoup == PERDU){scoreJ1PERTE++; scoreJ2GAGNE++;}
			if(propCoup == NUL){scoreJ1NUL++;scoreJ2NUL++;}
				numPartie++;
				break;
			}
			if ((coupBool == true && reqCoup.propCoup == CONT) || (!valid && reqCoup.propCoup == CONT))
			{
				printf("ENVOI COUP ADV\n");
				err = send(sockTrans2, &reqCoup, sizeof(TCoupReq), 0);
				if (err <= 0)
				{
			perror("(sockTrans2) erreur sur le send\n");
					shutdown(sockTrans2, SHUT_RDWR);
					close(sockTrans2);
					return -5;
				}
			}

			break;

		default:

			repCoup.err = ERR_TYP;
			err = send(sockTrans1, &repCoup, sizeof(TCodeRep), 0);
			if (err <= 0)
			{
			perror("(sockTrans1) erreur sur le send\n");
				shutdown(sockTrans1, SHUT_RDWR);
				close(sockTrans1);
				return -5;
			}
			numPartie++;

			break;
		}
		}
		
		if(retval == 0 && timeout){
		   repCoup.err = ERR_COUP;
		   repCoup.validCoup = TIMEOUT;
		   repCoup.propCoup = PERDU;
		   printf("Arbitre : fin attente coup pour ROUGE\nmain: le joueur avec ROUGE a depasse le temps\ntempsDepasse: debut pour joueur ROUGE\ntempsDepasse : envoi message au joueur ROUGE\ntempsDepasse : envoi message a l'adversaire BLEU\n");
		   err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
	           err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);
	           scoreJ1PERTE++;
		   scoreJ2GAGNE++;
		   numPartie++;
		   break;

		}
		}
		
		
		if(retval == 0 && timeout){
		   repCoup.err = ERR_COUP;
		   repCoup.validCoup = TIMEOUT;
		   repCoup.propCoup = PERDU;
		    printf("Arbitre : fin attente coup pour BLEU\nmain: le joueur avec BLEU a depasse le temps\ntempsDepasse: debut pour joueur BLEU\ntempsDepasse : envoi message au joueur BLEU\ntempsDepasse : envoi message a l'adversaire ROUGE\n");
		   err = send(sockTrans1, &repCoup, sizeof(TCoupRep), 0);
	           err = send(sockTrans2, &repCoup, sizeof(TCoupRep), 0);

		   scoreJ2PERTE++;
		   scoreJ1GAGNE++;
		   numPartie++;
		   break;

		}
		}
		

	

printf("Joueur %s - Matchs gagnes : %d / Matchs nuls : %d / Matchs perdus : %d\n",nomJoueur1,scoreJ1GAGNE,scoreJ1NUL,scoreJ1PERTE);
printf("Joueur %s - Matchs gagnes : %d / Matchs nuls : %d / Matchs perdus : %d\n",nomJoueur2,scoreJ2GAGNE,scoreJ2NUL,scoreJ2PERTE);


/*
* arret de la connexion et fermeture -- Tout a la fin du programme !
*/

	shutdown(sockTrans1, SHUT_RDWR);
	close(sockTrans1);
	shutdown(sockTrans2, SHUT_RDWR);
	close(sockTrans2);

	close(sockConx);

	return 0;
}
