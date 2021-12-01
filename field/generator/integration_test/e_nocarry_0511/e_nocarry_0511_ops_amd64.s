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
DATA q<>+0(SB)/8, $0xc6b574bfe8f2212d
DATA q<>+8(SB)/8, $0xf45cc913001fe46c
DATA q<>+16(SB)/8, $0xf7215bc284ff4791
DATA q<>+24(SB)/8, $0x3254ae3d2c2886a5
DATA q<>+32(SB)/8, $0xc87da10b62c3d43a
DATA q<>+40(SB)/8, $0x300ec89392afb247
DATA q<>+48(SB)/8, $0xed0c0bf80ad360bf
DATA q<>+56(SB)/8, $0x6dfb68e3a2fa56b3
GLOBL q<>(SB), (RODATA+NOPTR), $64

// qInv0 q'[0]
DATA qInv0<>(SB)/8, $0xe9dba7afcbd6295b
GLOBL qInv0<>(SB), (RODATA+NOPTR), $8

#define REDUCE(ra0, ra1, ra2, ra3, ra4, ra5, ra6, ra7, rb0, rb1, rb2, rb3, rb4, rb5, rb6, rb7) \
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
	CMOVQCS rb0, ra0;        \
	CMOVQCS rb1, ra1;        \
	CMOVQCS rb2, ra2;        \
	CMOVQCS rb3, ra3;        \
	CMOVQCS rb4, ra4;        \
	CMOVQCS rb5, ra5;        \
	CMOVQCS rb6, ra6;        \
	CMOVQCS rb7, ra7;        \

// add(res, x, y *Element)
TEXT ·add(SB), $16-24
	MOVQ x+8(FP), AX
	MOVQ 0(AX), CX
	MOVQ 8(AX), BX
	MOVQ 16(AX), SI
	MOVQ 24(AX), DI
	MOVQ 32(AX), R8
	MOVQ 40(AX), R9
	MOVQ 48(AX), R10
	MOVQ 56(AX), R11
	MOVQ y+16(FP), DX
	ADDQ 0(DX), CX
	ADCQ 8(DX), BX
	ADCQ 16(DX), SI
	ADCQ 24(DX), DI
	ADCQ 32(DX), R8
	ADCQ 40(DX), R9
	ADCQ 48(DX), R10
	ADCQ 56(DX), R11

	// reduce element(CX,BX,SI,DI,R8,R9,R10,R11) using temp registers (R12,R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP))
	REDUCE(CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,DX,s0-8(SP),s1-16(SP))

	MOVQ res+0(FP), R12
	MOVQ CX, 0(R12)
	MOVQ BX, 8(R12)
	MOVQ SI, 16(R12)
	MOVQ DI, 24(R12)
	MOVQ R8, 32(R12)
	MOVQ R9, 40(R12)
	MOVQ R10, 48(R12)
	MOVQ R11, 56(R12)
	RET

// sub(res, x, y *Element)
TEXT ·sub(SB), NOSPLIT, $0-24
	MOVQ x+8(FP), R10
	MOVQ 0(R10), AX
	MOVQ 8(R10), DX
	MOVQ 16(R10), CX
	MOVQ 24(R10), BX
	MOVQ 32(R10), SI
	MOVQ 40(R10), DI
	MOVQ 48(R10), R8
	MOVQ 56(R10), R9
	MOVQ y+16(FP), R10
	SUBQ 0(R10), AX
	SBBQ 8(R10), DX
	SBBQ 16(R10), CX
	SBBQ 24(R10), BX
	SBBQ 32(R10), SI
	SBBQ 40(R10), DI
	SBBQ 48(R10), R8
	SBBQ 56(R10), R9
	JCC  l1
	MOVQ $0xc6b574bfe8f2212d, R11
	ADDQ R11, AX
	MOVQ $0xf45cc913001fe46c, R11
	ADCQ R11, DX
	MOVQ $0xf7215bc284ff4791, R11
	ADCQ R11, CX
	MOVQ $0x3254ae3d2c2886a5, R11
	ADCQ R11, BX
	MOVQ $0xc87da10b62c3d43a, R11
	ADCQ R11, SI
	MOVQ $0x300ec89392afb247, R11
	ADCQ R11, DI
	MOVQ $0xed0c0bf80ad360bf, R11
	ADCQ R11, R8
	MOVQ $0x6dfb68e3a2fa56b3, R11
	ADCQ R11, R9

l1:
	MOVQ res+0(FP), R12
	MOVQ AX, 0(R12)
	MOVQ DX, 8(R12)
	MOVQ CX, 16(R12)
	MOVQ BX, 24(R12)
	MOVQ SI, 32(R12)
	MOVQ DI, 40(R12)
	MOVQ R8, 48(R12)
	MOVQ R9, 56(R12)
	RET

// double(res, x *Element)
TEXT ·double(SB), $16-16
	MOVQ x+8(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,AX,s0-8(SP),s1-16(SP))

	MOVQ res+0(FP), R11
	MOVQ DX, 0(R11)
	MOVQ CX, 8(R11)
	MOVQ BX, 16(R11)
	MOVQ SI, 24(R11)
	MOVQ DI, 32(R11)
	MOVQ R8, 40(R11)
	MOVQ R9, 48(R11)
	MOVQ R10, 56(R11)
	RET

// neg(res, x *Element)
TEXT ·neg(SB), NOSPLIT, $0-16
	MOVQ  res+0(FP), R11
	MOVQ  x+8(FP), AX
	MOVQ  0(AX), DX
	MOVQ  8(AX), CX
	MOVQ  16(AX), BX
	MOVQ  24(AX), SI
	MOVQ  32(AX), DI
	MOVQ  40(AX), R8
	MOVQ  48(AX), R9
	MOVQ  56(AX), R10
	MOVQ  DX, AX
	ORQ   CX, AX
	ORQ   BX, AX
	ORQ   SI, AX
	ORQ   DI, AX
	ORQ   R8, AX
	ORQ   R9, AX
	ORQ   R10, AX
	TESTQ AX, AX
	JEQ   l2
	MOVQ  $0xc6b574bfe8f2212d, R12
	SUBQ  DX, R12
	MOVQ  R12, 0(R11)
	MOVQ  $0xf45cc913001fe46c, R12
	SBBQ  CX, R12
	MOVQ  R12, 8(R11)
	MOVQ  $0xf7215bc284ff4791, R12
	SBBQ  BX, R12
	MOVQ  R12, 16(R11)
	MOVQ  $0x3254ae3d2c2886a5, R12
	SBBQ  SI, R12
	MOVQ  R12, 24(R11)
	MOVQ  $0xc87da10b62c3d43a, R12
	SBBQ  DI, R12
	MOVQ  R12, 32(R11)
	MOVQ  $0x300ec89392afb247, R12
	SBBQ  R8, R12
	MOVQ  R12, 40(R11)
	MOVQ  $0xed0c0bf80ad360bf, R12
	SBBQ  R9, R12
	MOVQ  R12, 48(R11)
	MOVQ  $0x6dfb68e3a2fa56b3, R12
	SBBQ  R10, R12
	MOVQ  R12, 56(R11)
	RET

l2:
	MOVQ AX, 0(R11)
	MOVQ AX, 8(R11)
	MOVQ AX, 16(R11)
	MOVQ AX, 24(R11)
	MOVQ AX, 32(R11)
	MOVQ AX, 40(R11)
	MOVQ AX, 48(R11)
	MOVQ AX, 56(R11)
	RET

TEXT ·reduce(SB), $24-8
	MOVQ res+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	RET

// MulBy3(x *Element)
TEXT ·MulBy3(SB), $24-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	RET

// MulBy5(x *Element)
TEXT ·MulBy5(SB), $24-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	RET

// MulBy13(x *Element)
TEXT ·MulBy13(SB), $88-8
	MOVQ x+0(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP),s10-88(SP))

	MOVQ DX, s3-32(SP)
	MOVQ CX, s4-40(SP)
	MOVQ BX, s5-48(SP)
	MOVQ SI, s6-56(SP)
	MOVQ DI, s7-64(SP)
	MOVQ R8, s8-72(SP)
	MOVQ R9, s9-80(SP)
	MOVQ R10, s10-88(SP)
	ADDQ DX, DX
	ADCQ CX, CX
	ADCQ BX, BX
	ADCQ SI, SI
	ADCQ DI, DI
	ADCQ R8, R8
	ADCQ R9, R9
	ADCQ R10, R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ s3-32(SP), DX
	ADCQ s4-40(SP), CX
	ADCQ s5-48(SP), BX
	ADCQ s6-56(SP), SI
	ADCQ s7-64(SP), DI
	ADCQ s8-72(SP), R8
	ADCQ s9-80(SP), R9
	ADCQ s10-88(SP), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	RET

// Butterfly(a, b *Element) sets a = a + b; b = a - b
TEXT ·Butterfly(SB), $24-16
	MOVQ b+8(FP), AX
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ a+0(FP), AX
	ADDQ 0(AX), DX
	ADCQ 8(AX), CX
	ADCQ 16(AX), BX
	ADCQ 24(AX), SI
	ADCQ 32(AX), DI
	ADCQ 40(AX), R8
	ADCQ 48(AX), R9
	ADCQ 56(AX), R10
	MOVQ DX, R11
	MOVQ CX, R12
	MOVQ BX, R13
	MOVQ SI, R14
	MOVQ DI, R15
	MOVQ R8, s0-8(SP)
	MOVQ R9, s1-16(SP)
	MOVQ R10, s2-24(SP)
	MOVQ 0(AX), DX
	MOVQ 8(AX), CX
	MOVQ 16(AX), BX
	MOVQ 24(AX), SI
	MOVQ 32(AX), DI
	MOVQ 40(AX), R8
	MOVQ 48(AX), R9
	MOVQ 56(AX), R10
	MOVQ b+8(FP), AX
	SUBQ 0(AX), DX
	SBBQ 8(AX), CX
	SBBQ 16(AX), BX
	SBBQ 24(AX), SI
	SBBQ 32(AX), DI
	SBBQ 40(AX), R8
	SBBQ 48(AX), R9
	SBBQ 56(AX), R10
	JCC  l3
	MOVQ $0xc6b574bfe8f2212d, AX
	ADDQ AX, DX
	MOVQ $0xf45cc913001fe46c, AX
	ADCQ AX, CX
	MOVQ $0xf7215bc284ff4791, AX
	ADCQ AX, BX
	MOVQ $0x3254ae3d2c2886a5, AX
	ADCQ AX, SI
	MOVQ $0xc87da10b62c3d43a, AX
	ADCQ AX, DI
	MOVQ $0x300ec89392afb247, AX
	ADCQ AX, R8
	MOVQ $0xed0c0bf80ad360bf, AX
	ADCQ AX, R9
	MOVQ $0x6dfb68e3a2fa56b3, AX
	ADCQ AX, R10

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
	MOVQ R11, DX
	MOVQ R12, CX
	MOVQ R13, BX
	MOVQ R14, SI
	MOVQ R15, DI
	MOVQ s0-8(SP), R8
	MOVQ s1-16(SP), R9
	MOVQ s2-24(SP), R10

	// reduce element(DX,CX,BX,SI,DI,R8,R9,R10) using temp registers (R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))
	REDUCE(DX,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,R14,R15,s0-8(SP),s1-16(SP),s2-24(SP))

	MOVQ a+0(FP), AX
	MOVQ DX, 0(AX)
	MOVQ CX, 8(AX)
	MOVQ BX, 16(AX)
	MOVQ SI, 24(AX)
	MOVQ DI, 32(AX)
	MOVQ R8, 40(AX)
	MOVQ R9, 48(AX)
	MOVQ R10, 56(AX)
	RET
