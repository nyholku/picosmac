package cosmac;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Hashtable;

import cosmac.CDP1802Assembler.AddrMode;

public class CDP1802Assembler {
	boolean VERBOSE = false;

	public enum AddrMode {
		IMPLICIT, REGISTER, INOUT, IMMEDIATE, SHORT, LONG
	};

	private static class Code {
		String m_Mnemonic;
		AddrMode m_AddrMode;
		int m_OpCode;

		Code(String mnemonic, int opCode, AddrMode addrMode) {
			m_Mnemonic = mnemonic;
			m_AddrMode = addrMode;
			m_OpCode = opCode;
		}

		public String toString() {
			return String.format("%02X", m_OpCode) + " " + m_Mnemonic + " " + m_AddrMode;
		}
	}

	private Hashtable<String, Code> m_Mnemonics = new Hashtable();

	private int m_Addr;

	private CDP1802State m_State;

	CDP1802Assembler() {
		try {
			String mnemonic, desc, spec, spec2, opcode;
			InputStream ins = Main.class.getResourceAsStream("CDP1802-spec.txt");
			BufferedReader br = new BufferedReader(new InputStreamReader(ins)); // creates a buffering character input stream
			while (null != (opcode = br.readLine())) {
				mnemonic = br.readLine();
				desc = br.readLine();
				spec = br.readLine();
				spec2 = br.readLine();
				br.readLine();

				// System.out.println(">>>" + opcode);
				int opLo = hex2dec(opcode.charAt(1));
				int opHi = hex2dec(opcode.charAt(0)) * 0x10;
				int opCode = opLo + opHi;
				if (opLo < 0)
					addMnemonic(mnemonic, opHi, AddrMode.REGISTER);
				else if (desc.indexOf("IMMEDIATE") >= 0)
					addMnemonic(mnemonic, opCode, AddrMode.IMMEDIATE);
				else if (desc.indexOf("INOUT") >= 0)
					addMnemonic(mnemonic, opCode, AddrMode.INOUT);
				else if (desc.indexOf("SHORT") >= 0)
					addMnemonic(mnemonic, opCode, AddrMode.SHORT);
				else if (desc.indexOf("SKIP") >= 0)
					addMnemonic(mnemonic, opCode, AddrMode.IMPLICIT);
				else if (desc.indexOf("LONG") >= 0)
					addMnemonic(mnemonic, opCode, AddrMode.LONG);
				else
					addMnemonic(mnemonic, opCode, AddrMode.IMPLICIT);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	int hex2dec(char ch) {
		if (ch >= ' ' && ch <= '9')
			return ch - '0';
		else if (ch >= 'A' && ch <= 'F')
			return 10 + ch - 'A';
		else
			return -1;
	}

	void setOutput(CDP1802State state) {
		m_State = state;
	}

	void out(int b) {
		if (VERBOSE)
			System.out.printf("asm  %04X %02X\n", m_Addr, b);
		if (m_State != null)
			m_State.M[m_Addr] = b;
		m_Addr++;
	}

	void addMnemonic(String mnemonic, int opCode, AddrMode addrMode) {
		Code code = new Code(mnemonic, opCode, addrMode);
		if (VERBOSE)
			System.out.println("opcd " + code);
		m_Mnemonics.put(mnemonic, code);
	}

	int parse(String exp) {
		if (exp.startsWith("$+"))
			return m_Addr + Integer.parseInt(exp.substring(2), 10);
		else if (exp.startsWith("$-"))
			return m_Addr - Integer.parseInt(exp.substring(2), 10);
		else if (exp.equals("$"))
			return m_Addr;
		if (exp.startsWith("0x"))
			return Integer.parseInt(exp.substring(2), 16);
		else
			return Integer.parseInt(exp, 10);

	}

	void disasm(int address, byte[] code) {
		int i = 0;
		Code[] lut = new Code[256];
		for (Code c : m_Mnemonics.values()) {
			if (c.m_AddrMode == AddrMode.REGISTER) {
				for (int r = 0; r < 16; r++)
					lut[c.m_OpCode + r] = c;
			} else
				lut[c.m_OpCode] = c;
		}
		while (i < code.length) {
			int i0 = i;
			int opcode = code[i++] & 0xFF;
			Code c = lut[opcode];
			String line = "";
			if (c == null)
				line += String.format("BAD OPCODE");
			else {
				try {
					line += String.format("%-3s  ", c.m_Mnemonic);
					int operand;
					switch (c.m_AddrMode) {
					case IMPLICIT:
						break;
					case IMMEDIATE:
						operand = code[i++] & 0xFF;
						line += "#" + String.format("0x%02X (%d)", operand, operand);
						break;
					case SHORT:
						operand = code[i++] & 0xFF;
						line += String.format("0x%02X (%d)", operand, operand);
						break;
					case LONG:
						operand = (code[i++] & 0xFF) << 8;
						operand += code[++i] & 0xFF;
						line += String.format("0x%04X (%d)", operand, operand);
						break;
					case REGISTER:
						line += String.format("R%X", opcode & 0xF);
						break;
					}
				} catch (IndexOutOfBoundsException ie) {
					line += " <END OF DATA ERROR>";
				}
			}
			String pre = String.format("%04X: ", address + i0);
			for (int j = 0; j < 3; j++) {
				if (i0 < i)
					pre += String.format("%02X ", code[i0++] & 0xFF);
				else
					pre += "   ";
			}
			line = pre + " " + line;
			System.out.println(line);
		}
	}

	void asm(String line) {
		int n = line.indexOf(" ");
		if (n < 0)
			n = line.length();
		String mnemonic = line.substring(0, n);
		String exp = line.substring(n).trim();
		if (mnemonic.startsWith("ORG")) {
			int addr = parse(exp);
			if (addr < 0 || addr > 0xFFFF)
				throw new IllegalArgumentException("bad address");
			m_Addr = addr;
			return;

		}
		if (mnemonic.startsWith("BYTE")) {
			int bty = parse(exp);
			if (bty < -128 || bty > 255)
				throw new IllegalArgumentException("bad address");
			out(bty & 0xFF);
			return;

		}

		Code code = m_Mnemonics.get(mnemonic);
		if (code == null)
			throw new IllegalArgumentException("unknow mnemonic " + mnemonic);
		switch (code.m_AddrMode) {
		case IMPLICIT:
			if (!exp.isEmpty())
				throw new IllegalArgumentException("extra garbage after mnemonic");
			out(code.m_OpCode);
			break;
		case REGISTER:
			int reg = parse(exp);
			if (reg < 0 || reg > 15)
				throw new IllegalArgumentException("bad register ref " + reg);
			out(code.m_OpCode | reg);
			break;
		case INOUT:
			int N = parse(exp);
			if (N < 1 || N > 7)
				throw new IllegalArgumentException("bad register ref " + N);
			out(code.m_OpCode + N - 1);
			break;
		case IMMEDIATE:
			int value = parse(exp);
			if (value < -128 || value > 255)
				throw new IllegalArgumentException("bad value " + value);
			out(code.m_OpCode);
			out(value & 0xFF);
			break;
		case SHORT:
		case LONG:
			int addr = parse(exp);
			if (addr < 0 || addr > 0xFFFF)
				throw new IllegalArgumentException("bad address " + String.format("0x%04X", addr));
			if (code.m_AddrMode == AddrMode.SHORT) {
				if ((addr & 0xFF00) != (m_Addr & 0xFF00))
					throw new IllegalArgumentException("branch out of page, from " + String.format("0x%04X", m_Addr) + " to " + String.format("0x%04X", addr));
				addr = (m_Addr & 0xFF00) + (addr & 0xFF);
				out(code.m_OpCode);
				out(addr & 0xFF);

			} else {
				out(code.m_OpCode);
				out(addr >> 8);
				out(addr & 0xFF);

			}
			break;

		}
	}

	static CDP1802State assemble(String... code) {
		CDP1802State state = new CDP1802State();
		CDP1802Assembler asm = new CDP1802Assembler();
		asm.setOutput(state);
		for (String line : code)
			asm.asm(line);
		return state;
	}

	public static void main_assemble_video_interrupt(String[] args) throws Exception {
		System.out.println(assemble("ORG 0x8000", //
				// Change to use R3 as program counter
				"LDI 0x06", //
				"PLO 3", //
				"LDI 0x80", //
				"PHI 3", //
				"SEP 3", //
				// turn OFF force A15=1
				"OUT 4", //

				// set video interrupt address 0x8080 to R1
				"LDI 0x80", //
				"PHI 1", //
				"LDI 0x82", //
				"PLO 1", //

				// set stack top to 0x03FF (top of 1 kB RAM)
				"LDI 0x03", //
				"PHI 2", //
				"LDI 0xFF", //
				"PLO 2", //
				"SEX 2", //

				// turn ON video
				"INP 1", //

				// loop and blink Q-LED
				"SEQ", //
				"REQ", //
				"BR  0x8016", //

				// Video interrupt for 64x32 display
				"ORG 0x8080", //
				"LDXA", //
				"RET", //
				"NOP", //	[3] INTERRUPT starts here ie @ 0x8082 
				"DEC 2", //	[2]
				"SAV", //	[2]
				"DEC 2", //	[2]
				"STR 2", //	[2]
				"LDI 0x01", //	[2]
				"PHI 0", //	[2]
				"LDI 0x00", //	[2]
				"PLO 0", //	[2]
				"NOP", //	[3]
				"NOP", //  [3]
				"SEX 2", // 	[2] LOOP:
				"GLO 0", //  |2] DMA starts after this completes, 13 inst =  10 x 2 + 3 x 3  = 29 cycles , so DMA starts here
				// previous DMA completes before this completes so we get the updates DMA address

				"SEX 2", //
				"DEC 0", //
				"PLO 0", // repeat line, so DMA start after this completes

				"SEX 2", //
				"DEC 0", //
				"PLO 0", // repeat line, so DMA start after this completes

				"SEX 2", //
				"DEC 0", //
				"PLO 0", // repeat line, so DMA start after this completes

				"BN1 0x808F", // LOOP if EF1 == 0 
				"BR 0x8080"

		//
		).getROMasPicAsmCode());
	}

	public static void main_disassemble_telmac1800rom(String[] args) throws Exception {
		try (FileInputStream fis = new FileInputStream("../telmac1800.rom")) {
			byte[] bytes = fis.readAllBytes();
			new CDP1802Assembler().disasm(0x8000, bytes);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
