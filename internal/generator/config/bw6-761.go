package config

var BW6_761 = Curve{
	Name:         "bw6-761",
	CurvePackage: "bw6761",
	EnumID:       "BW6_761",
	FrModulus:    "258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177",
	FpModulus:    "6891450384315732539396789682275657542479668912536150109513790160209623422243491736087683183289411687640864567753786613451161759120554247759349511699125301598951605099378508850372543631423596795951899700429969112842764913119068299",
	G1: Point{
		CoordType:        "fp.Element",
		CoordExtDegree:   1,
		PointName:        "g1",
		GLV:              true,
		CofactorCleaning: true,
		CRange:           []int{4, 5, 8, 16},
		Projective:       true,
	},
	G2: Point{
		CoordType:        "fp.Element",
		CoordExtDegree:   1,
		PointName:        "g2",
		GLV:              true,
		CofactorCleaning: true,
		CRange:           []int{4, 5, 8, 16},
	},
	HashE1: &HashSuite{
		A: []string{"0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d00000000007c"},
		B: []string{"0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d000000000075"},
		Z: []int{2},
		Isogeny: &Isogeny{
			XMap: RationalPolynomial{
				Num: [][]string{
					{"0x48ba093ee0f382b461f250013ebfcfae49861aa07451a214a09d7be021ef905c1ee98e39613a4640f3aebfc96d08c121a2723b44be7f641c7734f71cfaffcba62845b09599ea3e05833e2bbabc290df9a44f9a1c000020bd27400000000022"},
					{"0x9174127dc1e70568c3e4a0027d7f9f5c930c3540e8a34429413af7c043df20b83dd31c72c2748c81e75d7f92da11824344e476897cfec838ee69ee39f5ff974c508b612b33d47c0b067c577578521bf3489f34380000417a4e800000000046"},
					{"0x48ba093ee0f382b461f250013ebfcfae49861aa07451a214a09d7be021ef905c1ee98e39613a4640f3aebfc96d08c121a2723b44be7f641c7734f71cfaffcba62845b09599ea3e05833e2bbabc290df9a44f9a1c000020bd27400000000023"},
				},
				Den: [][]string{
					{"2"},
				},
			},
			YMap: RationalPolynomial{
				Num: [][]string{
					{"0xda2e1bbca2da881d25d6f003bc3f6f0adc924fe15cf4e63de1d873a065ceb1145cbcaaac23aed2c2db0c3f5c471a4364e756b1ce3b7e2c55659ee556f0ff62f278d111c0cdbeba1089ba8330347b29ececeece540000623775c0000000006a"},
					{"0x6d170dde516d440e92eb7801de1fb7856e4927f0ae7a731ef0ec39d032e7588a2e5e555611d769616d861fae238d21b273ab58e71dbf162ab2cf72ab787fb1793c6888e066df5d0844dd41981a3d94f67677672a0000311bbae00000000036"},
					{"0xda2e1bbca2da881d25d6f003bc3f6f0adc924fe15cf4e63de1d873a065ceb1145cbcaaac23aed2c2db0c3f5c471a4364e756b1ce3b7e2c55659ee556f0ff62f278d111c0cdbeba1089ba8330347b29ececeece540000623775c00000000069"},
					{"0xb5d1171d3260c6c2f4ddc8031cdf8733b7cf429122cc15339189b5b054d6e8e64d47e38f7311afa26134df779095e2d4161d942bdc3e7a472a0469c8737f7d1f64ae397600c99b0dc81b6d52d666a2f01ac70146000051d8e2200000000057"},
				},
				Den: [][]string{
					{"8"},
					{"12"},
					{"6"},
				},
			},
		},
	},
}

func init() {
	addCurve(&BW6_761)
}
