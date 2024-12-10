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

package babybear

// expBySqrtExp is equivalent to z.Exp(x, 7)
//
// uses github.com/mmcloughlin/addchain v0.4.0 to generate a shorter addition chain
func (z *Element) expBySqrtExp(x Element) *Element {
	// addition chain:
	//
	//	_10    = 2*1
	//	_11    = 1 + _10
	//	_110   = 2*_11
	//	return   1 + _110
	//
	// Operations: 2 squares 2 multiplies

	// Allocate Temporaries.
	var ()

	// var
	// Step 1: z = x^0x2
	z.Square(&x)

	// Step 2: z = x^0x3
	z.Mul(&x, z)

	// Step 3: z = x^0x6
	z.Square(z)

	// Step 4: z = x^0x7
	z.Mul(&x, z)

	return z
}

// expByLegendreExp is equivalent to z.Exp(x, 3c000000)
//
// uses github.com/mmcloughlin/addchain v0.4.0 to generate a shorter addition chain
func (z *Element) expByLegendreExp(x Element) *Element {
	// addition chain:
	//
	//	_10    = 2*1
	//	_11    = 1 + _10
	//	_1100  = _11 << 2
	//	_1111  = _11 + _1100
	//	return   _1111 << 26
	//
	// Operations: 29 squares 2 multiplies

	// Allocate Temporaries.
	var (
		t0 = new(Element)
	)

	// var t0 Element
	// Step 1: z = x^0x2
	z.Square(&x)

	// Step 2: z = x^0x3
	z.Mul(&x, z)

	// Step 4: t0 = x^0xc
	t0.Square(z)
	for s := 1; s < 2; s++ {
		t0.Square(t0)
	}

	// Step 5: z = x^0xf
	z.Mul(z, t0)

	// Step 31: z = x^0x3c000000
	for s := 0; s < 26; s++ {
		z.Square(z)
	}

	return z
}
