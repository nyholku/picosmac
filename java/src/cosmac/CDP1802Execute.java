package cosmac;

public class CDP1802Execute extends CDP1802SimuBase{
	void opcode_00() {
		waitint();
		}
	void opcode_01() {
		D = M[AM(R(1))];
		}
	void opcode_02() {
		D = M[AM(R(2))];
		}
	void opcode_03() {
		D = M[AM(R(3))];
		}
	void opcode_04() {
		D = M[AM(R(4))];
		}
	void opcode_05() {
		D = M[AM(R(5))];
		}
	void opcode_06() {
		D = M[AM(R(6))];
		}
	void opcode_07() {
		D = M[AM(R(7))];
		}
	void opcode_08() {
		D = M[AM(R(8))];
		}
	void opcode_09() {
		D = M[AM(R(9))];
		}
	void opcode_0A() {
		D = M[AM(R(10))];
		}
	void opcode_0B() {
		D = M[AM(R(11))];
		}
	void opcode_0C() {
		D = M[AM(R(12))];
		}
	void opcode_0D() {
		D = M[AM(R(13))];
		}
	void opcode_0E() {
		D = M[AM(R(14))];
		}
	void opcode_0F() {
		D = M[AM(R(15))];
		}
	void opcode_40() {
		D = M[AM(R(0))];
		inc(0,1);
		}
	void opcode_41() {
		D = M[AM(R(1))];
		inc(1,1);
		}
	void opcode_42() {
		D = M[AM(R(2))];
		inc(2,1);
		}
	void opcode_43() {
		D = M[AM(R(3))];
		inc(3,1);
		}
	void opcode_44() {
		D = M[AM(R(4))];
		inc(4,1);
		}
	void opcode_45() {
		D = M[AM(R(5))];
		inc(5,1);
		}
	void opcode_46() {
		D = M[AM(R(6))];
		inc(6,1);
		}
	void opcode_47() {
		D = M[AM(R(7))];
		inc(7,1);
		}
	void opcode_48() {
		D = M[AM(R(8))];
		inc(8,1);
		}
	void opcode_49() {
		D = M[AM(R(9))];
		inc(9,1);
		}
	void opcode_4A() {
		D = M[AM(R(10))];
		inc(10,1);
		}
	void opcode_4B() {
		D = M[AM(R(11))];
		inc(11,1);
		}
	void opcode_4C() {
		D = M[AM(R(12))];
		inc(12,1);
		}
	void opcode_4D() {
		D = M[AM(R(13))];
		inc(13,1);
		}
	void opcode_4E() {
		D = M[AM(R(14))];
		inc(14,1);
		}
	void opcode_4F() {
		D = M[AM(R(15))];
		inc(15,1);
		}
	void opcode_F0() {
		D = M[AM(R(X))];
		}
	void opcode_72() {
		D = M[AM(R(X))];
		inc(X,+1);
		}
	void opcode_F8() {
		D = M[AM(R(P))];
		inc(P,+1);
		}
	void opcode_50() {
		M[AM(R(0))] = D;
		}
	void opcode_51() {
		M[AM(R(1))] = D;
		}
	void opcode_52() {
		M[AM(R(2))] = D;
		}
	void opcode_53() {
		M[AM(R(3))] = D;
		}
	void opcode_54() {
		M[AM(R(4))] = D;
		}
	void opcode_55() {
		M[AM(R(5))] = D;
		}
	void opcode_56() {
		M[AM(R(6))] = D;
		}
	void opcode_57() {
		M[AM(R(7))] = D;
		}
	void opcode_58() {
		M[AM(R(8))] = D;
		}
	void opcode_59() {
		M[AM(R(9))] = D;
		}
	void opcode_5A() {
		M[AM(R(10))] = D;
		}
	void opcode_5B() {
		M[AM(R(11))] = D;
		}
	void opcode_5C() {
		M[AM(R(12))] = D;
		}
	void opcode_5D() {
		M[AM(R(13))] = D;
		}
	void opcode_5E() {
		M[AM(R(14))] = D;
		}
	void opcode_5F() {
		M[AM(R(15))] = D;
		}
	void opcode_73() {
		M[AM(R(X))] = D;
		inc(X,-1);
		}
	void opcode_10() {
		inc(0,+1);
		}
	void opcode_11() {
		inc(1,+1);
		}
	void opcode_12() {
		inc(2,+1);
		}
	void opcode_13() {
		inc(3,+1);
		}
	void opcode_14() {
		inc(4,+1);
		}
	void opcode_15() {
		inc(5,+1);
		}
	void opcode_16() {
		inc(6,+1);
		}
	void opcode_17() {
		inc(7,+1);
		}
	void opcode_18() {
		inc(8,+1);
		}
	void opcode_19() {
		inc(9,+1);
		}
	void opcode_1A() {
		inc(10,+1);
		}
	void opcode_1B() {
		inc(11,+1);
		}
	void opcode_1C() {
		inc(12,+1);
		}
	void opcode_1D() {
		inc(13,+1);
		}
	void opcode_1E() {
		inc(14,+1);
		}
	void opcode_1F() {
		inc(15,+1);
		}
	void opcode_20() {
		inc(0,-1);
		}
	void opcode_21() {
		inc(1,-1);
		}
	void opcode_22() {
		inc(2,-1);
		}
	void opcode_23() {
		inc(3,-1);
		}
	void opcode_24() {
		inc(4,-1);
		}
	void opcode_25() {
		inc(5,-1);
		}
	void opcode_26() {
		inc(6,-1);
		}
	void opcode_27() {
		inc(7,-1);
		}
	void opcode_28() {
		inc(8,-1);
		}
	void opcode_29() {
		inc(9,-1);
		}
	void opcode_2A() {
		inc(10,-1);
		}
	void opcode_2B() {
		inc(11,-1);
		}
	void opcode_2C() {
		inc(12,-1);
		}
	void opcode_2D() {
		inc(13,-1);
		}
	void opcode_2E() {
		inc(14,-1);
		}
	void opcode_2F() {
		inc(15,-1);
		}
	void opcode_60() {
		inc(X,+1);
		}
	void opcode_80() {
		D = R[0][0];
		}
	void opcode_81() {
		D = R[0][1];
		}
	void opcode_82() {
		D = R[0][2];
		}
	void opcode_83() {
		D = R[0][3];
		}
	void opcode_84() {
		D = R[0][4];
		}
	void opcode_85() {
		D = R[0][5];
		}
	void opcode_86() {
		D = R[0][6];
		}
	void opcode_87() {
		D = R[0][7];
		}
	void opcode_88() {
		D = R[0][8];
		}
	void opcode_89() {
		D = R[0][9];
		}
	void opcode_8A() {
		D = R[0][10];
		}
	void opcode_8B() {
		D = R[0][11];
		}
	void opcode_8C() {
		D = R[0][12];
		}
	void opcode_8D() {
		D = R[0][13];
		}
	void opcode_8E() {
		D = R[0][14];
		}
	void opcode_8F() {
		D = R[0][15];
		}
	void opcode_A0() {
		R[0][0] = D;
		}
	void opcode_A1() {
		R[0][1] = D;
		}
	void opcode_A2() {
		R[0][2] = D;
		}
	void opcode_A3() {
		R[0][3] = D;
		}
	void opcode_A4() {
		R[0][4] = D;
		}
	void opcode_A5() {
		R[0][5] = D;
		}
	void opcode_A6() {
		R[0][6] = D;
		}
	void opcode_A7() {
		R[0][7] = D;
		}
	void opcode_A8() {
		R[0][8] = D;
		}
	void opcode_A9() {
		R[0][9] = D;
		}
	void opcode_AA() {
		R[0][10] = D;
		}
	void opcode_AB() {
		R[0][11] = D;
		}
	void opcode_AC() {
		R[0][12] = D;
		}
	void opcode_AD() {
		R[0][13] = D;
		}
	void opcode_AE() {
		R[0][14] = D;
		}
	void opcode_AF() {
		R[0][15] = D;
		}
	void opcode_90() {
		D = R[1][0];
		}
	void opcode_91() {
		D = R[1][1];
		}
	void opcode_92() {
		D = R[1][2];
		}
	void opcode_93() {
		D = R[1][3];
		}
	void opcode_94() {
		D = R[1][4];
		}
	void opcode_95() {
		D = R[1][5];
		}
	void opcode_96() {
		D = R[1][6];
		}
	void opcode_97() {
		D = R[1][7];
		}
	void opcode_98() {
		D = R[1][8];
		}
	void opcode_99() {
		D = R[1][9];
		}
	void opcode_9A() {
		D = R[1][10];
		}
	void opcode_9B() {
		D = R[1][11];
		}
	void opcode_9C() {
		D = R[1][12];
		}
	void opcode_9D() {
		D = R[1][13];
		}
	void opcode_9E() {
		D = R[1][14];
		}
	void opcode_9F() {
		D = R[1][15];
		}
	void opcode_B0() {
		R[1][0] = D;
		}
	void opcode_B1() {
		R[1][1] = D;
		}
	void opcode_B2() {
		R[1][2] = D;
		}
	void opcode_B3() {
		R[1][3] = D;
		}
	void opcode_B4() {
		R[1][4] = D;
		}
	void opcode_B5() {
		R[1][5] = D;
		}
	void opcode_B6() {
		R[1][6] = D;
		}
	void opcode_B7() {
		R[1][7] = D;
		}
	void opcode_B8() {
		R[1][8] = D;
		}
	void opcode_B9() {
		R[1][9] = D;
		}
	void opcode_BA() {
		R[1][10] = D;
		}
	void opcode_BB() {
		R[1][11] = D;
		}
	void opcode_BC() {
		R[1][12] = D;
		}
	void opcode_BD() {
		R[1][13] = D;
		}
	void opcode_BE() {
		R[1][14] = D;
		}
	void opcode_BF() {
		R[1][15] = D;
		}
	void opcode_F1() {
		D = M[AM(R(X))] | D;
		}
	void opcode_F9() {
		D = M[AM(R(P))] | D;
		inc(P,+1);
		}
	void opcode_F3() {
		D = M[AM(R(X))] ^ D;
		}
	void opcode_FB() {
		D = M[AM(R(P))] ^ D;
		inc(P,+1);
		}
	void opcode_F2() {
		D = M[AM(R(X))] & D;
		}
	void opcode_FA() {
		D = M[AM(R(P))] & D;
		inc(P,+1);
		}
	void opcode_F6() {
		DF = D & 1;
		D = D >> 1;
		}
	void opcode_76() {
		D = (DF << 8) | D;
		DF = D & 1;
		D = D >> 1;
		}
	void opcode_FE() {
		DF = (D >> 7) & 1;
		D = D << 1;
		D &= 0xFF;
		}
	void opcode_7E() {
		D = (D << 1) | DF;
		DF = D >> 8;
		D &= 0xFF;
		}
	void opcode_F4() {
		D = M[AM(R(X))] + D;
		DF = D >> 8;
		D &= 0xFF;
		}
	void opcode_FC() {
		D = M[AM(R(P))] + D;
		DF = D >> 8;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_74() {
		D = M[AM(R(X))] + D + DF;
		DF = D >> 8;
		D &= 0xFF;
		}
	void opcode_7C() {
		D = M[AM(R(P))] + D + DF;
		DF = D >> 8;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_F5() {
		D = M[AM(R(X))] - D;
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		}
	void opcode_FD() {
		D = M[AM(R(P))] - D;
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_75() {
		D = M[AM(R(X))] - D - (DF^1);
		DF =((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		}
	void opcode_7D() {
		D = M[AM(R(P))] - D - (DF^1);
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_F7() {
		D = D - M[AM(R(X))];
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		}
	void opcode_FF() {
		D = D - M[AM(R(P))];
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_77() {
		D = D - M[AM(R(X))] - (DF^1);
		DF = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		}
	void opcode_7F() {
		D = D - M[AM(R(P))] - (DF^1);
		DF  = ((D >> 8) & 1) ^ 1;
		D &= 0xFF;
		inc(P,+1);
		}
	void opcode_30() {
		branchif(true);
		}
	void opcode_32() {
		branchif (D == 0);
		}
	void opcode_3A() {
		branchif (D != 0);
		}
	void opcode_33() {
		branchif (DF == 1);
		}
	void opcode_3B() {
		branchif (DF == 0);
		}
	void opcode_31() {
		branchif (Q == 1);
		}
	void opcode_39() {
		branchif (Q == 0);
		}
	void opcode_34() {
		branchif (EF(1) ==1);
		}
	void opcode_3C() {
		branchif( EF(1) == 0);
		}
	void opcode_35() {
		branchif( EF(2) == 1);
		}
	void opcode_3D() {
		branchif(EF(2) == 0);
		}
	void opcode_36() {
		branchif( EF(3) == 1);
		}
	void opcode_3E() {
		branchif( EF(3) == 0);
		}
	void opcode_37() {
		branchif( EF(4) == 1);
		}
	void opcode_3F() {
		branchif( EF(4) == 0);
		}
	void opcode_C0() {
		lbranchif(true);
		}
	void opcode_C2() {
		lbranchif( D == 0);
		}
	void opcode_CA() {
		lbranchif( D != 0);
		}
	void opcode_C3() {
		lbranchif( DF == 1);
		}
	void opcode_CB() {
		lbranchif( DF == 0);
		}
	void opcode_C1() {
		lbranchif( Q == 1);
		}
	void opcode_C9() {
		lbranchif( Q == 0);
		}
	void opcode_38() {
		branchif(false);
		}
	void opcode_C8() {
		lskip(true);
		}
	void opcode_CE() {
		lskip( D == 0 );
		}
	void opcode_C6() {
		lskip( D != 0 );
		}
	void opcode_CF() {
		lskip( DF == 1 );
		}
	void opcode_C7() {
		lskip( DF == 0 );
		}
	void opcode_CD() {
		lskip( Q == 1 );
		}
	void opcode_C5() {
		lskip( Q == 0 );
		}
	void opcode_CC() {
		lskip( IE == 1 );
		}
	void opcode_C4() {
		;
		}
	void opcode_D0() {
		P = 0;
		}
	void opcode_D1() {
		P = 1;
		}
	void opcode_D2() {
		P = 2;
		}
	void opcode_D3() {
		P = 3;
		}
	void opcode_D4() {
		P = 4;
		}
	void opcode_D5() {
		P = 5;
		}
	void opcode_D6() {
		P = 6;
		}
	void opcode_D7() {
		P = 7;
		}
	void opcode_D8() {
		P = 8;
		}
	void opcode_D9() {
		P = 9;
		}
	void opcode_DA() {
		P = 10;
		}
	void opcode_DB() {
		P = 11;
		}
	void opcode_DC() {
		P = 12;
		}
	void opcode_DD() {
		P = 13;
		}
	void opcode_DE() {
		P = 14;
		}
	void opcode_DF() {
		P = 15;
		}
	void opcode_E0() {
		X = 0;
		}
	void opcode_E1() {
		X = 1;
		}
	void opcode_E2() {
		X = 2;
		}
	void opcode_E3() {
		X = 3;
		}
	void opcode_E4() {
		X = 4;
		}
	void opcode_E5() {
		X = 5;
		}
	void opcode_E6() {
		X = 6;
		}
	void opcode_E7() {
		X = 7;
		}
	void opcode_E8() {
		X = 8;
		}
	void opcode_E9() {
		X = 9;
		}
	void opcode_EA() {
		X = 10;
		}
	void opcode_EB() {
		X = 11;
		}
	void opcode_EC() {
		X = 12;
		}
	void opcode_ED() {
		X = 13;
		}
	void opcode_EE() {
		X = 14;
		}
	void opcode_EF() {
		X = 15;
		}
	void opcode_7B() {
		Q = 1;
		}
	void opcode_7A() {
		Q = 0;
		}
	void opcode_78() {
		M[AM(R(X))] = T;
		}
	void opcode_79() {
		T = (X<<4) |  P;
		M[AM(R(2))] = T;
		X = P;
		inc(2,-1);
		}
	void opcode_70() {
		T = M[AM(R(X))];
		R(X, R(X) + 1); // hand fix
		X = T >> 4;
		P = T & 0xF;
		IE = 1;
		}
	void opcode_71() {
		T = M[AM(R(X))];
		R(X, R(X) + 1); // hand fix
		X = T >> 4;
		P = T & 0xF;
		IE = 0;
		}
	void opcode_61() {
		out(1);
		}
	void opcode_62() {
		out(2);
		}
	void opcode_63() {
		out(3);
		}
	void opcode_64() {
		out(4);
		}
	void opcode_65() {
		out(5);
		}
	void opcode_66() {
		out(6);
		}
	void opcode_67() {
		out(7);
		}
	void opcode_68() {
		undef();
		}
	void opcode_69() {
		inp(1);
		}
	void opcode_6A() {
		inp(2);
		}
	void opcode_6B() {
		inp(3);
		}
	void opcode_6C() {
		inp(4);
		}
	void opcode_6D() {
		inp(5);
		}
	void opcode_6E() {
		inp(6);
		}
	void opcode_6F() {
		inp(7);
		}
	int execOpcode(int opcode) {
		switch(opcode) {
			case 0x00 : opcode_00(); return 1; 
			case 0x01 : opcode_01(); return 1; 
			case 0x02 : opcode_02(); return 1; 
			case 0x03 : opcode_03(); return 1; 
			case 0x04 : opcode_04(); return 1; 
			case 0x05 : opcode_05(); return 1; 
			case 0x06 : opcode_06(); return 1; 
			case 0x07 : opcode_07(); return 1; 
			case 0x08 : opcode_08(); return 1; 
			case 0x09 : opcode_09(); return 1; 
			case 0x0A : opcode_0A(); return 1; 
			case 0x0B : opcode_0B(); return 1; 
			case 0x0C : opcode_0C(); return 1; 
			case 0x0D : opcode_0D(); return 1; 
			case 0x0E : opcode_0E(); return 1; 
			case 0x0F : opcode_0F(); return 1; 
			case 0x10 : opcode_10(); return 1; 
			case 0x11 : opcode_11(); return 1; 
			case 0x12 : opcode_12(); return 1; 
			case 0x13 : opcode_13(); return 1; 
			case 0x14 : opcode_14(); return 1; 
			case 0x15 : opcode_15(); return 1; 
			case 0x16 : opcode_16(); return 1; 
			case 0x17 : opcode_17(); return 1; 
			case 0x18 : opcode_18(); return 1; 
			case 0x19 : opcode_19(); return 1; 
			case 0x1A : opcode_1A(); return 1; 
			case 0x1B : opcode_1B(); return 1; 
			case 0x1C : opcode_1C(); return 1; 
			case 0x1D : opcode_1D(); return 1; 
			case 0x1E : opcode_1E(); return 1; 
			case 0x1F : opcode_1F(); return 1; 
			case 0x20 : opcode_20(); return 1; 
			case 0x21 : opcode_21(); return 1; 
			case 0x22 : opcode_22(); return 1; 
			case 0x23 : opcode_23(); return 1; 
			case 0x24 : opcode_24(); return 1; 
			case 0x25 : opcode_25(); return 1; 
			case 0x26 : opcode_26(); return 1; 
			case 0x27 : opcode_27(); return 1; 
			case 0x28 : opcode_28(); return 1; 
			case 0x29 : opcode_29(); return 1; 
			case 0x2A : opcode_2A(); return 1; 
			case 0x2B : opcode_2B(); return 1; 
			case 0x2C : opcode_2C(); return 1; 
			case 0x2D : opcode_2D(); return 1; 
			case 0x2E : opcode_2E(); return 1; 
			case 0x2F : opcode_2F(); return 1; 
			case 0x30 : opcode_30(); return 2; 
			case 0x31 : opcode_31(); return 2; 
			case 0x32 : opcode_32(); return 2; 
			case 0x33 : opcode_33(); return 2; 
			case 0x34 : opcode_34(); return 2; 
			case 0x35 : opcode_35(); return 2; 
			case 0x36 : opcode_36(); return 2; 
			case 0x37 : opcode_37(); return 2; 
			case 0x38 : opcode_38(); return 2; 
			case 0x39 : opcode_39(); return 2; 
			case 0x3A : opcode_3A(); return 2; 
			case 0x3B : opcode_3B(); return 2; 
			case 0x3C : opcode_3C(); return 2; 
			case 0x3D : opcode_3D(); return 2; 
			case 0x3E : opcode_3E(); return 2; 
			case 0x3F : opcode_3F(); return 2; 
			case 0x40 : opcode_40(); return 1; 
			case 0x41 : opcode_41(); return 1; 
			case 0x42 : opcode_42(); return 1; 
			case 0x43 : opcode_43(); return 1; 
			case 0x44 : opcode_44(); return 1; 
			case 0x45 : opcode_45(); return 1; 
			case 0x46 : opcode_46(); return 1; 
			case 0x47 : opcode_47(); return 1; 
			case 0x48 : opcode_48(); return 1; 
			case 0x49 : opcode_49(); return 1; 
			case 0x4A : opcode_4A(); return 1; 
			case 0x4B : opcode_4B(); return 1; 
			case 0x4C : opcode_4C(); return 1; 
			case 0x4D : opcode_4D(); return 1; 
			case 0x4E : opcode_4E(); return 1; 
			case 0x4F : opcode_4F(); return 1; 
			case 0x50 : opcode_50(); return 1; 
			case 0x51 : opcode_51(); return 1; 
			case 0x52 : opcode_52(); return 1; 
			case 0x53 : opcode_53(); return 1; 
			case 0x54 : opcode_54(); return 1; 
			case 0x55 : opcode_55(); return 1; 
			case 0x56 : opcode_56(); return 1; 
			case 0x57 : opcode_57(); return 1; 
			case 0x58 : opcode_58(); return 1; 
			case 0x59 : opcode_59(); return 1; 
			case 0x5A : opcode_5A(); return 1; 
			case 0x5B : opcode_5B(); return 1; 
			case 0x5C : opcode_5C(); return 1; 
			case 0x5D : opcode_5D(); return 1; 
			case 0x5E : opcode_5E(); return 1; 
			case 0x5F : opcode_5F(); return 1; 
			case 0x60 : opcode_60(); return 1; 
			case 0x61 : opcode_61(); return 1; 
			case 0x62 : opcode_62(); return 1; 
			case 0x63 : opcode_63(); return 1; 
			case 0x64 : opcode_64(); return 1; 
			case 0x65 : opcode_65(); return 1; 
			case 0x66 : opcode_66(); return 1; 
			case 0x67 : opcode_67(); return 1; 
			case 0x68 : opcode_68(); return 1; 
			case 0x69 : opcode_69(); return 1; 
			case 0x6A : opcode_6A(); return 1; 
			case 0x6B : opcode_6B(); return 1; 
			case 0x6C : opcode_6C(); return 1; 
			case 0x6D : opcode_6D(); return 1; 
			case 0x6E : opcode_6E(); return 1; 
			case 0x6F : opcode_6F(); return 1; 
			case 0x70 : opcode_70(); return 1; 
			case 0x71 : opcode_71(); return 1; 
			case 0x72 : opcode_72(); return 1; 
			case 0x73 : opcode_73(); return 1; 
			case 0x74 : opcode_74(); return 1; 
			case 0x75 : opcode_75(); return 1; 
			case 0x76 : opcode_76(); return 1; 
			case 0x77 : opcode_77(); return 1; 
			case 0x78 : opcode_78(); return 1; 
			case 0x79 : opcode_79(); return 1; 
			case 0x7A : opcode_7A(); return 1; 
			case 0x7B : opcode_7B(); return 1; 
			case 0x7C : opcode_7C(); return 2; 
			case 0x7D : opcode_7D(); return 2; 
			case 0x7E : opcode_7E(); return 1; 
			case 0x7F : opcode_7F(); return 2; 
			case 0x80 : opcode_80(); return 1; 
			case 0x81 : opcode_81(); return 1; 
			case 0x82 : opcode_82(); return 1; 
			case 0x83 : opcode_83(); return 1; 
			case 0x84 : opcode_84(); return 1; 
			case 0x85 : opcode_85(); return 1; 
			case 0x86 : opcode_86(); return 1; 
			case 0x87 : opcode_87(); return 1; 
			case 0x88 : opcode_88(); return 1; 
			case 0x89 : opcode_89(); return 1; 
			case 0x8A : opcode_8A(); return 1; 
			case 0x8B : opcode_8B(); return 1; 
			case 0x8C : opcode_8C(); return 1; 
			case 0x8D : opcode_8D(); return 1; 
			case 0x8E : opcode_8E(); return 1; 
			case 0x8F : opcode_8F(); return 1; 
			case 0x90 : opcode_90(); return 1; 
			case 0x91 : opcode_91(); return 1; 
			case 0x92 : opcode_92(); return 1; 
			case 0x93 : opcode_93(); return 1; 
			case 0x94 : opcode_94(); return 1; 
			case 0x95 : opcode_95(); return 1; 
			case 0x96 : opcode_96(); return 1; 
			case 0x97 : opcode_97(); return 1; 
			case 0x98 : opcode_98(); return 1; 
			case 0x99 : opcode_99(); return 1; 
			case 0x9A : opcode_9A(); return 1; 
			case 0x9B : opcode_9B(); return 1; 
			case 0x9C : opcode_9C(); return 1; 
			case 0x9D : opcode_9D(); return 1; 
			case 0x9E : opcode_9E(); return 1; 
			case 0x9F : opcode_9F(); return 1; 
			case 0xA0 : opcode_A0(); return 1; 
			case 0xA1 : opcode_A1(); return 1; 
			case 0xA2 : opcode_A2(); return 1; 
			case 0xA3 : opcode_A3(); return 1; 
			case 0xA4 : opcode_A4(); return 1; 
			case 0xA5 : opcode_A5(); return 1; 
			case 0xA6 : opcode_A6(); return 1; 
			case 0xA7 : opcode_A7(); return 1; 
			case 0xA8 : opcode_A8(); return 1; 
			case 0xA9 : opcode_A9(); return 1; 
			case 0xAA : opcode_AA(); return 1; 
			case 0xAB : opcode_AB(); return 1; 
			case 0xAC : opcode_AC(); return 1; 
			case 0xAD : opcode_AD(); return 1; 
			case 0xAE : opcode_AE(); return 1; 
			case 0xAF : opcode_AF(); return 1; 
			case 0xB0 : opcode_B0(); return 1; 
			case 0xB1 : opcode_B1(); return 1; 
			case 0xB2 : opcode_B2(); return 1; 
			case 0xB3 : opcode_B3(); return 1; 
			case 0xB4 : opcode_B4(); return 1; 
			case 0xB5 : opcode_B5(); return 1; 
			case 0xB6 : opcode_B6(); return 1; 
			case 0xB7 : opcode_B7(); return 1; 
			case 0xB8 : opcode_B8(); return 1; 
			case 0xB9 : opcode_B9(); return 1; 
			case 0xBA : opcode_BA(); return 1; 
			case 0xBB : opcode_BB(); return 1; 
			case 0xBC : opcode_BC(); return 1; 
			case 0xBD : opcode_BD(); return 1; 
			case 0xBE : opcode_BE(); return 1; 
			case 0xBF : opcode_BF(); return 1; 
			case 0xC0 : opcode_C0(); return 3; 
			case 0xC1 : opcode_C1(); return 3; 
			case 0xC2 : opcode_C2(); return 3; 
			case 0xC3 : opcode_C3(); return 3; 
			case 0xC4 : opcode_C4(); return 1; 
			case 0xC5 : opcode_C5(); return 3; 
			case 0xC6 : opcode_C6(); return 3; 
			case 0xC7 : opcode_C7(); return 3; 
			case 0xC8 : opcode_C8(); return 3; 
			case 0xC9 : opcode_C9(); return 3; 
			case 0xCA : opcode_CA(); return 3; 
			case 0xCB : opcode_CB(); return 3; 
			case 0xCC : opcode_CC(); return 3; 
			case 0xCD : opcode_CD(); return 3; 
			case 0xCE : opcode_CE(); return 3; 
			case 0xCF : opcode_CF(); return 3; 
			case 0xD0 : opcode_D0(); return 1; 
			case 0xD1 : opcode_D1(); return 1; 
			case 0xD2 : opcode_D2(); return 1; 
			case 0xD3 : opcode_D3(); return 1; 
			case 0xD4 : opcode_D4(); return 1; 
			case 0xD5 : opcode_D5(); return 1; 
			case 0xD6 : opcode_D6(); return 1; 
			case 0xD7 : opcode_D7(); return 1; 
			case 0xD8 : opcode_D8(); return 1; 
			case 0xD9 : opcode_D9(); return 1; 
			case 0xDA : opcode_DA(); return 1; 
			case 0xDB : opcode_DB(); return 1; 
			case 0xDC : opcode_DC(); return 1; 
			case 0xDD : opcode_DD(); return 1; 
			case 0xDE : opcode_DE(); return 1; 
			case 0xDF : opcode_DF(); return 1; 
			case 0xE0 : opcode_E0(); return 1; 
			case 0xE1 : opcode_E1(); return 1; 
			case 0xE2 : opcode_E2(); return 1; 
			case 0xE3 : opcode_E3(); return 1; 
			case 0xE4 : opcode_E4(); return 1; 
			case 0xE5 : opcode_E5(); return 1; 
			case 0xE6 : opcode_E6(); return 1; 
			case 0xE7 : opcode_E7(); return 1; 
			case 0xE8 : opcode_E8(); return 1; 
			case 0xE9 : opcode_E9(); return 1; 
			case 0xEA : opcode_EA(); return 1; 
			case 0xEB : opcode_EB(); return 1; 
			case 0xEC : opcode_EC(); return 1; 
			case 0xED : opcode_ED(); return 1; 
			case 0xEE : opcode_EE(); return 1; 
			case 0xEF : opcode_EF(); return 1; 
			case 0xF0 : opcode_F0(); return 1; 
			case 0xF1 : opcode_F1(); return 1; 
			case 0xF2 : opcode_F2(); return 1; 
			case 0xF3 : opcode_F3(); return 1; 
			case 0xF4 : opcode_F4(); return 1; 
			case 0xF5 : opcode_F5(); return 1; 
			case 0xF6 : opcode_F6(); return 1; 
			case 0xF7 : opcode_F7(); return 1; 
			case 0xF8 : opcode_F8(); return 2; 
			case 0xF9 : opcode_F9(); return 2; 
			case 0xFA : opcode_FA(); return 2; 
			case 0xFB : opcode_FB(); return 2; 
			case 0xFC : opcode_FC(); return 2; 
			case 0xFD : opcode_FD(); return 2; 
			case 0xFE : opcode_FE(); return 1; 
			case 0xFF : opcode_FF(); return 2; 
			}
		return -1;
		}
	}
