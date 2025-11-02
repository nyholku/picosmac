package cosmac;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.function.Supplier;

public class RunTests {
	boolean RUN = true;
	boolean VERBOSE = false;
	boolean TIMEXEC = false;
	boolean DEBUG_TRIAL = false;
	PrintWriter m_asm;
	int m_MaxExecTime = 0;
	String m_MaxExecTimeOpcode;
	String m_TestName;

	void writeHead() throws Exception {
		m_asm = new PrintWriter(new FileOutputStream(new File("../src/trial.asm")));

		m_asm.println();

		m_asm.println(";");
		m_asm.println("\tLIST");
		m_asm.println(";");
		m_asm.println("\tCONFIG WDT = OFF");
		m_asm.println(";");
		m_asm.println("\tINCLUDE coff.inc");
		m_asm.println("\tINCLUDE p18cxxx.inc");
		m_asm.println(";");
		m_asm.println("\tRADIX dec");
		m_asm.println("\tGLOBAL main_program, init_done");
		m_asm.println("\tEXTERN all_done, init_cdp1802, init_cdp1861, exec_one_cycle, timexec");
		for (int opcode = 0; opcode < 256; opcode++)
			m_asm.println(String.format("\tEXTERN opcode_%02X", opcode));
		m_asm.println(";");
		m_asm.println("\tCODE");
		m_asm.println(";");
	}

	void writeTail(CDP1802State simu) throws Exception {
		m_asm.println("main_program:");
		m_asm.println("\tCLRWDT");
		m_asm.println("\tCALL init_cdp1802");
		m_asm.println("\tCALL init_cdp1861");
		m_asm.println("init_done:");
		m_asm.println("\tNOP");

		if (TIMEXEC) {
			m_asm.println("\tGLOBAL time0,time1,time2");
			m_asm.println("time0:");
			m_asm.println("\tCALL   timexec; exec_one_cycle");
			m_asm.println("time1:");
			m_asm.println("\tCALL   timexec; exec_one_cycle");
			m_asm.println("time2:");
			m_asm.println("\tNOP");
		} else { // run until we hit a breakpoint, which is set CDP1802 opcode 68, ie the undefined opcode
			m_asm.println("\tglobal again");
			m_asm.println("again: 	CALL   exec_one_cycle");
			m_asm.println("\tGOTO again");
		}

		m_asm.print(simu.getROMasPicAsmCode());

		m_asm.printf("\t.sim \"REG_D=0x%02X\"\n", simu.D);
		m_asm.printf("\t.sim \"REG_DF=0x%02X\"\n", simu.D);
		m_asm.printf("\t.sim \"REG_P=0x%02X\"\n", simu.P);
		m_asm.printf("\t.sim \"REG_X=0x%02X\"\n", simu.X);
		m_asm.printf("\t.sim \"REG_T=0x%02X\"\n", simu.T);
		m_asm.printf("\t.sim \"REG_INTF=0x%02X\"\n", (simu.IE ^ 1) << 1);
		m_asm.printf("\t.sim \"REG_Q=0x%02X\"\n", simu.Q);

		for (int i = 0; i < 16; i++) {
			m_asm.printf("\t.sim \"REG%X_1=0x%02X\"\n", i, simu.R[1][i]);
			m_asm.printf("\t.sim \"REG%X_0=0x%02X\"\n", i, simu.R[0][i]);
		}

		//		m_asm.println("\t.sim \"break e done\"");
		m_asm.println("\t.sim \"break e init_done\"");
		//		m_asm.printf("\t.sim \"break e opcode_%02X\"\n", CDP1802SimuBase.STOP);
		m_asm.println("\t.sim \"break e opcode_68\"");
		if (DEBUG_TRIAL)
			m_asm.println("\t.sim \"break e again\"");

		if (RUN) {
			m_asm.println("\t.sim \"run\"");
			if (TIMEXEC) {
				m_asm.println("\t.sim \"break e time1\"");
				m_asm.println("\t.sim \"break e time2\"");
				m_asm.println("\t.sim \"run\"");
				m_asm.printf("\t.sim \"stopwatch=0\"\n");
				m_asm.println("\t.sim \"run\"");
				m_asm.printf("\t.sim \"stopwatch\"\n");
			} else if (!DEBUG_TRIAL) {
				m_asm.println("\t.sim \"run\"");
			}
		}
		m_asm.printf("\t.sim \"REG_D\"\n");
		m_asm.printf("\t.sim \"REG_DF\"\n");
		m_asm.printf("\t.sim \"REG_P\"\n");
		m_asm.printf("\t.sim \"REG_X\"\n");
		m_asm.printf("\t.sim \"REG_T\"\n");
		m_asm.printf("\t.sim \"REG_INTF\"\n");
		m_asm.printf("\t.sim \"REG_Q\"\n");
		// m_asm.printf("\t.sim \"OPCODE\"\n");

		for (int i = 0; i < 16; i++) {
			m_asm.printf("\t.sim \"REG%X_1\"\n", i);
			m_asm.printf("\t.sim \"REG%X_0\"\n", i);
		}

		m_asm.printf("\t.sim \"r macro\"\n");
		m_asm.printf("\t.sim \"pc\"\n");
		m_asm.printf("\t.sim \"run\"\n");
		m_asm.printf("\t.sim \"run\"\n");
		m_asm.printf("\t.sim \"FORCE_A15\"\n");
		m_asm.printf("\t.sim \"FORCE_A15\"\n");
		m_asm.printf("\t.sim \"REG_D\"\n");
		m_asm.printf("\t.sim \"REG_X\"\n");
		m_asm.printf("\t.sim \"REG_P\"\n");
		m_asm.printf("\t.sim \"REG0_1\"\n");
		m_asm.printf("\t.sim \"REG0_0\"\n");
		m_asm.printf("\t.sim \"REG1_1\"\n");
		m_asm.printf("\t.sim \"REG1_0\"\n");
		m_asm.printf("\t.sim \"REG2_1\"\n");
		m_asm.printf("\t.sim \"REG2_0\"\n");
		m_asm.printf("\t.sim \"REG3_1\"\n");
		m_asm.printf("\t.sim \"REG3_0\"\n");
		m_asm.printf("\t.sim \"OPCODE\"\n");
		m_asm.printf("\t.sim \"endm\"\n");

		if (RUN && !DEBUG_TRIAL)
			m_asm.println("\t.sim \"q\"");
		m_asm.println("\t END");
		m_asm.close();
	}

	void testCodeOBS(String cosmac) throws Exception {
		int addr = Integer.parseInt(cosmac.substring(0, 4), 16);
		int i = 5;
		while (i + 2 <= cosmac.length()) {
			int bty = Integer.parseInt(cosmac.substring(i, i + 2), 16);
			m_asm.printf("\tMOVLW   0x%02X\n", bty);
			m_asm.printf("\tMOVWF   MEM_START+0x%04X\n", addr);
			i += 3;
			addr++;
		}
	}

	void writeCodeToRam(CDP1802State state) throws Exception {
		m_asm.println("\tCLRWDT");
		for (int i = 0; i < state.M.length; i++) {
			int b = state.M[i];
			if (b >= 0) {
				String a = String.format("MEM_START+0x%04X\n", i);
				m_asm.printf("\tMOVLW   0x%02X\n", b);
				m_asm.printf("\tBANKSEL %s\n", a);
				m_asm.printf("\tMOVWF   %s\n", a);
			}
		}

	}

	void writeOutTests(CDP1802State state) throws Exception {
		writeHead();
		writeTail(state);
	}

	public static Supplier<String> capture(InputStream ins) {
		return new Supplier<String>() {
			BlockingQueue<String> queue = new ArrayBlockingQueue<String>(1);
			{
				new Thread(() -> {
					try (BufferedReader reader = new BufferedReader(new InputStreamReader(ins))) {
						// queue.put(new
						// BufferedReader(reader).lines().collect(Collectors.joining("\n")));
						String capt = "";
						for (String line = ""; line != null; line = reader.readLine()) {
							// System.out.println(line);
							capt += line + "\n";
						}
						queue.put(capt.substring(1));
					} catch (Exception e) {
						try {
							queue.put(null);
						} catch (Exception e2) {
							e.printStackTrace();
						}
					}
				}).start();
			}

			@Override
			public String get() {
				try {
					return queue.take();
				} catch (Exception e) {
					return null;
				}
			}
		};
	}

	public static void printResults(Process process) throws IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
		String line = "";
		while ((line = reader.readLine()) != null) {
			System.out.println("" + line);
		}
	}

	void assembleTest() throws Exception {
		String shell = System.getenv("SHELL");
		Process proc = Runtime.getRuntime().exec(new String[] { shell, "-c", "export PATH && make --always-make trial" }, new String[] { "PATH", "/usr/local/bin/" }, new File("../src"));
		Supplier<String> out = capture(proc.getInputStream());
		Supplier<String> err = capture(proc.getErrorStream());
		if (VERBOSE) {
			System.out.println(out.get());
			System.err.print(err.get());
		}
		if (proc.waitFor() != 0)
			System.err.println("make failed!");
	}

	int parse(String res, String reg) {
		String f = reg + " = 0x";
		int i = res.indexOf(f);
		if (i < 0) {
			System.err.println("reg=" + reg);
			System.err.println("res=" + res);
			throw new IllegalArgumentException("reg not in results");
		}
		String x = res.substring(i + f.length());
		x = x.substring(0, x.indexOf("\n"));
		return Integer.parseInt(x, 16);
	}

	CDP1802State runGpsim() throws Exception {

		String shell = System.getenv("SHELL");
		String existingPath = System.getenv("PATH");
		String newPath = "/opt/homebrew/bin/:" + existingPath; // This is for Apple silicon Macs, for Linux use /usr/local/bin/

		Process proc = Runtime.getRuntime().exec(new String[] { shell, "-c", "gpsim trial.cod" }, new String[] { "PATH=" + newPath }, new File("../obj"));

		Supplier<String> out = capture(proc.getInputStream());
		Supplier<String> err = capture(proc.getErrorStream());
		String result = out.get();
		proc.waitFor();
		if (proc.waitFor() != 0)
			System.err.println("gpsim failed!");
		CDP1802State state = new CDP1802State();
		state.D = parse(result, "REG_D");
		state.DF = parse(result, "REG_DF");
		state.P = parse(result, "REG_P");
		state.X = parse(result, "REG_X");
		state.T = parse(result, "REG_T");
		int INTF = parse(result, "REG_INTF");
		state.IE = ((INTF & 2) >> 1) ^ 1;
		state.Q = parse(result, "REG_Q");

		for (int i = 0; i < 16; i++) {
			state.R[1][i] = parse(result, String.format("REG%X_1", i));
			state.R[0][i] = parse(result, String.format("REG%X_0", i));
		}

		int it = result.indexOf("**gpsim> $");
		if (it >= 0) {
			int etime = Integer.parseInt(result.substring(it + 10, it + 18), 16);
			System.out.println("exectime " + etime);
			if (etime > m_MaxExecTime) {
				m_MaxExecTime = etime;
				m_MaxExecTimeOpcode = m_TestName;
			}
		}

		if (VERBOSE) {
			System.out.println(result);
			System.err.println(err.get());
		}
		return state;
	}

	void time(String name, String... code) throws Exception {
		//CDP1802Simu initialState = new CDP1802Simu();
		//initialState.load(addr, code);

		System.out.print("Test: '" + name + "' ");
		CDP1802Simu jsimstate = new CDP1802Simu();
		CDP1802Assembler asm = new CDP1802Assembler();
		asm.setOutput(jsimstate);
		for (String line : code)
			asm.asm(line);

		writeOutTests(jsimstate);
		assembleTest();
		CDP1802State psimstate = runGpsim();
		if (VERBOSE)
			psimstate.printState();

	}

	boolean test(String name, String... code) throws Exception {
		if (code == null || code.length == 0)
			throw new IllegalArgumentException("no code supplied");
		System.out.println("Test: '" + name + "'");
		CDP1802Simu jsimstate = new CDP1802Simu();
		CDP1802Assembler asm = new CDP1802Assembler();
		asm.setOutput(jsimstate);
		for (String line : code)
			asm.asm(line);

		writeOutTests(jsimstate);
		assembleTest();
		CDP1802State psimstate = runGpsim();
		jsimstate.execute();
		boolean fail = jsimstate.printDiff(" Java ", "gpsim", psimstate, false);
		if (fail)
			System.out.println("^^^ ----------------------------------------- FAIL!");
		if (VERBOSE)
			psimstate.printState();
		return !fail;
	}

	boolean testLogicalOps() throws Exception {
		boolean ok = true;
		// logical ops
		ok &= test("OR", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"LDI 0x3C", //
				"OR", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0xF0");

		ok &= test("ORI", //
				"ORG 0x8000", //
				"LDI 0x3C", //
				"ORI 0x0F", //
				"STOP" //
		);

		ok &= test("AND", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"LDI 0x3C", //
				"AND", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0xF0");

		ok &= test("ANI", //
				"ORG 0x8000", //
				"LDI 0x3C", //
				"ANI 0x0F", //
				"STOP" //
		);

		ok &= test("XOR", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"LDI 0x3C", //
				"XOR", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0xF0");

		ok &= test("XRI", //
				"ORG 0x8000", //
				"LDI 0x3C", //
				"XRI 0x0F", //
				"STOP" //
		);
		return ok;
	}

	boolean testShiftOps() throws Exception {
		boolean ok = true;
		// shift ops
		ok &= test("SHR", //
				"ORG 0x8000", //
				"LDI 0x55", //
				"SHR", //
				"STOP" //
		);

		ok &= test("SHRC", //
				"ORG 0x8000", //
				"LDI 0xA6", //
				"ADI -1", //
				"SHRC", //
				"STOP" //
		);

		ok &= test("SHL", //
				"ORG 0x8000", //
				"LDI 0x55", //
				"SHL", //
				"STOP");

		ok &= test("SHLC", //
				"ORG 0x8000", //
				"LDI 0x56", //
				"ADI -1", //
				"SHLC", //
				"STOP" //
		);
		return ok;
	}

	private String[] str(String s) {
		return new String[] { s };
	}

	private String[] concat(String... args) {

		return args;
	}

	private String[] concat(String[]... args) {
		int n = 0;
		for (String[] a : args) {
			n += a.length;
		}
		String[] r = new String[n];
		int i = 0;
		for (String[] a : args) {
			for (String s : a) {
				r[i++] = s;
			}
		}

		return r;
	}

	boolean testArithmeticOps(String... ops) throws Exception {
		boolean ok = true;
		// testAritmeticOps("ADD","ADI","ADC","ADCI","SD","SDI","SDB","SDBI","SM","SM"I,"SMB","SMBI");
		for (String op : ops) {
			int[] vals = { 127, 128 };

			for (int i = 0; i < 2; i++) {
				for (int j = 0; j < 2; j++) {
					for (int c = 0; c < 2; c++) {
						int a1 = vals[i];
						int a2 = vals[j];
						String[] C0 = { //
								"LDI 0", //
								"SHR"//
						};

						String[] C1 = { //
								"LDI 1", //
								"SHR" //
						};
						String[] A1I = { //
								"LDI " + a1//
						};
						String[] A1M = { //
								"LDI 0x80", //
								"PHI 2", //
								"LDI 0x40", //
								"PLO 2", //
								"SEX 2" //
						};
						String[] A1D = { //
								"ORG 0x8040", //
								"BYTE " + a1 //
						};
						String[] A2 = { //
								"LDI " + a2 //
						};
						String[] t = { "ORG 0x8000" };

						t = concat(t, c == 1 ? C1 : C0);
						t = concat(t, (op.endsWith("I")) ? A1I : A1M);
						if (op.endsWith("I")) {
							t = concat(t, str(op + " " + a2));

						} else {
							t = concat(t, A2);
							t = concat(t, str(op));
						}

						t = concat(t, str("STOP"));

						if (!op.endsWith("I"))
							t = concat(t, A1D);

						if (VERBOSE) {
							for (String s : t) {
								System.out.println(s);
							}
							System.out.println();
						}
						String n = op + " C=" + c + " a1=" + a1 + " a2=" + a2;
						ok &= test(n, t);
						if (!ok) {
							System.out.println("FAIL!!!");
						}
					}
				}
			}
		}
		return ok;
	}

	boolean testBranchOps(boolean skip, int jmp, String... ops) throws Exception {
		boolean ok = true;
		for (String opt : ops) {
			for (int d = 0; d < 2; d++) {
				for (int q = 0; q < 2; q++) {
					for (int df = 0; df < 2; df++) {
						String Q = q == 0 ? "REQ" : "SEQ";
						String DF = df == 1 ? "LDI 1" : "LDI 0";
						String D = "LDI " + d;
						String nD = "LDI " + (d ^ 1);
						String op = opt + (skip ? "" : " $+" + jmp);
						String n = op + " D=" + d + " DF=" + df + " Q=" + q;

						String[] t = concat("ORG 0x8000", Q, DF, "SHR", D, op, nD, "STOP");

						if (VERBOSE) {
							for (String s : t) {
								System.out.println(s);
							}
							System.out.println();
						}
						ok &= test(n, t);

					}

				}
			}

		}

		return ok;

	}

	boolean testSubDOps() throws Exception {
		boolean ok = true;
		ok &= test("SMI no borrow", //
				"ORG 0x8000", //
				"LDI 3", //
				"SMI 1", //
				"STOP" //
		);
		ok &= test("SMI with borrow out", //
				"ORG 0x8000", //
				"LDI 1", //
				"SMI 3", //
				"STOP" //
		);
		ok &= test("LDX", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"LDX", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0x76" //
		);

		ok &= test("SMI with no borrow out", //
				"ORG 0x8000", //
				"LDI 3", //
				"SMI 1", //
				"STOP" //
		);

		ok &= test("SMBI with borrow in", //
				"ORG 0x8000", //
				"LDI 1", //
				"SMI 3", //
				"LDI 5", //
				"SMBI 0", //
				"SMBI 0", //
				"STOP" //
		);

		ok &= test("SD", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"LDI 1", //
				"SMI 3", //
				"LDI 10", //
				"SD", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 15" //
		);

		return ok;
	}

	boolean testMiscOps() throws Exception {
		boolean ok = true;
		ok &= test("RET", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"RET", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0x34" //
		);

		ok &= test("DIS", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"DIS", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0x34" //
		);

		ok &= test("MARK", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"MARK", //
				"STOP", //
				"ORG 0x8040", //
				"BYTE 0x20" //
		);
		ok &= test("SAV", //
				"ORG 0x8000", //
				"LDI 0x00", //
				"PHI 3", //
				"LDI 0x07", //
				"PLO 3", //
				"SEP 3", //
				"LDI 0x80", //
				"PHI 2", //
				"LDI 0x40", //
				"PLO 2", //
				"SEX 2", //
				"MARK", //
				"SEX 2", //
				"SAV", //
				"STOP", //
				"ORG 0x803E", //
				"BYTE 0x20", //
				"BYTE 0x20", //
				"BYTE 0x20", //
				"BYTE 0x20" //
		);

		return ok;
	}

	boolean testRegisterOps() throws Exception {
		boolean ok = true;
		for (int r = 0; r < 16; r++) {
			int p = (r + 1) % 16;
			ok &= test("INC " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0", //
					"PHI " + r, //
					"LDI 255", //
					"PLO " + r, //
					"INC " + r, //
					"STOP" //
			);
			ok &= test("DEC " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0", //
					"PHI " + r, //
					"LDI 0", //
					"PLO " + r, //
					"DEC " + r, //
					"STOP" //
			);
			ok &= test("IRX " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"SEX " + r, //
					"IRX", //
					"STOP" //
			);

			ok &= test("GLO " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0", //
					"PLO " + r, //
					"LDI 255", //
					"GLO " + r, //
					"STOP" //
			);

			ok &= test("GHI " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0", //
					"PHI " + r, //
					"LDI 255", //
					"GHI " + r, //
					"STOP" //
			);
		}

		return ok;
	}

	boolean testMemoryOps() throws Exception {
		boolean ok = true;
		for (int r = 1; r < 16; r++) {

			int p = (r + 1) % 16;
			ok &= test("LDN " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"LDN " + r, //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
			ok &= test("LDA " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"LDA " + r, //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
			ok &= test("LDX " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"SEX " + r, //
					"LDX", //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
			ok &= test("LDXA " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"SEX " + r, //
					"LDXA", //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
			ok &= test("STR " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"LDN " + r, //
					"LDI 0x55", //
					"STR " + r, //
					"LDI 0x00", //
					"LDN " + r, //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
			ok &= test("STXD " + r, //
					"ORG 0x8000", //
					"LDI 0", //
					"PHI " + p, //
					"LDI 7", //
					"PLO " + p, //
					"SEP " + p, //
					"LDI 0x80", //
					"PHI " + r, //
					"LDI 0x40", //
					"PLO " + r, //
					"LDN " + r, //
					"SEX " + r, //
					"LDI 0x55", //
					"STXD", //
					"IRX", //
					"LDI 0x00", //
					"LDX", //
					"STOP", //
					"ORG 0x8040", //
					"BYTE 0x55" //
			);
		}
		return ok;
	}

	boolean testRAM() throws Exception {
		boolean ok = true;
		ok &= test("RAM", //
				"ORG 0x8000", //
				"LDI 0x80", //
				"PHI 0", //
				"LDI 0x06", //
				"PLO 0", //
				"SEX 2", //
				"OUT 4", //
				"LDI 0x00", //
				"PHI 2", //
				"LDI 0x00", //
				"PLO 2", //
				"LDI 0x55", //
				"STR 2", //
				"LDI 0xCC", //
				"LDN 2", //

				"STOP" //
		);
		return ok;

	}

	boolean testQBlink() throws Exception {
		boolean ok = true;
		ok &= test("QBLINK", //
				"ORG 0x8000", //
				"SEQ", //
				"LDI 0", //
				"PLO 1", //
				"SMI 1", //
				"BNZ $-2", //
				"GLO 1", //
				"SMI 1", //
				"BNZ $-8", //
				"REQ", //
				"LDI 0", //
				"PLO 1", //
				"SMI 1", //
				"BNZ $-2", //
				"GLO 1", //
				"SMI 1", //
				"BNZ $-8", //
				"BR $+2", //
				"STOP" //
		);
		return ok;

	}

	void run() {
		try {
			boolean ok = true;

			if (TIMEXEC) {
				for (int i = 0x00; i <= 0xFF; i++) {
					if (i == 0x79)
						continue;
					m_TestName = String.format("%02X", i);
					time("OPCODE 0x" + String.format("%02X", i), //
							"ORG 0x8000", //
							String.format("BYTE 0x%02X", i));
				}
				System.out.println("m_MaxExecTime " + m_MaxExecTime + " opcode " + m_MaxExecTimeOpcode);
			} else {
				ok &= testLogicalOps();
				ok &= testRAM();

				ok &= testShiftOps();
				ok &= testMiscOps();
				ok &= testArithmeticOps("ADD", "ADI", "ADC", "ADCI", "SD", "SDI", "SDB", "SDBI", "SM", "SMI", "SMB", "SMBI");

				ok &= testBranchOps(false, 4, "BR", "BZ", "BNZ", "BQ", "BNQ", "BDF", "BNF", "SKP");
				ok &= testBranchOps(false, 5, "LBR", "LBZ", "LBNZ", "LBQ", "LBNQ", "LBDF", "LBNF");
				ok &= testBranchOps(true, 5, "LSZ", "LSNZ", "LSQ", "LSNQ", "LSDF", "LSKP", "LSNF");

				ok &= testRegisterOps();
				ok &= testMemoryOps();
				ok &= testQBlink();

				test("NOP", //
						"ORG 0x8000", //
						"NOP", //
						"STOP");
				test("SEP 0", //
						"ORG 0x8000", //
						"SEP 0", //
						"STOP");

				if (ok)
					System.out.println("ALL TESTS PASSED");
				else
					System.out.println("SOME TESTS FAILED");

				CDP1802Simu.dumpTestCoverage(true);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
