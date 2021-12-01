// Copyright 2020 ConsenSys Software Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "textflag.h"
#include "funcdata.h"

// modulus q
DATA q<>+0(SB)/8, $0xfb3cfa5bb4b2d8ab
DATA q<>+8(SB)/8, $0xd95ccc7565773445
DATA q<>+16(SB)/8, $0x259c48f62ab3075f
DATA q<>+24(SB)/8, $0x8314f7fdbd76cdf0
DATA q<>+32(SB)/8, $0x6cd232fc6f1b648d
DATA q<>+40(SB)/8, $0x3bfd473702eb530b
DATA q<>+48(SB)/8, $0x6e7791f41e2fc7ed
DATA q<>+56(SB)/8, $0xa4645b7c24bf10d0
DATA q<>+64(SB)/8, $0xef2591cce242801c
DATA q<>+72(SB)/8, $0x467245fb69b63a19
DATA q<>+80(SB)/8, $0x000000000006ddd0
GLOBL q<>(SB), (RODATA+NOPTR), $88

// qInv0 q'[0]
DATA qInv0<>(SB)/8, $0xe04e40a0931d9dfd
GLOBL qInv0<>(SB), (RODATA+NOPTR), $8

#define REDUCE(ra0, ra1, ra2, ra3, ra4, ra5, ra6, ra7, ra8, ra9, ra10, rb0, rb1, rb2, rb3, rb4, rb5, rb6, rb7, rb8, rb9, rb10) \
	MOVQ    ra0, rb0;         \
	SUBQ    q<>(SB), ra0;     \
	MOVQ    ra1, rb1;         \
	SBBQ    q<>+8(SB), ra1;   \
	MOVQ    ra2, rb2;         \
	SBBQ    q<>+16(SB), ra2;  \
	MOVQ    ra3, rb3;         \
	SBBQ    q<>+24(SB), ra3;  \
	MOVQ    ra4, rb4;         \
	SBBQ    q<>+32(SB), ra4;  \
	MOVQ    ra5, rb5;         \
	SBBQ    q<>+40(SB), ra5;  \
	MOVQ    ra6, rb6;         \
	SBBQ    q<>+48(SB), ra6;  \
	MOVQ    ra7, rb7;         \
	SBBQ    q<>+56(SB), ra7;  \
	MOVQ    ra8, rb8;         \
	SBBQ    q<>+64(SB), ra8;  \
	MOVQ    ra9, rb9;         \
	SBBQ    q<>+72(SB), ra9;  \
	MOVQ    ra10, rb10;       \
	SBBQ    q<>+80(SB), ra10; \
	CMOVQCS rb0, ra0;         \
	CMOVQCS rb1, ra1;         \
	CMOVQCS rb2, ra2;         \
	CMOVQCS rb3, ra3;         \
	CMOVQCS rb4, ra4;         \
	CMOVQCS rb5, ra5;         \
	CMOVQCS rb6, ra6;         \
	CMOVQCS rb7, ra7;         \
	CMOVQCS rb8, ra8;         \
	CMOVQCS rb9, ra9;         \
	CMOVQCS rb10, ra10;       \

// add(res, x, y *Element)
TEXT ·add(SB), $64-24
	MOVQ x+8(FP), AX
	MOVQ 0(AX), CX
	MOVQ 8(AX), BX
	MOVQ 16(AX), SI
	MOVQ 24(AX), DI
	MOVQ 32(AX), R8
	MOVQ 40(AX), R9
	MOVQ 48(AX), R10
	MOVQ 56(AX), R11
	MOVQ 64(AX), R12
	MOVQ 72(AX), R13
	MOVQ 80(AX), R14
	MOVQ y+16(FP), DX
	ADDQ 0(DX), CX
	ADCQ 8(DX), BX
	ADCQ 16(DX), SI
	ADCQ 24(DX), DI
	ADCQ 32(DX), R8
	ADCQ 40(DX), R9
	ADCQ 48(DX), R10
	ADCQ 56(DX), R11
	ADCQ 64(DX), R12
	ADCQ 72(DX), R13
	ADCQ 80(DX), R14

	// reduce element(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14) using temp registers (R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP))
	REDUCE(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP))

	MOVQ res+0(FP), R15
	MOVQ CX, 0(R15)
	MOVQ BX, 8(R15)
	MOVQ SI, 16(R15)
	MOVQ DI, 24(R15)
	MOVQ R8, 32(R15)
	MOVQ R9, 40(R15)
	MOVQ R10, 48(R15)
	MOVQ R11, 56(R15)
	MOVQ R12, 64(R15)
	MOVQ R13, 72(R15)
	MOVQ R14, 80(R15)
	RET

// sub(res, x, y *Element)
TEXT ·sub(SB), NOSPLIT, $0-24
	MOVQ x+8(FP), R13
	MOVQ 0(R13), AX
	MOVQ 8(R13), DX
	MOVQ 16(R13), CX
	MOVQ 24(R13), BX
	MOVQ 32(R13), SI
	MOVQ 40(R13), DI
	MOVQ 48(R13), R8
	MOVQ 56(R13), R9
	MOVQ 64(R13), R10
	MOVQ 72(R13), R11
	MOVQ 80(R13), R12
	MOVQ y+16(FP), R13
	SUBQ 0(R13), AX
	SBBQ 8(R13), DX
	SBBQ 16(R13), CX
	SBBQ 24(R13), BX
	SBBQ 32(R13), SI
	SBBQ 40(R13), DI
	SBBQ 48(R13), R8
	SBBQ 56(R13), R9
	SBBQ 64(R13), R10
	SBBQ 72(R13), R11
	SBBQ 80(R13), R12
	JCC  l1
	MOVQ $0xfb3cfa5bb4b2d8ab, R14
	ADDQ R14, AX
	MOVQ $0xd95ccc7565773445, R14
	ADCQ R14, DX
	MOVQ $0x259c48f62ab3075f, R14
	ADCQ R14, CX
	MOVQ $0x8314f7fdbd76cdf0, R14
	ADCQ R14, BX
	MOVQ $0x6cd232fc6f1b648d, R14
	ADCQ R14, SI
	MOVQ $0x3bfd473702eb530b, R14
	ADCQ R14, DI
	MOVQ $0x6e7791f41e2fc7ed, R14
	ADCQ R14, R8
	MOVQ $0xa4645b7c24bf10d0, R14
	ADCQ R14, R9
	MOVQ $0xef2591cce242801c, R14
	ADCQ R14, R10
	MOVQ $0x467245fb69b63a19, R14
	ADCQ R14, R11
	MOVQ $0x000000000006ddd0, R14
	ADCQ R14, R12

l1:
	MOVQ res+0(FP), R15
	MOVQ AX, 0(R15)
	MOVQ DX, 8(R15)
	MOVQ CX, 16(R15)
	MOVQ BX, 24(R15)
	MOVQ SI, 32(R15)
	MOVQ DI, 40(R15)
	MOVQ R8, 48(R15)
	MOVQ R9, 56(R15)
	MOVQ R10, 64(R15)
	MOVQ R11, 72(R15)
	MOVQ R12, 80(R15)
	RET

// double(res, x *Element)
TEXT ·double(SB), $64-16
	MOVQ x+8(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP))

	MOVQ res+0(FP), R14
	MOVQ DX, 0(R14)
	MOVQ CX, 8(R14)
	MOVQ BX, 16(R14)
	MOVQ SI, 24(R14)
	MOVQ DI, 32(R14)
	MOVQ R8, 40(R14)
	MOVQ R9, 48(R14)
	MOVQ R10, 56(R14)
	MOVQ R11, 64(R14)
	MOVQ R12, 72(R14)
	MOVQ R13, 80(R14)
	RET

// neg(res, x *Element)
TEXT ·neg(SB), NOSPLIT, $0-16
	MOVQ  res+0(FP), R14
	MOVQ  x+8(FP), AX
	MOVQ  0(AX), DX
	MOVQ  8(AX), CX
	MOVQ  16(AX), BX
	MOVQ  24(AX), SI
	MOVQ  32(AX), DI
	MOVQ  40(AX), R8
	MOVQ  48(AX), R9
	MOVQ  56(AX), R10
	MOVQ  64(AX), R11
	MOVQ  72(AX), R12
	MOVQ  80(AX), R13
	MOVQ  DX, AX
	ORQ   CX, AX
	ORQ   BX, AX
	ORQ   SI, AX
	ORQ   DI, AX
	ORQ   R8, AX
	ORQ   R9, AX
	ORQ   R10, AX
	ORQ   R11, AX
	ORQ   R12, AX
	ORQ   R13, AX
	TESTQ AX, AX
	JEQ   l2
	MOVQ  $0xfb3cfa5bb4b2d8ab, R15
	SUBQ  DX, R15
	MOVQ  R15, 0(R14)
	MOVQ  $0xd95ccc7565773445, R15
	SBBQ  CX, R15
	MOVQ  R15, 8(R14)
	MOVQ  $0x259c48f62ab3075f, R15
	SBBQ  BX, R15
	MOVQ  R15, 16(R14)
	MOVQ  $0x8314f7fdbd76cdf0, R15
	SBBQ  SI, R15
	MOVQ  R15, 24(R14)
	MOVQ  $0x6cd232fc6f1b648d, R15
	SBBQ  DI, R15
	MOVQ  R15, 32(R14)
	MOVQ  $0x3bfd473702eb530b, R15
	SBBQ  R8, R15
	MOVQ  R15, 40(R14)
	MOVQ  $0x6e7791f41e2fc7ed, R15
	SBBQ  R9, R15
	MOVQ  R15, 48(R14)
	MOVQ  $0xa4645b7c24bf10d0, R15
	SBBQ  R10, R15
	MOVQ  R15, 56(R14)
	MOVQ  $0xef2591cce242801c, R15
	SBBQ  R11, R15
	MOVQ  R15, 64(R14)
	MOVQ  $0x467245fb69b63a19, R15
	SBBQ  R12, R15
	MOVQ  R15, 72(R14)
	MOVQ  $0x000000000006ddd0, R15
	SBBQ  R13, R15
	MOVQ  R15, 80(R14)
	RET

l2:
	MOVQ AX, 0(R14)
	MOVQ AX, 8(R14)
	MOVQ AX, 16(R14)
	MOVQ AX, 24(R14)
	MOVQ AX, 32(R14)
	MOVQ AX, 40(R14)
	MOVQ AX, 48(R14)
	MOVQ AX, 56(R14)
	MOVQ AX, 64(R14)
	MOVQ AX, 72(R14)
	MOVQ AX, 80(R14)
	RET

TEXT ·reduce(SB), $72-8
	MOVQ res+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	RET

// MulBy3(x *Element)
TEXT ·MulBy3(SB), $72-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11
	ADCQ 72(AX), R12
	ADCQ 80(AX), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	RET

// MulBy5(x *Element)
TEXT ·MulBy5(SB), $72-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11
	ADCQ 72(AX), R12
	ADCQ 80(AX), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	RET

// MulBy13(x *Element)
TEXT ·MulBy13(SB), $160-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP),s14-120(SP),s15-128(SP),s16-136(SP),s17-144(SP),s18-152(SP),s19-160(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP),s14-120(SP),s15-128(SP),s16-136(SP),s17-144(SP),s18-152(SP),s19-160(SP))

	MOVQ DX, s9-80(SP)
	MOVQ CX, s10-88(SP)
	MOVQ BX, s11-96(SP)
	MOVQ SI, s12-104(SP)
	MOVQ DI, s13-112(SP)
	MOVQ R8, s14-120(SP)
	MOVQ R9, s15-128(SP)
	MOVQ R10, s16-136(SP)
	MOVQ R11, s17-144(SP)
	MOVQ R12, s18-152(SP)
	MOVQ R13, s19-160(SP)
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11
	ADCQ R12, R12
	ADCQ R13, R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ s9-80(SP), DX
	ADCQ s10-88(SP), CX
	ADCQ s11-96(SP), BX
	ADCQ s12-104(SP), SI
	ADCQ s13-112(SP), DI
	ADCQ s14-120(SP), R8
	ADCQ s15-128(SP), R9
	ADCQ s16-136(SP), R10
	ADCQ s17-144(SP), R11
	ADCQ s18-152(SP), R12
	ADCQ s19-160(SP), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11
	ADCQ 72(AX), R12
	ADCQ 80(AX), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	RET

// Butterfly(a, b *Element) sets a = a + b; b = a - b
TEXT ·Butterfly(SB), $72-16
	MOVQ b+8(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	MOVQ a+0(FP), AX
	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11
	ADCQ 72(AX), R12
	ADCQ 80(AX), R13
	MOVQ DX, R14
	MOVQ CX, R15
	MOVQ BX, s0-8(SP)
	MOVQ SI, s1-16(SP)
	MOVQ DI, s2-24(SP)
	MOVQ R8, s3-32(SP)
	MOVQ R9, s4-40(SP)
	MOVQ R10, s5-48(SP)
	MOVQ R11, s6-56(SP)
	MOVQ R12, s7-64(SP)
	MOVQ R13, s8-72(SP)
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
	MOVQ 72(AX), R12
	MOVQ 80(AX), R13
	MOVQ b+8(FP), AX
	SUBQ 0(AX), DX
	SBBQ 8(AX), CX
	SBBQ 16(AX), BX
	SBBQ 24(AX), SI
	SBBQ 32(AX), DI
	SBBQ 40(AX), R8
	SBBQ 48(AX), R9
	SBBQ 56(AX), R10
	SBBQ 64(AX), R11
	SBBQ 72(AX), R12
	SBBQ 80(AX), R13
	JCC  l3
	MOVQ $0xfb3cfa5bb4b2d8ab, AX
	ADDQ AX, DX
	MOVQ $0xd95ccc7565773445, AX
	ADCQ AX, CX
	MOVQ $0x259c48f62ab3075f, AX
	ADCQ AX, BX
	MOVQ $0x8314f7fdbd76cdf0, AX
	ADCQ AX, SI
	MOVQ $0x6cd232fc6f1b648d, AX
	ADCQ AX, DI
	MOVQ $0x3bfd473702eb530b, AX
	ADCQ AX, R8
	MOVQ $0x6e7791f41e2fc7ed, AX
	ADCQ AX, R9
	MOVQ $0xa4645b7c24bf10d0, AX
	ADCQ AX, R10
	MOVQ $0xef2591cce242801c, AX
	ADCQ AX, R11
	MOVQ $0x467245fb69b63a19, AX
	ADCQ AX, R12
	MOVQ $0x000000000006ddd0, AX
	ADCQ AX, R13

l3:
	MOVQ b+8(FP), AX
	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	MOVQ R14, DX
	MOVQ R15, CX
	MOVQ s0-8(SP), BX
	MOVQ s1-16(SP), SI
	MOVQ s2-24(SP), DI
	MOVQ s3-32(SP), R8
	MOVQ s4-40(SP), R9
	MOVQ s5-48(SP), R10
	MOVQ s6-56(SP), R11
	MOVQ s7-64(SP), R12
	MOVQ s8-72(SP), R13

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP))

	MOVQ a+0(FP), AX
	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	MOVQ R12, 72(AX)
	MOVQ R13, 80(AX)
	RET
