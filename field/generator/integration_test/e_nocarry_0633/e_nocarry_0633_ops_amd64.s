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
DATA q<>+0(SB)/8, $0xefcb4fd943e66d07
DATA q<>+8(SB)/8, $0xc7bd4d1e9a441db9
DATA q<>+16(SB)/8, $0x10e6014b3031ef1b
DATA q<>+24(SB)/8, $0x5b62a7e0bdd2795c
DATA q<>+32(SB)/8, $0x00af63ce23a9385f
DATA q<>+40(SB)/8, $0xd8c3bbb210e69ad0
DATA q<>+48(SB)/8, $0x14c6416821c2d98e
DATA q<>+56(SB)/8, $0x053e2d2fe9d965e6
DATA q<>+64(SB)/8, $0x06dcce047197fbc2
DATA q<>+72(SB)/8, $0x01b2c064c68c9bc2
GLOBL q<>(SB), (RODATA+NOPTR), $80

// qInv0 q'[0]
DATA qInv0<>(SB)/8, $0x3ef365fbbb7c8f49
GLOBL qInv0<>(SB), (RODATA+NOPTR), $8

#define REDUCE(ra0, ra1, ra2, ra3, ra4, ra5, ra6, ra7, ra8, ra9, rb0, rb1, rb2, rb3, rb4, rb5, rb6, rb7, rb8, rb9) \
	MOVQ    ra0, rb0;        \
	SUBQ    q<>(SB), ra0;    \
	MOVQ    ra1, rb1;        \
	SBBQ    q<>+8(SB), ra1;  \
	MOVQ    ra2, rb2;        \
	SBBQ    q<>+16(SB), ra2; \
	MOVQ    ra3, rb3;        \
	SBBQ    q<>+24(SB), ra3; \
	MOVQ    ra4, rb4;        \
	SBBQ    q<>+32(SB), ra4; \
	MOVQ    ra5, rb5;        \
	SBBQ    q<>+40(SB), ra5; \
	MOVQ    ra6, rb6;        \
	SBBQ    q<>+48(SB), ra6; \
	MOVQ    ra7, rb7;        \
	SBBQ    q<>+56(SB), ra7; \
	MOVQ    ra8, rb8;        \
	SBBQ    q<>+64(SB), ra8; \
	MOVQ    ra9, rb9;        \
	SBBQ    q<>+72(SB), ra9; \
	CMOVQCS rb0, ra0;        \
	CMOVQCS rb1, ra1;        \
	CMOVQCS rb2, ra2;        \
	CMOVQCS rb3, ra3;        \
	CMOVQCS rb4, ra4;        \
	CMOVQCS rb5, ra5;        \
	CMOVQCS rb6, ra6;        \
	CMOVQCS rb7, ra7;        \
	CMOVQCS rb8, ra8;        \
	CMOVQCS rb9, ra9;        \

// add(res, x, y *Element)
TEXT ·add(SB), $48-24
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

	// reduce element(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13) using temp registers (R14,R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP))
	REDUCE(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP))

	MOVQ res+0(FP), R14
	MOVQ CX, 0(R14)
	MOVQ BX, 8(R14)
	MOVQ SI, 16(R14)
	MOVQ DI, 24(R14)
	MOVQ R8, 32(R14)
	MOVQ R9, 40(R14)
	MOVQ R10, 48(R14)
	MOVQ R11, 56(R14)
	MOVQ R12, 64(R14)
	MOVQ R13, 72(R14)
	RET

// sub(res, x, y *Element)
TEXT ·sub(SB), NOSPLIT, $0-24
	MOVQ x+8(FP), R12
	MOVQ 0(R12), AX
	MOVQ 8(R12), DX
	MOVQ 16(R12), CX
	MOVQ 24(R12), BX
	MOVQ 32(R12), SI
	MOVQ 40(R12), DI
	MOVQ 48(R12), R8
	MOVQ 56(R12), R9
	MOVQ 64(R12), R10
	MOVQ 72(R12), R11
	MOVQ y+16(FP), R12
	SUBQ 0(R12), AX
	SBBQ 8(R12), DX
	SBBQ 16(R12), CX
	SBBQ 24(R12), BX
	SBBQ 32(R12), SI
	SBBQ 40(R12), DI
	SBBQ 48(R12), R8
	SBBQ 56(R12), R9
	SBBQ 64(R12), R10
	SBBQ 72(R12), R11
	JCC  l1
	MOVQ $0xefcb4fd943e66d07, R13
	ADDQ R13, AX
	MOVQ $0xc7bd4d1e9a441db9, R13
	ADCQ R13, DX
	MOVQ $0x10e6014b3031ef1b, R13
	ADCQ R13, CX
	MOVQ $0x5b62a7e0bdd2795c, R13
	ADCQ R13, BX
	MOVQ $0x00af63ce23a9385f, R13
	ADCQ R13, SI
	MOVQ $0xd8c3bbb210e69ad0, R13
	ADCQ R13, DI
	MOVQ $0x14c6416821c2d98e, R13
	ADCQ R13, R8
	MOVQ $0x053e2d2fe9d965e6, R13
	ADCQ R13, R9
	MOVQ $0x06dcce047197fbc2, R13
	ADCQ R13, R10
	MOVQ $0x01b2c064c68c9bc2, R13
	ADCQ R13, R11

l1:
	MOVQ res+0(FP), R14
	MOVQ AX, 0(R14)
	MOVQ DX, 8(R14)
	MOVQ CX, 16(R14)
	MOVQ BX, 24(R14)
	MOVQ SI, 32(R14)
	MOVQ DI, 40(R14)
	MOVQ R8, 48(R14)
	MOVQ R9, 56(R14)
	MOVQ R10, 64(R14)
	MOVQ R11, 72(R14)
	RET

// double(res, x *Element)
TEXT ·double(SB), $48-16
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP))

	MOVQ res+0(FP), R13
	MOVQ DX, 0(R13)
	MOVQ CX, 8(R13)
	MOVQ BX, 16(R13)
	MOVQ SI, 24(R13)
	MOVQ DI, 32(R13)
	MOVQ R8, 40(R13)
	MOVQ R9, 48(R13)
	MOVQ R10, 56(R13)
	MOVQ R11, 64(R13)
	MOVQ R12, 72(R13)
	RET

// neg(res, x *Element)
TEXT ·neg(SB), NOSPLIT, $0-16
	MOVQ  res+0(FP), R13
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
	TESTQ AX, AX
	JEQ   l2
	MOVQ  $0xefcb4fd943e66d07, R14
	SUBQ  DX, R14
	MOVQ  R14, 0(R13)
	MOVQ  $0xc7bd4d1e9a441db9, R14
	SBBQ  CX, R14
	MOVQ  R14, 8(R13)
	MOVQ  $0x10e6014b3031ef1b, R14
	SBBQ  BX, R14
	MOVQ  R14, 16(R13)
	MOVQ  $0x5b62a7e0bdd2795c, R14
	SBBQ  SI, R14
	MOVQ  R14, 24(R13)
	MOVQ  $0x00af63ce23a9385f, R14
	SBBQ  DI, R14
	MOVQ  R14, 32(R13)
	MOVQ  $0xd8c3bbb210e69ad0, R14
	SBBQ  R8, R14
	MOVQ  R14, 40(R13)
	MOVQ  $0x14c6416821c2d98e, R14
	SBBQ  R9, R14
	MOVQ  R14, 48(R13)
	MOVQ  $0x053e2d2fe9d965e6, R14
	SBBQ  R10, R14
	MOVQ  R14, 56(R13)
	MOVQ  $0x06dcce047197fbc2, R14
	SBBQ  R11, R14
	MOVQ  R14, 64(R13)
	MOVQ  $0x01b2c064c68c9bc2, R14
	SBBQ  R12, R14
	MOVQ  R14, 72(R13)
	RET

l2:
	MOVQ AX, 0(R13)
	MOVQ AX, 8(R13)
	MOVQ AX, 16(R13)
	MOVQ AX, 24(R13)
	MOVQ AX, 32(R13)
	MOVQ AX, 40(R13)
	MOVQ AX, 48(R13)
	MOVQ AX, 56(R13)
	MOVQ AX, 64(R13)
	MOVQ AX, 72(R13)
	RET

TEXT ·reduce(SB), $56-8
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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
	RET

// MulBy3(x *Element)
TEXT ·MulBy3(SB), $56-8
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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
	RET

// MulBy5(x *Element)
TEXT ·MulBy5(SB), $56-8
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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
	RET

// MulBy13(x *Element)
TEXT ·MulBy13(SB), $136-8
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP),s14-120(SP),s15-128(SP),s16-136(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP),s14-120(SP),s15-128(SP),s16-136(SP))

	MOVQ DX, s7-64(SP)
	MOVQ CX, s8-72(SP)
	MOVQ BX, s9-80(SP)
	MOVQ SI, s10-88(SP)
	MOVQ DI, s11-96(SP)
	MOVQ R8, s12-104(SP)
	MOVQ R9, s13-112(SP)
	MOVQ R10, s14-120(SP)
	MOVQ R11, s15-128(SP)
	MOVQ R12, s16-136(SP)
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

	ADDQ s7-64(SP), DX
	ADCQ s8-72(SP), CX
	ADCQ s9-80(SP), BX
	ADCQ s10-88(SP), SI
	ADCQ s11-96(SP), DI
	ADCQ s12-104(SP), R8
	ADCQ s13-112(SP), R9
	ADCQ s14-120(SP), R10
	ADCQ s15-128(SP), R11
	ADCQ s16-136(SP), R12

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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
	RET

// Butterfly(a, b *Element) sets a = a + b; b = a - b
TEXT ·Butterfly(SB), $56-16
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
	MOVQ DX, R13
	MOVQ CX, R14
	MOVQ BX, R15
	MOVQ SI, s0-8(SP)
	MOVQ DI, s1-16(SP)
	MOVQ R8, s2-24(SP)
	MOVQ R9, s3-32(SP)
	MOVQ R10, s4-40(SP)
	MOVQ R11, s5-48(SP)
	MOVQ R12, s6-56(SP)
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
	JCC  l3
	MOVQ $0xefcb4fd943e66d07, AX
	ADDQ AX, DX
	MOVQ $0xc7bd4d1e9a441db9, AX
	ADCQ AX, CX
	MOVQ $0x10e6014b3031ef1b, AX
	ADCQ AX, BX
	MOVQ $0x5b62a7e0bdd2795c, AX
	ADCQ AX, SI
	MOVQ $0x00af63ce23a9385f, AX
	ADCQ AX, DI
	MOVQ $0xd8c3bbb210e69ad0, AX
	ADCQ AX, R8
	MOVQ $0x14c6416821c2d98e, AX
	ADCQ AX, R9
	MOVQ $0x053e2d2fe9d965e6, AX
	ADCQ AX, R10
	MOVQ $0x06dcce047197fbc2, AX
	ADCQ AX, R11
	MOVQ $0x01b2c064c68c9bc2, AX
	ADCQ AX, R12

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
	MOVQ R13, DX
	MOVQ R14, CX
	MOVQ R15, BX
	MOVQ s0-8(SP), SI
	MOVQ s1-16(SP), DI
	MOVQ s2-24(SP), R8
	MOVQ s3-32(SP), R9
	MOVQ s4-40(SP), R10
	MOVQ s5-48(SP), R11
	MOVQ s6-56(SP), R12

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP))

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
	RET
