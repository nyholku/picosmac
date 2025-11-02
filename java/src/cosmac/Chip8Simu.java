package cosmac;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;

public class Chip8Simu {
	public static void main(String... args) {
		try {
			CDP1802Simu cpu = new CDP1802Simu();
			int pc = 0;
			{

				BufferedReader reader = new BufferedReader(new InputStreamReader(Chip8Simu.class.getResourceAsStream("Chip8.txt")));
				String line;
				while (null != (line = reader.readLine())) {
					if (line.length() == 0)
						continue;
					for (int i = 0; i < 16; ++i) {
						String s = line.substring(7 + i * 6, 7 + i * 6 + 2);
						cpu.M[pc++] = Integer.parseInt(s, 16);
					}
				}
			}
			{
				pc = 0x8000;
				BufferedReader reader = new BufferedReader(new InputStreamReader(Chip8Simu.class.getResourceAsStream("TelmacROM.txt")));
				String line;
				while (null != (line = reader.readLine())) {
					if (line.length() == 0)
						continue;
					for (int i = 0; i < 16; ++i) {
						String s = line.substring(7 + i * 6, 7 + i * 6 + 2);
						cpu.M[pc++] = Integer.parseInt(s, 16);
					}
				}

				cpu.VERBOSE = true;
				while (true) {
					boolean b = cpu.R[1][4] == 0x00 && cpu.R[0][4] == 0x1B && cpu.P == 4;
					if (b) {
						int a = (cpu.R[1][5] << 8) | cpu.R[0][5];
						System.out.printf(" <-----------------------------------------------------------\n");
						for (int i = 0; i < 16; i++)
							System.out.printf("V%X = 0x%02X\n", i, cpu.M[(cpu.R[1][6] << 8) + i + 0xF0]);
						System.out.printf("I   = 0x%02X\n", (cpu.R[1][10] << 8) | cpu.R[0][10]);
						System.out.printf("CHIP8 %04X: %04X", a, (cpu.M[a] << 8) | cpu.M[a + 1]);
					}
					cpu.execute(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
