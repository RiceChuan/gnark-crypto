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

// Package integration contains field arithmetic operations for modulus = 0x3a339f...7dc027.
//
// The API is similar to math/big (big.Int), but the operations are significantly faster (up to 20x for the modular multiplication on amd64, see also https://hackmd.io/@zkteam/modular_multiplication)
//
// The modulus is hardcoded in all the operations.
//
// Field elements are represented as an array, and assumed to be in Montgomery form in all methods:
// 	type e_nocarry_0606 [10]uint64
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
// 	0x3a339f119a4290c87253e5f2001f480714105fca0b3a46cf0a2a218e289c55cb6b9472128c985394755e6c64877e9ff4f926a1ddc2365a623301fca85560b4760eeeb83928a630383e7dc027 // base 16
// 	241508635990149898752408251222218328332179572264847222533541433109396508447915063666251007266531533888610246920400401757615961504775674875885392204303237507473392757194482562382020647 // base 10
package integration
