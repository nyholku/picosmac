package cosmac;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MakeChip8 {

	public static void mainx(String[] args) throws Exception {
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream("/Users/nyholku/Cosmac/chip8.txt")));
		String line;
		int j = 0;
		while (null != (line = reader.readLine())) {
			line = line.substring(4);
			//System.out.println(line);
			if (j % 2 == 0)
				System.out.printf("\n\t\tDB");

			for (int i = 0; i < 8; i++)
				System.out.printf(", 0x%s", line.substring(i * 2, i * 2 + 2));
			j++;
		}

	}

	public static void convertChip8File(String srcFileName) throws Exception {
		String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

		if (!srcFileName.endsWith(".ch8")) {
			System.err.println("Not a CHIP8 file '" + srcFileName + "'");
		}
		File file = new File(srcFileName);
		String basename = file.getName().substring(0, file.getName().length() - 4).toLowerCase();
		String asmLabel = (basename + "_ch8");
		String dstFileName = (basename + ".asm");
		int flen = (int) file.length();
		if (flen > 0x580) {
			System.out.printf("File length %d > %d file '%s'\n", flen, 0x580, srcFileName);
			return;
		}

		FileInputStream in = new FileInputStream(file);
		System.out.println(new File(dstFileName).getAbsolutePath());
		PrintWriter out = new PrintWriter(dstFileName);
		out.printf(";\n");
		out.printf("; This file was generated on %s from CHIP8 file '%s' with MakeChip8.java \n", date, file.getName());
		out.printf(";\n");
		out.printf("; Note that the generated code uses gpasm DW directive to encode the 16 bit CHIP8 commands,\n");
		out.printf("; which results in little-endian data in Flash memory, the PIC load_ch8_code routine in \n");
		out.printf("; CDP1802 emulator swaps the bytes when it copies the code from Flash to RAM.\n");
		out.printf(";\n");
		out.printf("\t\tGLOBAL\t%s\n", asmLabel);
		out.printf(";\n");

		out.printf("\t\tLIST\n");
		out.printf(";\n");
		out.printf("\n\t\tRADIX\tDEC\n");
		out.printf(";\n");
		out.printf("\t\tCODE\n");
		out.printf(";\n");
		out.printf("\t\tDW 0x%04X\n", flen);
		out.printf(";\n");
		out.printf(asmLabel);

		int j = 0;
		int b = 0;
		String comma = "";
		while (0 <= (b = in.read())) {
			if (j % 16 == 0) {
				out.printf("\n\t\tDW");
				comma = "";
			}
			if (j % 2 == 0) {
				out.printf(comma + " 0x");
			}

			out.printf("%02X", b);
			comma = ",";
			j++;
		}
		out.printf("\n");
		out.printf(";\n");
		out.printf("\t\tEND\n");
		out.printf(";\n");
		out.close();
		in.close();
	}

	public static void main(String[] args) throws Exception {
		try {
			convertChip8File("Kaleidoscope.ch8");
			convertChip8File("Vers.ch8");
			convertChip8File("Missile.ch8");
			convertChip8File("Bowling.ch8");
			convertChip8File("LunarLander.ch8");
			convertChip8File("Blinky.ch8");
			convertChip8File("Tank.ch8");
			convertChip8File("Pong2.ch8");
			convertChip8File("Pong.ch8");
			convertChip8File("invaders.ch8");
			convertChip8File("tetris.ch8");
			convertChip8File("brix.ch8");
			convertChip8File("Maze.ch8");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
