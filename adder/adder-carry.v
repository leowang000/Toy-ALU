/* ACM Class System (I) Fall Assignment 1 
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
 
module adder_4 (
	input wire [3:0] a,
	input wire [3:0] b,
	input wire [3:0] G,
	input wire [3:0] P,
	input wire in_carry,
	output wire [3:0] sum,
	output wire out_carry
);
	wire [3:0] c;
	assign c[0] = in_carry;
	assign c[1] = G[0] | (P[0] & (in_carry));
	assign c[2] = G[1] | (P[1] & (G[0] | (P[0] & (in_carry))));
	assign c[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & (in_carry))))));
	assign out_carry = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & (in_carry))))))));
	assign sum = P ^ c;
endmodule

module adder_16 (
	input wire [15:0] a,
	input wire [15:0] b,
	input wire [15:0] G,
	input wire [15:0] P,
	input wire in_carry,
	output wire [15:0] sum,
	output wire out_carry
);
	wire [3:0] carry_result;
	adder_4 adder_4_0 (
		.a(a[3:0]),
		.b(b[3:0]),
		.G(G[3:0]),
		.P(P[3:0]),
		.in_carry(in_carry),
		.sum(sum[3:0]),
		.out_carry(carry_result[0])
	);
	adder_4 adder_4_1 (
		.a(a[7:4]),
		.b(b[7:4]),
		.G(G[7:4]),
		.P(P[7:4]),
		.in_carry(carry_result[0]),
		.sum(sum[7:4]),
		.out_carry(carry_result[1])
	);
	adder_4 adder_4_2 (
		.a(a[11:8]),
		.b(b[11:8]),
		.G(G[11:8]),
		.P(P[11:8]),
		.in_carry(carry_result[1]),
		.sum(sum[11:8]),
		.out_carry(carry_result[2])
	);
	adder_4 adder_4_3 (
		.a(a[15:12]),
		.b(b[15:12]),
		.G(G[15:12]),
		.P(P[15:12]),
		.in_carry(carry_result[2]),
		.sum(sum[15:12]),
		.out_carry(carry_result[3])
	);
	assign out_carry = carry_result[3];
endmodule

module Add(
	input wire [31:0] a,
	input wire [31:0] b,
	output wire [31:0] sum,
	output wire carry
);
	wire [31:0] G = a & b;
	wire [31:0] P = a ^ b;
	wire [1:0] carry_result;
	adder_16 adder_16_0 (
		.a(a[15:0]),
		.b(b[15:0]),
		.G(G[15:0]),
		.P(P[15:0]),
		.in_carry(1'b0),
		.sum(sum[15:0]),
		.out_carry(carry_result[0])
	);
	adder_16 adder16_1 (
		.a(a[31:16]),
		.b(b[31:16]),
		.G(G[31:16]),
		.P(P[31:16]),
		.in_carry(carry_result[0]),
		.sum(sum[31:16]),
		.out_carry(carry_result[1])
	);
	assign carry = carry_result[1];
endmodule