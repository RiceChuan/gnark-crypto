//go:build gofuzz
// +build gofuzz

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

// Code generated by consensys/gnark-crypto DO NOT EDIT

package integration

import (
	"bytes"
	"encoding/binary"
	"io"
	"math/big"
	"math/bits"
)

const (
	fuzzInteresting = 1
	fuzzNormal      = 0
	fuzzDiscard     = -1
)

// Fuzz arithmetic operations fuzzer
func Fuzz(data []byte) int {
	r := bytes.NewReader(data)

	var e1, e2 e_nocarry_0671
	e1.SetRawBytes(r)
	e2.SetRawBytes(r)

	{
		// mul assembly

		var c, _c e_nocarry_0671
		a, _a, b, _b := e1, e1, e2, e2
		c.Mul(&a, &b)
		_mulGeneric(&_c, &_a, &_b)

		if !c.Equal(&_c) {
			panic("mul asm != mul generic on e_nocarry_0671")
		}
	}

	{
		// inverse
		inv := e1
		inv.Inverse(&inv)

		var bInv, b1, b2 big.Int
		e1.ToBigIntRegular(&b1)
		bInv.ModInverse(&b1, Modulus())
		inv.ToBigIntRegular(&b2)

		if b2.Cmp(&bInv) != 0 {
			panic("inverse operation doesn't match big int result")
		}
	}

	{
		// a + -a == 0
		a, b := e1, e1
		b.Neg(&b)
		a.Add(&a, &b)
		if !a.IsZero() {
			panic("a + -a != 0")
		}
	}

	return fuzzNormal

}

// SetRawBytes reads up to Bytes (bytes needed to represent e_nocarry_0671) from reader
// and interpret it as big endian uint64
// used for fuzzing purposes only
func (z *e_nocarry_0671) SetRawBytes(r io.Reader) {

	buf := make([]byte, 8)

	for i := 0; i < len(z); i++ {
		if _, err := io.ReadFull(r, buf); err != nil {
			goto eof
		}
		z[i] = binary.BigEndian.Uint64(buf[:])
	}
eof:
	z[10] %= qe_nocarry_0671[10]

	if z.BiggerModulus() {
		var b uint64
		z[0], b = bits.Sub64(z[0], qe_nocarry_0671[0], 0)
		z[1], b = bits.Sub64(z[1], qe_nocarry_0671[1], b)
		z[2], b = bits.Sub64(z[2], qe_nocarry_0671[2], b)
		z[3], b = bits.Sub64(z[3], qe_nocarry_0671[3], b)
		z[4], b = bits.Sub64(z[4], qe_nocarry_0671[4], b)
		z[5], b = bits.Sub64(z[5], qe_nocarry_0671[5], b)
		z[6], b = bits.Sub64(z[6], qe_nocarry_0671[6], b)
		z[7], b = bits.Sub64(z[7], qe_nocarry_0671[7], b)
		z[8], b = bits.Sub64(z[8], qe_nocarry_0671[8], b)
		z[9], b = bits.Sub64(z[9], qe_nocarry_0671[9], b)
		z[10], b = bits.Sub64(z[10], qe_nocarry_0671[10], b)
	}

	return
}

func (z *e_nocarry_0671) BiggerModulus() bool {
	if z[10] > qe_nocarry_0671[10] {
		return true
	}
	if z[10] < qe_nocarry_0671[10] {
		return false
	}

	if z[9] > qe_nocarry_0671[9] {
		return true
	}
	if z[9] < qe_nocarry_0671[9] {
		return false
	}

	if z[8] > qe_nocarry_0671[8] {
		return true
	}
	if z[8] < qe_nocarry_0671[8] {
		return false
	}

	if z[7] > qe_nocarry_0671[7] {
		return true
	}
	if z[7] < qe_nocarry_0671[7] {
		return false
	}

	if z[6] > qe_nocarry_0671[6] {
		return true
	}
	if z[6] < qe_nocarry_0671[6] {
		return false
	}

	if z[5] > qe_nocarry_0671[5] {
		return true
	}
	if z[5] < qe_nocarry_0671[5] {
		return false
	}

	if z[4] > qe_nocarry_0671[4] {
		return true
	}
	if z[4] < qe_nocarry_0671[4] {
		return false
	}

	if z[3] > qe_nocarry_0671[3] {
		return true
	}
	if z[3] < qe_nocarry_0671[3] {
		return false
	}

	if z[2] > qe_nocarry_0671[2] {
		return true
	}
	if z[2] < qe_nocarry_0671[2] {
		return false
	}

	if z[1] > qe_nocarry_0671[1] {
		return true
	}
	if z[1] < qe_nocarry_0671[1] {
		return false
	}

	return z[0] >= qe_nocarry_0671[0]
}
