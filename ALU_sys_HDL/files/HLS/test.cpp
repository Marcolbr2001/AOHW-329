
#include <stdio.h>

#define DATA_LENGTH 400

void ALU_sys_HDL(volatile int* a, volatile int* b, volatile int* c, volatile int* op, volatile int selec);

int main() {


    int DATA_A[DATA_LENGTH];
	int DATA_B[DATA_LENGTH];
	int DATA_RESULT[DATA_LENGTH];
	int ALU_OPERATION[DATA_LENGTH];
	int SELEC;

    printf("\n\n");

    ////////CASE SELEC=10: DEFAULT RESET////////////////////////////////////////////

    // Put data into variables
    for (int i = 0; i < DATA_LENGTH; i++)
    {
    	DATA_A[i] = 1;
    	DATA_B[i] = 1;
    	DATA_RESULT[i] = 0;
	}

    // selecting operations
    for (int i = 0; i < DATA_LENGTH; i++)
	{
		ALU_OPERATION[i] = 1;
	}

	// selecting inputs

	SELEC=10;

	ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION, SELEC);

    //print results
    for (int i = 0; i < DATA_LENGTH; i++)
	{
    	printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
    }
    printf("\n\n");
    // ----------------------------------------- //



	////////NEW PATTERN////////////////////////////////////////////
	for (int i = 0; i < DATA_LENGTH; i++)
	{
		ALU_OPERATION[i] = 1;
	}

	SELEC=0;

	ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION, SELEC);


	for (int i = 0; i < DATA_LENGTH; i++)
	{
		printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
	}
	printf("\n\n");

	////////NEW DATA_AND_EXECUTE////////////////////////////////////////////


	// Put data into variables
	for (int i = 0; i < DATA_LENGTH; i++)
	{
		DATA_A[i] = 2;
		DATA_B[i] = 3;
	}

	// selecting operations //IT WILL BE IGNORED
	for (int i = 0; i < DATA_LENGTH; i++)
	{
		ALU_OPERATION[i] = 10;
	}

	SELEC=1;
	ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION,SELEC);


	for (int i = 0; i < DATA_LENGTH; i++)
	{
		printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
	}
	printf("\n\n");

	////////NEW PATTERN AND OP////////////////////////////////////////////

	// Put data into variables
	for (int i = 0; i < DATA_LENGTH; i++)
	{
		DATA_A[i] = 45;
		DATA_B[i] = 45;
	}

	// selecting operations
	for (int i = 0; i < DATA_LENGTH; i++)
	{
		ALU_OPERATION[i] = 0;
	}

	SELEC=2;

	ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION,SELEC);


	for (int i = 0; i < DATA_LENGTH; i++)
	{
		printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
	}
	printf("\n\n");

	// selecting operations
		for (int i = 0; i < DATA_LENGTH; i++)
		{
			ALU_OPERATION[i] = 1;
		}

		SELEC=2;

		ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION,SELEC);


		for (int i = 0; i < DATA_LENGTH; i++)
		{
			printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
		}
		printf("\n\n");

		// selecting operations
			for (int i = 0; i < DATA_LENGTH; i++)
			{
				ALU_OPERATION[i] = 2;
			}

			SELEC=2;

			ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION,SELEC);


			for (int i = 0; i < DATA_LENGTH; i++)
			{
				printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
			}
			printf("\n\n");

			// selecting operations
				for (int i = 0; i < DATA_LENGTH; i++)
				{
					ALU_OPERATION[i] = 3;
				}

				SELEC=2;

				ALU_sys_HDL(DATA_A, DATA_B, DATA_RESULT, ALU_OPERATION,SELEC);


				for (int i = 0; i < DATA_LENGTH; i++)
				{
					printf("A = %d B = %d RES = %d, OP = %d, SELEC = %d \n", DATA_A[i], DATA_B[i], DATA_RESULT[i], ALU_OPERATION[i], SELEC);
				}
				printf("\n\n");

    return 0;
}

