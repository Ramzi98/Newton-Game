void affichage(int argc,char **argv, bool *timeout, bool *validation){


    char *time = "--noTimeout";
	char *valid = "--noValid";

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

	}