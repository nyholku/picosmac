package cosmac;

import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.channels.IllegalSelectorException;

public abstract class CDP1802SimuBase extends CDP1802State implements Cloneable {
	boolean VERBOSE = false;
	public final static int STOP = 0x68;
	private int LOAD = 0;
	public int m_FORCE_A15 = 0x8000; // up on reset in Telmac1800 address line A15 is forced to 1
	// until OUTPUT 4 (0x64) or INPUT 4 (0x6C) opcode is executed
	protected static int[] m_Coverage = new int[256];

	int[] m_OpLen = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 00..0F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 10..1F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 20..2F
			2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, // 30..3F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 40..4F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 50..5F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 60..6F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 2, // 70..7F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 80..8F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 90..9F
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // A0..AF
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // B0..BF
			3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, // C0..CF
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // D0..DF
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // E0..EF
			1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 2 // F0..FF
	};

	int EF(int ef) {
		return 0;
	}

	void waitint() {

	}

	void undef() {
	}

	void out(int out) {
		// In Telmac1800 any OUTPUT opcode with sets CPU PIN N2 clears the forced A15=1
		if ((out & 0x04) != 0)
			m_FORCE_A15 = 0;
		inc(X, +1);
	}

	void inp(int inp) {
		// In Telmac1800 any INPUT opcode with sets CPU PIN N2 clears the forced A15=1
		if ((inp & 0x04) != 0)
			m_FORCE_A15 = 0;

	}

	void branchif(boolean cond) {
		if (cond)
			R[0][P] = M[AM(R(P))];
		else
			inc(P, +1);
	}

	void lbranchif(boolean cond) {
		if (cond)
			R(P, (M[AM(R(P))] << 8) | M[AM(R(P) + 1)]);
		else
			inc(P, +2);

	}

	void lskip(boolean cond) {
		if (cond)
			inc(P, +2);
	}

	int lo(int x) {
		return x & 0xFF;
	}

	int hi(int x) {
		return x >> 8;
	}

	int R(int N) {
		return (R[1][N] << 8) | R[0][N];
	}

	void R(int N, int v) {
		R[1][N] = (v >> 8) & 0xFF;
		R[0][N] = v & 0xFF;
	}

	void inc(int N, int inc) {
		R(N, R(N) + inc);
	}

	void opcode_A0() {
	}

	void load(int addr) {
		LOAD = addr;
	}

	void load(String s) {
		while (s.length() > 0) {
			M[LOAD++] = Integer.parseInt(s.substring(0, 2), 16);
			s = s.substring(2);
			s = s.trim();
		}
	}

	abstract int execOpcode(int opcode);

	public int AM(int a) {
		int am = a | m_FORCE_A15;

		if (M[am] < 0) {
			String es = String.format("Illegal access at 0x%04X (aka 0x%04X), PC=%04X\n", am, a, R(P));
			//System.err.println(es);
			throw new IllegalArgumentException(es);
		}
		return am;
	}

	void execute() {
		execute(0x7FFFFFFF);

	}

	public void execute(int step) {
		boolean pstate = false;
		while (step-- > 0) {
			int opcode = M[AM(R(P))];

			CDP1802State oldState = null;
			if (VERBOSE) {
				oldState = cloneState();
				System.out.printf("\nexec %04X", R(P), opcode);
				for (int i = 0; i < m_OpLen[opcode]; i++)
					System.out.printf(" %02X", M[AM(R(P) + i)]);
				System.out.printf("\n");
			}
			inc(P, +1);
			m_Coverage[opcode]++;
			execOpcode(opcode);
			if (VERBOSE) {
				printDiff("", "", oldState, VERBOSE);
				printState();
			}
			if (opcode == STOP)
				return;
		}
	}

	static void dumpTestCoverage(boolean zeroOnly) {
		for (int op = 0; op < 256; op++) {
			if (zeroOnly && m_Coverage[op] != 0)
				continue;
			System.out.printf("%02X = %3d %s\n", op, m_Coverage[op], m_Coverage[op] == 0 ? " ¡zero!" : "");
		}
	}
}

