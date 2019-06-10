#include <stdio.h>
#include <stdlib.h>
#include "ohex.h"
#include "ohex_0.h"
#include "ohex_1.h"
#include "ohex_2.h"
#include "ohex_3.h"
#include "ohex_4.h"
#include "ohex_5.h"
#include "ohex_6.h"
#include "ohex_flag.h"
#include "ohex_À×.h"
#include "r0.h"
#include "r1.h"
#include "r2.h"
#include "r3.h"
#include "r4.h"
#include "r5.h"
#include "r6.h"
#include "r7.h"
#include "r8.h"
#include "r9.h"
#include "remaining.h"
int main() {
	FILE* fp = fopen("hex_ss.mif", "w");
	fprintf(fp, "DEPTH = 65536;\nWIDTH = 9;\naddress_radix = uns;\ndata_radix = bin;\nCONTENT BEGIN\n");
	int i, j, count = 0;
	for (i = 63; i >= 0; i --) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_0[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_0[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_0[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_0[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_0[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_0[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_0[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_0[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_0[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_1[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_1[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_1[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_1[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_1[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_1[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_1[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_1[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_1[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_2[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_2[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_2[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_2[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_2[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_2[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_2[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_2[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_2[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_3[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_3[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_3[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_3[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_3[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_3[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_3[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_3[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_3[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_4[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_4[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_4[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_4[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_4[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_4[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_4[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_4[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_4[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_5[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_5[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_5[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_5[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_5[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_5[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_5[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_5[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_5[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_6[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_6[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_6[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_6[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_6[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_6[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_6[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_6[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_6[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_flag[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_flag[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_flag[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_flag[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_flag[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_flag[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_flag[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_flag[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_flag[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (hex_lei[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (hex_lei[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (hex_lei[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (hex_lei[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (hex_lei[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (hex_lei[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (hex_lei[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (hex_lei[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (hex_lei[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 64; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (remaining[(i * 64 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (remaining[(i * 64 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (remaining[(i * 64 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (remaining[(i * 64 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (remaining[(i * 64 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (remaining[(i * 64 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (remaining[(i * 64 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (remaining[(i * 64 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (remaining[(i * 64 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r0[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r0[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r0[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r0[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r0[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r0[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r0[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r0[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r0[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r1[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r1[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r1[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r1[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r1[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r1[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r1[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r1[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r1[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r2[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r2[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r2[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r2[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r2[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r2[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r2[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r2[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r2[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r3[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r3[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r3[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r3[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r3[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r3[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r3[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r3[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r3[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r4[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r4[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r4[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r4[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r4[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r4[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r4[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r4[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r4[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r5[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r5[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r5[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r5[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r5[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r5[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r5[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r5[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r5[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r6[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r6[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r6[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r6[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r6[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r6[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r6[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r6[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r6[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r7[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r7[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r7[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r7[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r7[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r7[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r7[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r7[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r7[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r8[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r8[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r8[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r8[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r8[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r8[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r8[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r8[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r8[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	for (i = 63; i >= 0; i--) {
		for (j = 0; j < 32; j++) {
			char tmp[10];
			/*unsigned char tmp = ((test_pic_cut[i] >> 5) << 5) | ((test_pic_cut[i + 1] >> 6) << 3) || (test_pic_cut[i + 2] >> 5);*/
			tmp[8] = (r9[(i * 32 + j) * 3 + 54] >> 7) + '0';
			tmp[7] = (r9[(i * 32 + j) * 3 + 54] >> 6) % 2 + '0';
			tmp[6] = (r9[(i * 32 + j) * 3 + 54] >> 5) % 2 + '0';
			tmp[5] = (r9[(i * 32 + j) * 3 + 54 + 1] >> 7) + '0';
			tmp[4] = (r9[(i * 32 + j) * 3 + 54 + 1] >> 6) % 2 + '0';
			tmp[3] = (r9[(i * 32 + j) * 3 + 54 + 1] >> 5) % 2 + '0';
			tmp[2] = (r9[(i * 32 + j) * 3 + 54 + 2] >> 7) + '0';
			tmp[1] = (r9[(i * 32 + j) * 3 + 54 + 2] >> 6) % 2 + '0';
			tmp[0] = (r9[(i * 32 + j) * 3 + 54 + 2] >> 5) % 2 + '0';
			tmp[9] = '\0';
			fprintf(fp, "\t%d: %s;\n", count++, tmp);
		}
	}
	fprintf(fp, "END;");
	//fwrite(&test_pic_cut[54], sizeof(char), 12342 - 54, fp);

	fclose(fp);
	return 0;
}