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

// Package integration contains field arithmetic operations for modulus = 0x746768...f4aeb7.
//
// The API is similar to math/big (big.Int), but the operations are significantly faster (up to 20x for the modular multiplication on amd64, see also https://hackmd.io/@zkteam/modular_multiplication)
//
// The modulus is hardcoded in all the operations.
//
// Field elements are represented as an array, and assumed to be in Montgomery form in all methods:
// 	type e_nocarry_0439 [7]uint64
//
// Example API signature
// 	// Mul z = x * y mod q
// 	func (z *Element) Mul(x, y *Element) *Element
//
// and can be used like so:
// 	var a, b Element
// 	a.SetUint64(2)
// 	b.SetString("984896738")
// 	a.Mul(a, b)
// 	a.Sub(a, a)
// 	 .Add(a, b)
// 	 .Inv(a)
// 	b.Exp(b, new(big.Int).SetUint64(42))
//
// Modulus
// 	0x7467683bab2f9322ff58c1f1622198d783fd7bf4665cbd44f404c179481288af9d6a8393e4bc0eacd8d3cbf5475a131d07ad2b8bf4aeb7 // base 16
// 	1290998642759493623035311541660174655828130052711000536049016467764240103624370679411060681758077347587527848842814359574496291368631 // base 10
package integration
