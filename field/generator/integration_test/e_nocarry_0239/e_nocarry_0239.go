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

import (
	"crypto/rand"
	"encoding/binary"
	"errors"
	"io"
	"math/big"
	"math/bits"
	"reflect"
	"strconv"
	"sync"
)

// e_nocarry_0239 represents a field element stored on 4 words (uint64)
// e_nocarry_0239 are assumed to be in Montgomery form in all methods
// field modulus q =
//
// 840896475690187666580608204156068138741111444609040856153043941660092967
type e_nocarry_0239 [4]uint64

// Limbs number of 64 bits words needed to represent e_nocarry_0239
const Limbs = 4

// Bits number bits needed to represent e_nocarry_0239
const Bits = 239

// Bytes number bytes needed to represent e_nocarry_0239
const Bytes = Limbs * 8

// field modulus stored as big.Int
var _modulus big.Int

// Modulus returns q as a big.Int
// q =
//
// 840896475690187666580608204156068138741111444609040856153043941660092967
func Modulus() *big.Int {
	return new(big.Int).Set(&_modulus)
}

// q (modulus)
var qe_nocarry_0239 = e_nocarry_0239{
	13008234502727461415,
	1949033851888618160,
	8792921428961489695,
	133962537352182,
}

// rSquare
var rSquare = e_nocarry_0239{
	10316421979052316609,
	6000600401564469255,
	16088919773169045625,
	73320521876106,
}

var bigIntPool = sync.Pool{
	New: func() interface{} {
		return new(big.Int)
	},
}

func init() {
	_modulus.SetString("840896475690187666580608204156068138741111444609040856153043941660092967", 10)
}

// SetUint64 z = v, sets z LSB to v (non-Montgomery form) and convert z to Montgomery form
func (z *e_nocarry_0239) SetUint64(v uint64) *e_nocarry_0239 {
	*z = e_nocarry_0239{v}
	return z.Mul(z, &rSquare) // z.ToMont()
}

// Set z = x
func (z *e_nocarry_0239) Set(x *e_nocarry_0239) *e_nocarry_0239 {
	z[0] = x[0]
	z[1] = x[1]
	z[2] = x[2]
	z[3] = x[3]
	return z
}

// SetInterface converts provided interface into e_nocarry_0239
// returns an error if provided type is not supported
// supported types: e_nocarry_0239, *e_nocarry_0239, uint64, int, string (interpreted as base10 integer),
// *big.Int, big.Int, []byte
func (z *e_nocarry_0239) SetInterface(i1 interface{}) (*e_nocarry_0239, error) {
	switch c1 := i1.(type) {
	case e_nocarry_0239:
		return z.Set(&c1), nil
	case *e_nocarry_0239:
		return z.Set(c1), nil
	case uint64:
		return z.SetUint64(c1), nil
	case int:
		return z.SetString(strconv.Itoa(c1)), nil
	case string:
		return z.SetString(c1), nil
	case *big.Int:
		return z.SetBigInt(c1), nil
	case big.Int:
		return z.SetBigInt(&c1), nil
	case []byte:
		return z.SetBytes(c1), nil
	default:
		return nil, errors.New("can't set integration.e_nocarry_0239 from type " + reflect.TypeOf(i1).String())
	}
}

// SetZero z = 0
func (z *e_nocarry_0239) SetZero() *e_nocarry_0239 {
	z[0] = 0
	z[1] = 0
	z[2] = 0
	z[3] = 0
	return z
}

// SetOne z = 1 (in Montgomery form)
func (z *e_nocarry_0239) SetOne() *e_nocarry_0239 {
	z[0] = 298763847153722948
	z[1] = 18164867411255283697
	z[2] = 3659998076708403342
	z[3] = 102680314024579
	return z
}

// Div z = x*y^-1 mod q
func (z *e_nocarry_0239) Div(x, y *e_nocarry_0239) *e_nocarry_0239 {
	var yInv e_nocarry_0239
	yInv.Inverse(y)
	z.Mul(x, &yInv)
	return z
}

// Bit returns the i'th bit, with lsb == bit 0.
// It is the responsability of the caller to convert from Montgomery to Regular form if needed
func (z *e_nocarry_0239) Bit(i uint64) uint64 {
	j := i / 64
	if j >= 4 {
		return 0
	}
	return uint64(z[j] >> (i % 64) & 1)
}

// Equal returns z == x
func (z *e_nocarry_0239) Equal(x *e_nocarry_0239) bool {
	return (z[3] == x[3]) && (z[2] == x[2]) && (z[1] == x[1]) && (z[0] == x[0])
}

// IsZero returns z == 0
func (z *e_nocarry_0239) IsZero() bool {
	return (z[3] | z[2] | z[1] | z[0]) == 0
}

// IsUint64 returns true if z[0] >= 0 and all other words are 0
func (z *e_nocarry_0239) IsUint64() bool {
	return (z[3] | z[2] | z[1]) == 0
}

// Cmp compares (lexicographic order) z and x and returns:
//
//   -1 if z <  x
//    0 if z == x
//   +1 if z >  x
//
func (z *e_nocarry_0239) Cmp(x *e_nocarry_0239) int {
	_z := *z
	_x := *x
	_z.FromMont()
	_x.FromMont()
	if _z[3] > _x[3] {
		return 1
	} else if _z[3] < _x[3] {
		return -1
	}
	if _z[2] > _x[2] {
		return 1
	} else if _z[2] < _x[2] {
		return -1
	}
	if _z[1] > _x[1] {
		return 1
	} else if _z[1] < _x[1] {
		return -1
	}
	if _z[0] > _x[0] {
		return 1
	} else if _z[0] < _x[0] {
		return -1
	}
	return 0
}

// LexicographicallyLargest returns true if this element is strictly lexicographically
// larger than its negation, false otherwise
func (z *e_nocarry_0239) LexicographicallyLargest() bool {
	// adapted from github.com/zkcrypto/bls12_381
	// we check if the element is larger than (q-1) / 2
	// if z - (((q -1) / 2) + 1) have no underflow, then z > (q-1) / 2

	_z := *z
	_z.FromMont()

	var b uint64
	_, b = bits.Sub64(_z[0], 6504117251363730708, 0)
	_, b = bits.Sub64(_z[1], 10197888962799084888, b)
	_, b = bits.Sub64(_z[2], 4396460714480744847, b)
	_, b = bits.Sub64(_z[3], 66981268676091, b)

	return b == 0
}

// SetRandom sets z to a random element < q
func (z *e_nocarry_0239) SetRandom() (*e_nocarry_0239, error) {
	var bytes [32]byte
	if _, err := io.ReadFull(rand.Reader, bytes[:]); err != nil {
		return nil, err
	}
	z[0] = binary.BigEndian.Uint64(bytes[0:8])
	z[1] = binary.BigEndian.Uint64(bytes[8:16])
	z[2] = binary.BigEndian.Uint64(bytes[16:24])
	z[3] = binary.BigEndian.Uint64(bytes[24:32])
	z[3] %= 133962537352182

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}

	return z, nil
}

// One returns 1 (in montgommery form)
func One() e_nocarry_0239 {
	var one e_nocarry_0239
	one.SetOne()
	return one
}

// Halve sets z to z / 2 (mod p)
func (z *e_nocarry_0239) Halve() {
	if z[0]&1 == 1 {
		var carry uint64

		// z = z + q
		z[0], carry = bits.Add64(z[0], 13008234502727461415, 0)
		z[1], carry = bits.Add64(z[1], 1949033851888618160, carry)
		z[2], carry = bits.Add64(z[2], 8792921428961489695, carry)
		z[3], _ = bits.Add64(z[3], 133962537352182, carry)

	}

	// z = z >> 1

	z[0] = z[0]>>1 | z[1]<<63
	z[1] = z[1]>>1 | z[2]<<63
	z[2] = z[2]>>1 | z[3]<<63
	z[3] >>= 1

}

// API with assembly impl

// Mul z = x * y mod q
// see https://hackmd.io/@zkteam/modular_multiplication
func (z *e_nocarry_0239) Mul(x, y *e_nocarry_0239) *e_nocarry_0239 {
	mul(z, x, y)
	return z
}

// Square z = x * x mod q
// see https://hackmd.io/@zkteam/modular_multiplication
func (z *e_nocarry_0239) Square(x *e_nocarry_0239) *e_nocarry_0239 {
	mul(z, x, x)
	return z
}

// FromMont converts z in place (i.e. mutates) from Montgomery to regular representation
// sets and returns z = z * 1
func (z *e_nocarry_0239) FromMont() *e_nocarry_0239 {
	fromMont(z)
	return z
}

// Add z = x + y mod q
func (z *e_nocarry_0239) Add(x, y *e_nocarry_0239) *e_nocarry_0239 {
	add(z, x, y)
	return z
}

// Double z = x + x mod q, aka Lsh 1
func (z *e_nocarry_0239) Double(x *e_nocarry_0239) *e_nocarry_0239 {
	double(z, x)
	return z
}

// Sub  z = x - y mod q
func (z *e_nocarry_0239) Sub(x, y *e_nocarry_0239) *e_nocarry_0239 {
	sub(z, x, y)
	return z
}

// Neg z = q - x
func (z *e_nocarry_0239) Neg(x *e_nocarry_0239) *e_nocarry_0239 {
	neg(z, x)
	return z
}

// Generic (no ADX instructions, no AMD64) versions of multiplication and squaring algorithms

func _mulGeneric(z, x, y *e_nocarry_0239) {

	var t [4]uint64
	var c [3]uint64
	{
		// round 0
		v := x[0]
		c[1], c[0] = bits.Mul64(v, y[0])
		m := c[0] * 6435217579646917225
		c[2] = madd0(m, 13008234502727461415, c[0])
		c[1], c[0] = madd1(v, y[1], c[1])
		c[2], t[0] = madd2(m, 1949033851888618160, c[2], c[0])
		c[1], c[0] = madd1(v, y[2], c[1])
		c[2], t[1] = madd2(m, 8792921428961489695, c[2], c[0])
		c[1], c[0] = madd1(v, y[3], c[1])
		t[3], t[2] = madd3(m, 133962537352182, c[0], c[2], c[1])
	}
	{
		// round 1
		v := x[1]
		c[1], c[0] = madd1(v, y[0], t[0])
		m := c[0] * 6435217579646917225
		c[2] = madd0(m, 13008234502727461415, c[0])
		c[1], c[0] = madd2(v, y[1], c[1], t[1])
		c[2], t[0] = madd2(m, 1949033851888618160, c[2], c[0])
		c[1], c[0] = madd2(v, y[2], c[1], t[2])
		c[2], t[1] = madd2(m, 8792921428961489695, c[2], c[0])
		c[1], c[0] = madd2(v, y[3], c[1], t[3])
		t[3], t[2] = madd3(m, 133962537352182, c[0], c[2], c[1])
	}
	{
		// round 2
		v := x[2]
		c[1], c[0] = madd1(v, y[0], t[0])
		m := c[0] * 6435217579646917225
		c[2] = madd0(m, 13008234502727461415, c[0])
		c[1], c[0] = madd2(v, y[1], c[1], t[1])
		c[2], t[0] = madd2(m, 1949033851888618160, c[2], c[0])
		c[1], c[0] = madd2(v, y[2], c[1], t[2])
		c[2], t[1] = madd2(m, 8792921428961489695, c[2], c[0])
		c[1], c[0] = madd2(v, y[3], c[1], t[3])
		t[3], t[2] = madd3(m, 133962537352182, c[0], c[2], c[1])
	}
	{
		// round 3
		v := x[3]
		c[1], c[0] = madd1(v, y[0], t[0])
		m := c[0] * 6435217579646917225
		c[2] = madd0(m, 13008234502727461415, c[0])
		c[1], c[0] = madd2(v, y[1], c[1], t[1])
		c[2], z[0] = madd2(m, 1949033851888618160, c[2], c[0])
		c[1], c[0] = madd2(v, y[2], c[1], t[2])
		c[2], z[1] = madd2(m, 8792921428961489695, c[2], c[0])
		c[1], c[0] = madd2(v, y[3], c[1], t[3])
		z[3], z[2] = madd3(m, 133962537352182, c[0], c[2], c[1])
	}

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func _mulWGeneric(z, x *e_nocarry_0239, y uint64) {

	var t [4]uint64
	{
		// round 0
		c1, c0 := bits.Mul64(y, x[0])
		m := c0 * 6435217579646917225
		c2 := madd0(m, 13008234502727461415, c0)
		c1, c0 = madd1(y, x[1], c1)
		c2, t[0] = madd2(m, 1949033851888618160, c2, c0)
		c1, c0 = madd1(y, x[2], c1)
		c2, t[1] = madd2(m, 8792921428961489695, c2, c0)
		c1, c0 = madd1(y, x[3], c1)
		t[3], t[2] = madd3(m, 133962537352182, c0, c2, c1)
	}
	{
		// round 1
		m := t[0] * 6435217579646917225
		c2 := madd0(m, 13008234502727461415, t[0])
		c2, t[0] = madd2(m, 1949033851888618160, c2, t[1])
		c2, t[1] = madd2(m, 8792921428961489695, c2, t[2])
		t[3], t[2] = madd2(m, 133962537352182, t[3], c2)
	}
	{
		// round 2
		m := t[0] * 6435217579646917225
		c2 := madd0(m, 13008234502727461415, t[0])
		c2, t[0] = madd2(m, 1949033851888618160, c2, t[1])
		c2, t[1] = madd2(m, 8792921428961489695, c2, t[2])
		t[3], t[2] = madd2(m, 133962537352182, t[3], c2)
	}
	{
		// round 3
		m := t[0] * 6435217579646917225
		c2 := madd0(m, 13008234502727461415, t[0])
		c2, z[0] = madd2(m, 1949033851888618160, c2, t[1])
		c2, z[1] = madd2(m, 8792921428961489695, c2, t[2])
		z[3], z[2] = madd2(m, 133962537352182, t[3], c2)
	}

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func _fromMontGeneric(z *e_nocarry_0239) {
	// the following lines implement z = z * 1
	// with a modified CIOS montgomery multiplication
	{
		// m = z[0]n'[0] mod W
		m := z[0] * 6435217579646917225
		C := madd0(m, 13008234502727461415, z[0])
		C, z[0] = madd2(m, 1949033851888618160, z[1], C)
		C, z[1] = madd2(m, 8792921428961489695, z[2], C)
		C, z[2] = madd2(m, 133962537352182, z[3], C)
		z[3] = C
	}
	{
		// m = z[0]n'[0] mod W
		m := z[0] * 6435217579646917225
		C := madd0(m, 13008234502727461415, z[0])
		C, z[0] = madd2(m, 1949033851888618160, z[1], C)
		C, z[1] = madd2(m, 8792921428961489695, z[2], C)
		C, z[2] = madd2(m, 133962537352182, z[3], C)
		z[3] = C
	}
	{
		// m = z[0]n'[0] mod W
		m := z[0] * 6435217579646917225
		C := madd0(m, 13008234502727461415, z[0])
		C, z[0] = madd2(m, 1949033851888618160, z[1], C)
		C, z[1] = madd2(m, 8792921428961489695, z[2], C)
		C, z[2] = madd2(m, 133962537352182, z[3], C)
		z[3] = C
	}
	{
		// m = z[0]n'[0] mod W
		m := z[0] * 6435217579646917225
		C := madd0(m, 13008234502727461415, z[0])
		C, z[0] = madd2(m, 1949033851888618160, z[1], C)
		C, z[1] = madd2(m, 8792921428961489695, z[2], C)
		C, z[2] = madd2(m, 133962537352182, z[3], C)
		z[3] = C
	}

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func _addGeneric(z, x, y *e_nocarry_0239) {
	var carry uint64

	z[0], carry = bits.Add64(x[0], y[0], 0)
	z[1], carry = bits.Add64(x[1], y[1], carry)
	z[2], carry = bits.Add64(x[2], y[2], carry)
	z[3], _ = bits.Add64(x[3], y[3], carry)

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func _doubleGeneric(z, x *e_nocarry_0239) {
	var carry uint64

	z[0], carry = bits.Add64(x[0], x[0], 0)
	z[1], carry = bits.Add64(x[1], x[1], carry)
	z[2], carry = bits.Add64(x[2], x[2], carry)
	z[3], _ = bits.Add64(x[3], x[3], carry)

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func _subGeneric(z, x, y *e_nocarry_0239) {
	var b uint64
	z[0], b = bits.Sub64(x[0], y[0], 0)
	z[1], b = bits.Sub64(x[1], y[1], b)
	z[2], b = bits.Sub64(x[2], y[2], b)
	z[3], b = bits.Sub64(x[3], y[3], b)
	if b != 0 {
		var c uint64
		z[0], c = bits.Add64(z[0], 13008234502727461415, 0)
		z[1], c = bits.Add64(z[1], 1949033851888618160, c)
		z[2], c = bits.Add64(z[2], 8792921428961489695, c)
		z[3], _ = bits.Add64(z[3], 133962537352182, c)
	}
}

func _negGeneric(z, x *e_nocarry_0239) {
	if x.IsZero() {
		z.SetZero()
		return
	}
	var borrow uint64
	z[0], borrow = bits.Sub64(13008234502727461415, x[0], 0)
	z[1], borrow = bits.Sub64(1949033851888618160, x[1], borrow)
	z[2], borrow = bits.Sub64(8792921428961489695, x[2], borrow)
	z[3], _ = bits.Sub64(133962537352182, x[3], borrow)
}

func _reduceGeneric(z *e_nocarry_0239) {

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
}

func mulByConstant(z *e_nocarry_0239, c uint8) {
	switch c {
	case 0:
		z.SetZero()
		return
	case 1:
		return
	case 2:
		z.Double(z)
		return
	case 3:
		_z := *z
		z.Double(z).Add(z, &_z)
	case 5:
		_z := *z
		z.Double(z).Double(z).Add(z, &_z)
	default:
		var y e_nocarry_0239
		y.SetUint64(uint64(c))
		z.Mul(z, &y)
	}
}

// BatchInvert returns a new slice with every element inverted.
// Uses Montgomery batch inversion trick
func BatchInvert(a []e_nocarry_0239) []e_nocarry_0239 {
	res := make([]e_nocarry_0239, len(a))
	if len(a) == 0 {
		return res
	}

	zeroes := make([]bool, len(a))
	accumulator := One()

	for i := 0; i < len(a); i++ {
		if a[i].IsZero() {
			zeroes[i] = true
			continue
		}
		res[i] = accumulator
		accumulator.Mul(&accumulator, &a[i])
	}

	accumulator.Inverse(&accumulator)

	for i := len(a) - 1; i >= 0; i-- {
		if zeroes[i] {
			continue
		}
		res[i].Mul(&res[i], &accumulator)
		accumulator.Mul(&accumulator, &a[i])
	}

	return res
}

func _butterflyGeneric(a, b *e_nocarry_0239) {
	t := *a
	a.Add(a, b)
	b.Sub(&t, b)
}

// BitLen returns the minimum number of bits needed to represent z
// returns 0 if z == 0
func (z *e_nocarry_0239) BitLen() int {
	if z[3] != 0 {
		return 192 + bits.Len64(z[3])
	}
	if z[2] != 0 {
		return 128 + bits.Len64(z[2])
	}
	if z[1] != 0 {
		return 64 + bits.Len64(z[1])
	}
	return bits.Len64(z[0])
}

// Exp z = x^exponent mod q
func (z *e_nocarry_0239) Exp(x e_nocarry_0239, exponent *big.Int) *e_nocarry_0239 {
	var bZero big.Int
	if exponent.Cmp(&bZero) == 0 {
		return z.SetOne()
	}

	z.Set(&x)

	for i := exponent.BitLen() - 2; i >= 0; i-- {
		z.Square(z)
		if exponent.Bit(i) == 1 {
			z.Mul(z, &x)
		}
	}

	return z
}

// ToMont converts z to Montgomery form
// sets and returns z = z * r^2
func (z *e_nocarry_0239) ToMont() *e_nocarry_0239 {
	return z.Mul(z, &rSquare)
}

// ToRegular returns z in regular form (doesn't mutate z)
func (z e_nocarry_0239) ToRegular() e_nocarry_0239 {
	return *z.FromMont()
}

// String returns the string form of an e_nocarry_0239 in Montgomery form
func (z *e_nocarry_0239) String() string {
	zz := *z
	zz.FromMont()
	if zz.IsUint64() {
		return strconv.FormatUint(zz[0], 10)
	} else {
		var zzNeg e_nocarry_0239
		zzNeg.Neg(z)
		zzNeg.FromMont()
		if zzNeg.IsUint64() {
			return "-" + strconv.FormatUint(zzNeg[0], 10)
		}
	}
	vv := bigIntPool.Get().(*big.Int)
	defer bigIntPool.Put(vv)
	return zz.ToBigInt(vv).String()
}

// ToBigInt returns z as a big.Int in Montgomery form
func (z *e_nocarry_0239) ToBigInt(res *big.Int) *big.Int {
	var b [Limbs * 8]byte
	binary.BigEndian.PutUint64(b[24:32], z[0])
	binary.BigEndian.PutUint64(b[16:24], z[1])
	binary.BigEndian.PutUint64(b[8:16], z[2])
	binary.BigEndian.PutUint64(b[0:8], z[3])

	return res.SetBytes(b[:])
}

// ToBigIntRegular returns z as a big.Int in regular form
func (z e_nocarry_0239) ToBigIntRegular(res *big.Int) *big.Int {
	z.FromMont()
	return z.ToBigInt(res)
}

// Bytes returns the regular (non montgomery) value
// of z as a big-endian byte array.
func (z *e_nocarry_0239) Bytes() (res [Limbs * 8]byte) {
	_z := z.ToRegular()
	binary.BigEndian.PutUint64(res[24:32], _z[0])
	binary.BigEndian.PutUint64(res[16:24], _z[1])
	binary.BigEndian.PutUint64(res[8:16], _z[2])
	binary.BigEndian.PutUint64(res[0:8], _z[3])

	return
}

// Marshal returns the regular (non montgomery) value
// of z as a big-endian byte slice.
func (z *e_nocarry_0239) Marshal() []byte {
	b := z.Bytes()
	return b[:]
}

// SetBytes interprets e as the bytes of a big-endian unsigned integer,
// sets z to that value (in Montgomery form), and returns z.
func (z *e_nocarry_0239) SetBytes(e []byte) *e_nocarry_0239 {
	// get a big int from our pool
	vv := bigIntPool.Get().(*big.Int)
	vv.SetBytes(e)

	// set big int
	z.SetBigInt(vv)

	// put temporary object back in pool
	bigIntPool.Put(vv)

	return z
}

// SetBigInt sets z to v (regular form) and returns z in Montgomery form
func (z *e_nocarry_0239) SetBigInt(v *big.Int) *e_nocarry_0239 {
	z.SetZero()

	var zero big.Int

	// fast path
	c := v.Cmp(&_modulus)
	if c == 0 {
		// v == 0
		return z
	} else if c != 1 && v.Cmp(&zero) != -1 {
		// 0 < v < q
		return z.setBigInt(v)
	}

	// get temporary big int from the pool
	vv := bigIntPool.Get().(*big.Int)

	// copy input + modular reduction
	vv.Set(v)
	vv.Mod(v, &_modulus)

	// set big int byte value
	z.setBigInt(vv)

	// release object into pool
	bigIntPool.Put(vv)
	return z
}

// setBigInt assumes 0 <= v < q
func (z *e_nocarry_0239) setBigInt(v *big.Int) *e_nocarry_0239 {
	vBits := v.Bits()

	if bits.UintSize == 64 {
		for i := 0; i < len(vBits); i++ {
			z[i] = uint64(vBits[i])
		}
	} else {
		for i := 0; i < len(vBits); i++ {
			if i%2 == 0 {
				z[i/2] = uint64(vBits[i])
			} else {
				z[i/2] |= uint64(vBits[i]) << 32
			}
		}
	}

	return z.ToMont()
}

// SetString creates a big.Int with s (in base 10) and calls SetBigInt on z
func (z *e_nocarry_0239) SetString(s string) *e_nocarry_0239 {
	// get temporary big int from the pool
	vv := bigIntPool.Get().(*big.Int)

	if _, ok := vv.SetString(s, 10); !ok {
		panic("e_nocarry_0239.SetString failed -> can't parse number in base10 into a big.Int")
	}
	z.SetBigInt(vv)

	// release object into pool
	bigIntPool.Put(vv)

	return z
}

var (
	_bLegendreExponente_nocarry_0239 *big.Int
	_bSqrtExponente_nocarry_0239     *big.Int
)

func init() {
	_bLegendreExponente_nocarry_0239, _ = new(big.Int).SetString("3ceb4ab9ddfb3d035db9f395b98f8d862dfb1e8425585a43442e09067513", 16)
	const sqrtExponente_nocarry_0239 = "1e75a55ceefd9e81aedcf9cadcc7c6c316fd8f4212ac2d21a21704833a8a"
	_bSqrtExponente_nocarry_0239, _ = new(big.Int).SetString(sqrtExponente_nocarry_0239, 16)
}

// Legendre returns the Legendre symbol of z (either +1, -1, or 0.)
func (z *e_nocarry_0239) Legendre() int {
	var l e_nocarry_0239
	// z^((q-1)/2)
	l.Exp(*z, _bLegendreExponente_nocarry_0239)

	if l.IsZero() {
		return 0
	}

	// if l == 1
	if (l[3] == 102680314024579) && (l[2] == 3659998076708403342) && (l[1] == 18164867411255283697) && (l[0] == 298763847153722948) {
		return 1
	}
	return -1
}

// Sqrt z = √x mod q
// if the square root doesn't exist (x is not a square mod q)
// Sqrt leaves z unchanged and returns nil
func (z *e_nocarry_0239) Sqrt(x *e_nocarry_0239) *e_nocarry_0239 {
	// q ≡ 3 (mod 4)
	// using  z ≡ ± x^((p+1)/4) (mod q)
	var y, square e_nocarry_0239
	y.Exp(*x, _bSqrtExponente_nocarry_0239)
	// as we didn't compute the legendre symbol, ensure we found y such that y * y = x
	square.Square(&y)
	if square.Equal(x) {
		return z.Set(&y)
	}
	return nil
}

// Inverse z = x^-1 mod q
// Algorithm 16 in "Efficient Software-Implementation of Finite Fields with Applications to Cryptography"
// if x == 0, sets and returns z = x
func (z *e_nocarry_0239) InverseOld(x *e_nocarry_0239) *e_nocarry_0239 {
	if x.IsZero() {
		z.SetZero()
		return z
	}

	// initialize u = q
	var u = e_nocarry_0239{
		13008234502727461415,
		1949033851888618160,
		8792921428961489695,
		133962537352182,
	}

	// initialize s = r^2
	var s = e_nocarry_0239{
		10316421979052316609,
		6000600401564469255,
		16088919773169045625,
		73320521876106,
	}

	// r = 0
	r := e_nocarry_0239{}

	v := *x

	var carry, borrow uint64
	var bigger bool

	for {
		for v[0]&1 == 0 {

			// v = v >> 1

			v[0] = v[0]>>1 | v[1]<<63
			v[1] = v[1]>>1 | v[2]<<63
			v[2] = v[2]>>1 | v[3]<<63
			v[3] >>= 1

			if s[0]&1 == 1 {

				// s = s + q
				s[0], carry = bits.Add64(s[0], 13008234502727461415, 0)
				s[1], carry = bits.Add64(s[1], 1949033851888618160, carry)
				s[2], carry = bits.Add64(s[2], 8792921428961489695, carry)
				s[3], _ = bits.Add64(s[3], 133962537352182, carry)

			}

			// s = s >> 1

			s[0] = s[0]>>1 | s[1]<<63
			s[1] = s[1]>>1 | s[2]<<63
			s[2] = s[2]>>1 | s[3]<<63
			s[3] >>= 1

		}
		for u[0]&1 == 0 {

			// u = u >> 1

			u[0] = u[0]>>1 | u[1]<<63
			u[1] = u[1]>>1 | u[2]<<63
			u[2] = u[2]>>1 | u[3]<<63
			u[3] >>= 1

			if r[0]&1 == 1 {

				// r = r + q
				r[0], carry = bits.Add64(r[0], 13008234502727461415, 0)
				r[1], carry = bits.Add64(r[1], 1949033851888618160, carry)
				r[2], carry = bits.Add64(r[2], 8792921428961489695, carry)
				r[3], _ = bits.Add64(r[3], 133962537352182, carry)

			}

			// r = r >> 1

			r[0] = r[0]>>1 | r[1]<<63
			r[1] = r[1]>>1 | r[2]<<63
			r[2] = r[2]>>1 | r[3]<<63
			r[3] >>= 1

		}

		// v >= u
		bigger = !(v[3] < u[3] || (v[3] == u[3] && (v[2] < u[2] || (v[2] == u[2] && (v[1] < u[1] || (v[1] == u[1] && (v[0] < u[0])))))))

		if bigger {

			// v = v - u
			v[0], borrow = bits.Sub64(v[0], u[0], 0)
			v[1], borrow = bits.Sub64(v[1], u[1], borrow)
			v[2], borrow = bits.Sub64(v[2], u[2], borrow)
			v[3], _ = bits.Sub64(v[3], u[3], borrow)

			// s = s - r
			s[0], borrow = bits.Sub64(s[0], r[0], 0)
			s[1], borrow = bits.Sub64(s[1], r[1], borrow)
			s[2], borrow = bits.Sub64(s[2], r[2], borrow)
			s[3], borrow = bits.Sub64(s[3], r[3], borrow)

			if borrow == 1 {

				// s = s + q
				s[0], carry = bits.Add64(s[0], 13008234502727461415, 0)
				s[1], carry = bits.Add64(s[1], 1949033851888618160, carry)
				s[2], carry = bits.Add64(s[2], 8792921428961489695, carry)
				s[3], _ = bits.Add64(s[3], 133962537352182, carry)

			}
		} else {

			// u = u - v
			u[0], borrow = bits.Sub64(u[0], v[0], 0)
			u[1], borrow = bits.Sub64(u[1], v[1], borrow)
			u[2], borrow = bits.Sub64(u[2], v[2], borrow)
			u[3], _ = bits.Sub64(u[3], v[3], borrow)

			// r = r - s
			r[0], borrow = bits.Sub64(r[0], s[0], 0)
			r[1], borrow = bits.Sub64(r[1], s[1], borrow)
			r[2], borrow = bits.Sub64(r[2], s[2], borrow)
			r[3], borrow = bits.Sub64(r[3], s[3], borrow)

			if borrow == 1 {

				// r = r + q
				r[0], carry = bits.Add64(r[0], 13008234502727461415, 0)
				r[1], carry = bits.Add64(r[1], 1949033851888618160, carry)
				r[2], carry = bits.Add64(r[2], 8792921428961489695, carry)
				r[3], _ = bits.Add64(r[3], 133962537352182, carry)

			}
		}
		if (u[0] == 1) && (u[3]|u[2]|u[1]) == 0 {
			z.Set(&r)
			return z
		}
		if (v[0] == 1) && (v[3]|v[2]|v[1]) == 0 {
			z.Set(&s)
			return z
		}
	}

}

func max(a int, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

//Though we're defining k as a constant, this code "profoundly" assumes that the processor is 64 bit
const k = 32 // word size / 2
const signBitSelector = uint64(1) << 63
const approxLowBitsN = k - 1
const approxHighBitsN = k + 1

func approximate(x *e_nocarry_0239, n int) uint64 {

	if n <= 64 {
		return x[0]
	}

	const mask = (uint64(1) << (k - 1)) - 1 //k-1 ones
	lo := mask & x[0]

	hiWordIndex := (n - 1) / 64

	hiWordBitsAvailable := n - hiWordIndex*64
	hiWordBitsUsed := min(hiWordBitsAvailable, approxHighBitsN)

	mask_ := uint64(^((1 << (hiWordBitsAvailable - hiWordBitsUsed)) - 1))
	hi := (x[hiWordIndex] & mask_) << (64 - hiWordBitsAvailable)

	mask_ = ^(1<<(approxLowBitsN+hiWordBitsUsed) - 1)
	mid := (mask_ & x[hiWordIndex-1]) >> hiWordBitsUsed

	return lo | mid | hi
}

var inversionCorrectionFactor = e_nocarry_0239{
	3137421947995594289,
	565808697734176266,
	8312454025831340205,
	84327194265105,
}

func (z *e_nocarry_0239) Inverse(x *e_nocarry_0239) *e_nocarry_0239 {
	if x.IsZero() {
		z.SetZero()
		return z
	}

	var a = *x
	var b = qe_nocarry_0239
	var u = e_nocarry_0239{1}

	//Update factors: we get [u; v]:= [f0 g0; f1 g1] [u; v]
	var f0, g0, f1, g1 int64

	//Saved update factors to reduce the number of field multiplications
	var pf0, pg0, pf1, pg1 int64

	var i uint

	var v, s e_nocarry_0239

	const iterationN = 2 * ((2*Bits-2)/(2*k) + 1) // 2  ⌈ (2 * field size - 1) / 2k ⌉

	//Since u,v are updated every other iteration, we must make sure we terminate after evenly many iterations
	//This also lets us get away with half as many updates to u,v
	//To make this constant-time-ish, replace the condition with i < iterationN
	for i = 0; i&1 == 1 || !a.IsZero(); i++ {
		n := max(a.BitLen(), b.BitLen())
		aApprox, bApprox := approximate(&a, n), approximate(&b, n)

		// After 0 iterations, we have f₀ ≤ 2⁰ and f₁ < 2⁰
		f0, g0, f1, g1 = 1, 0, 0, 1

		for j := 0; j < approxLowBitsN; j++ {

			if aApprox&1 == 0 {
				aApprox /= 2
			} else {
				s, borrow := bits.Sub64(aApprox, bApprox, 0)
				if borrow == 1 {
					s = bApprox - aApprox
					bApprox = aApprox
					f0, f1 = f1, f0
					g0, g1 = g1, g0
				}

				aApprox = s / 2
				f0 -= f1
				g0 -= g1

				//Now |f₀| < 2ʲ + 2ʲ = 2ʲ⁺¹
				//|f₁| ≤ 2ʲ still
			}

			f1 *= 2
			g1 *= 2
			//|f₁| ≤ 2ʲ⁺¹
		}

		s = a
		aHi := a.linearCombNonModular(&s, f0, &b, g0)
		if aHi&signBitSelector != 0 {
			// if aHi < 0
			f0, g0 = -f0, -g0
			aHi = a.neg(&a, aHi)
		}
		//right-shift a by k-1 bits
		a[0] = (a[0] >> approxLowBitsN) | ((a[1]) << approxHighBitsN)
		a[1] = (a[1] >> approxLowBitsN) | ((a[2]) << approxHighBitsN)
		a[2] = (a[2] >> approxLowBitsN) | ((a[3]) << approxHighBitsN)
		a[3] = (a[3] >> approxLowBitsN) | (aHi << approxHighBitsN)

		bHi := b.linearCombNonModular(&s, f1, &b, g1)
		if bHi&signBitSelector != 0 {
			// if bHi < 0
			f1, g1 = -f1, -g1
			bHi = b.neg(&b, bHi)
		}
		//right-shift b by k-1 bits
		b[0] = (b[0] >> approxLowBitsN) | ((b[1]) << approxHighBitsN)
		b[1] = (b[1] >> approxLowBitsN) | ((b[2]) << approxHighBitsN)
		b[2] = (b[2] >> approxLowBitsN) | ((b[3]) << approxHighBitsN)
		b[3] = (b[3] >> approxLowBitsN) | (bHi << approxHighBitsN)

		if i&1 == 1 {
			//Combine current update factors with previously stored ones
			// [f₀, g₀; f₁, g₁] ← [f₀, g₀; f₁, g₀] [pf₀, pg₀; pf₀, pg₀]
			// We have |f₀|, |g₀|, |pf₀|, |pf₁| ≤ 2ᵏ⁻¹, and that |pf_i| < 2ᵏ⁻¹ for i ∈ {0, 1}
			// Then for the new value we get |f₀| < 2ᵏ⁻¹ × 2ᵏ⁻¹ + 2ᵏ⁻¹ × 2ᵏ⁻¹ = 2²ᵏ⁻¹
			// Which leaves us with an extra bit for the sign
			f0, g0, f1, g1 = f0*pf0+g0*pf1,
				f0*pg0+g0*pg1,
				f1*pf0+g1*pf1,
				f1*pg0+g1*pg1

			s = u
			u.linearCombSosSigned(&u, f0, &v, g0)
			v.linearCombSosSigned(&s, f1, &v, g1)

		} else {
			//Save update factors
			pf0, pg0, pf1, pg1 = f0, g0, f1, g1
		}
	}

	if i > iterationN {
		panic("more iterations than expected")
	}

	//For every iteration that we miss, v is not being multiplied by 2²ᵏ⁻²
	const pSq int64 = 1 << (2 * (k - 1))
	//If the function is constant-time ish, this loop will not run (probably no need to take it out explicitly)
	for ; i < iterationN; i += 2 {
		v.mulWSigned(&v, pSq)
	}

	z.Mul(&v, &inversionCorrectionFactor)
	return z
}

func (z *e_nocarry_0239) linearCombSosSigned(x *e_nocarry_0239, xC int64, y *e_nocarry_0239, yC int64) {
	hi := z.linearCombNonModular(x, xC, y, yC)
	z.montReduceSigned(z, hi)
}

//montReduceSigned SOS algorithm; xHi must be at most 63 bits long. Last bit of xHi may be used as a sign bit
func (z *e_nocarry_0239) montReduceSigned(x *e_nocarry_0239, xHi uint64) {

	const qInvNegLsw uint64 = 6435217579646917225
	const signBitRemover = ^signBitSelector
	neg := xHi&signBitSelector != 0
	//the SOS implementation requires that most significant bit is 0
	// Let X be xHi*r + x
	// note that if X is negative we would have initially stored it as 2⁶⁴ r + X
	xHi &= signBitRemover
	// with this a negative X is now represented as 2⁶³ r + X

	var t [2*Limbs - 1]uint64
	var C uint64

	m := x[0] * qInvNegLsw

	C = madd0(m, qe_nocarry_0239[0], x[0])
	C, t[1] = madd2(m, qe_nocarry_0239[1], x[1], C)
	C, t[2] = madd2(m, qe_nocarry_0239[2], x[2], C)
	C, t[3] = madd2(m, qe_nocarry_0239[3], x[3], C)

	// the high word of m * qe_nocarry_0239[3] is at most 62 bits
	// x[3] + C is at most 65 bits (high word at most 1 bit)
	// Thus the resulting C will be at most 63 bits
	t[4] = xHi + C
	// xHi and C are 63 bits, therefore no overflow

	{
		const i = 1
		m = t[i] * qInvNegLsw

		//TODO: Is it better to hard-code the values of qe_nocarry_0239 as the "reduce" template does?
		C = madd0(m, qe_nocarry_0239[0], t[i+0])
		C, t[i+1] = madd2(m, qe_nocarry_0239[1], t[i+1], C)
		C, t[i+2] = madd2(m, qe_nocarry_0239[2], t[i+2], C)
		C, t[i+3] = madd2(m, qe_nocarry_0239[3], t[i+3], C)

		t[i+Limbs] += C
	}
	{
		const i = 2
		m = t[i] * qInvNegLsw

		//TODO: Is it better to hard-code the values of qe_nocarry_0239 as the "reduce" template does?
		C = madd0(m, qe_nocarry_0239[0], t[i+0])
		C, t[i+1] = madd2(m, qe_nocarry_0239[1], t[i+1], C)
		C, t[i+2] = madd2(m, qe_nocarry_0239[2], t[i+2], C)
		C, t[i+3] = madd2(m, qe_nocarry_0239[3], t[i+3], C)

		t[i+Limbs] += C
	}
	{
		const i = 3
		m := t[i] * qInvNegLsw

		C = madd0(m, qe_nocarry_0239[0], t[i+0])
		C, z[0] = madd2(m, qe_nocarry_0239[1], t[i+1], C)
		C, z[1] = madd2(m, qe_nocarry_0239[2], t[i+2], C)
		z[3], z[2] = madd2(m, qe_nocarry_0239[3], t[i+3], C)
	}

	// if z > q --> z -= q
	// note: this is NOT constant time
	if !(z[3] < 133962537352182 || (z[3] == 133962537352182 && (z[2] < 8792921428961489695 || (z[2] == 8792921428961489695 && (z[1] < 1949033851888618160 || (z[1] == 1949033851888618160 && (z[0] < 13008234502727461415))))))) {
		var b uint64
		z[0], b = bits.Sub64(z[0], 13008234502727461415, 0)
		z[1], b = bits.Sub64(z[1], 1949033851888618160, b)
		z[2], b = bits.Sub64(z[2], 8792921428961489695, b)
		z[3], _ = bits.Sub64(z[3], 133962537352182, b)
	}
	if neg {
		//We have computed ( 2⁶³ r + X ) r⁻¹ = 2⁶³ + X r⁻¹ instead
		var b uint64
		z[0], b = bits.Sub64(z[0], signBitSelector, 0)
		z[1], b = bits.Sub64(z[1], 0, b)
		z[2], b = bits.Sub64(z[2], 0, b)
		z[3], b = bits.Sub64(z[3], 0, b)

		//Occurs iff x == 0 && xHi < 0, i.e. X = rX' for -2⁶³ ≤ X' < 0
		if b != 0 {
			// z[3] = -1
			//negative: add q
			const neg1 = 0xFFFFFFFFFFFFFFFF

			b = 0
			z[0], b = bits.Add64(z[0], 13008234502727461415, b)
			z[1], b = bits.Add64(z[1], 1949033851888618160, b)
			z[2], b = bits.Add64(z[2], 8792921428961489695, b)
			z[3], _ = bits.Add64(neg1, 133962537352182, b)
		}
	}
}

// mulWSigned mul word signed (w/ montgomery reduction)
func (z *e_nocarry_0239) mulWSigned(x *e_nocarry_0239, y int64) {
	m := y >> 63
	_mulWGeneric(z, x, uint64((y^m)-m))
	//multiply by abs(y)
	if y < 0 {
		z.Neg(z)
	}
}

// regular multiplication by one word regular (non montgomery)
// Fewer additions than the branch-free for positive y. Could be faster on some architectures
func (z *e_nocarry_0239) mulWRegularBr(x *e_nocarry_0239, y int64) uint64 {

	// w := abs(y)
	m := y >> 63
	w := uint64((y ^ m) - m)

	var c uint64
	c, z[0] = bits.Mul64(x[0], w)
	c, z[1] = madd1(x[1], w, c)
	c, z[2] = madd1(x[2], w, c)
	c, z[3] = madd1(x[3], w, c)

	if y < 0 {
		c = z.neg(z, c)
	}

	return c
}

func (z *e_nocarry_0239) neg(x *e_nocarry_0239, xHi uint64) uint64 {
	b := uint64(0)

	z[0], b = bits.Sub64(0, x[0], 0)
	z[1], b = bits.Sub64(0, x[1], b)
	z[2], b = bits.Sub64(0, x[2], b)
	z[3], b = bits.Sub64(0, x[3], b)
	xHi, _ = bits.Sub64(0, xHi, b)

	return xHi
}

// mulWRegular branch-free regular multiplication by one word (non montgomery)
func (z *e_nocarry_0239) mulWRegular(x *e_nocarry_0239, y int64) uint64 {

	w := uint64(y)
	allNeg := uint64(y >> 63) // -1 if y < 0, 0 o.w

	//s[0], s[1] so results are not stored immediately in z.
	//x[i] will be needed in the i+1 th iteration. We don't want to overwrite it in case x = z
	var s [2]uint64
	var h [2]uint64

	h[0], s[0] = bits.Mul64(x[0], w)

	c := uint64(0)
	b := uint64(0)

	{
		const curI = 1 % 2
		const prevI = 1 - curI
		const iMinusOne = 1 - 1

		h[curI], s[curI] = bits.Mul64(x[1], w)
		s[curI], c = bits.Add64(s[curI], h[prevI], c)
		s[curI], b = bits.Sub64(s[curI], allNeg&x[iMinusOne], b)
		z[iMinusOne] = s[prevI]
	}

	{
		const curI = 2 % 2
		const prevI = 1 - curI
		const iMinusOne = 2 - 1

		h[curI], s[curI] = bits.Mul64(x[2], w)
		s[curI], c = bits.Add64(s[curI], h[prevI], c)
		s[curI], b = bits.Sub64(s[curI], allNeg&x[iMinusOne], b)
		z[iMinusOne] = s[prevI]
	}

	{
		const curI = 3 % 2
		const prevI = 1 - curI
		const iMinusOne = 3 - 1

		h[curI], s[curI] = bits.Mul64(x[3], w)
		s[curI], c = bits.Add64(s[curI], h[prevI], c)
		s[curI], b = bits.Sub64(s[curI], allNeg&x[iMinusOne], b)
		z[iMinusOne] = s[prevI]
	}
	{
		const curI = 4 % 2
		const prevI = 1 - curI
		const iMinusOne = 3

		s[curI], _ = bits.Sub64(h[prevI], allNeg&x[iMinusOne], b)
		z[iMinusOne] = s[prevI]

		return s[curI] + c
	}
}

//Requires NoCarry
func (z *e_nocarry_0239) linearCombNonModular(x *e_nocarry_0239, xC int64, y *e_nocarry_0239, yC int64) uint64 {
	var yTimes e_nocarry_0239

	yHi := yTimes.mulWRegular(y, yC)
	xHi := z.mulWRegular(x, xC)

	carry := uint64(0)
	z[0], carry = bits.Add64(z[0], yTimes[0], carry)
	z[1], carry = bits.Add64(z[1], yTimes[1], carry)
	z[2], carry = bits.Add64(z[2], yTimes[2], carry)
	z[3], carry = bits.Add64(z[3], yTimes[3], carry)

	yHi, _ = bits.Add64(xHi, yHi, carry)

	return yHi
}
