// Copyright 2020 Consensys Software Inc.
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

package mimc

import (
	"github.com/consensys/gnark-crypto/ecc/bls12-381/fr"
)

// Option defines option for altering the behavior of the MiMC hasher.
// See the descriptions of functions returning instances of this type for
// particular options.
type Option func(*mimcConfig)

type mimcConfig struct {
	byteOrder fr.ByteOrder
}

// default options
func mimcOptions(opts ...Option) mimcConfig {
	// apply options
	opt := mimcConfig{
		byteOrder: fr.BigEndian,
	}
	for _, option := range opts {
		option(&opt)
	}
	return opt
}

// WithByteOrder sets the byte order used to decode the input
// in the Write method. Default is BigEndian.
func WithByteOrder(byteOrder fr.ByteOrder) Option {
	return func(opt *mimcConfig) {
		opt.byteOrder = byteOrder
	}
}