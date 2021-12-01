// +build amd64_adx

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
DATA q<>+0(SB)/8, $0xc868619b8a707da7
DATA q<>+8(SB)/8, $0x2790c83552639a6a
DATA q<>+16(SB)/8, $0x1898de4fe429fb85
DATA q<>+24(SB)/8, $0xd84c46afb172d1cb
DATA q<>+32(SB)/8, $0xba659304da9a8f08
DATA q<>+40(SB)/8, $0x3c5f91f7e2a9a437
DATA q<>+48(SB)/8, $0xb17a38d5764e9b54
DATA q<>+56(SB)/8, $0xa00d8aad4a9d6ae1
DATA q<>+64(SB)/8, $0x06194d7af74b4fa6
DATA q<>+72(SB)/8, $0xd8c5a5e1b76dbfcb
DATA q<>+80(SB)/8, $0x0003c02101c59890
GLOBL q<>(SB), (RODATA+NOPTR), $88

// qInv0 q'[0]
DATA qInv0<>(SB)/8, $0xf90cd2c3fa77a5e9
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

// mul(res, x, y *Element)
TEXT ·mul(SB), $80-24

	// the algorithm is described here
	// https://hackmd.io/@zkteam/modular_multiplication
	// however, to benefit from the ADCX and ADOX carry chains
	// we split the inner loops in 2:
	// for i=0 to N-1
	// 		for j=0 to N-1
	// 		    (A,t[j])  := t[j] + x[j]*y[i] + A
	// 		m := t[0]*q'[0] mod W
	// 		C,_ := t[0] + m*q[0]
	// 		for j=1 to N-1
	// 		    (C,t[j-1]) := t[j] + m*q[j] + C
	// 		t[N-1] = C + A

	NO_LOCAL_POINTERS
	MOVQ x+8(FP), R13

	// A -> BP
	// t[0] -> R14
	// t[1] -> R15
	// t[2] -> CX
	// t[3] -> BX
	// t[4] -> SI
	// t[5] -> DI
	// t[6] -> R8
	// t[7] -> R9
	// t[8] -> R10
	// t[9] -> R11
	// t[10] -> R12
	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 0(AX), DX

	// (A,t[0])  := x[0]*y[0] + A
	MULXQ 0(R13), R14, R15

	// (A,t[1])  := x[1]*y[0] + A
	MULXQ 8(R13), AX, CX
	ADOXQ AX, R15

	// (A,t[2])  := x[2]*y[0] + A
	MULXQ 16(R13), AX, BX
	ADOXQ AX, CX

	// (A,t[3])  := x[3]*y[0] + A
	MULXQ 24(R13), AX, SI
	ADOXQ AX, BX

	// (A,t[4])  := x[4]*y[0] + A
	MULXQ 32(R13), AX, DI
	ADOXQ AX, SI

	// (A,t[5])  := x[5]*y[0] + A
	MULXQ 40(R13), AX, R8
	ADOXQ AX, DI

	// (A,t[6])  := x[6]*y[0] + A
	MULXQ 48(R13), AX, R9
	ADOXQ AX, R8

	// (A,t[7])  := x[7]*y[0] + A
	MULXQ 56(R13), AX, R10
	ADOXQ AX, R9

	// (A,t[8])  := x[8]*y[0] + A
	MULXQ 64(R13), AX, R11
	ADOXQ AX, R10

	// (A,t[9])  := x[9]*y[0] + A
	MULXQ 72(R13), AX, R12
	ADOXQ AX, R11

	// (A,t[10])  := x[10]*y[0] + A
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 8(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[1] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[1] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[1] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[1] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[1] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[1] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[1] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[1] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[1] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[1] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[1] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 16(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[2] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[2] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[2] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[2] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[2] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[2] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[2] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[2] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[2] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[2] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[2] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 24(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[3] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[3] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[3] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[3] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[3] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[3] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[3] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[3] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[3] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[3] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[3] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 32(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[4] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[4] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[4] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[4] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[4] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[4] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[4] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[4] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[4] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[4] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[4] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 40(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[5] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[5] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[5] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[5] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[5] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[5] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[5] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[5] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[5] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[5] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[5] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 48(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[6] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[6] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[6] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[6] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[6] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[6] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[6] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[6] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[6] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[6] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[6] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 56(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[7] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[7] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[7] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[7] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[7] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[7] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[7] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[7] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[7] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[7] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[7] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 64(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[8] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[8] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[8] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[8] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[8] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[8] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[8] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[8] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[8] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[8] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[8] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 72(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[9] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[9] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[9] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[9] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[9] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[9] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[9] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[9] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[9] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[9] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[9] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// clear the flags
	XORQ AX, AX
	MOVQ y+16(FP), AX
	MOVQ 80(AX), DX

	// (A,t[0])  := t[0] + x[0]*y[10] + A
	MULXQ 0(R13), AX, BP
	ADOXQ AX, R14

	// (A,t[1])  := t[1] + x[1]*y[10] + A
	ADCXQ BP, R15
	MULXQ 8(R13), AX, BP
	ADOXQ AX, R15

	// (A,t[2])  := t[2] + x[2]*y[10] + A
	ADCXQ BP, CX
	MULXQ 16(R13), AX, BP
	ADOXQ AX, CX

	// (A,t[3])  := t[3] + x[3]*y[10] + A
	ADCXQ BP, BX
	MULXQ 24(R13), AX, BP
	ADOXQ AX, BX

	// (A,t[4])  := t[4] + x[4]*y[10] + A
	ADCXQ BP, SI
	MULXQ 32(R13), AX, BP
	ADOXQ AX, SI

	// (A,t[5])  := t[5] + x[5]*y[10] + A
	ADCXQ BP, DI
	MULXQ 40(R13), AX, BP
	ADOXQ AX, DI

	// (A,t[6])  := t[6] + x[6]*y[10] + A
	ADCXQ BP, R8
	MULXQ 48(R13), AX, BP
	ADOXQ AX, R8

	// (A,t[7])  := t[7] + x[7]*y[10] + A
	ADCXQ BP, R9
	MULXQ 56(R13), AX, BP
	ADOXQ AX, R9

	// (A,t[8])  := t[8] + x[8]*y[10] + A
	ADCXQ BP, R10
	MULXQ 64(R13), AX, BP
	ADOXQ AX, R10

	// (A,t[9])  := t[9] + x[9]*y[10] + A
	ADCXQ BP, R11
	MULXQ 72(R13), AX, BP
	ADOXQ AX, R11

	// (A,t[10])  := t[10] + x[10]*y[10] + A
	ADCXQ BP, R12
	MULXQ 80(R13), AX, BP
	ADOXQ AX, R12

	// A += carries from ADCXQ and ADOXQ
	MOVQ  $0, AX
	ADCXQ AX, BP
	ADOXQ AX, BP
	PUSHQ BP

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX

	// clear the flags
	XORQ AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14
	POPQ  BP

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11

	// t[10] = C + A
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ BP, R12

	// reduce element(R14,R15,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP))
	REDUCE(R14,R15,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP))

	MOVQ res+0(FP), AX
	MOVQ R14, 0(AX)
	MOVQ R15, 8(AX)
	MOVQ CX, 16(AX)
	MOVQ BX, 24(AX)
	MOVQ SI, 32(AX)
	MOVQ DI, 40(AX)
	MOVQ R8, 48(AX)
	MOVQ R9, 56(AX)
	MOVQ R10, 64(AX)
	MOVQ R11, 72(AX)
	MOVQ R12, 80(AX)
	RET

TEXT ·fromMont(SB), $80-8
	NO_LOCAL_POINTERS

	// the algorithm is described here
	// https://hackmd.io/@zkteam/modular_multiplication
	// when y = 1 we have:
	// for i=0 to N-1
	// 		t[i] = x[i]
	// for i=0 to N-1
	// 		m := t[0]*q'[0] mod W
	// 		C,_ := t[0] + m*q[0]
	// 		for j=1 to N-1
	// 		    (C,t[j-1]) := t[j] + m*q[j] + C
	// 		t[N-1] = C
	MOVQ res+0(FP), DX
	MOVQ 0(DX), R14
	MOVQ 8(DX), R15
	MOVQ 16(DX), CX
	MOVQ 24(DX), BX
	MOVQ 32(DX), SI
	MOVQ 40(DX), DI
	MOVQ 48(DX), R8
	MOVQ 56(DX), R9
	MOVQ 64(DX), R10
	MOVQ 72(DX), R11
	MOVQ 80(DX), R12
	XORQ DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12
	XORQ  DX, DX

	// m := t[0]*q'[0] mod W
	MOVQ  qInv0<>(SB), DX
	IMULQ R14, DX
	XORQ  AX, AX

	// C,_ := t[0] + m*q[0]
	MULXQ q<>+0(SB), AX, BP
	ADCXQ R14, AX
	MOVQ  BP, R14

	// (C,t[0]) := t[1] + m*q[1] + C
	ADCXQ R15, R14
	MULXQ q<>+8(SB), AX, R15
	ADOXQ AX, R14

	// (C,t[1]) := t[2] + m*q[2] + C
	ADCXQ CX, R15
	MULXQ q<>+16(SB), AX, CX
	ADOXQ AX, R15

	// (C,t[2]) := t[3] + m*q[3] + C
	ADCXQ BX, CX
	MULXQ q<>+24(SB), AX, BX
	ADOXQ AX, CX

	// (C,t[3]) := t[4] + m*q[4] + C
	ADCXQ SI, BX
	MULXQ q<>+32(SB), AX, SI
	ADOXQ AX, BX

	// (C,t[4]) := t[5] + m*q[5] + C
	ADCXQ DI, SI
	MULXQ q<>+40(SB), AX, DI
	ADOXQ AX, SI

	// (C,t[5]) := t[6] + m*q[6] + C
	ADCXQ R8, DI
	MULXQ q<>+48(SB), AX, R8
	ADOXQ AX, DI

	// (C,t[6]) := t[7] + m*q[7] + C
	ADCXQ R9, R8
	MULXQ q<>+56(SB), AX, R9
	ADOXQ AX, R8

	// (C,t[7]) := t[8] + m*q[8] + C
	ADCXQ R10, R9
	MULXQ q<>+64(SB), AX, R10
	ADOXQ AX, R9

	// (C,t[8]) := t[9] + m*q[9] + C
	ADCXQ R11, R10
	MULXQ q<>+72(SB), AX, R11
	ADOXQ AX, R10

	// (C,t[9]) := t[10] + m*q[10] + C
	ADCXQ R12, R11
	MULXQ q<>+80(SB), AX, R12
	ADOXQ AX, R11
	MOVQ  $0, AX
	ADCXQ AX, R12
	ADOXQ AX, R12

	// reduce element(R14,R15,CX,BX,SI,DI,R8,R9,R10,R11,R12) using temp registers (R13,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP))
	REDUCE(R14,R15,CX,BX,SI,DI,R8,R9,R10,R11,R12,R13,s0-8(SP),s1-16(SP),s2-24(SP),s3-32(SP),s4-40(SP),s5-48(SP),s6-56(SP),s7-64(SP),s8-72(SP),s9-80(SP))

	MOVQ res+0(FP), AX
	MOVQ R14, 0(AX)
	MOVQ R15, 8(AX)
	MOVQ CX, 16(AX)
	MOVQ BX, 24(AX)
	MOVQ SI, 32(AX)
	MOVQ DI, 40(AX)
	MOVQ R8, 48(AX)
	MOVQ R9, 56(AX)
	MOVQ R10, 64(AX)
	MOVQ R11, 72(AX)
	MOVQ R12, 80(AX)
	RET
