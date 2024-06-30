#include <stdio.h>
#include <string.h>

void sisd(int a, int b, int op, int& c) {

	#pragma HLS INTERFACE ap_ctrl_none port=return

	#pragma HLS INTERFACE s_axilite port=a
	#pragma HLS INTERFACE s_axilite port=b
	#pragma HLS INTERFACE s_axilite port=op

	#pragma HLS INTERFACE s_axilite port=c


	// ----- Doing chosen operation ----- //


	if(op == 0)

			c = a + b;

	else if (op== 1)

			c  = a - b;

	else if (op == 3)

			c  = a * b;

	else if (op == 2)

			c  = a / b;

}
