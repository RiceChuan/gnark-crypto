//go:build !amd64
// +build !amd64

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

// /!\ WARNING /!\
// this code has not been audited and is provided as-is. In particular,
// there is no security guarantees such as constant time implementation
// or side-channel attack resistance
// /!\ WARNING /!\

// MulBy3 x *= 3
func MulBy3(x *e_nocarry_0507) {
	mulByConstant(x, 3)
}

// MulBy5 x *= 5
func MulBy5(x *e_nocarry_0507) {
	mulByConstant(x, 5)
}

// MulBy13 x *= 13
func MulBy13(x *e_nocarry_0507) {
	mulByConstant(x, 13)
}

// Butterfly sets
// a = a + b
// b = a - b
func Butterfly(a, b *e_nocarry_0507) {
	_butterflyGeneric(a, b)
}

func mul(z, x, y *e_nocarry_0507) {
	_mulGeneric(z, x, y)
}

// FromMont converts z in place (i.e. mutates) from Montgomery to regular representation
// sets and returns z = z * 1
func fromMont(z *e_nocarry_0507) {
	_fromMontGeneric(z)
}

func add(z, x, y *e_nocarry_0507) {
	_addGeneric(z, x, y)
}

func double(z, x *e_nocarry_0507) {
	_doubleGeneric(z, x)
}

func sub(z, x, y *e_nocarry_0507) {
	_subGeneric(z, x, y)
}

func neg(z, x *e_nocarry_0507) {
	_negGeneric(z, x)
}

func reduce(z *e_nocarry_0507) {
	_reduceGeneric(z)
}
