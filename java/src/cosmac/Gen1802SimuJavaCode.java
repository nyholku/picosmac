package cosmac;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;

public class Gen1802SimuJavaCode {

	String opcode;
	String mnemonic;
	String desc;
	String spec;
	String spec2;
	int N;
	PrintWriter java;
	PrintWriter test;
	int[] m_OpLen = new int[256];

	void writeJavaHead() {
		java.println("public class CDP1802Opcodes extends CDP1802Simu{");

	}

	void writeJavaTail() {

		java.println("	int[] m_OpLen={");
		for (int i = 0; i <= 0xFF; i++) {
			if (i % 16 == 0)
				java.print("		");
			java.printf("%d ", m_OpLen[i]);
			if (i != 255)
				java.printf(", ");

			if (i % 16 == 15) {
				java.printf(" // %02X..%02X\n ",i-15,i);
			}
		}
		java.println("		};");

		java.println("	void execute(int opcode) {");
		java.println("		switch(opcode) {");
		for (int i = 0; i <= 0xFF; i++) {
			java.printf("			case 0x%02X : opcode_%02X(); break; \n", i, i);

		}

		java.println("			}");
		java.println("		}");
		java.println("	}");

	}

	int hex2dec(char ch) {
		if (ch >= ' ' && ch <= '9')
			return ch - '0';
		else if (ch >= 'A' && ch <= 'F')
			return 10 + ch - 'A';
		else
			return -1;
	}

	String dec2hex(int x) {
		return String.format("%02X", x);
	}

	private void generateJavaSimulateOneOpCode(String x) {

		int op = hex2dec(opcode.charAt(0)) * 0x10;
		int oplo = hex2dec(opcode.charAt(1));
		int n = 16;
		if (oplo >= 0) {
			n = 1;
			op += oplo;
		}
		int c = 1;
		if (desc.indexOf("IMMEDIATE") >= 0 || desc.indexOf("SHORT") >= 0)
			c = 2;
		else if (desc.indexOf("LONG") >= 0)
			c = 3;

		for (N = 0; N < n; N++, op++) {
			m_OpLen[op] = c;
			if (N == 0 && opcode.equals("0N"))
				continue;
			java.println("	void opcode_" + dec2hex(op) + "() {");

			String s[] = spec.split(";");
			for (int i = 0; i < s.length; i++) {
				String js = s[i].trim();
				js = js.replaceAll("N", "" + N);
				js += ";";
				java.println("		" + js);
			}

			java.println("		}");

		}

	}

	public void run() throws Exception {
		java = new PrintWriter(new FileOutputStream(new File("./src/CDP1802Opcodes.java")));
		test = new PrintWriter(new FileOutputStream(new File("test.txt")));

		writeJavaHead();

		InputStream ins = Gen1802SimuJavaCode.class.getResourceAsStream("specfile2.txt");
		BufferedReader br = new BufferedReader(new InputStreamReader(ins)); //creates a buffering character input stream  
		while (null != (opcode = br.readLine())) {
			mnemonic = br.readLine();
			desc = br.readLine();
			spec = br.readLine();
			spec2 = br.readLine();

			//System.out.printf("| %2s | %8s | %30s | %s",opcode,mnemonic, desc,spec);
			//System.out.println();

			generateJavaSimulateOneOpCode(spec);
			//			pw.println(opcode);
			//			pw.println(mnemonic);
			//			pw.println(desc);
			//			pw.println(spec);
			//			pw.println();
			//process(spec);
			int i = spec.indexOf("→");
			if (i >= 0) {
				String s = spec.substring(i + 1) + " = " + spec.substring(0, i) + ";";
				//System.out.println(s);
			}

		}

		writeJavaTail();

		java.close();
		test.close();
	}

}
