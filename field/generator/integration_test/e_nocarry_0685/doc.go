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

// Package integration contains field arithmetic operations for modulus = 0x1af03a...c5a5e5.
//
// The API is similar to math/big (big.Int), but the operations are significantly faster (up to 20x for the modular multiplication on amd64, see also https://hackmd.io/@zkteam/modular_multiplication)
//
// The modulus is hardcoded in all the operations.
//
// Field elements are represented as an array, and assumed to be in Montgomery form in all methods:
// 	type e_nocarry_0685 [11]uint64
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
// 	0x1af03ac9fae4a7d28e9d9f3fce2c0ac679b4035303316bda49ac98a9a13a56437aa22eb6911d4bbbd32406adda175e3d572ac6a809465ef1772021af8f2202638e51293753d82e64616f1556267b2ab51ffc76c5a5e5 // base 16
// 	135135297247037615538158635173265231617968283040123432664553122789152272556326370836451724428104847252767954723267544968034919546645611647442547007737367547785316756228562648843713383433534145638668685387237 // base 10
package integration
