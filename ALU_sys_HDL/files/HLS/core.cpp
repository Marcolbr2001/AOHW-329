#include <stdio.h>
#include <string.h>
#include <ap_int.h>
#include <hls_stream.h>

#define DATA_LENGTH 400

void reset_FIFO_a(hls::stream<int>&data_a)
{
	clear_FIFO_a : while(!data_a.empty())
				{
					int x;
					x=data_a.read();
				}
}

void reset_FIFO_b(hls::stream<int>&data_b)
{
	clear_FIFO_b : while(!data_b.empty())
				{
					int x;
					x=data_b.read();
				}
}

void reset_ALU_operation(hls::stream<int>&ALU_operation)
{
	clear_ALU_op : while(!ALU_operation.empty())
				{
					int x;
					x=ALU_operation.read();
				}
}

void clear_RAM_op(int ALU_operation_MEM[])
{
	clear_RAM_op : for(int i = 0; i < DATA_LENGTH; i++)
			{
				ALU_operation_MEM[i] = 0;
			}
}

void reset(hls::stream<int>&data_a, hls::stream<int>&data_b, hls::stream<int>&ALU_operation, int ALU_operation_MEM[])
{

	reset_FIFO_a(data_a);
	reset_FIFO_b(data_b);
	reset_ALU_operation(ALU_operation);
	clear_RAM_op(ALU_operation_MEM);

}


void load_data_a(volatile int a[], hls::stream<int>&data_a)
{
	l_data_a: for(int i = 0; i < DATA_LENGTH; i++)
	{
		#pragma HLS  PIPELINE II=1

		int tmp_a = a[i];
		data_a.write(tmp_a);
	}
}

void load_data_b(volatile int b[], hls::stream<int>&data_b)
{
	l_data_b: for(int i = 0; i < DATA_LENGTH; i++)
	{
		#pragma HLS  PIPELINE II=1

		int tmp_b = b[i];
		data_b.write(tmp_b);

	}
}


void load_op(volatile int op[], hls::stream<int>&ALU_operation)
{

	l_operation: for(int i = 0; i < DATA_LENGTH; i++)
	{
		#pragma HLS  PIPELINE II=1

		int tmp_op = op[i];
		ALU_operation.write(tmp_op);
	}
}


void store_op(hls::stream<int>&ALU_operation, int ALU_operation_MEM[])
{

	s_operation_data_op: for(int i = 0; i < DATA_LENGTH; i++)
	{
		#pragma HLS  PIPELINE II=1

		ALU_operation_MEM[i] = ALU_operation.read();

	}
}


void operation(volatile int op[], hls::stream<int>&ALU_operation,int ALU_operation_MEM[])
{
	load_op(op, ALU_operation);
	store_op(ALU_operation, ALU_operation_MEM);
}




void load_data_and_op(volatile int a[], volatile int b[],volatile int op[], hls::stream<int>&data_a, hls::stream<int>&data_b, hls::stream<int>&ALU_operation)
{

	#pragma HLS INLINE

	load_op(op, ALU_operation);
	load_data_a(a, data_a);
	load_data_b(b, data_b);

}

void execute(hls::stream<int>&data_a,hls::stream<int>&data_b, int ALU_operation_MEM[], hls::stream<int>&data_result)
{
	// ----- Doing chosen operation ----- //
	exe: for(int i=0; i < DATA_LENGTH; i++)
	{
		#pragma HLS PIPELINE II=1

		int a,b;

		a=data_a.read();
		b=data_b.read();

		switch(ALU_operation_MEM[i])
		{

			case 0 : // sum
				data_result.write(a + b);
			break;

			case 1 : // difference
				data_result.write(a - b);
			break;

			case 2 : // division
				data_result.write(a/b);

			break;

			case 3 : // multiplication
				data_result.write(a*b);
			break;

			/* any other no-operation number  */
			default :
				data_result.write(0);

		}
	}
}

void write_back(hls::stream<int>&data_result, volatile int c[])
{
	write_back: for(int i = 0; i < DATA_LENGTH; i++)
	{
		#pragma HLS  PIPELINE II=1
		c[i] = data_result.read();
	}

}


void data_exe_wb(volatile int a[],volatile int b[], hls::stream<int>&data_a,hls::stream<int>&data_b, int ALU_operation_MEM[], hls::stream<int>&data_result, volatile int c[])
{
		load_data_a(a, data_a);
		load_data_b(b, data_b);
		execute(data_a, data_b, ALU_operation_MEM, data_result);
		write_back(data_result, c);
}

void op_data_exe_wb(volatile int a[],volatile  int b[],volatile int op[],hls::stream<int>&data_a,hls::stream<int>&data_b, hls::stream<int>&ALU_operation ,int ALU_operation_MEM[], hls::stream<int>&data_result,volatile int c[])
{
		load_data_and_op(a, b, op, data_a, data_b, ALU_operation);
		store_op(ALU_operation,ALU_operation_MEM);
		execute(data_a, data_b, ALU_operation_MEM, data_result);
		write_back(data_result, c);
}

void ALU_sys_HDL(volatile int* a,volatile  int* b, volatile int* c,volatile int* op, int selec) {

	#pragma HLS INTERFACE mode=s_axilite bundle=control port=a
	#pragma HLS INTERFACE mode=s_axilite bundle=control port=b
	#pragma HLS INTERFACE mode=s_axilite bundle=control port=c
	#pragma HLS INTERFACE mode=s_axilite bundle=control port=op
	#pragma HLS INTERFACE mode=s_axilite bundle=control port=selec

	#pragma HLS INTERFACE mode=s_axilite bundle=control port=return

	#pragma HLS INTERFACE mode=m_axi port=a bundle=gmem0 depth=DATA_LENGTH offset=slave
	#pragma HLS INTERFACE mode=m_axi port=b bundle=gmem1 depth=DATA_LENGTH offset=slave
	#pragma HLS INTERFACE mode=m_axi port=c bundle=gmem2 depth=DATA_LENGTH offset=slave
	#pragma HLS INTERFACE mode=m_axi port=op bundle=gmem3 depth=DATA_LENGTH offset=slave

	static hls::stream<int> data_a("data_a");
	#pragma HLS STREAM variable=data_a depth=DATA_LENGTH
	//first operand

	static hls::stream<int> data_b("data_b");
	#pragma HLS STREAM variable=data_b depth=DATA_LENGTH
	 //second operand

	static hls::stream<int> data_result("data_result");
	#pragma HLS STREAM variable=data_result depth=DATA_LENGTH
	 //result

	static hls::stream<int> ALU_operation("ALU_operation");
	#pragma HLS STREAM variable=ALU_operation depth=DATA_LENGTH
	 //operation

	static int ALU_operation_MEM[DATA_LENGTH] = {0};
	int data_result_MEM[DATA_LENGTH] = {0};

	#pragma HLS DATAFLOW

	switch(selec)
	{

		case 0: //LOAD PATTERN

			operation(op, ALU_operation, ALU_operation_MEM);

		break;

		case 1: //LOAD DATA, EXECUTE, WB

			data_exe_wb(a, b, data_a, data_b, ALU_operation_MEM, data_result, c);

		break;

		case 2: //LOAD PATTERN, DATA, EXECUTE, WB

			op_data_exe_wb(a, b, op ,data_a, data_b, ALU_operation,ALU_operation_MEM, data_result, c);

		break;

		default :

			reset(data_a, data_b, ALU_operation, ALU_operation_MEM);

	}



}
