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
DATA q<>+0(SB)/8, $0xcf1da9ee30eaf5bf
DATA q<>+8(SB)/8, $0xcee0f84b2b51619b
DATA q<>+16(SB)/8, $0x1d12a98a5e689081
DATA q<>+24(SB)/8, $0x0620331fa32e4f9a
DATA q<>+32(SB)/8, $0xd4a36fa098c20708
DATA q<>+40(SB)/8, $0x2c5f874d88a773ff
DATA q<>+48(SB)/8, $0x1556225b59399c2d
DATA q<>+56(SB)/8, $0x141bcc9c7dee9b38
DATA q<>+64(SB)/8, $0x0000000000000031
GLOBL q<>(SB), (RODATA+NOPTR), $72

// qInv0 q'[0]
DATA qInv0<>(SB)/8, $0xbfa9cf791bf005c1
GLOBL qInv0<>(SB), (RODATA+NOPTR), $8

#define REDUCE(ra0, ra1, ra2, ra3, ra4, ra5, ra6, ra7, ra8, rb0, rb1, rb2, rb3, rb4, rb5, rb6, rb7, rb8) \
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
	CMOVQCS rb0, ra0;        \
	CMOVQCS rb1, ra1;        \
	CMOVQCS rb2, ra2;        \
	CMOVQCS rb3, ra3;        \
	CMOVQCS rb4, ra4;        \
	CMOVQCS rb5, ra5;        \
	CMOVQCS rb6, ra6;        \
	CMOVQCS rb7, ra7;        \
	CMOVQCS rb8, ra8;        \

// add(res, x, y *Element)
TEXT ·add(SB), $32-24
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

	// reduce element(CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP))
	REDUCE(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP))

	MOVQ res+0(FP), R13
	MOVQ CX, 0(R13)
	MOVQ BX, 8(R13)
	MOVQ SI, 16(R13)
	MOVQ DI, 24(R13)
	MOVQ R8, 32(R13)
	MOVQ R9, 40(R13)
	MOVQ R10, 48(R13)
	MOVQ R11, 56(R13)
	MOVQ R12, 64(R13)
	RET

// sub(res, x, y *Element)
TEXT ·sub(SB), NOSPLIT, $0-24
	MOVQ x+8(FP), R11
	MOVQ 0(R11), AX
	MOVQ 8(R11), DX
	MOVQ 16(R11), CX
	MOVQ 24(R11), BX
	MOVQ 32(R11), SI
	MOVQ 40(R11), DI
	MOVQ 48(R11), R8
	MOVQ 56(R11), R9
	MOVQ 64(R11), R10
	MOVQ y+16(FP), R11
	SUBQ 0(R11), AX
	SBBQ 8(R11), DX
	SBBQ 16(R11), CX
	SBBQ 24(R11), BX
	SBBQ 32(R11), SI
	SBBQ 40(R11), DI
	SBBQ 48(R11), R8
	SBBQ 56(R11), R9
	SBBQ 64(R11), R10
	JCC  l1
	MOVQ $0xcf1da9ee30eaf5bf, R12
	ADDQ R12, AX
	MOVQ $0xcee0f84b2b51619b, R12
	ADCQ R12, DX
	MOVQ $0x1d12a98a5e689081, R12
	ADCQ R12, CX
	MOVQ $0x0620331fa32e4f9a, R12
	ADCQ R12, BX
	MOVQ $0xd4a36fa098c20708, R12
	ADCQ R12, SI
	MOVQ $0x2c5f874d88a773ff, R12
	ADCQ R12, DI
	MOVQ $0x1556225b59399c2d, R12
	ADCQ R12, R8
	MOVQ $0x141bcc9c7dee9b38, R12
	ADCQ R12, R9
	MOVQ $0x0000000000000031, R12
	ADCQ R12, R10

l1:
	MOVQ res+0(FP), R13
	MOVQ AX, 0(R13)
	MOVQ DX, 8(R13)
	MOVQ CX, 16(R13)
	MOVQ BX, 24(R13)
	MOVQ SI, 32(R13)
	MOVQ DI, 40(R13)
	MOVQ R8, 48(R13)
	MOVQ R9, 56(R13)
	MOVQ R10, 64(R13)
	RET

// double(res, x *Element)
TEXT ·double(SB), $32-16
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
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP))

	MOVQ res+0(FP), R12
	MOVQ DX, 0(R12)
	MOVQ CX, 8(R12)
	MOVQ BX, 16(R12)
	MOVQ SI, 24(R12)
	MOVQ DI, 32(R12)
	MOVQ R8, 40(R12)
	MOVQ R9, 48(R12)
	MOVQ R10, 56(R12)
	MOVQ R11, 64(R12)
	RET

// neg(res, x *Element)
TEXT ·neg(SB), NOSPLIT, $0-16
	MOVQ  res+0(FP), R12
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
	MOVQ  DX, AX
	ORQ   CX, AX
	ORQ   BX, AX
	ORQ   SI, AX
	ORQ   DI, AX
	ORQ   R8, AX
	ORQ   R9, AX
	ORQ   R10, AX
	ORQ   R11, AX
	TESTQ AX, AX
	JEQ   l2
	MOVQ  $0xcf1da9ee30eaf5bf, R13
	SUBQ  DX, R13
	MOVQ  R13, 0(R12)
	MOVQ  $0xcee0f84b2b51619b, R13
	SBBQ  CX, R13
	MOVQ  R13, 8(R12)
	MOVQ  $0x1d12a98a5e689081, R13
	SBBQ  BX, R13
	MOVQ  R13, 16(R12)
	MOVQ  $0x0620331fa32e4f9a, R13
	SBBQ  SI, R13
	MOVQ  R13, 24(R12)
	MOVQ  $0xd4a36fa098c20708, R13
	SBBQ  DI, R13
	MOVQ  R13, 32(R12)
	MOVQ  $0x2c5f874d88a773ff, R13
	SBBQ  R8, R13
	MOVQ  R13, 40(R12)
	MOVQ  $0x1556225b59399c2d, R13
	SBBQ  R9, R13
	MOVQ  R13, 48(R12)
	MOVQ  $0x141bcc9c7dee9b38, R13
	SBBQ  R10, R13
	MOVQ  R13, 56(R12)
	MOVQ  $0x0000000000000031, R13
	SBBQ  R11, R13
	MOVQ  R13, 64(R12)
	RET

l2:
	MOVQ AX, 0(R12)
	MOVQ AX, 8(R12)
	MOVQ AX, 16(R12)
	MOVQ AX, 24(R12)
	MOVQ AX, 32(R12)
	MOVQ AX, 40(R12)
	MOVQ AX, 48(R12)
	MOVQ AX, 56(R12)
	MOVQ AX, 64(R12)
	RET

TEXT ·reduce(SB), $40-8
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

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	RET

// MulBy3(x *Element)
TEXT ·MulBy3(SB), $40-8
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
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	RET

// MulBy5(x *Element)
TEXT ·MulBy5(SB), $40-8
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
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	RET

// MulBy13(x *Element)
TEXT ·MulBy13(SB), $112-8
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
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP),s11-96(SP),s12-104(SP),s13-112(SP))

	MOVQ DX, s5-48(SP)
	MOVQ CX, s6-56(SP)
	MOVQ BX, s7-64(SP)
	MOVQ SI, s8-72(SP)
	MOVQ DI, s9-80(SP)
	MOVQ R8, s10-88(SP)
	MOVQ R9, s11-96(SP)
	MOVQ R10, s12-104(SP)
	MOVQ R11, s13-112(SP)
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10
	ADCQ R11, R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ s5-48(SP), DX
	ADCQ s6-56(SP), CX
	ADCQ s7-64(SP), BX
	ADCQ s8-72(SP), SI
	ADCQ s9-80(SP), DI
	ADCQ s10-88(SP), R8
	ADCQ s11-96(SP), R9
	ADCQ s12-104(SP), R10
	ADCQ s13-112(SP), R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	ADCQ 64(AX), R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	MOVQ R11, 64(AX)
	RET

// Butterfly(a, b *Element) sets a = a + b; b = a - b
TEXT ·Butterfly(SB), $40-16
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
	MOVQ DX, R12
	MOVQ CX, R13
	MOVQ BX, R14
	MOVQ SI, R15
	MOVQ DI, s0-8(SP)
	MOVQ R8, s1-16(SP)
	MOVQ R9, s2-24(SP)
	MOVQ R10, s3-32(SP)
	MOVQ R11, s4-40(SP)
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ 64(AX), R11
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
	JCC  l3
	MOVQ $0xcf1da9ee30eaf5bf, AX
	ADDQ AX, DX
	MOVQ $0xcee0f84b2b51619b, AX
	ADCQ AX, CX
	MOVQ $0x1d12a98a5e689081, AX
	ADCQ AX, BX
	MOVQ $0x0620331fa32e4f9a, AX
	ADCQ AX, SI
	MOVQ $0xd4a36fa098c20708, AX
	ADCQ AX, DI
	MOVQ $0x2c5f874d88a773ff, AX
	ADCQ AX, R8
	MOVQ $0x1556225b59399c2d, AX
	ADCQ AX, R9
	MOVQ $0x141bcc9c7dee9b38, AX
	ADCQ AX, R10
	MOVQ $0x0000000000000031, AX
	ADCQ AX, R11

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
	MOVQ R12, DX
	MOVQ R13, CX
	MOVQ R14, BX
	MOVQ R15, SI
	MOVQ s0-8(SP), DI
	MOVQ s1-16(SP), R8
	MOVQ s2-24(SP), R9
	MOVQ s3-32(SP), R10
	MOVQ s4-40(SP), R11

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP))

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
	RET
